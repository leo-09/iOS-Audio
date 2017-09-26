//
//  LXMCalendarDayCell.m
//  LXMDemo_Calendar
//
//  Created by luxiaoming on 16/3/22.
//  Copyright © 2016年 luxiaoming. All rights reserved.
//

#import "LXMCalendarDayCell.h"

@implementation LXMCalendarDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.8, self.contentView.frame.size.height)];
    leftLine.backgroundColor = CTXColor(240, 238, 239);
    [self.contentView addSubview:leftLine];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.8)];
    topLine.backgroundColor = CTXColor(240, 238, 239);
    [self.contentView addSubview:topLine];
}

- (void)configureWithSignModel:(LXMSignModel *)signModel {
    self.contentLabel.layer.borderWidth = 0;
    
    if (signModel.signType == LXMSignTypeNone) {
        self.contentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        self.contentLabel.layer.masksToBounds = true;
        self.contentLabel.layer.cornerRadius = 0;
        self.contentLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    } else if (signModel.signType == LXMSignTypeSigned) {
        self.contentLabel.layer.masksToBounds = true;
        self.contentLabel.layer.cornerRadius = 14.5;
        self.contentLabel.textColor = [UIColor lightGrayColor];
        self.contentLabel.layer.backgroundColor = CTXColor(206, 224, 238).CGColor;
    } else if (signModel.signType == CurrentTypeDay) {
        self.contentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        self.contentLabel.layer.masksToBounds = true;
        self.contentLabel.layer.cornerRadius = 14.5;
        self.contentLabel.layer.borderWidth = 1.0;
        self.contentLabel.layer.borderColor = CTXColor(254, 201, 73).CGColor;
        self.contentLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    } else {
        self.contentLabel.textColor = CTXColor(147, 193, 245);
        self.contentLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    
    self.contentLabel.text = signModel.dayText;
}

@end
