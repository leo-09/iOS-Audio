//
//  ViewController.m
//  AudioQueuePlayerDemo
//
//  Created by Ingenic_iOS on 2017/3/21.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define VErr(err, msg) do {\
    if(nil != err) {\
        NSLog(@"[ERR]:%@--%@", (msg), [err localizedDescription]);\
        return ;\
    }\
} while(0)

#define VStatus(err, msg) do {\
    if(noErr != err) {\
        NSLog(@"[ERR-%d]:%@", err, (msg));\
        return ;\
    }\
} while(0)

enum {
    kNumberBuffers = 3,         // buffer的数目
    kNumberPackages = 10 * 1000 // 一次读取的package数目
};

struct PlayerStat {
    AudioFileID                     mAudioFile;// 文件ID
    
    AudioQueueRef                   mQueue;// Queue对象
    AudioStreamBasicDescription     mDataFormat;// 源数据的格式信息
    
    AudioQueueBufferRef             mBuffers[kNumberBuffers];// Buffer数组，用来装数据
    UInt32                          bufferByteSize;// 单个Buffer长度
    
    SInt64                          mCurrentPacket;// 当前读到哪个packet
    AudioStreamPacketDescription    *mPacketDesc;// 每个Packet的描述
};

static BOOL clicked = NO;

@interface ViewController () {
    struct PlayerStat playStat;
}

@property (strong, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onPlay:(id)sender {
    if (!clicked) {
        [self play];
        clicked = YES;
        [_playBtn setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
    } else {
        [self stop];
        clicked = NO;
        [_playBtn setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    }
}

- (void) setAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error != nil) {
        NSLog(@"AudioSession setActive error:%@", error.localizedDescription);
        return;
    }
    
    error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&error];
    if (nil != error) {
        NSLog(@"AudioSession setCategory(AVAudioSessionCategoryPlayAndRecord) error:%@", error.localizedDescription);
        return;
    }
}

- (void) play {
    [self setAudioSession];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"caf"];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    
    // step 1: open a file
    OSStatus status = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &playStat.mAudioFile);
    VStatus(status, @"AudioFileOpenURL");
    NSLog(@"open file %@ success", url);
    
    // step 2: read file's properity
    UInt32 descSize = sizeof(playStat.mDataFormat);
    status = AudioFileGetProperty(playStat.mAudioFile,
                                  kAudioFilePropertyDataFormat,
                                  &descSize,
                                  &playStat.mDataFormat);
    VStatus(status, @"AudioFileGetProperty-kAudioFilePropertyDataFormat");
    
    // step 3: create a buffer queue
    status = AudioQueueNewOutput(&playStat.mDataFormat,
                                 impAudioQueueOutputCallback,
                                 (__bridge void *)(self),
                                 CFRunLoopGetCurrent(),
                                 kCFRunLoopCommonModes,
                                 0,
                                 &playStat.mQueue);
    VStatus(status, @"AudioQueueNewOutput");
    
    // step 4: allocat memeory for pacakge's dscription
    UInt32 maxPacketSize;
    UInt32 propertySize = sizeof(maxPacketSize);
    status = AudioFileGetProperty(playStat.mAudioFile,
                                  kAudioFilePropertyPacketSizeUpperBound,
                                  &propertySize,
                                  &maxPacketSize);
    VStatus(status, @"AudioFileGetProperty-kAudioFilePropertyPacketSizeUpperBound");
    playStat.bufferByteSize = kNumberPackages * maxPacketSize;
    playStat.mPacketDesc = (AudioStreamPacketDescription *) malloc(kNumberPackages * sizeof(AudioStreamPacketDescription));
    
    // step 5: deal magic cookie data
    UInt32 cookieSize = sizeof(UInt32);
    bool couldNotGetProperty = AudioFileGetPropertyInfo(playStat.mAudioFile,
                                                        kAudioFilePropertyMagicCookieData,
                                                        &cookieSize,
                                                        NULL);
    if (!couldNotGetProperty && cookieSize) {
        char *magicCookie = (char *) malloc(cookieSize);
        AudioFileGetProperty(playStat.mAudioFile,
                             kAudioFilePropertyMagicCookieData,
                             &cookieSize,
                             magicCookie);
        AudioQueueSetProperty(playStat.mQueue,
                              kAudioQueueProperty_MagicCookie,
                              magicCookie,
                              cookieSize);
        free(magicCookie);
    }
    
    // step 6: setup buffer queues
    playStat.mCurrentPacket = 0;
    for (int i = 0; i < kNumberBuffers; i++) {
        AudioQueueAllocateBuffer(playStat.mQueue,
                                 playStat.bufferByteSize,
                                 &playStat.mBuffers[i]);
        impAudioQueueOutputCallback((__bridge void *)(self),
                                    playStat.mQueue,
                                    playStat.mBuffers[i]);
    }
    
    // set gain
    Float32 gain = 1.0;
    AudioQueueSetParameter(playStat.mQueue, kAudioQueueParam_Volume, gain);
    
    status = AudioQueueStart(playStat.mQueue, NULL);
    VStatus(status, @"AudioQueueStart");
}

- (void) stop {
    if (playStat.mQueue) {
        AudioQueueDispose(playStat.mQueue, YES);
    }
    
    if (playStat.mAudioFile) {
        AudioFileClose(playStat.mAudioFile);
    }
    
    if (playStat.mPacketDesc) {
        free(playStat.mPacketDesc);
        playStat.mPacketDesc = NULL;
    }
    
    // 暂停
//    OSStatus status = AudioQueuePause(playStat.mQueue);
//    VStatus(status, @"AudioQueuePause");
    
    // 停止
    OSStatus status = AudioQueueStop(playStat.mQueue, YES);
    VStatus(status, @"AudioQueueStop");
}

void impAudioQueueOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    ViewController *this = (__bridge ViewController *)inUserData;
    struct PlayerStat *ps = &(this->playStat);
//    struct PlayerStat *ps = (struct PlayerStat *) inUserData;
    
    // step1: read data from your file
    UInt32 bufLen = ps->bufferByteSize;
    UInt32 numPkgs = kNumberPackages;
    // Read packets of audio data from the audio file.
    OSStatus status = AudioFileReadPacketData(ps->mAudioFile, NO, &bufLen, ps->mPacketDesc, ps->mCurrentPacket, &numPkgs, inBuffer->mAudioData);
    VStatus(status, @"AudioFileReadPacketData");
    inBuffer->mAudioDataByteSize = bufLen;
    
    // step2: enqueue data buffer to AudioQueueBufferRef
    status = AudioQueueEnqueueBuffer(ps->mQueue, inBuffer, numPkgs, ps->mPacketDesc);
    VStatus(status, @"AudioQueueEnqueueBuffer");
    ps->mCurrentPacket += numPkgs;
    
    // step3: decid wheather should stop the AduioQueue
    if (numPkgs == 0) {
        AudioQueueStop(ps->mQueue, YES);
        
        clicked = NO;
        [this.playBtn setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    }
}

@end
