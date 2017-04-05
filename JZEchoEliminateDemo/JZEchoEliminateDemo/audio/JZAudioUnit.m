//
//  AudioUnit.m
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioUnit.h"
#import <AVFoundation/AVFoundation.h>

#define inputElement 1
#define outputElement 0

#pragma mark - 异常打印
static void CheckError(OSStatus error, const char *operation) {
    if (error == noErr) {
        return;
    }
    
    char str[20];
    // see if it appears to be a 4-char-code
    *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\'';
        str[6] = '\0';
    } else {
        sprintf(str, "%d", (int)error);// no, format it as an integer
    }
    
    fprintf(stderr, "Error: %s (%s)\n", operation, str);
    
    exit(1);
}

@implementation JZAudioUnit

#pragma mark - 公共接口

- (instancetype)initUnitWitInput:(JZAudioBuffer *)input withOutput:(JZAudioBuffer *)output {
    if (self = [super init]) {
        if (input == nil || output == nil) {
            NSLog(@"没有添加输入输出音频单元");
            return nil;
        }
        
        self.inputBuffer = input;
        self.outputBuffer = output;
        
        [self initVoIPIOUnit];
    }
    
    return self;
}

- (void)startAudioUnit {
    CheckError(AUGraphStart(_auGraph),
               "couldn't AUGraphStart");
}

- (void)stopAudioUnit {
    CheckError(AUGraphStop(_auGraph),
               "couldn't AUGraphStop");
}

- (void)uninitialUnit {
    CheckError(AUGraphClose(_auGraph),
               "couldn't AUGraphClose");
}

#pragma mark - 初始化并设置VoiceProcessingIO

- (void)initVoIPIOUnit {
    [self setAudioSession];
    [self createAudioUnit];
    [self setAudioUnitProperty];
    [self setAudioStreamBasicDescription];
    [self setCallback];
    [self showAUGraph];
}

// 设置AudioSession
- (void) setAudioSession {
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    
    // 将声音输出route到speaker，这样声音比较大，回声明显
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    [audioSession setActive:YES error:&error];
}

- (void) createAudioUnit {
    // 创建一个 AUGraph
    CheckError(NewAUGraph(&_auGraph),
               "couldn't new AUGraph");
    CheckError(AUGraphOpen(_auGraph),
               "couldn't open AUGraph");
    
    // 配置AudioComponentDescription
    AudioComponentDescription componentDesc;
    componentDesc.componentType = kAudioUnitType_Output;
    componentDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;// VoiceProcessingIO带回声消除功能
    componentDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    componentDesc.componentFlags = 0;
    componentDesc.componentFlagsMask = 0;
    
    // 得到AUNode, Node表示在图中的一个节点
    CheckError (AUGraphAddNode(_auGraph, &componentDesc, &_auNode),
                "couldn't add remote io node");
    
    // 这个Node里面包含了需要的“AudioComponent”, 即AudioUnit
    CheckError(AUGraphNodeInfo(_auGraph, _auNode,NULL,&_audioUnit),
               "couldn't get remote io unit from node");
}

- (void) setAudioUnitProperty {
    UInt32 oneFlag = 1;
    
    // Open output of bus 0(output speaker)
    CheckError(AudioUnitSetProperty(_audioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,             // 输出scope
                                    outputElement,                      // Element: Output用“0”（和O很像）表示
                                    &oneFlag,
                                    sizeof(oneFlag)),
               "couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Output");
    
    // Open input of the bus 1(input mic)
    CheckError(AudioUnitSetProperty(_audioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,              // 输入scope
                                    inputElement,                       // Element: Input用“1”（和I很像）表示
                                    &oneFlag,
                                    sizeof(oneFlag)),
               "couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Input");
}

- (void) setAudioStreamBasicDescription {
    // 重新设置AudioStreamBasicDescription
    AudioStreamBasicDescription format;
    UInt32 propSize = sizeof(format);
    CheckError(AudioUnitGetProperty(_audioUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    outputElement,
                                    &format,
                                    &propSize),
               "couldn't get kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output");
    
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    format.mSampleRate = 44100;
    format.mFramesPerPacket = 1;
    format.mBytesPerFrame = 2;
    format.mBytesPerPacket = 2;
    format.mChannelsPerFrame = 1;
    format.mBitsPerChannel = 16;
    
    [self updateInputAudioStreamBasicDescription:format];
    [self updateOutputAudioStreamBasicDescription:format];
}

- (void) updateInputAudioStreamBasicDescription:(AudioStreamBasicDescription) format {
    UInt32 propSize = sizeof(format);
    CheckError(AudioUnitSetProperty(_audioUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    outputElement,
                                    &format,
                                    propSize),
               "couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Input");
}

- (void) updateOutputAudioStreamBasicDescription:(AudioStreamBasicDescription) format {
    UInt32 propSize = sizeof(format);
    CheckError(AudioUnitSetProperty(_audioUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    inputElement,
                                    &format,
                                    propSize),
               "couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output");
}

- (void) setCallback {
    // 配置回调
    AURenderCallbackStruct inputProc;// 回调结构体
    inputProc.inputProc = audioCallback;// 回调的实现
    inputProc.inputProcRefCon = (__bridge void *)(self);// 回调执行的上下文
    CheckError(AUGraphSetNodeInputCallback(_auGraph, _auNode, 0, &inputProc),
               "Error setting io output callback");
}

- (void) showAUGraph {
    CheckError(AUGraphInitialize(_auGraph),
               "couldn't AUGraphInitialize");
    CheckError(AUGraphUpdate(_auGraph, NULL),
               "couldn't AUGraphUpdate" );
    CAShow(_auGraph);
}

#pragma mark - 回调
static OSStatus	audioCallback(void                          *inRefCon,      // 回调执行的上下文
                              AudioUnitRenderActionFlags 	*ioActionFlags, // 回调上下文的设置(没有数据则是kAudioUnitRenderAction_OutputIsSilence)
                              const AudioTimeStamp          *inTimeStamp,   // 回调被执行的时间，但不是绝对时间，而是采样帧的数目
                              UInt32 						inBusNumber,    // 通道数
                              UInt32 						inNumberFrames,
                              AudioBufferList               *ioData) {      // 具体的使用的数据，比如播放文件时，将文件内容填入
    JZAudioUnit *this = (__bridge JZAudioUnit*) inRefCon;
    
    // 对讲，则将数据写入outputBuffer
    if (this.isTalk) {
        // 回声消除
        AudioUnitRender(this.audioUnit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
        
        [this.outputBuffer pushData:ioData->mBuffers[0].mData withSize:ioData->mBuffers[0].mDataByteSize];
    }
    
    // 不静音，则将数据写入inputBuffer
    if (!this.isMute) {
        [this.inputBuffer popDataTo:ioData->mBuffers[0].mData withSize:ioData->mBuffers[0].mDataByteSize];
    }
    
    return noErr;
}

@end
