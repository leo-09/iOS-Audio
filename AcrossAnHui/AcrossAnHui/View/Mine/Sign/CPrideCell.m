//
//  CPrideCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CPrideCell.h"
#import "Masonry.h"

@interface CPrideCell() {
    UIImageView *leftIV;
    UIImageView *rightIV;
}

@end

@implementation CPrideCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CPrideCell";
    // 1.缓存中
    CPrideCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CPrideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        CGFloat actualWidth = CTXScreenWidth - 30;
        
        // 左背景图
        leftIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdjp_left"]];
        [self addSubview:leftIV];
        [leftIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.bottom.equalTo(@0);
            make.height.equalTo(@87);
            make.width.equalTo(actualWidth * 2 / 3);
        }];
        
        // 右背景图
        rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdjp_right"]];
        [self addSubview:rightIV];
        [rightIV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@0);
            make.left.equalTo(leftIV.right);
            make.height.equalTo(@87);
        }];
        
        // 奖品名称
        _prideLabel = [[UILabel alloc] init];
        _prideLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:_prideLabel];
        [_prideLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftIV.centerY);
            make.left.equalTo(leftIV.left).offset(@20);
            make.right.equalTo(leftIV.right).offset(@(-20));
        }];
        
        // 领取时间
        _receivedTimeLabel = [[UILabel alloc] init];
        _receivedTimeLabel.text = @"2017-02-20";
        _receivedTimeLabel.textColor = UIColorFromRGB(0x999999);
        _receivedTimeLabel.textAlignment = NSTextAlignmentCenter;
        _receivedTimeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_receivedTimeLabel];
        [_receivedTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightIV.left);
            make.right.equalTo(rightIV.right);
            make.centerY.equalTo(rightIV.centerY).offset(@(-12));
        }];
        
        // 已领取
        _receivedLabel = [[UILabel alloc] init];
        _receivedLabel.text = @"已领取";
        _receivedLabel.textColor = UIColorFromRGB(0x999999);
        _receivedLabel.textAlignment = NSTextAlignmentCenter;
        _receivedLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_receivedLabel];
        [_receivedLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightIV.left);
            make.right.equalTo(rightIV.right);
            make.centerY.equalTo(rightIV.centerY).offset(@12);
        }];
        
        // 未领取
        _expiredLabel = [[UILabel alloc] init];
        _expiredLabel.text = @"未领取";
        _expiredLabel.textColor = UIColorFromRGB(0x999999);
        _expiredLabel.font = [UIFont systemFontOfSize:16];
        _expiredLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_expiredLabel];
        [_expiredLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightIV.top);
            make.bottom.equalTo(rightIV.bottom);
            make.right.equalTo(rightIV.right);
            make.left.equalTo(rightIV.left).offset(@15);
        }];
        
        // 领取
        _gainLabel = [[UILabel alloc] init];
        _gainLabel.text = @"领取";
        _gainLabel.textColor = UIColorFromRGB(0x999999);
        _gainLabel.font = [UIFont systemFontOfSize:16];
        _gainLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_gainLabel];
        [_gainLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightIV.top);
            make.bottom.equalTo(rightIV.bottom);
            make.right.equalTo(rightIV.right);
            make.left.equalTo(rightIV.left).offset(@15);
        }];
    }
    return self;
}

- (void) updateIamgeViewBottom {
    // 左背景图
    [leftIV updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    
    // 右背景图
    [rightIV updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
}

- (void) updateLastIamgeViewBottom {
    // 左背景图
    [leftIV updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
    }];
    
    // 右背景图
    [rightIV updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
    }];
}

@end
