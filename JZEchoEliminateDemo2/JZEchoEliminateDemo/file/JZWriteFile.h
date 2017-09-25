//
//  JZWriteFile.h
//  JZEchoEliminateDemo
//
//  Created by liyangyang on 2017/4/5.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface JZWriteFile : NSObject

- (void) createAudioFile;
- (void) closeFile;

- (void) writeData:(char *)inData size:(int) size;
- (void) setAudioStreamBasicDescription:(AudioStreamBasicDescription)desc;

- (void) play;
- (void) stop;

@end
