//
//  CCarInspectLogisticsCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarInspectLogisticsCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation CCarInspectLogisticsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarInspectLogisticsCell";
    // 1.缓存中
    CCarInspectLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarInspectLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.backgroundColor = [UIColor whiteColor];
        
        // descLabel
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        [self.contentView addSubview:_descLabel];
        [_descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@32);
            make.right.equalTo(@(-15));
        }];
        
        // timeLabel
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descLabel.bottom).offset(20);
            make.left.equalTo(_descLabel.left);
            make.right.equalTo(_descLabel.right);
        }];
        
        // topLine
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_topLine];
        [_topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@15.6);
            make.width.equalTo(@0.8);
            make.height.equalTo(@26);
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topLine.bottom);
            make.left.equalTo(_topLine.left);
            make.width.equalTo(@0.8);
            make.bottom.equalTo(@0);
        }];
        
        // circleView
        _circleView = [[UIView alloc] init];
        [self.contentView addSubview:_circleView];
        [_circleView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topLine.centerX);
            make.centerY.equalTo(_topLine.bottom);
            make.size.equalTo(CGSizeMake(16, 16));
        }];
        
        // bottomLine
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_bottomLine];
        [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_descLabel.left);
            make.right.equalTo(_descLabel.right);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.8);
        }];
    }
    
    return self;
}

- (void) setModel:(CarInspectLogistics *)model isFirstCell:(BOOL)isFirstCell  isLastCell:(BOOL)isLastCell {
    _model = model;
    
    if (isLastCell) {
        _bottomLine.hidden = YES;
    } else {
        _bottomLine.hidden = NO;
    }
    
    if (isFirstCell) {
        _topLine.hidden = YES;
        
        [_circleView updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(20, 20));
        }];
        _circleView.backgroundColor = UIColorFromRGB(CTXThemeColor);
        CTXViewBorderRadius(_circleView, 10, 0, [UIColor clearColor]);
        
        _descLabel.textColor = UIColorFromRGB(CTXThemeColor);
        _descLabel.font = [UIFont systemFontOfSize:16.0];
        
        _timeLabel.textColor = UIColorFromRGB(CTXThemeColor);
        _timeLabel.font = [UIFont systemFontOfSize:15.0];
        
    } else {
        _topLine.hidden = NO;
        
        [_circleView updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(16, 16));
        }];
        _circleView.backgroundColor = UIColorFromRGB(CTXBaseFontColor);
        CTXViewBorderRadius(_circleView, 8, 0, [UIColor clearColor]);
        
        _descLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _descLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    _descLabel.text = [NSString stringWithFormat:@"【%@】%@", _model.address, _model.remark];
    _timeLabel.text = _model.time ? _model.time : @"";
    
    [UILabel changeLineSpaceForLabel:_descLabel WithSpace:6];
}

- (CGFloat)heightForModel:(CarInspectLogistics *)model isFirstCell:(BOOL)isFirstCell {
    CGFloat height = 0;
    
    // descLabel的字体大小不一样
    if (isFirstCell) {
        _descLabel.font = [UIFont systemFontOfSize:16.0];
    } else {
        _descLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    }
    _descLabel.text = [NSString stringWithFormat:@"【%@】%@", model.address, model.remark];
    
    height += 15;
    height += [_descLabel getLabelHeightWithLineSpace:6 WithWidth:(CTXScreenWidth - 47) WithNumline:0].height;
    
    height += 20;       // 时间的上边距
    height += 18;       // 时间的高度
    
    height += 20;       // 线的上边距
    height += 1;        // 线的高度
    
    return height;
}

@end
