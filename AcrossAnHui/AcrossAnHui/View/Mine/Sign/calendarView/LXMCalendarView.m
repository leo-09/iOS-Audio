//
//  LXMCalendarView.m
//  LXMDemo_Calendar
//
//  Created by luxiaoming on 16/3/22.
//  Copyright © 2016年 luxiaoming. All rights reserved.
//

#import "LXMCalendarView.h"
#import "LXMCalendarDayCell.h"
#import "Masonry.h"

@interface LXMCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *titles;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;//存储日期和空白的数组
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, assign) NSInteger frontBlankCount;//每个月前面空白的个数
@property (nonatomic, assign) NSInteger dayCount;//每个月的天数
@property (nonatomic, assign) NSInteger backBlankCount;//每个月后面空白的个数

@property (nonatomic, strong) NSDateComponents *monthDateComponents;//用于保存目前是几月

@end

@implementation LXMCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        titles = @[ @"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
        
        [self setupCollectionView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    CGFloat itemWidth = (self.frame.size.width - 0) / 7;
    CGFloat itemHeight = 45;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGRect bounsRect = self.bounds;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:bounsRect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LXMCalendarDayCell" bundle:nil] forCellWithReuseIdentifier:LXMCalendarDayCellIdentifier];
    
    [self addSubview:self.collectionView];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(bounsRect.size.width, 0, 0.8, bounsRect.size.height-5)];
    rightLine.backgroundColor = CTXColor(240, 238, 239);
    [self addSubview:rightLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bounsRect.size.height-5, bounsRect.size.width, 0.8)];
    bottomLine.backgroundColor = CTXColor(240, 238, 239);
    [self addSubview:bottomLine];
}

#pragma mark - public Method

- (void)setupWithMonthDateComponents:(NSDateComponents *)components {
    self.monthDateComponents = components;
    
    NSDateComponents *firstDayComponents = [[NSDateComponents alloc] init];
    firstDayComponents.year = components.year;
    firstDayComponents.month = components.month;
    firstDayComponents.day = 1;
    NSDate *firstDay = [self.calendar dateFromComponents:firstDayComponents];
    
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |
                                        NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:firstDay];
    
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay];//指定日期的day在month中的位置
    self.dayCount = range.length;
    
    self.dataArray = nil;
    self.frontBlankCount  = dateComponents.weekday - self.calendar.firstWeekday;
    
    if (self.frontBlankCount  < 0) {
        //这里，因为weekday周日是1，所以判断下
        self.frontBlankCount  += 7;
    }
    
    for (int i = 0; i < self.frontBlankCount; i++) {
        //这里是让每个月最开始的地方按需求空白
        LXMSignModel *model = [[LXMSignModel alloc] init];
        model.dayText = @"";
        [self.dataArray addObject:model];
    }
    
    for (int i = 0; i < range.length; i++) {
        LXMSignModel *model = [[LXMSignModel alloc] init];
        model.dayText = [NSString stringWithFormat:@"%@", @(i + 1)];
        
        if ([model.dayText isEqualToString:[NSString stringWithFormat:@"%ld", (long)self.monthDateComponents.day]]) {
            model.signType = CurrentTypeDay;
        }
        
        [self.dataArray addObject:model];
    }
    
    NSInteger weeks = 0; // 每个月有几周
    NSInteger aaa = self.dataArray.count / 7;
    NSInteger bbb = self.dataArray.count % 7;
    
    if (bbb == 0) {
        weeks = aaa;
    } else {
        weeks = aaa + 1;
    }
    
    self.backBlankCount = weeks * 7 - self.dataArray.count;
    for (int i = 0; i < self.backBlankCount; i++) {
        LXMSignModel *model = [[LXMSignModel alloc] init];
        model.dayText = @"";
        [self.dataArray addObject:model];
    }
    
    [self.collectionView reloadData];
}

- (void)updateWithSignDayArray:(NSArray *)signDayArray {
        for (LXMSignModel *tempModel in self.dataArray) {
            if ([self model:tempModel isInArray:signDayArray]) {
                 tempModel.signType = LXMSignTypeSigned;
            } else {
                if ([tempModel.dayText isEqualToString:[NSString stringWithFormat:@"%d", (int)self.monthDateComponents.day]]) {
                    tempModel.signType = CurrentTypeDay;
                } else {
                    tempModel.signType = LXMSignTypeNone;
                }
            }
        }
    
    [self.collectionView reloadData];
}

- (BOOL)model:(LXMSignModel *)model isInArray:(NSArray *)array {
    if ([array containsObject:model.dayText]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 7) {
        LXMCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LXMCalendarDayCellIdentifier forIndexPath:indexPath];
        
        LXMSignModel *model = [[LXMSignModel alloc] init];
        model.dayText = titles[indexPath.row];
        model.signType = CurrentTypeTitle;
        [cell configureWithSignModel:model];
        
        return cell;
    }
    
    NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:indexPath.row-7 inSection:indexPath.section];
    LXMCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LXMCalendarDayCellIdentifier forIndexPath:indexPath];
    LXMSignModel *model = [self.dataArray objectAtIndex:subIndexPath.row];
    [cell configureWithSignModel:model];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 7;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 设置单元格间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return -4;
}

// section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - property

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.firstWeekday = 1;//1是周日，2是周一，以此类推
        _calendar.minimumDaysInFirstWeek = 1;//表示一个月的最初一周如果少于这个值，则算为上个月的最后一周，大约等于则算本月第一周，用1就好
    }
    
    return _calendar;
}

@end
