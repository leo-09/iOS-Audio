//
//  JZAudioManage.m
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioManage.h"

@implementation JZAudioManage

#pragma mark - 成员变量
static JZAudioUnit *audioUnit;
static JZAudioBuffer *inputBuffer;
static JZAudioBuffer *outputBuffer;

#pragma mark - 实现单例

static JZAudioManage *instance = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        
        inputBuffer = [[JZAudioBuffer alloc] init];
        outputBuffer = [[JZAudioBuffer alloc] init];
        
        audioUnit = [[JZAudioUnit alloc] initUnitWitInput:inputBuffer withOutput:outputBuffer];
        [audioUnit startAudioUnit];
    });
    
    return instance;
}

+ (id) allocWithZone:(struct _NSZone *) zone {
    return [JZAudioManage shareInstance];
}

- (id) copyWithZone:(struct _NSZone *) zone {
    return [JZAudioManage shareInstance];
}

#pragma mark - 添加音频输入流数据／取出录音的输出流数据

- (BOOL) pushData:(char *) inData withSize:(int) inDataSize {
    return [inputBuffer pushData:inData withSize:inDataSize];
}

- (BOOL) popDataTo:(char *) outData withSize:(int) outDataSize {
    return [outputBuffer popDataTo:outData withSize:outDataSize];
}

#pragma mark - 音频流程控制：是否静音／是否对讲/是否录音

- (BOOL) openMute {
    // 正在对讲  都不可以操作静音
    if (talk) {
        //        return NO;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("muteQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        [inputBuffer cleanAudioBuffer];
        [audioUnit stopAudioUnit];
    });
    
    mute = YES;
    audioUnit.isMute = YES;
    
    return YES;
}

- (BOOL) closeMute {
    mute = NO;
    audioUnit.isMute = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("muteQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        [inputBuffer startAudioBuffer];
        [audioUnit startAudioUnit];
    });
    
    return YES;
}

- (BOOL) openTalk {
    // 正在录音/静音 则不可以对讲
    if (mute) {
        //        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputBuffer startAudioBuffer];
        [audioUnit startAudioUnit];
    });
    
    talk = YES;
    audioUnit.isTalk = YES;
    
    return YES;
}

- (BOOL) closeTalk {
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputBuffer cleanAudioBuffer];
        // 录音完不需要[audioUnit stopAudioUnit];
    });
    
    talk = NO;
    audioUnit.isTalk = NO;
    
    return YES;
}

#pragma mark - 回收资源

- (void) uninitAudioManage {
    [audioUnit stopAudioUnit];
    [audioUnit uninitialUnit];
    audioUnit = nil;
    
//    [inputBuffer cleanAudioBuffer];
//    [inputBuffer uninitialBuffer];
//    inputBuffer = nil;
//    
//    [outputBuffer cleanAudioBuffer];
//    [outputBuffer uninitialBuffer];
//    outputBuffer = nil;
}

#pragma mark - 设置AudioStreamBasicDescription

- (void) setInputAudioStreamBasicDescription:(AudioStreamBasicDescription) format {
    [audioUnit updateInputAudioStreamBasicDescription:format];
}

- (void) setOutputAudioStreamBasicDescription:(AudioStreamBasicDescription) format {
    [audioUnit updateOutputAudioStreamBasicDescription:format];
}

@end
