//
//  JZAudioUnitPlayer.h
//  AudioUnitPlayerDemo
//
//  Created by Ingenic_iOS on 2017/3/30.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZAudioFile.h"

@interface JZAudioUnitPlayer : NSObject

@property (nonatomic, retain) JZAudioFile *jzAudioFile;

- (OSStatus) start;
- (OSStatus) stop;
- (void) cleanup;

@end
