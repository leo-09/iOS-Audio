//
//  ViewController.m
//  JZEchoEliminateDemo
//
//  Created by liyangyang on 2017/4/5.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import "JZAudioManage.h"
#import "JZReadFile.h"
#import "JZWriteFile.h"

#define BUF_SIZE 800

@interface ViewController () {
    char recordData[BUF_SIZE];
}

@property (nonatomic, retain) JZAudioManage *audioManage;
@property (nonatomic, retain) JZReadFile *readFile;
@property (nonatomic, retain) JZWriteFile *writeFile;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"pcm"];
    
    _audioManage = [JZAudioManage shareInstance];
    
    _readFile = [[JZReadFile alloc] initWithPath:path];
    AudioStreamBasicDescription format = [_readFile getFormat];
    [_audioManage setInputAudioStreamBasicDescription:format];
    __weak ViewController *weakSelf = self;
    [_readFile setReadAudioDataListener:^(char *data, int size) {
        [weakSelf.audioManage pushData:data withSize:size];
    }];
    
    _writeFile = [[JZWriteFile alloc] initWithIONumPackets:(BUF_SIZE / format.mBytesPerPacket)];
    [_audioManage setOutputAudioStreamBasicDescription:format];
    [_writeFile setAudioStreamBasicDescription:format];
}

- (IBAction)playAudio:(id)sender {
    [_readFile openAudioFile];
    [_readFile readFileContent];
}

- (IBAction)record:(id)sender {
    
}

- (IBAction)stop:(id)sender {
    [_readFile closeFile];
    [_writeFile closeFile];
    
    [_audioManage closeTalk];
    [_audioManage closeMute];
    [_audioManage uninitAudioManage];
}

- (IBAction)playRecord:(id)sender {
    [_writeFile play];
}

- (IBAction)stopPlayRecord:(id)sender {
    [_writeFile stop];
}

@end
