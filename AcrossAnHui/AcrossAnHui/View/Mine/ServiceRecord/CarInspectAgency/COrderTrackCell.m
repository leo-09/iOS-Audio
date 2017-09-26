//
//  COrderTrackCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "COrderTrackCell.h"
#import "Masonry.h"

@implementation COrderTrackCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"COrderTrackCell";
    // 1.缓存中
    COrderTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[COrderTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:_topLine];
        [_topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@22);
            make.width.equalTo(@1);
            make.height.equalTo(self.contentView.frame.size.height / 2);
        }];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:_bottomLine];
        [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@22);
            make.width.equalTo(@1);
            make.height.equalTo(self.contentView.frame.size.height / 2);
        }];
        
        _iv = [[UIImageView alloc] init];
        [self.contentView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self.contentView.centerY);
            make.size.equalTo(CGSizeMake(20, 20));
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.centerY.equalTo(self.contentView.centerY);
            make.width.equalTo(@80);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iv.right).equalTo(@20);
            make.centerY.equalTo(self.contentView.centerY);
            make.right.equalTo(_timeLabel.left).offset(@(-2));
        }];
    }
    
    return self;
}

- (void) setModel:(CarInspectAgencyOrderTrackModel *)model isFirstCell:(BOOL)isFirstCell isLastCell:(BOOL)isLastCell {
    _model = model;
    
    _iv.image = [UIImage imageNamed:@"order_tracking"];
    _nameLabel.text = _model.opcontent;
    _timeLabel.text = [_model time];
    
    if (isFirstCell) {
        _topLine.hidden = YES;
    } else {
        _topLine.hidden = NO;
    }
    
    if (isLastCell) {
        _bottomLine.hidden = YES;
    } else {
        _bottomLine.hidden = NO;
    }
}

@end
