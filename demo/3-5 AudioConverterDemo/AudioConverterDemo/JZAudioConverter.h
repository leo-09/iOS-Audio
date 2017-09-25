//
//  JZAudioConverter.h
//  AudioConverterDemo
//
//  Created by Ingenic_iOS on 2017/3/31.
//  Copyright © 2017年 ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AudioToolbox;
@protocol AudioFileConvertOperationDelegate;

@interface JZAudioConverter : NSObject

@property (readonly, nonatomic, strong) NSURL *sourceURL;
@property (readonly, nonatomic, strong) NSURL *destinationURL;
@property (readonly, nonatomic, assign) Float64 sampleRate;
@property (readonly, nonatomic, assign) AudioFormatID outputFormat;
@property (nonatomic, weak) id<AudioFileConvertOperationDelegate> delegate;

- (instancetype)initWithSourceURL:(NSURL *)sourceURL destinationURL:(NSURL *)destinationURL sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat;

@end

@protocol AudioFileConvertOperationDelegate <NSObject>

- (void)audioFileConvertOperation:(JZAudioConverter *)audioFileConvertOperation didEncounterError:(NSError *)error;
- (void)audioFileConvertOperation:(JZAudioConverter *)audioFileConvertOperation didCompleteWithURL:(NSURL *)destinationURL;

@end
