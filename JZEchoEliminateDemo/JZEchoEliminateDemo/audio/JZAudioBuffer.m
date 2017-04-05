//
//  AudioBuffer.m
//  AudioUnitEliminateEchoDemo
//
//  Created by liyy on 2017/3/29.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioBuffer.h"

@implementation JZAudioBuffer

- (instancetype) init {
    if (self = [super init]) {
        memset(buffer, 0, maxBufferSize);
        start = 0;
        end = 0;
        usedSize = 0;
        isWait = NO;
    }
    
    return self;
}

#pragma mark - 缓存数组的空间大小

// 获取已用空间的大小
- (int) getUsedDataSize {
    @synchronized (self) {
        return usedSize;
    }
}

// 获取剩余空间的大小
- (int) getRemainSize {
    @synchronized (self) {
        return (maxBufferSize - usedSize);
    }
}

#pragma mark - 清空缓存
- (void) cleanAudioBuffer {
    @synchronized (self) {
        memset(buffer, 0, maxBufferSize);
        start = 0;
        end = 0;
        usedSize = 0;
        isWait = YES;
    }
}

- (void) startAudioBuffer {
    isWait = NO;
}

#pragma mark - 回收缓存
- (void) uninitialBuffer {
    //    free(buffer);
}

#pragma mark - push／pop缓存数据

- (BOOL) pushData:(char *) inData withSize:(int) inDataSize {
    while ([self getRemainSize] < inDataSize) {// 剩余空间不足,则等待
        if (isWait) {
            return NO;
        }
        usleep(1000);
    }
    
    @synchronized (self) {
        if ((end + inDataSize) > maxBufferSize) {
            // 填充的数据越界了
            long remind = maxBufferSize - end;
            
            memcpy(buffer+end, inData, remind);// 先填充数组的剩余空间
            memcpy(buffer, inData + remind, (inDataSize - remind));// 再从数组起始位置开始填充数据
            
            end = inDataSize - remind;
        } else {
            // 填充的数据没有越界
            memcpy(buffer + end, inData, inDataSize);// 直接填充到数组的剩余空间
            end += inDataSize;
        }
        
        usedSize += inDataSize;
    }
    
    return YES;
}

- (BOOL) popDataTo:(char *) outData withSize:(int) outDataSize {
    while ([self getUsedDataSize] < outDataSize) {
        if (isWait) {
            return NO;
        }
        usleep(1000);
    }
    
    @synchronized (self) {
        if (start + outDataSize > maxBufferSize) {
            // 取出的数据越界了
            long aRemind = maxBufferSize - start;
            
            memcpy(outData, buffer + start, aRemind);// 先取出数组后半部分的数据
            memset(buffer + start, 0, aRemind);// 取出的数据空间置为0
            
            memcpy(outData + aRemind, buffer, outDataSize-aRemind);// 再从数组起始位置去数据
            memset(buffer, 0, outDataSize - aRemind);// 取出的数据空间置为0
            
            start = outDataSize-aRemind;
        } else {
            // 取出的数据没有越界
            memcpy(outData, buffer + start, outDataSize);// 直接从start位置取出数据添加到outData中
            memset(buffer + start, 0, outDataSize);// 取出的数据空间置为0
            start += outDataSize;
        }
        
        usedSize -= outDataSize;
    }
    
    return YES;
}

@end
