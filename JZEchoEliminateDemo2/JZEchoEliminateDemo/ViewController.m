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

#define BUF_SIZE 1024

@interface ViewController () {
    char recordData[BUF_SIZE];
    BOOL audioEnable;
}

@property (nonatomic, retain) JZAudioManage *audioManage;
@property (nonatomic, retain) JZReadFile *readFile;
@property (nonatomic, retain) JZWriteFile *writeFile;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"origin" ofType:@"pcm"];
    
    _audioManage = [JZAudioManage shareInstance];
    
    _readFile = [[JZReadFile alloc] initWithPath:path];
    AudioStreamBasicDescription format = [_readFile getFormat];
    [_audioManage setInputAudioStreamBasicDescription:format];
    __weak ViewController *weakSelf = self;
    [_readFile setReadAudioDataListener:^(char *data, int size) {
        [weakSelf.audioManage pushData:data withSize:size];
    }];
    
    _writeFile = [[JZWriteFile alloc] init];
    [_audioManage setOutputAudioStreamBasicDescription:format];
    [_writeFile setAudioStreamBasicDescription:format];// 设置音频格式，根据音频格式创建音频文件格式
    [_writeFile createAudioFile];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stop:nil];
}

- (IBAction)playAudio:(id)sender {
    [_readFile readFile];
}

- (IBAction)record:(id)sender {
    [_audioManage openTalk];
    
    memset(recordData, 0, BUF_SIZE);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        audioEnable = YES;
        while (audioEnable) {
            [_audioManage popDataTo:recordData withSize:BUF_SIZE];
            // 写数据
            [_writeFile writeData:recordData size:BUF_SIZE];
        }
    });
}

- (IBAction)stop:(id)sender {
    audioEnable = NO;
    
    [_readFile closeFile];
    [_writeFile closeFile];
    
    [_audioManage openMute];
    [_audioManage closeTalk];
    [_audioManage uninitAudioManage];
}

- (IBAction)playRecord:(id)sender {
    [_writeFile play];
}

- (IBAction)stopPlayRecord:(id)sender {
    [_writeFile stop];
}

@end
