//
//  ZWCountDemoView.m
//  countDown(倒计时)
//
//  Created by 张伟 on 16/3/5.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "ZWCountDownView.h"

#define LabelCount 3

@interface ZWCountDownView()
/** 定时器 */
@property (nonatomic,strong)dispatch_source_t timer;
/** 时间数组 */
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
/** 分离 */
@property (nonatomic,strong)NSMutableArray *separateLableArrM;

/** 天 */
@property (nonatomic,strong)UILabel *dayLabel;
/** 时 */
@property (nonatomic,strong)UILabel *hourLabel;
/** 分 */
@property (nonatomic,strong)UILabel *minuesLabel;
/** 秒 */
@property (nonatomic,strong)UILabel *secondsLabel;
/** 毫秒 */
@property (nonatomic,strong)UILabel *millisecondLabel;
@property (nonatomic,strong)UILabel *minuesNameLabel;
@property (nonatomic,strong)UILabel *millisecondNameLabel;

@end

@implementation ZWCountDownView

/** 创建单例 */
+ (instancetype)shareCoundDown
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZWCountDownView alloc] init];
    });
    return instance;
}

/** 类方法创建 */
+ (instancetype)countDown
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLabel];
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
        //        [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
        [self addSubview:self.millisecondLabel];
        [self addSubview:_minuesNameLabel];
        [self addSubview:_millisecondNameLabel];
        for (NSInteger index = 0; index < LabelCount; index ++) {
            UILabel *separateLabel = [[UILabel alloc] init];
            separateLabel.text = @":";
            separateLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:separateLabel];
            [self.separateLableArrM addObject:separateLabel];
        }
    }
    return self;
}
-(void)setUI{
    
    UILabel * timeNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 120, 15)];
    timeNameLab.text=@"支付剩余时间";
    timeNameLab.textAlignment = NSTextAlignmentCenter;
    timeNameLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:timeNameLab];
    
    UILabel * leftLineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+7, 30, 1.5)];
    leftLineLab.backgroundColor = [UIColor blackColor];
    [self addSubview:leftLineLab];
    
    UILabel * RightLineLab = [[UILabel alloc]initWithFrame:CGRectMake(170, 15+7, 30, 1.5)];
    RightLineLab.backgroundColor = [UIColor blackColor];
    [self addSubview:RightLineLab];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

// 拿到传过来的时间
- (void)setTimeStamp:(NSInteger)timeStamp
{
    timeStamp *= 1000;  // 秒 到 毫秒
    _timeStamp = timeStamp;
    __block NSInteger timeSp = _timeStamp;
   
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC);
        
        // 频率,以毫秒
        uint64_t interval = (uint64_t)(0.001 * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, interval, 0);
        
        //设置回调
        dispatch_source_set_event_handler(self.timer, ^{
            timeSp --;
            [self getDetailTimeWithTimestamp:timeSp];
            if (timeSp == 0) {
                dispatch_cancel(self.timer);
                
                self.timer = nil;
                self.timeStopBlock();
                
            }
        });
        //启动定时器
        dispatch_resume(self.timer);
        if (timeSp == 0) {
            [self getDetailTimeWithTimestamp:timeSp];

            dispatch_cancel(self.timer);
            self.timer = nil;
        }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timeStamp
{
    NSInteger ms = timeStamp;
    
    NSInteger ml = 1;
    NSInteger ss = ml * 1000 ;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    //    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger hour = ms / hh;                                                       // 时
    NSInteger minute = (ms - hour * hh) / mi;                                       // 分
    NSInteger second =  (ms - hour * hh - minute * mi) / ss ;                       // 秒
    NSInteger millisecond = (ms - hour * hh - minute * mi - second * ss) / 10;      // 毫秒
    //        NSLog(@"%zd时:%zd分:%zd秒:%zd毫秒",hour,minute,second,millisecond);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.hourLabel.text = [NSString stringWithFormat:@"%02zd",hour];
        self.minuesLabel.text = [NSString stringWithFormat:@"%02zd",minute];
        self.secondsLabel.text = [NSString stringWithFormat:@"%02zd",second];
        self.millisecondLabel.text = [NSString stringWithFormat:@"%02zd",millisecond];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //self.hourLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.minuesLabel.frame = CGRectMake(20+20, 40, 40, 40);
    self.minuesNameLabel.frame = CGRectMake(40+20+20, 40, 20, 40);
    self.secondsLabel.frame = CGRectMake(40+20+20+20, 40, 40, 40);
    self.millisecondNameLabel.frame = CGRectMake(100+20+20, 40, 20, 40);
    self.millisecondLabel.frame = CGRectMake(120+20, 40, 40, 40);
}

- (void)setupLabel
{
    // 初始化数组
    _timeLabelArrM = [NSMutableArray array];
    _separateLableArrM = [NSMutableArray array];
    
    // 初始化label
    // 时
    _hourLabel  = [[UILabel alloc] init];
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    
    // 分
    _minuesLabel  = [[UILabel alloc] init];
    _minuesLabel.textAlignment = NSTextAlignmentCenter;
    _minuesLabel.backgroundColor=[UIColor colorWithRed:3/255.0 green:163/255.0 blue:214/255.0 alpha:1.0];
    _minuesLabel.textColor = [UIColor whiteColor];
    
    // 秒
    _secondsLabel  = [[UILabel alloc] init];
    _secondsLabel.textAlignment = NSTextAlignmentCenter;
    _secondsLabel.backgroundColor=[UIColor colorWithRed:3/255.0 green:163/255.0 blue:214/255.0 alpha:1.0];
    _secondsLabel.textColor = [UIColor whiteColor];
    // 毫秒
//    _millisecondLabel  = [[UILabel alloc] init];
//    _millisecondLabel.textAlignment = NSTextAlignmentCenter;
//    _millisecondLabel.backgroundColor=[UIColor redColor];
//    _millisecondLabel.textColor = [UIColor whiteColor];
    
    
    _minuesNameLabel  = [[UILabel alloc] init];
    _minuesNameLabel.textAlignment = NSTextAlignmentCenter;
    _minuesNameLabel.font = [UIFont systemFontOfSize:14];
    _minuesNameLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    _minuesNameLabel.text = @"分";
    
    
    _millisecondNameLabel  = [[UILabel alloc] init];
    _millisecondNameLabel.textAlignment = NSTextAlignmentCenter;
    _millisecondNameLabel.font = [UIFont systemFontOfSize:14];
    _millisecondNameLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    _millisecondNameLabel.text = @"秒";
}

@end
