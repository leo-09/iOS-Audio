//
//  JZAudioManage.h
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZAudioUnit.h"

@interface JZAudioManage : NSObject {
    BOOL mute;// 是否静音
    BOOL talk;// 是否对讲
}

+ (instancetype) shareInstance;

// 填充音频数据
- (BOOL) pushData:(char *) inData withSize:(int) inDataSize;
// 取出音频数据
- (BOOL) popDataTo:(char *) outData withSize:(int) outDataSize;

- (BOOL) openMute;
- (BOOL) closeMute;

- (BOOL) openTalk;
- (BOOL) closeTalk;

// 回收资源
- (void) uninitAudioManage;

// 设置AudioStreamBasicDescription
- (void) setInputAudioStreamBasicDescription:(AudioStreamBasicDescription) format;
- (void) setOutputAudioStreamBasicDescription:(AudioStreamBasicDescription) format;

@end
