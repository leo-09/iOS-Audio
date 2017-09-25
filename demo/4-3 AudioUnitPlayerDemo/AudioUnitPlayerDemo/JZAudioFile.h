//
//  JZAudioFile.h
//  AudioUnitPlayerDemo
//
//  Created by Ingenic_iOS on 2017/3/30.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

@interface JZAudioFile : NSObject {
    AudioStreamBasicDescription basicDescription;
    AudioFileID audioFile;
    UInt32 bufferByteSize;
    SInt64 currentPacket;
    UInt32 packetToRead;
    
    AudioStreamPacketDescription packetDescription;
    UInt32 packetCount;
    UInt32 *audioData;
    SInt64 packetIndex;
}

- (OSStatus) open:(NSString *) filePath;
- (UInt32) getNextPacket;
- (void) reset;

@end
