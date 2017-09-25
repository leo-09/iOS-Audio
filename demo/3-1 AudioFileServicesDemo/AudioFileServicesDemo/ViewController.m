//
//  ViewController.m
//  AudioFileServicesDemo
//
//  Created by Ingenic_iOS on 2017/3/21.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

#define VErr(err, msg) do {\
    if (err != nil) {\
        NSLog(@"[ERR]: %@----%@", (msg), [err localizedDescription]);\
        return;\
    }\
} while(0)

#define VStatus(err, msg) do {\
    if(noErr != err){ \
        NSLog(@"[ERR-%d]:%@", err, (msg));\
        return;\
    }\
} while(0);

@interface ViewController ()<MPMediaPickerControllerDelegate> {
    AudioFileID musicFD_;
    char format_[5];
    UInt32  maxPkgSize_;
    UInt64 pkgNum_;
}

@property (nonatomic, strong) MPMediaPickerController *pickerController;
@property (nonatomic, strong) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    _pickerController.prompt = @"请选择音频";
    _pickerController.allowsPickingMultipleItems = NO;
    _pickerController.showsCloudItems = NO;
    _pickerController.delegate = self;
}

- (IBAction)onPick:(id)sender {
    [self presentViewController:_pickerController animated:YES completion:nil];
}

#pragma mark AudioFile

- (IBAction)onOpenFile:(id)sender {
    CFURLRef url = (__bridge CFURLRef) _url;
//    if (url == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"caf"];
        url = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
//    }
    
    OSStatus stts = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &musicFD_);
    VStatus(stts, @"AudioFileOpenURL");
    NSLog(@"open file %@ success!", url);
}

- (IBAction)onReadProperty:(id)sender {
    OSStatus stts;
    
    UInt32 audioFilePropertyFileFormatSize = 0;
    UInt32 audioFilePropertyFileFormatIsWritable = 0;
    stts = AudioFileGetPropertyInfo(musicFD_, kAudioFilePropertyFileFormat, &audioFilePropertyFileFormatSize, &audioFilePropertyFileFormatIsWritable);
    VStatus(stts, @"kAudioFilePropertyFileFormat");
    if (audioFilePropertyFileFormatSize >4) {
        NSLog(@"format name length > 4");
        return ;
    }
    memset(format_, 0, 5);
    stts = AudioFileGetProperty(musicFD_, kAudioFilePropertyFileFormat, &audioFilePropertyFileFormatSize, format_);
    NSLog(@"Audio's format is %s", format_);
    
    UInt32 audioFilePropertyMaximumPacketSize = 0;
    UInt32 audioFilePropertyMaximumPacketSizeWritable = 0;
    stts = AudioFileGetPropertyInfo(musicFD_, kAudioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSizeWritable);
    VStatus(stts, @"kAudioFilePropertyMaximumPacketSize");
    char *audioFilePropertyMaximumPacketSizeBuf = (char *)malloc(audioFilePropertyMaximumPacketSize+1);
    if (NULL == audioFilePropertyMaximumPacketSizeBuf) {
        NSLog(@"audioFilePropertyMaximumPacketSizeBuf is NULL");
        return ;
    }
    memset(audioFilePropertyMaximumPacketSizeBuf, 0, audioFilePropertyMaximumPacketSize+1);
    stts = AudioFileGetProperty(musicFD_, kAudioFilePropertyMaximumPacketSize, &audioFilePropertyMaximumPacketSize, audioFilePropertyMaximumPacketSizeBuf);
    maxPkgSize_ = *(int *)audioFilePropertyMaximumPacketSizeBuf;
    NSLog(@"Audio's max packet size  is %d", maxPkgSize_);
    
    UInt32 audioFilePropertyAudioDataPacketCountSize = 0;
    UInt32 audioFilePropertyAudioDataPacketCountSizeWritable = 0;
    stts = AudioFileGetPropertyInfo(musicFD_, kAudioFilePropertyAudioDataPacketCount, &audioFilePropertyAudioDataPacketCountSize, &audioFilePropertyAudioDataPacketCountSizeWritable);
    VStatus(stts, @"kAudioFilePropertyAudioDataPacketCount");
    if (audioFilePropertyAudioDataPacketCountSize>sizeof(UInt64)) {
        NSLog(@"what a big number");
        return;
    }
    pkgNum_ = 0;
    stts = AudioFileGetProperty(musicFD_, kAudioFilePropertyAudioDataPacketCount, &audioFilePropertyAudioDataPacketCountSize, &pkgNum_);
    NSLog(@"Audio's  packet number  is %llu", pkgNum_);
}

- (IBAction)onReadGlobalInfo:(id)sender {
    OSStatus stts;
    UInt32 infoSize = 0;
    stts = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AllMIMETypes, 0, NULL, &infoSize);
    VStatus(stts, @"AudioFileGetGlobalInfoSize");
    
    NSArray *MIMEs;
    stts = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AllMIMETypes, 0, NULL, &infoSize, &MIMEs);
    VStatus(stts, @"AudioFileGetGlobalInfo");
    NSLog(@"fileType is %@", MIMEs);
    
    UInt32 propertySize;
    OSType readOrwrite = kAudioFileGlobalInfo_ReadableTypes;
    // kAudioFileGlobalInfo_ReadableTypes : kAudioFileGlobalInfo_WritableTypes;
    
    stts = AudioFileGetGlobalInfoSize(readOrwrite, 0, NULL, &propertySize);
    VStatus(stts, @"AudioFileGetGlobalInfoSize");
    
    OSType *types = (OSType*)malloc(propertySize);
    stts = AudioFileGetGlobalInfo(readOrwrite, 0, NULL, &propertySize,  types);
    VStatus(stts, @"AudioFileGetGlobalInfo");
    
    UInt32 numTypes = propertySize / sizeof(OSType);
    for (UInt32 i=0; i<numTypes; ++i){
        CFStringRef name;
        UInt32 outSize = sizeof(name);
        stts = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_FileTypeName, sizeof(OSType), types+i, &outSize, &name);
        VStatus(stts, @"AudioFileGetGlobalInfo");
        NSLog(@"readalbe types: %@", name);
    }
}

- (IBAction)onReadUserData:(id)sender {
    OSStatus stts;
    UInt32 userDataCount = 0;
    UInt32 format = 0;
    
    if (!strcmp(format_, "EVAW")) {
        format = kAudioFileWAVEType;
    } else if (! strcmp(format_, "3GPM")) {
        format = kAudioFileMP3Type;
    } else {
        NSLog(@"Unsupport format");
    }
    
    stts = AudioFileCountUserData(musicFD_, kCAF_AudioDataChunkID, &userDataCount);
    VStatus(stts, @"AudioFileCountUserData");
    NSLog(@"AudioFileCountUserData get count %d", userDataCount);
    
    UInt32 userDataSize = 0;
    stts = AudioFileGetUserDataSize(musicFD_, kCAF_AudioDataChunkID, 0, &userDataSize);
    VStatus(stts, @"AudioFileGetUserDataSize");
    NSLog(@"AudioFileGetUserDataSize with size %d", userDataSize);
}

- (IBAction)onReadFileContent:(id)sender {
    OSStatus stts;
    
    char *packetBuf = (char *) malloc(maxPkgSize_ * 2);
    if (NULL == packetBuf) {
        NSLog(@"NULL == packetBuf || NULL == byteBuf");
        return ;
    }
    
    for (int i = 0; i < pkgNum_ ; i += 2) {
        UInt32 packetBufLen = maxPkgSize_* 2;
        memset(packetBuf, packetBufLen, 0);
        
        AudioStreamPacketDescription aspDesc[2];
        
        UInt32 pktNum = 2;
        if ((i+2) > pkgNum_) {
            pktNum = 1;
        }
        stts = AudioFileReadPacketData(musicFD_, NO, &packetBufLen, aspDesc, i, &pktNum, packetBuf);
        if (kAudioFileEndOfFileError == stts) {
            NSLog(@"End of File");
            break;
        }
        VStatus(stts, @"AudioFileReadPacketData");
//        NSLog(@"[%d/%lld]Read two packet data,desc is %d,%d [packetBufLen:%d], [pktNum:%d]", i+2, pkgNum_, aspDesc[0].mDataByteSize, aspDesc[1].mDataByteSize, packetBufLen, pktNum);
        
        NSLog(@"%s", packetBuf);
    }
    
    if (NULL != packetBuf) {
        free(packetBuf);
        packetBuf = NULL;
    }
}

- (IBAction)onCloseFile:(id)sender {
    OSStatus stts = AudioFileClose(musicFD_);
    VStatus(stts, @"AudioFileClose");
    NSLog(@"close file success");
}

#pragma mark  MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if (mediaItemCollection == nil) {
        NSLog(@"mediaItemCollection is null");
        return;
    }
    
    MPMediaItem *item = mediaItemCollection.items.firstObject;
    _url = [item valueForKey:MPMediaItemPropertyAssetURL];
    
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
