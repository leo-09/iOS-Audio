//
//  JZAudioUnitPlayer.m
//  AudioUnitPlayerDemo
//
//  Created by Ingenic_iOS on 2017/3/30.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioUnitPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

#define kOutputBus 0
#define kInputBus 1

@interface JZAudioUnitPlayer() {
    AudioUnit audioUnit;
}

@end

@implementation JZAudioUnitPlayer

@synthesize jzAudioFile;

- (instancetype) init {
    if (self = [super init]) {
        [self initializeAudio];
    }
    
    return self;
}

#pragma mark - private method
- (void) initializeAudio {
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
    
    UInt32 flag = 1;
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Output,
                         kOutputBus,
                         &flag,
                         sizeof(flag));
    
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 2;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerFrame = audioFormat.mBitsPerChannel * audioFormat.mChannelsPerFrame / 8;
    audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket;
    
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         kInputBus,
                         &audioFormat,
                         sizeof(audioFormat));
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = playbackCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Global,
                         kOutputBus,
                         &callbackStruct,
                         sizeof(callbackStruct));
    
    AudioUnitInitialize(audioUnit);
}

static OSStatus playbackCallback(void *inRefCon,
                                 AudioUnitRenderActionFlags *ioActionFlags,
                                 const AudioTimeStamp *inTimeStamp,
                                 UInt32 inBusNumber,
                                 UInt32 inNumberFrames,
                                 AudioBufferList *ioData) {
    JZAudioFile *this = (__bridge JZAudioFile *) inRefCon;
    
    for (int i = 0; i < ioData->mNumberBuffers; i++) {
        AudioBuffer buffer = ioData->mBuffers[i];
        UInt32 *frameBuffer = buffer.mData;
        
        for (int j = 0; i < inNumberFrames; j++) {
            frameBuffer[j] = [this.jzAudioFile getNextPacket];
        }
    }
    
    return noErr;
}

#pragma mark - public method

- (OSStatus) start {
    return AudioOutputUnitStart(audioUnit);
}

- (OSStatus) stop {
    return AudioOutputUnitStop(audioUnit);
}

- (void) cleanup {
    AudioUnitUninitialize(audioUnit);
}

@end
