//
//  JZWriteFile.m
//  JZEchoEliminateDemo
//
//  Created by liyangyang on 2017/4/5.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "JZWriteFile.h"

@interface JZWriteFile() {
    AudioFileID audioID;
    NSString *path;
    
    AudioStreamBasicDescription format;
    AudioStreamPacketDescription *inPacketDescriptions;
    SInt64 inStartingPacket;
    UInt32 ioNumPackets;
    
    AVAudioPlayer *player;
}

@end

@implementation JZWriteFile

- (instancetype) initWithIONumPackets:(UInt32) num {
    if (self = [super init]) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [NSString stringWithFormat:@"%@/%@", docPath, @"record.wav"];
        
        inStartingPacket = 0;
        ioNumPackets = num;
    }
    
    return self;
}

- (void) createAudioFile {
    CFURLRef url = (__bridge CFURLRef)[NSURL URLWithString:path];
    AudioFileCreateWithURL(url, kAudioFileWAVEType, &format, kAudioFileFlags_EraseFile, &audioID);
}

- (void) writeData:(char *)inData size:(int) size {
    AudioFileWritePackets(audioID, NO, size, inPacketDescriptions, inStartingPacket, &ioNumPackets, inData);
    inStartingPacket += size;
}

- (void) closeFile {
    OSStatus stts;
    stts = AudioFileClose(audioID);
    NSLog(@"Close File Success");
}

- (void) setAudioStreamBasicDescription:(AudioStreamBasicDescription)desc {
    format = desc;
}

- (void) play {
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeWAVE error:&error];
    if (nil != error) {
        NSLog(@"create player[%@] error:%@", path, error.localizedDescription);
        
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [player play];
}

- (void) stop {
    [player stop];
}

@end
