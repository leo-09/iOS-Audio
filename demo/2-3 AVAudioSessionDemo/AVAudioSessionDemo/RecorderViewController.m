//
//  RecorderViewController.m
//  AVAudioSessionDemo
//
//  Created by Ingenic_iOS on 2017/3/20.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "RecorderViewController.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface RecorderViewController ()<AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSString *fileName;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"record";
    [self setAudioSession];
}

- (void) setAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error != nil) {
        NSLog(@"AudioSession setActive error:%@", error.localizedDescription);
        return;
    }
}

- (IBAction)onPlay:(id)sender {
    if ([self preparePlayer:_fileName]) {
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (nil != error) {
            NSLog(@"AudioSession setCategory(AVAudioSessionCategoryPlayback) error:%@", error.localizedDescription);
            return;
        }
        
        [_player play];
    }
}

- (BOOL) preparePlayer: (NSString *) fileName {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *localFile = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    NSURL *url = [NSURL URLWithString:localFile];
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (nil != error) {
        NSLog(@"create player[%@] error:%@", fileName, error.localizedDescription);
        return NO;
    }
    
    return YES;
}

- (IBAction)onRecord:(id)sender {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"Microphone is available!");
        } else {
            NSLog(@"Microphone is not  available!");
            return ;
        }
    }];
    
    static BOOL clicked = NO;
    if (!clicked) {
        [_recordBtn setImage:[UIImage imageNamed:@"btn_microphone_open"] forState:UIControlStateNormal];
        
        _fileName = [NSString stringWithFormat:@"voice_%ld.aac", time(NULL)];
        if ([self prepareRecorder:_fileName]) {
            if (_recorder != nil) {
                NSError *error;
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
                if (error != nil) {
                    NSLog(@"AudioSession setCategory(AVAudioSessionCategoryPlayAndRecord) error:%@", error.localizedDescription);
                    return;
                }
                
                if ([_recorder record]) {
                    NSLog(@"start recording");
                } else {
                    NSLog(@"record error");
                }
            }
        }
        
        clicked = YES;
    } else {
        [_recordBtn setImage:[UIImage imageNamed:@"btn_microphone_closed"] forState:UIControlStateNormal];
        if (_recorder != nil) {
            [_recorder stop];
        }
        clicked = NO;
    }
}

- (BOOL) prepareRecorder:(NSString *) fileName {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *localFile = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    NSURL *url = [NSURL URLWithString:localFile];
    
    NSDictionary *setting = @{AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                              AVSampleRateKey: [NSNumber numberWithInt:44100],
                              AVNumberOfChannelsKey: [NSNumber numberWithInt:2],
                              AVLinearPCMBitDepthKey: [NSNumber numberWithInt:16]
                              };
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    if (error != nil) {
        NSLog(@"create recorder for[%@] error: %@", fileName, error.localizedDescription);
        return NO;
    }
    _recorder.delegate = self;
    
    return YES;
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"audioRecorderDidFinishRecording");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    NSLog(@"audioRecorderEncodeErrorDidOccur error:%@", error.localizedDescription);
}

@end
