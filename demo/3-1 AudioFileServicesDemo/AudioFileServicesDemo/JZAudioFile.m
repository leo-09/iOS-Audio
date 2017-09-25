//
//  JZAudioFile.m
//  AudioFileServicesDemo
//
//  Created by Ingenic_iOS on 2017/3/31.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZAudioFile.h"
#import <AudioToolbox/AudioToolbox.h>

#define VErr(err, msg) do {\
    if (err != nil) {\
        NSLog(@"[ERR]: %@----%@", (msg), [err   localizedDescription]);\
        return;\
    }\
} while(0)

#define VStatus(err, msg) do {\
    if(noErr != err){ \
        NSLog(@"[ERR-%d]:%@", err, (msg));\
        return;\
    }\
} while(0);

@interface JZAudioFile() {
    AudioFileID audioFile;
    char format[5];
    UInt32 maxPkgSize;
    UInt64 pkgCount;
}

@end

@implementation JZAudioFile

#pragma mark AudioFile

- (void) openAudioFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"caf"];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    
    OSStatus stts = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioFile);
    VStatus(stts, @"open audio file ");
}

- (void) readProperty {
    OSStatus stts;
    
    // 读取kAudioFilePropertyFileFormat属性
    UInt32 formatSize = 0;
    UInt32 formatIsWritable = 0;
    stts = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyFileFormat, &formatSize, &formatIsWritable);
    if (formatSize >4) {
        NSLog(@"format name length > 4");
        return ;
    }
    memset(format, 0, 5);
    stts = AudioFileGetProperty(audioFile, kAudioFilePropertyFileFormat, &formatSize, format);
    NSLog(@"Audio's format is %s", format);
    
    // 读取kAudioFilePropertyMaximumPacketSize属性
    UInt32 maximumPacketSize = 0;
    UInt32 maximumPacketSizeWriteable = 0;
    stts = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyMaximumPacketSize, &maximumPacketSize, &maximumPacketSizeWriteable);
    char *maximumPacketSizeBuf = (char *) malloc(maximumPacketSize + 1);
    memset(maximumPacketSizeBuf, 0, (maximumPacketSize + 1));
    stts = AudioFileGetProperty(audioFile, kAudioFilePropertyMaximumPacketSize, &maximumPacketSize, maximumPacketSizeBuf);
    maxPkgSize = *(int *) maximumPacketSizeBuf;
    
    // 读取kAudioFilePropertyAudioDataPacketCount属性
    UInt32 audioDataPacketCountSize = 0;
    UInt32 audioDataPacketCountSizeWriteable = 0;
    stts = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyAudioDataPacketCount, &audioDataPacketCountSize, &audioDataPacketCountSizeWriteable);
    if (audioDataPacketCountSize > sizeof(UInt64)) {
        return;
    }
    pkgCount = 0;
    stts = AudioFileGetProperty(audioFile, kAudioFilePropertyAudioDataPacketCount, &audioDataPacketCountSize, &pkgCount);
}

- (void) readAudioFileContent {
    OSStatus stts;
    
    char *packetBuf = (char *) malloc(maxPkgSize * 2);
    char *byteBuf = (char *) malloc(maxPkgSize);
    
    for (int i = 0; i < pkgCount; i += 2) {
        UInt32 packetBufLen = maxPkgSize * 2;
        memset(packetBuf, packetBufLen, 0);
        memset(byteBuf, maxPkgSize, 0);
        
        UInt32 pktNum = 2;
        if ((i+2) > pkgCount) {
            pktNum = 1;
        }
        
        AudioStreamPacketDescription desc[2];
        stts = AudioFileReadPacketData(audioFile, NO, &packetBufLen, desc, i, &pktNum, packetBuf);
        if (kAudioFileEndOfFileError == stts) {
            NSLog(@"End of File");
            break;
        }
        
        NSLog(@"[%d/%lld]Read two packet data,desc is %d,%d [packetBufLen:%d], [pktNum:%d]", i+2, pkgCount, desc[0].mDataByteSize, desc[1].mDataByteSize, packetBufLen, pktNum);
        
    }
    
    // 释放资源
    if (packetBuf != NULL) {
        free(packetBuf);
        packetBuf = NULL;
    }
    if (byteBuf != NULL) {
        free(byteBuf);
        byteBuf = NULL;
    }
}

- (void) closeAudioFile {
    OSStatus stts = AudioFileClose(audioFile);
    VStatus(stts, @"close audio file");
}

@end
