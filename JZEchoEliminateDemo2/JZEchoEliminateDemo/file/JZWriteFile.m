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

- (instancetype) init {
    if (self = [super init]) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [NSString stringWithFormat:@"%@/%@", docDir, @"record.aac"];
        
        inStartingPacket = 0;
    }
    
    return self;
}

- (void) setAudioStreamBasicDescription:(AudioStreamBasicDescription)desc {
    format = desc;
    
    [self createAudioFile];
}

- (void) createAudioFile {
    NSURL * tmpURL = [NSURL URLWithString:path];
    CFURLRef url = (__bridge CFURLRef) tmpURL;
    OSStatus stts = AudioFileCreateWithURL(url,
                                           kAudioFileWAVEType,
                                           &format,
                                           kAudioFileFlags_EraseFile,
                                           &audioID);
    
    NSLog(@"AudioFileCreateWithURL : %d", stts);
}

- (void) writeData:(char *)inData size:(int) size {
    ioNumPackets = size / format.mBytesPerPacket;
    
    OSStatus stts = AudioFileWritePackets(audioID,
                                          false,
                                          size,
                                          inPacketDescriptions,
                                          inStartingPacket,
                                          &ioNumPackets,
                                          inData);
    inStartingPacket += ioNumPackets;
    
    NSLog(@"AudioFileWritePackets : %d", stts);
}

- (void) closeFile {
    OSStatus stts;
    stts = AudioFileClose(audioID);
    NSLog(@"Close File Success");
}

- (void) play {
    NSError *error;
    
//    path = [[NSBundle mainBundle] pathForResource:@"xing" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeWAVE error:&error];
    if (nil != error) {
        NSLog(@"create player[%@] error:%@", path, error.localizedDescription);
    }
    
    NSLog(@"prepareToPlay : %d", [player prepareToPlay]);
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (nil != error) {
        NSLog(@"create player[%@] error:%@", path, error.localizedDescription);
    }
    
    NSLog(@"play: %d", [player play]);
}

- (void) stop {
    [player stop];
}

@end
