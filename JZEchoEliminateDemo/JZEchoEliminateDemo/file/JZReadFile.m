//
//  JZReadFile.m
//  JZEchoEliminateDemo
//
//  Created by liyangyang on 2017/4/5.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZReadFile.h"

@interface JZReadFile() {
    AudioFileID audioID;
    AudioStreamBasicDescription format;
    UInt32  maxPkgSize_;
    UInt64 pkgNum_;
    
    NSString *filePath;
}

@end

@implementation JZReadFile

- (instancetype) initWithPath:(NSString *)path {
    if (self = [super init]) {
        filePath = path;
    }
    
    return self;
}

- (void) openAudioFile {
    [self openFile];
    [self readProperty];
}

- (void) openFile {
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:filePath];
    AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioID);
}

- (void)readProperty {
    OSStatus stts;
    
    // kAudioFilePropertyDataFormat
    UInt32 audioFilePropertyDataFormat = 0;
    UInt32 audioFilePropertyDataFormatWritable = 0;
    AudioFileGetPropertyInfo(audioID, kAudioFilePropertyDataFormat, &audioFilePropertyDataFormat, &audioFilePropertyDataFormatWritable);
    AudioFileGetProperty(audioID, kAudioFilePropertyDataFormat, &audioFilePropertyDataFormat, &format);
    
    // kAudioFilePropertyMaximumPacketSize
    UInt32 audioFilePropertyMaximumPacketSize = 0;
    UInt32 audioFilePropertyMaximumPacketSizeWritable = 0;
    AudioFileGetPropertyInfo(audioID, kAudioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSizeWritable);
    char *audioFilePropertyMaximumPacketSizeBuf = (char *)malloc(audioFilePropertyMaximumPacketSize+1);
    if (NULL == audioFilePropertyMaximumPacketSizeBuf) {
        NSLog(@"audioFilePropertyMaximumPacketSizeBuf is NULL");
        return ;
    }
    memset(audioFilePropertyMaximumPacketSizeBuf, 0, audioFilePropertyMaximumPacketSize+1);
    stts = AudioFileGetProperty(audioID, kAudioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSize, audioFilePropertyMaximumPacketSizeBuf);
    maxPkgSize_ = *(int *)audioFilePropertyMaximumPacketSizeBuf;
    NSLog(@"Audio's max packet size  is %d", maxPkgSize_);
    
    // kAudioFilePropertyAudioDataPacketCount
    UInt32 audioFilePropertyAudioDataPacketCountSize = 0;
    UInt32 audioFilePropertyAudioDataPacketCountSizeWritable = 0;
    stts = AudioFileGetPropertyInfo(audioID, kAudioFilePropertyAudioDataPacketCount, &audioFilePropertyAudioDataPacketCountSize, &audioFilePropertyAudioDataPacketCountSizeWritable);
    if (audioFilePropertyAudioDataPacketCountSize>sizeof(UInt64)) {
        NSLog(@"what a big number");
        return;
    }
    pkgNum_ = 0;
    stts = AudioFileGetProperty(audioID, kAudioFilePropertyAudioDataPacketCount, &audioFilePropertyAudioDataPacketCountSize, &pkgNum_);
    NSLog(@"Audio's  packet number  is %llu", pkgNum_);
}

- (void)readFileContent {
    OSStatus stts;
    
    int count = 64;
    
    char *packetBuf = (char *) malloc( maxPkgSize_ * count);
    if (NULL == packetBuf) {
        NSLog(@"NULL == packetBuf || NULL == byteBuf");
        return ;
    }
    
    for (int i = 0; i < pkgNum_ ;i += count) {
        UInt32 packetBufLen = maxPkgSize_ * count;
        memset(packetBuf, 0, packetBufLen);
        
        AudioStreamPacketDescription aspDesc[count];
        
        UInt32 pktNum = count;
        if ((i + count) > pkgNum_) {
            pktNum = (UInt32)pkgNum_ - i;
        }
        stts = AudioFileReadPacketData(audioID, NO, &packetBufLen, aspDesc, i, &pktNum, packetBuf);
        if (kAudioFileEndOfFileError == stts) {
            NSLog(@"End of File");
            break;
        }
        
        if (readAudioDataListener) {
            readAudioDataListener(packetBuf, packetBufLen);
        }
        
        NSLog(@"[%d/%lld]Read two packet data,desc is %d,%d [packetBufLen:%d], [pktNum:%d]", i+2, pkgNum_, aspDesc[0].mDataByteSize, aspDesc[1].mDataByteSize, packetBufLen, pktNum);
    }
    
    if (NULL != packetBuf) {
        free(packetBuf);
        packetBuf = NULL;
    }
}

- (void) closeFile {
    OSStatus stts;
    stts = AudioFileClose(audioID);
    NSLog(@"Close File Success");
}
    
- (AudioStreamBasicDescription) getFormat {
    return format;
}

- (void) setReadAudioDataListener:(void (^)(char *data, int size))listener {
    readAudioDataListener = listener;
}

@end
