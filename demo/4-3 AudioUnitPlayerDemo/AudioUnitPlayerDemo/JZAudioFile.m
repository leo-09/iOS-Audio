//
//  JZAudioFile.m
//  AudioUnitPlayerDemo
//
//  Created by Ingenic_iOS on 2017/3/30.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioFile.h"

@implementation JZAudioFile

- (instancetype) init {
    if (self = [super init]) {
        packetCount = 0;
    }
    return self;
}

#pragma mark - public method

- (OSStatus) open:(NSString *) filePath {
    // 文件地址
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:filePath];
    OSStatus result = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioFile);
    
    if (result != noErr) {
        NSLog(@"filePath=== %@", filePath);
        packetCount = -1;
    } else {
        [self getFileInfo];
        
        UInt32 packetReads = packetCount;
        free(audioData);
        
        OSStatus result = -1;
        if (packetCount<=0) {
            
        }else{
            UInt32 numBytesRead = -1;
            audioData = (UInt32 *)malloc(sizeof(UInt32) * packetCount);
            result = AudioFileReadPackets(audioFile, false, &numBytesRead, NULL, 0, &packetReads, audioData);
            // AudioFileReadPacketData
        }
        
        if (result==noErr) {
            
        }
    }
    
    CFRelease(url);
    
    return result;
}

- (UInt32) getNextPacket {
    UInt32 resultvalue = 0;
    
    if (packetIndex >= packetCount) {
        packetIndex = 0;
    }
    resultvalue = audioData[packetIndex++];
    
    return resultvalue;
}

- (void) reset {
    packetIndex = 0;
}

#pragma mark - private method

- (OSStatus) getFileInfo {
    OSStatus result = -1;
    
    if (audioFile != nil) {
        UInt32 dataSize = sizeof(packetCount);
        result = AudioFileGetProperty(audioFile,
                                      kAudioFilePropertyAudioDataPacketCount,
                                      &dataSize,
                                      &packetCount);
        if (result == noErr) {
            double duration = ((double) packetCount * 2) / 44100;
            NSLog(@"duration===%f",duration);
        } else {
            packetCount = -1;
        }
    }
    
    return result;
}

- (SInt64) getIndex {
    return packetIndex;
}

@end
