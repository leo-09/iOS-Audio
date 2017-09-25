//
//  ViewController.m
//  AudioUnitMixerDemo
//
//  Created by Ingenic_iOS on 2017/3/30.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#pragma mark    异常打印
static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    
    char str[20];
    // see if it appears to be a 4-char-code
    *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\'';
        str[6] = '\0';
    } else
        // no, format it as an integer
        sprintf(str, "%d", (int)error);
    
    fprintf(stderr, "Error: %s (%s)\n", operation, str);
    
    exit(1);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initVoiceProcessingIO {
    // 1.Configure your audio session.
    // 2.Specify audio units.
    // 3.Create an audio processing graph, then obtain the audio units.
    // 4.Configure the audio units.
    // 5.Connect the audio unit nodes.
    // 6.Provide a user interface.
    // 7.Initialize and then start the audio processing graph.
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [[AVAudioSession sharedInstance] setPreferredSampleRate:11400 error:&error];
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.005f error:&error];
//    [[AVAudioSession sharedInstance] setPreferredOutputNumberOfChannels:1 error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    
    // create AUGraph
    AUGraph auGraph;
    CheckError(NewAUGraph(&auGraph), "");
    
    // I/O unit
    AudioComponentDescription ioUnitDescription;
    ioUnitDescription.componentType = kAudioUnitType_Output;
    ioUnitDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    ioUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    ioUnitDescription.componentFlags = 0;
    ioUnitDescription.componentFlagsMask = 0;
    
    // Multichannel mixer unit
    AudioComponentDescription mixerUnitDescription;
    mixerUnitDescription.componentType = kAudioUnitType_Mixer;
    mixerUnitDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
    mixerUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    mixerUnitDescription.componentFlags = 0;
    mixerUnitDescription.componentFlagsMask = 0;
    
    AUNode ioNode;
    AUNode mixerNode;
    CheckError(AUGraphAddNode(auGraph, &ioUnitDescription, &ioNode), "");
    CheckError(AUGraphAddNode(auGraph, &mixerUnitDescription, &mixerNode), "");
    
    // open the AUGraph
    CheckError(AUGraphOpen(auGraph), "");
    
    // Obtain unit instance
    AudioUnit mixerUnit;
    AudioUnit ioUnit;
    
    CheckError(AUGraphNodeInfo(auGraph, ioNode, NULL, &ioUnit), "");
    CheckError(AUGraphNodeInfo(auGraph, mixerNode, NULL, &mixerUnit), "");
    
    ////////////////////////////////////////////////////////////////
    UInt32 busCount = 2; // bus count for mixer unit input
    UInt32 guitarBus = 0; // mixer unit bus 0 will be stereo and will take the guitar sound
    UInt32 beatBus = 1; // mixer unit bus 1 will be mono and will take the beats sound
    
    CheckError(AudioUnitSetProperty(mixerUnit,
                                    kAudioUnitProperty_ElementCount,
                                    kAudioUnitScope_Input,
                                    0,
                                    &busCount,
                                    sizeof(busCount)),
               "");
    
    UInt32 maximumFramesPerSlice = 4096;
    CheckError(AudioUnitSetProperty(mixerUnit,
                                    kAudioUnitProperty_MaximumFramesPerSlice,
                                    kAudioUnitScope_Global,
                                    0,
                                    &maximumFramesPerSlice,
                                    sizeof(maximumFramesPerSlice)),
               "");
    
    // Attach the input render callback and context to each input bus
    for (UInt16 busNumber = 0; busNumber < busCount; busNumber++) {
        // Setup the struture that contains the input render callback
        AURenderCallbackStruct playCallback;
        playCallback.inputProc = callback;
        playCallback.inputProcRefCon = (__bridge void *)self;
        
        // Set a callback for the specified node's specified input
        CheckError(AUGraphSetNodeInputCallback(auGraph, mixerNode, busNumber, &playCallback),
                   "");
    }
    
    // Config mixer unit input default format
    AudioStreamBasicDescription fmt;
    fmt.mSampleRate = 44100; // 44.1kbps sample rate
    fmt.mFormatID = kAudioFormatLinearPCM;// pcm data
    fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt.mFramesPerPacket = 1;
    fmt.mChannelsPerFrame = 2; // double channel
    fmt.mBitsPerChannel = 16; // 16bit
    fmt.mBytesPerFrame = fmt.mBitsPerChannel * fmt.mChannelsPerFrame / 8;
    fmt.mBytesPerPacket = fmt.mBytesPerFrame * fmt.mFramesPerPacket;
    
    
    
//    fmt.mReserved
    
    CheckError(AudioUnitSetProperty(mixerUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    guitarBus,
                                    &fmt,
                                    sizeof(fmt)),
               "");
    CheckError(AudioUnitSetProperty(mixerUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    beatBus,
                                    &fmt,
                                    sizeof(fmt)),
               "");
    
    Float64 graphSampleRate = 44100.0;    // Hertz;
    CheckError(AudioUnitSetProperty(mixerUnit,
                                    kAudioUnitProperty_SampleRate,
                                    kAudioUnitScope_Output,
                                    0,
                                    &graphSampleRate,
                                    sizeof(graphSampleRate)),
               "");
    
    ////////////////////////////////////////////////////////////////
    // config void unit IO Enable status
    UInt32 flag = 1;
    CheckError(AudioUnitSetProperty(ioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,
                                    0,
                                    &flag,
                                    sizeof(flag)),
               "");
    CheckError(AudioUnitSetProperty(ioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    1,
                                    &flag
                                    ,
                                    sizeof(flag)),
               "");
    CheckError(AudioUnitSetProperty(ioUnit,
                                    kAudioUnitProperty_MaximumFramesPerSlice,
                                    kAudioUnitScope_Global,
                                    0,
                                    &maximumFramesPerSlice,
                                    sizeof(UInt32)),
               "");
    
    // Set the record callback
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc = callback;
    recordCallback.inputProcRefCon = (__bridge void *)self;
    CheckError(AudioUnitSetProperty(ioUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Global,
                                    1,
                                    &recordCallback, sizeof(recordCallback)),
               "");
    
    // set buffer allocate
    flag = 0;
    CheckError(AudioUnitSetProperty(ioUnit,
                                    kAudioUnitProperty_ShouldAllocateBuffer,
                                    kAudioUnitScope_Output,
                                    1,
                                    &flag,
                                    sizeof(flag)),
               "");
    
    ////////////////////////////////////////////////////////////////
    // Initialize the output IO instance
    CheckError(AUGraphConnectNodeInput(auGraph,
                                       mixerNode,
                                       0,
                                       ioNode,
                                       0),
               "");
    CheckError(AUGraphInitialize(auGraph),
               "");
    
}

static OSStatus	callback(void						*inRefCon,
                         AudioUnitRenderActionFlags 	*ioActionFlags,
                         const AudioTimeStamp 		*inTimeStamp,
                         UInt32 						inBusNumber,
                         UInt32 						inNumberFrames,
                         AudioBufferList 			*ioData) {
    
    
    return noErr;
}

@end
