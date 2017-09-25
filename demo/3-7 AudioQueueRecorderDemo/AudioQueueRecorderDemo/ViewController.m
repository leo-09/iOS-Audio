//
//  ViewController.m
//  AudioQueueRecorderDemo
//
//  Created by Ingenic_iOS on 2017/3/21.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define VErr(err, msg)  do {\
    if(nil != err) {\
        NSLog(@"[ERR]:%@--%@", (msg), [err localizedDescription]);\
        return ;\
    }\
} while(0)

#define VStatus(err, msg) do {\
    if(noErr != err) {\
        NSLog(@"[ERR:%d]:%@", err, (msg));\
        return ;\
    }\
} while(0)

#define VStatusBOOL(err, msg) do {\
    if(noErr != err) {\
        NSLog(@"[ERR:%d]:%@", err, (msg));\
        return NO;\
    }\
} while(0)

enum {
    kNumberBuffers = 3,
    kNumberPackages = 10 * 1000
};

struct RecorderStat {
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[kNumberBuffers];
    AudioFileID mAudioFile;
    UInt32 bufferByteSize;
    SInt64 mCurrentPacket;
    bool mIsRunning;
};

@interface ViewController ()<AVAudioPlayerDelegate> {
    struct RecorderStat recorderStat;
}

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [NSString stringWithFormat:@"%@/%@", docDir, @"record.wav"];
}

#pragma mark - commont method

- (void) setAudioSession: (int) mode {
    NSError *error;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error != nil) {
        NSLog(@"AudioSession setActive error:%@", error.localizedDescription);
        return;
    }
    
    error = nil;
    NSString *category;
    if (mode == 1) {
        category = AVAudioSessionCategoryRecord;
    } else {
        category = AVAudioSessionCategorySoloAmbient;
    }
    
    [[AVAudioSession sharedInstance] setCategory:category error:&error];
    if (error != nil) {
        NSLog(@"AudioSession setCategory(AVAudioSessionCategoryPlayAndRecord) error:%@", error.localizedDescription);
        return;
    }
}

#pragma mark - 录音

- (IBAction)onRecord:(id)sender {
    static BOOL once = NO;
    if (! once ) {
        [self startRecord];
        [_recordBtn setImage:[UIImage imageNamed:@"btn_microphone_closed"] forState:UIControlStateNormal];
        once = YES;
    } else {
        [self stopRecord];
        [_recordBtn setImage:[UIImage imageNamed:@"btn_microphone_open"] forState:UIControlStateNormal];
        once = NO;
    }
}

- (void) startRecord {
    [self prepareAudioRecorder];
    
    [self setAudioSession:1];
    OSStatus stts = AudioQueueStart(recorderStat.mQueue, NULL);
    VStatus(stts, @"AudioQueueStart error");
    recorderStat.mIsRunning = YES;
}

- (BOOL) prepareAudioRecorder {
    OSStatus stts  = noErr;
    // step 1: set up the format of recording
    recorderStat.mDataFormat.mFormatID =  kAudioFormatLinearPCM;
    recorderStat.mDataFormat.mSampleRate = 44100.0;
    recorderStat.mDataFormat.mChannelsPerFrame = 2;
    recorderStat.mDataFormat.mBitsPerChannel = 16;
    recorderStat.mDataFormat.mFramesPerPacket = 1;
    recorderStat.mDataFormat.mBytesPerFrame = recorderStat.mDataFormat.mChannelsPerFrame * recorderStat.mDataFormat.mBitsPerChannel / 8;
    recorderStat.mDataFormat.mBytesPerPacket = recorderStat.mDataFormat.mBytesPerFrame * recorderStat.mDataFormat.mFramesPerPacket;
    recorderStat.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsBigEndian;
    
    // step 2: create audio intpu queue
    stts = AudioQueueNewInput(&recorderStat.mDataFormat, impAudioQueueInputCallback, &recorderStat,CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &recorderStat.mQueue);
    VStatusBOOL(stts, @"AudioQueueNewInput");
    
    // step 3: get the detail format
    UInt32 dataFormatSize = sizeof (recorderStat.mDataFormat);
    stts = AudioQueueGetProperty(recorderStat.mQueue, kAudioQueueProperty_StreamDescription, &recorderStat.mDataFormat, &dataFormatSize);
    VStatusBOOL(stts, @"AudioQueueGetProperty-AudioQueueGetProperty");
    
    // step 4: create audio file
    NSURL * tmpURL = [NSURL URLWithString:_filePath];
    CFURLRef url = (__bridge CFURLRef) tmpURL;
    stts = AudioFileCreateWithURL(url, kAudioFileAIFFType, &recorderStat.mDataFormat, kAudioFileFlags_EraseFile, &recorderStat.mAudioFile);
    VStatusBOOL(stts, @"AudioFileOpenURL");
    NSLog(@"open file %@ success!", url);
    
    // step 5: prepare buffers and buffer queue
    recorderStat.bufferByteSize = kNumberPackages * recorderStat.mDataFormat.mBytesPerPacket;
    for (int i=0; i<kNumberBuffers; i++) {
        AudioQueueAllocateBuffer(recorderStat.mQueue, recorderStat.bufferByteSize, &recorderStat.mBuffers[0]);
        AudioQueueEnqueueBuffer(recorderStat.mQueue, recorderStat.mBuffers[i], 0, NULL);
    }
    
    return YES;
}

- (void) stopRecord {
    [self disposeAudioRecorder];
    
    [self setAudioSession:0];
    recorderStat.mIsRunning = NO;
}

- (BOOL) disposeAudioRecorder {
    if (recorderStat.mQueue) {
        AudioQueueDispose(recorderStat.mQueue, false);
        recorderStat.mQueue = NULL;
    }
    
    if (recorderStat.mAudioFile) {
        AudioFileClose(recorderStat.mAudioFile);
        recorderStat.mAudioFile = NULL;
    }
    
    return YES;
}

// 录音回调
void impAudioQueueInputCallback ( void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp * inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs)
{
    struct RecorderStat *rs = (struct RecorderStat *)inUserData;
    
    if (!rs->mIsRunning) {
        OSStatus stts = AudioQueueStop(rs->mQueue, true);
        VStatus(stts, @"AudioQueueStop error");
        AudioFileClose(rs->mAudioFile);
    }
    
    if (inNumberPacketDescriptions == 0 && rs->mDataFormat.mBytesPerPacket != 0) {// for CBR
        inNumberPacketDescriptions = rs->bufferByteSize / rs->mDataFormat.mBytesPerPacket;
    }
    
    OSStatus stts = AudioFileWritePackets(rs->mAudioFile,
                                          false,
                                          rs->bufferByteSize,
                                          inPacketDescs,
                                          rs->mCurrentPacket,
                                          &inNumberPacketDescriptions,
                                          inBuffer->mAudioData);
    VStatus(stts, @"AudioFileWritePackets error");
    
    rs->mCurrentPacket += inNumberPacketDescriptions;
    stts = AudioQueueEnqueueBuffer(rs->mQueue, inBuffer, 0, NULL);
    VStatus(stts, @"AudioQueueEnqueueBuffer error");
}

#pragma mark - 播放

- (IBAction)onPlay:(id)sender {
    // prepareToPlay
    NSURL *url = [NSURL URLWithString:_filePath];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error != nil) {
        NSLog(@"create player[%@] error:%@", url, error.localizedDescription);
        return;
    }
    _player.delegate = self;
    _player.numberOfLoops = 99;
    BOOL rst = [_player prepareToPlay];
    NSLog(@"Prepare with %d", rst);
    NSLog(@"file length is %g", _player.duration);
    NSLog(@"channle number %lu", (unsigned long)_player.numberOfChannels);
    
    // play
    [self setAudioSession:0];
    rst = [_player play];
    NSLog(@"Play with %d", rst);
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying rst: %d", flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"audioPlayerDecodeErrorDidOccur error:%@", error.localizedDescription);
}

@end
