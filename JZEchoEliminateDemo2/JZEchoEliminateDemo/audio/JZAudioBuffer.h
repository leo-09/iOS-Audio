//
//  AudioBuffer.h
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define maxBufferSize (1024 * 1024 * 2)

@interface JZAudioBuffer : NSObject {
    char buffer[maxBufferSize];// 缓存数组
    long start, end;// 存储数据的起始、终点位置
    int usedSize;// 已经填充的数据的大小
    BOOL isWait;
}

// push／pop缓存数据
- (BOOL) pushData:(char *) inData withSize:(int) inDataSize;
- (BOOL) popDataTo:(char *) outData withSize:(int) outDataSize;

// 清空缓存
- (void) cleanAudioBuffer;
- (void) startAudioBuffer;

// 回收缓存
- (void) uninitialBuffer;

@end
