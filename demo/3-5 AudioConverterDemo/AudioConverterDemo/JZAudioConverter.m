//
//  JZAudioConverter.m
//  AudioConverterDemo
//
//  Created by Ingenic_iOS on 2017/3/31.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioConverter.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct {
    AudioFileID                     srcFileId;
    SInt64                          srcFilePos;
    char *                          srcBuffer;
    UInt32                          srcBufferSize;
    UInt32                          srcSizePerPacket;
    UInt32                          numPacketPerRead;
    AudioStreamBasicDescription     srcFormat;
    AudioStreamPacketDescription    *packetDescriptions;
} AudioFileIO, *AudioFileIOPtr;

enum {
    kMyAudioConverterErr_CannotResumeFromInterruptionError = 'CANT',
    eofErr = -39 // End of file
};

typedef NS_ENUM(NSInteger, AudioConverterState) {
    AudioConverterStateInitial,
    AudioConverterStateRunning,
    AudioConverterStatePaused,
    AudioConverterStateDone
};

@interface JZAudioConverter()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) AudioConverterState state;

@end

@implementation JZAudioConverter

- (instancetype)initWithSourceURL:(NSURL *)sourceURL destinationURL:(NSURL *)destinationURL sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat {
    if ((self = [super init])) {
        _sourceURL = sourceURL;
        _destinationURL = destinationURL;
        _sampleRate = sampleRate;
        _outputFormat = outputFormat;
        _state = AudioConverterStateInitial;
        
        _queue = dispatch_queue_create("com.example.apple-samplecode.AudioConverterFileConvertTest.AudioFileConverOperation.queue", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(0);
        
        // AudioSession系统中断响应
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (void) createAudioConverter:(NSString *)path {
    // open file
    AudioFileID sourceFileID = 0;
    CFURLRef sourceURL = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    AudioFileOpenURL(sourceURL, kAudioFileReadPermission, 0, &sourceFileID);
    
    // Get the source data format.
    AudioStreamBasicDescription sourceFormat;
    UInt32 size = sizeof(sourceFormat);
    AudioFileGetProperty(sourceFileID, kAudioFilePropertyDataFormat, &size, &sourceFormat);
    
    // Setup the output file format.
    AudioStreamBasicDescription destinationFormat;
    destinationFormat.mSampleRate = (self.sampleRate == 0 ? sourceFormat.mSampleRate : self.sampleRate);
    
    if (self.outputFormat ==kAudioFormatLinearPCM) {
        // If the output format is PCM, create a 16-bit file format description.
        destinationFormat.mFormatID = kAudioFormatLinearPCM;
        destinationFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger; // little-endian
        destinationFormat.mFramesPerPacket = 1;
        destinationFormat.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
        destinationFormat.mBitsPerChannel = 16;
        destinationFormat.mBytesPerFrame = destinationFormat.mBitsPerChannel * destinationFormat.mChannelsPerFrame / 8;
        destinationFormat.mBytesPerPacket = destinationFormat.mBytesPerFrame * destinationFormat.mFramesPerPacket;
    } else {
        // This is a compressed format, need to set at least format, sample rate and channel fields for kAudioFormatProperty_FormatInfo.
        destinationFormat.mFormatID = self.outputFormat;
        // For iLBC, the number of channels must be 1.
        destinationFormat.mChannelsPerFrame = (self.outputFormat == kAudioFormatiLBC ? 1 : sourceFormat.mChannelsPerFrame);
        
        // Use AudioFormat API to fill out the rest of the description.
        size = sizeof(destinationFormat);
        AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &size, &destinationFormat);
    }
    
    // TODO
    // 打印sourceFormat和destinationFormat
    printf("Source File format:%d \n", sourceFormat.mFormatID);
    printf("Destination File format:%d \n",destinationFormat.mFormatID);
    
    // ==============================================================================================
    // Create the AudioConverterRef.
    AudioConverterRef converter;
    AudioConverterNew(&sourceFormat, &destinationFormat, &converter);
    
    // If the source file has a cookie, get ir and set it on the AudioConverterRef.
    // TODO
    
    // Get the actuall formats (source and destination) from the AudioConverterRef.
    size = sizeof(sourceFormat);
    AudioConverterGetProperty(converter, kAudioConverterCurrentInputStreamDescription, &size, &sourceFormat);
    size = sizeof(destinationFormat);
    AudioConverterGetProperty(converter, kAudioConverterCurrentOutputStreamDescription, &size, &destinationFormat);
    
    // TODO
    // 打印sourceFormat和destinationFormat
    printf("Source File format:%d \n", sourceFormat.mFormatID);
    printf("Destination File format:%d \n",destinationFormat.mFormatID);
    
    
    if (destinationFormat.mFormatID == kAudioFormatMPEG4AAC) {
        UInt32 outputBitRate = 64000;
        UInt32 propSize = sizeof(outputBitRate);
        if (destinationFormat.mSampleRate >= 44100) {
            outputBitRate = 192000;
        } else if (destinationFormat.mSampleRate < 22000) {
            outputBitRate = 32000;
        }
        AudioConverterSetProperty(converter, kAudioConverterEncodeBitRate, propSize, &outputBitRate);
    }
    
    
    UInt32 canResume = 0;
    size = sizeof(canResume);
    OSStatus stts = AudioConverterGetProperty(converter, kAudioConverterPropertyCanResumeFromInterruption, &size, &canResume);
    BOOL canResumeFromInterruption = YES;
    if (stts == noErr) {
        if (canResume == 0) {
            canResumeFromInterruption = NO;
        }
    } else {
        if (stts == kAudioConverterErr_PropertyNotSupported) {
            printf("kAudioConverterPropertyCanResumeFromInterruption property not supported - see comments in source for more info.\n");
            
        } else {
            printf("AudioConverterGetProperty kAudioConverterPropertyCanResumeFromInterruption result %d, paramErr is OK if PCM\n", (int)stts);
        }
        
        stts = noErr;
    }
    
    // Create the destination audio file.
    AudioFileID destinationFileId = 0;
    AudioFileCreateWithURL((__bridge CFURLRef _Nonnull)(self.destinationURL), kAudioFileCAFType, &destinationFormat, kAudioFileFlags_EraseFile, &destinationFileId);
    
    // Setup source buffers and data proc info struct.
    AudioFileIO afio;
    afio.srcFileId = sourceFileID;
    afio.srcBufferSize = 32768;
    afio.srcBuffer = malloc(afio.srcBufferSize * sizeof(char));
    afio.srcFilePos = 0;
    afio.srcFormat = sourceFormat;
    
    if (sourceFormat.mBytesPerPacket == 0) {
        
    } else {
        
    }
    
    // Set up output buffers
    
    
    
    
    
    
    
    // Cleanup
    
    
}


#pragma mark - Input data proc callback
static OSStatus EncoderDataProc(AudioConverterRef inAudioConverter,
                                UInt32 *ioNumberDataPackets,
                                AudioBufferList *ioData,
                                AudioStreamPacketDescription **outDataPacketDescription,
                                void *inUserData) {
    AudioFileIOPtr afio = (AudioFileIOPtr) inUserData;
    
    // figure out how much to read
    UInt32 maxPackets = afio->srcBufferSize / afio->srcSizePerPacket;
    if (*ioNumberDataPackets > maxPackets) {
        *ioNumberDataPackets = maxPackets;
    }
    
    // read from the file
    UInt32 outNumBytes = maxPackets * afio->srcSizePerPacket;
    
    OSStatus stts = AudioFileReadPacketData(afio->srcFileId, false, &outNumBytes, afio->packetDescriptions, afio->srcFilePos, ioNumberDataPackets, afio->srcBuffer);
    if (eofErr == stts) {
        stts = noErr;
    }
    if (stts) {
        printf ("Input Proc Read error: %d (%4.4s)\n", (int)stts, (char*)&stts);
        return stts;
    }
    afio->srcFilePos += *ioNumberDataPackets;
    
    // put the data pointer into the buffer list
    ioData->mBuffers[0].mData = afio->srcBuffer;
    ioData->mBuffers[0].mDataByteSize = outNumBytes;
    ioData->mBuffers[0].mNumberChannels = afio->srcFormat.mChannelsPerFrame;
    
    // don't forget the packet descriptions if required
    if (outDataPacketDescription) {
        if (afio->packetDescriptions) {
            *outDataPacketDescription = afio->packetDescriptions;
        } else {
            *outDataPacketDescription = NULL;
        }
    }
    
    return noErr;
}

#pragma mark - Notification Handler Methods
// MARK: Notification Handlers.

- (void)handleAudioSessionInterruptionNotification:(NSNotification *)notification {
    
}

@end
