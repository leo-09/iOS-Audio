//
//  JZReadFile.h
//  JZEchoEliminateDemo
//
//  Created by liyangyang on 2017/4/5.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface JZReadFile : NSObject {
    void (^readAudioDataListener)(char *data, int size);
}

- (instancetype) initWithPath:(NSString *)path;

- (void) openAudioFile;
- (void) readFileContent;
- (void) closeFile;
- (AudioStreamBasicDescription) getFormat;

- (void) setReadAudioDataListener:(void (^)(char *data, int size))listener;

@end
