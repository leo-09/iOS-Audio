//
//  ViewController.m
//  AudioUnitLoopDemo
//
//  Created by Ingenic_iOS on 2017/3/22.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef struct AUGraphStruct {
    AUGraph graph;
    AudioUnit remoteIOUnit;
} AUGraphStruct;
AUGraphStruct myStruct;

#define BUFFER_COUNT 15

AudioBuffer recordedBuffers[BUFFER_COUNT];// Used to save audio data
int currentBufferPointer;// Pointer to the current buffer
int callbackCount;

static void CheckError(OSStatus error, const char *operation) {
    if (error == noErr) {
        return;
    }
    
    char errorString[20];
    // See if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else {
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
    }
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

OSStatus InputCallback(void *inRefCon,                              // 回调执行的上下文
                       AudioUnitRenderActionFlags *ioActionFlags,   // 回调上下文的设置(没有数据则设置成kAudioUnitRenderAction_OutputIsSilence)
                       const AudioTimeStamp *inTimeStamp,           // 回调被执行的时间，但不是绝对时间，而是采样帧的数目
                       UInt32 inBusNumber,                          // 通道数
                       UInt32 inNumberFrames,
                       AudioBufferList *ioData)                     // 具体的使用的数据，比如播放文件时，将文件内容填入。
{
    AUGraphStruct* myStruct = (AUGraphStruct*) inRefCon;
    
    // Get samples from input bus(bus 1)
    OSStatus status = AudioUnitRender(myStruct->remoteIOUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      1,
                                      inNumberFrames,
                                      ioData);
    CheckError(status, "AudioUnitRender failed");
    
    // save audio to ring buffer and load from ring buffer
    AudioBuffer buffer = ioData->mBuffers[0];
    recordedBuffers[currentBufferPointer].mNumberChannels = buffer.mNumberChannels;
    recordedBuffers[currentBufferPointer].mDataByteSize = buffer.mDataByteSize;
    free(recordedBuffers[currentBufferPointer].mData);
    recordedBuffers[currentBufferPointer].mData = malloc(sizeof(SInt16)*buffer.mDataByteSize);
    memcpy(recordedBuffers[currentBufferPointer].mData, buffer.mData, buffer.mDataByteSize);
    currentBufferPointer = (currentBufferPointer+1) % BUFFER_COUNT;
    
    if (callbackCount >= BUFFER_COUNT) {
        memcpy(buffer.mData, recordedBuffers[currentBufferPointer].mData, buffer.mDataByteSize);
    }
    callbackCount++;
    
    return noErr;
}

@interface ViewController() {
    AUGraph _processingGraph;
    AUNode _remoteIONode;
    AudioUnit _remoteIOUnit;
    AudioComponentDescription _remoteIODesc;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize currentBufferPointer
    currentBufferPointer = 0;
    callbackCount = 0;
    
    [self setupSession];
    [self createAUGraph:&myStruct];
    [self setupRemoteIOUnit:&myStruct];
    [self startGraph:myStruct.graph];
    [self addControlButton];
}

-(void)setupSession {
    // 将声音输出route到speaker，这样声音比较大，回声明显
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

-(void)createAUGraph:(AUGraphStruct *) myStruct {
    // 创建一个 AUGraph
    CheckError(NewAUGraph(&myStruct->graph),
               "NewAUGraph failed");
    
    // 配置AudioComponentDescription
    AudioComponentDescription inputDesc;
    inputDesc.componentType = kAudioUnitType_Output;  // 输入输出单元
    // RemoteIO不带回声消除功能，VoiceProcessingIO类型的才带(VoIP输入输出)
    inputDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    inputDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    inputDesc.componentFlags = 0;
    inputDesc.componentFlagsMask = 0;
    
    // 得到AUNode, Node表示在图中的一个节点
    AUNode remoteIONode;
    CheckError(AUGraphAddNode(myStruct->graph, &inputDesc, &remoteIONode),
               "AUGraphAddNode failed");
    
    // Open the graph
    CheckError(AUGraphOpen(myStruct->graph),
               "AUGraphOpen failed");
    
    // 这个Node里面包含了需要的“AudioComponent”,即AudioUnit
    CheckError(AUGraphNodeInfo(myStruct->graph, remoteIONode, &inputDesc, &myStruct->remoteIOUnit),
               "AUGraphNodeInfo failed");
}

-(void)setupRemoteIOUnit:(AUGraphStruct*) myStruct {
    // Open input of the bus 1(input mic)
    UInt32 enableFlag = 1;
    CheckError(AudioUnitSetProperty(myStruct->remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,              // 输入scope
                                    1,                                  // Element: Input用“1”（和I很像）表示
                                    &enableFlag,
                                    sizeof(enableFlag)),
               "Open input of bus 1 failed");
    
    // Open output of bus 0(output speaker)
    CheckError(AudioUnitSetProperty(myStruct->remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,  //
                                    kAudioUnitScope_Output,             // 输出scope
                                    0,                                  // Element: Output用“0”（和O很像）表示
                                    &enableFlag,
                                    sizeof(enableFlag)),
               "Open output of bus 0 failed");
    
    // 配置输入输出的数据格式
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = 44100;   // 采样率
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    streamFormat.mFramesPerPacket = 1;  //
    streamFormat.mChannelsPerFrame = 1; // 声道数
    streamFormat.mBitsPerChannel = 16;  // 位数
    streamFormat.mBytesPerFrame = streamFormat.mBitsPerChannel * streamFormat.mChannelsPerFrame / 8;
    streamFormat.mBytesPerPacket = streamFormat.mBytesPerFrame * streamFormat.mFramesPerPacket;
    
    
    CheckError(AudioUnitSetProperty(myStruct->remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &streamFormat,
                                    sizeof(streamFormat)),
               "kAudioUnitProperty_StreamFormat of bus 0 failed");
    
    CheckError(AudioUnitSetProperty(myStruct->remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    1,
                                    &streamFormat,
                                    sizeof(streamFormat)),
               "kAudioUnitProperty_StreamFormat of bus 1 failed");
    
    // 配置录音回调
    AURenderCallbackStruct input;// 回调结构体
    input.inputProc = InputCallback;    // 回调的实现
    input.inputProcRefCon = myStruct;   // 回调执行的上下文
    
    CheckError(AudioUnitSetProperty(myStruct->remoteIOUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Global,
                                    0,//input mic
                                    &input,
                                    sizeof(input)),
               "kAudioUnitProperty_SetRenderCallback failed");
}

-(void)startGraph:(AUGraph) graph {
    CheckError(AUGraphInitialize(graph),
               "AUGraphInitialize failed");
    CheckError(AUGraphStart(graph),
               "AUGraphStart failed");
}

- (void)addControlButton {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(60, 60, 200, 50);
    [button setTitle:@"Echo cancellation is open" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(openOrCloseEchoCancellation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)openOrCloseEchoCancellation:(UIButton*) button {
    UInt32 echoCancellation;
    UInt32 size = sizeof(echoCancellation);
    // 给回声消除添加一个开关。VoiceProcessingIO有一个属性可用来打开/关闭回声消除功能：kAUVoiceIOProperty_BypassVoiceProcessing
    CheckError(AudioUnitGetProperty(myStruct.remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &echoCancellation,
                                    &size),
               "kAUVoiceIOProperty_BypassVoiceProcessing failed");
    if (echoCancellation == 0) {
        echoCancellation = 1;
    } else {
        echoCancellation = 0;
    }
    
    CheckError(AudioUnitSetProperty(myStruct.remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &echoCancellation,
                                    sizeof(echoCancellation)),
               "AudioUnitSetProperty kAUVoiceIOProperty_BypassVoiceProcessing failed");
    
    NSString *text = (echoCancellation == 0 ? @"Echo cancellation is open" : @"Echo cancellation is closed");
    [button setTitle:text forState:UIControlStateNormal];
}

@end
