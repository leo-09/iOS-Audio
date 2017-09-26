//
//  HighRoadTrafficCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HighRoadTrafficCell.h"
#import "Masonry.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"

@implementation HighRoadTrafficCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HighRoadTrafficCell";
    // 1.缓存中
    HighRoadTrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[HighRoadTrafficCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.right.equalTo(-12);
            make.top.equalTo(@12);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _contentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _contentLabel.numberOfLines = 0;
        // 最大宽度
        _contentLabel.preferredMaxLayoutWidth = CTXScreenWidth - 24;
        [contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.bottom).offset(12);
            make.left.equalTo(12);
            make.right.equalTo(-12);
        }];
    }
    
    return self;
}

- (void) setModel:(HighTraficModel *)model {
    _model = model;
    
    self.timeLabel.text = [model time];
    self.contentLabel.text = model.content ? model.content : @"";
    
    // 调整行间距
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:6];
}

// 根绝数据计算cell的高度
- (CGFloat)heightForModel:(HighTraficModel *)model {
    CGFloat height = 0;
    
    height += 12;
    height += 20;
    height += 12;
    
    _contentLabel.text = model.content ? model.content : @"";
    height += [_contentLabel labelHeightWithLineSpace:6 WithWidth:(CTXScreenWidth - 24) WithNumline:0].height;
    
    height += 20;
    
    return height;
}

@end
