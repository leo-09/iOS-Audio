//
//  PlayerViewController.m
//  AVAudioSessionDemo
//
//  Created by Ingenic_iOS on 2017/3/20.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController ()<MPMediaPickerControllerDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, strong) MPMediaPickerController *pickerController;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSURL *url;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.title = @"player";
    _pickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    _pickerController.allowsPickingMultipleItems = NO;
    _pickerController.delegate = self;
    
    _player = [[AVAudioPlayer alloc] init];
    
    // 中断响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
    // 其他App占据AudioSession的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hintNotification:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
    
    // 外设改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
}

// 中断响应
- (void) interruptionNotification:(NSNotification *)noti {
    AVAudioSessionInterruptionType type = [[[noti userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {// 中断开始
        
    }
    if (type == AVAudioSessionInterruptionTypeEnded) {// 中断结束
        
    }
    
    AVAudioSessionInterruptionOptions option = [[[noti userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] intValue];
    if (option == AVAudioSessionInterruptionOptionShouldResume) {// 此时也应该恢复继续播放和采集
        
    }
}

// 其他App占据AudioSession的通知
- (void) hintNotification:(NSNotification *)noti {
    AVAudioSessionSilenceSecondaryAudioHintType type = [[[noti userInfo] objectForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] intValue];
    
    if (type == AVAudioSessionSilenceSecondaryAudioHintTypeBegin) {// 其他App开始占据Session
        
    }
    
    if (type == AVAudioSessionSilenceSecondaryAudioHintTypeEnd) {// 其他App开始释放Session
        
    }
}

// 通知有新设备/设备被退出
- (void) routeChangeNotification:(NSNotification *)noti {
    AVAudioSessionRouteChangeReason reason = [[[noti userInfo] objectForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    if (reason == AVAudioSessionRouteChangeReasonUnknown) {// 未知原因
        
    } else if (reason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {// 有新设备可用
        
    } else if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {// 老设备不可用
        
    } else if (reason == AVAudioSessionRouteChangeReasonCategoryChange) {// 类别改变了
        
    } else if (reason == AVAudioSessionRouteChangeReasonOverride) {// App重置了输出设置
        
    } else if (reason == AVAudioSessionRouteChangeReasonWakeFromSleep) {// 从睡眠状态呼醒
        
    } else if (reason == AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory) {// 当前Category下没有合适的设备
        
    } else if (reason == AVAudioSessionRouteChangeReasonRouteConfigurationChange) {// Rotuer的配置改变了
        
    }
    
    AVAudioSessionSilenceSecondaryAudioHintType type = [[[noti userInfo] objectForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] intValue];
    
    if (type == AVAudioSessionSilenceSecondaryAudioHintTypeBegin) {// 其他App开始占据Session
        
    }
    
    if (type == AVAudioSessionSilenceSecondaryAudioHintTypeEnd) {// 其他App开始释放Session
        
    }
}

- (IBAction)onPickMusic:(id)sender {
    [self presentViewController:_pickerController animated:YES completion:nil];
}

- (IBAction)onPlay:(id)sender {
    if (_url == nil) {
        NSLog(@"请先选择音乐");
        return;
    }
    
    static BOOL once = NO;
    
    if (!once) {
        [_playBtn setImage:[UIImage imageNamed:@"btn_pause.png"] forState:UIControlStateNormal];
        once = YES;
        
        NSLog(@"%@", [AVAudioSession sharedInstance].category);
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (nil != error) {
            NSLog(@"set Category error %@", error.localizedDescription);
        }
        NSLog(@"%@", [AVAudioSession sharedInstance].category);
        
        AVAudioSessionCategoryOptions options = [[AVAudioSession sharedInstance] categoryOptions];
        NSLog(@"Category[%@] has %lu options",  [AVAudioSession sharedInstance].category, options);
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
        if (nil != error) {
            NSLog(@"set Option error %@", error.localizedDescription);
        }
        
        options = [[AVAudioSession sharedInstance] categoryOptions];
        NSLog(@"Category[%@] has %lu options",  [AVAudioSession sharedInstance].category, options);
        
        if (_player != nil) {
            [_player play];
        }
    } else {
        [_playBtn setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
        once = NO;
        
        if (nil != _player) {
            [_player stop];
        }
    }
}

#pragma mark MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSString *title = [[[mediaItemCollection items] firstObject] valueForKey:MPMediaItemPropertyTitle];
    NSString *artist = [[[mediaItemCollection items] firstObject] valueForKey:MPMediaItemPropertyArtist];
    _url = [[[mediaItemCollection items] firstObject] valueForKey:MPMediaItemPropertyAssetURL];
    
    NSString *content = title;
    content = [content stringByAppendingFormat:@"\n %@", artist];
    
    NSError *error;
    if (_url != nil) {
        _player = [_player initWithContentsOfURL:_url error:&error];
        if (nil != error) {
            NSLog(@"initWithContentsOfURL with error %@", error.localizedDescription);
            return ;
        }
        
        _player.delegate = self;
        _player.enableRate = YES;
        _player.meteringEnabled = YES;
    }
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  AVAudioPlayerDelegate
    
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"audioPlayerDecodeErrorDidOccur");
}

@end
