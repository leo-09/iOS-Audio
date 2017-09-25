//
//  AudioUnit.h
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "JZAudioBuffer.h"

@interface JZAudioUnit : NSObject

@property (nonatomic) AUGraph auGraph;
@property (nonatomic) AUNode auNode;
@property (nonatomic) AudioUnit audioUnit;

@property (nonatomic, strong) JZAudioBuffer *inputBuffer;
@property (nonatomic, strong) JZAudioBuffer *outputBuffer;

@property (nonatomic, assign) BOOL isMute;// 是否静音
@property (nonatomic, assign) BOOL isTalk;// 是否对讲

- (instancetype)initUnitWitInput:(JZAudioBuffer *)input withOutput:(JZAudioBuffer *)output;

- (void)startAudioUnit;
- (void)stopAudioUnit;
- (void)uninitialUnit;

- (void) updateInputAudioStreamBasicDescription:(AudioStreamBasicDescription) format;
- (void) updateOutputAudioStreamBasicDescription:(AudioStreamBasicDescription) format;

@end
