//
//  DateTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const YYYYMM;
extern NSString * const YYYYMMDD;
extern NSString * const YYYYMMDD_HHMM;
extern NSString * const YYYYMMDD_HHMMSS;
extern NSString * const HHMM;

@interface DateTool : NSObject

+ (instancetype) sharedInstance;

/**
 时间戳(秒)转化为时间NSDate

 @param timeStamp 时间戳(秒)
 @param format 时间格式
 @return 格式化的时间
 */
- (NSString *) timeFormatWithSecondTimeStamp:(NSString *)timeStamp format:(NSString *)format;

/**
 时间戳(毫秒)转化为时间NSDate
 
 @param timeStamp 时间戳(毫秒)
 @param format 时间格式
 @return 格式化的时间
 */
- (NSString *) timeFormatWithMillisecondTimeStamp:(NSString *)timeStamp format:(NSString *)format;

// 当前当前时间的格式
- (NSString *) currentDataWithFormat:(NSString *)format;

/**
 获取今年的年份

 @return 今年的年份
 */
- (int) getCurrentYear;
- (int) getCurrentMonth;
- (int) getCurrentDay;

@end
