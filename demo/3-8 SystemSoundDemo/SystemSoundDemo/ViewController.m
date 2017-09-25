//
//  ViewController.m
//  SystemSoundDemo
//
//  Created by Ingenic_iOS on 2017/3/21.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController () {
    SystemSoundID ssid;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onPlay:(id)sender {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"13" ofType:@"wav"]];
    OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &ssid);
    
    UInt32 isDie = 1;
    status = AudioServicesSetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, sizeof(ssid), &ssid, sizeof(isDie), &isDie);
    
    status = AudioServicesAddSystemSoundCompletion(ssid, NULL, NULL, impAudioServicesSystemSoundCompletionProc, (__bridge void * _Nullable) self);
    
    AudioServicesPlayAlertSound(ssid);
//    AudioServicesPlaySystemSound(ssid);
}

void impAudioServicesSystemSoundCompletionProc(SystemSoundID ssid, void *clientData) {
    NSLog(@"self is %p", clientData);
    NSLog(@"ssID is %d", ssid);
}

@end
