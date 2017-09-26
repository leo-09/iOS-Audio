//
//  DateTool.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DateTool.h"

NSString * const YYYYMM = @"yyyy-MM";
NSString * const YYYYMMDD = @"yyyy-MM-dd";
NSString * const YYYYMMDD_HHMM = @"yyyy-MM-dd HH:mm";
NSString * const YYYYMMDD_HHMMSS = @"yyyy-MM-dd HH:mm:ss";
NSString * const HHMM = @"HH:mm";

@implementation DateTool

#pragma mark - 单例模式

static DateTool *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

#pragma mark - public method

- (NSString *) timeFormatWithSecondTimeStamp:(NSString *)timeStamp format:(NSString *)format {
    return [self timeFormatWithTimeStamp:timeStamp format:format isMillisecond:NO];
}

- (NSString *) timeFormatWithMillisecondTimeStamp:(NSString *)timeStamp format:(NSString *)format {
    return [self timeFormatWithTimeStamp:timeStamp format:format isMillisecond:YES];
}

- (NSString *) currentDataWithFormat:(NSString *)format {
    NSDate *now = [NSDate date];
    NSDateFormatter* formatter = [self getNSDateFormatterWithFormat:format];// 格式化时间
    
    NSString* dateString = [formatter stringFromDate:now];
    return dateString;
}

- (int) getCurrentYear {
    NSDate *now = [NSDate date];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return (int)[dateComponent year];
}

- (int) getCurrentMonth {
    NSDate *now = [NSDate date];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return (int)[dateComponent month];
}

- (int) getCurrentDay {
    NSDate *now = [NSDate date];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return (int)[dateComponent day];
}

#pragma mark - private method

- (NSString *)timeFormatWithTimeStamp:(NSString *)timeStamp format:(NSString *)format isMillisecond:(BOOL) isMillisecond {
    NSDate *date;
    
    if (isMillisecond) {
        // 注意，timeString必须转成NSTimeInterval格式，就是double格式！！！
        date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];// 毫秒值转化为秒
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    }
    
    // 格式化时间
    NSDateFormatter* formatter = [self getNSDateFormatterWithFormat:format];
    
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 UTC时间,和北京时间相差8小时,将UTC时间转成当地的时间,需要给NSDate设置时区

 @param date UTC格式的Date
 @return 当地时间的Date
 */
- (NSDate *) transformLocalTimeZoneDateWithDate:(NSDate *) date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    return localDate;
}

- (NSDateFormatter *) getNSDateFormatterWithFormat:(NSString *) format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    // 给NSDateFormatter设置时区
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    // 输出格式通过setDateStyle和setTimeStyle设置，分别定义的日期和时间的格式可选一下的系统给出的方法
//    [formatter setDateStyle:NSDateFormatterMediumStyle];    // 如 "Nov 23, 1937"
//    [formatter setTimeStyle:NSDateFormatterShortStyle];     // 如 “3:30pm”
    
    return formatter;
}

@end
