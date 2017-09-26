//
//  CCancelOrderReasonCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCancelOrderReasonCell.h"
#import "Masonry.h"

@implementation CCancelOrderReasonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCancelOrderReasonCell";
    // 1.缓存中
    CCancelOrderReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCancelOrderReasonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // cellView
        _cellView = [[UIView alloc] init];
        [self.contentView addSubview:_cellView];
        [_cellView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        // iv
        _iv = [[UIImageView alloc] init];
        [_cellView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellView.centerY);
            make.right.equalTo(@(-15));
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        
        _label = [[UILabel alloc] init];
        _label.textColor = UIColorFromRGB(CTXTextBlackColor);
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        [_cellView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(_cellView.centerY);
            make.right.equalTo(_iv.left).offset(@(-10));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [_cellView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        // submitLabel
        _submitLabel = [[UILabel alloc] init];
        _submitLabel.text = @"提交";
        _submitLabel.textAlignment = NSTextAlignmentCenter;
        _submitLabel.textColor = [UIColor whiteColor];
        _submitLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _submitLabel.backgroundColor = UIColorFromRGB(CTXThemeColor);
        CTXViewBorderRadius(_submitLabel, 5.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:_submitLabel];
        [_submitLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.height.equalTo(@40);
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
        }];
    }
    
    return self;
}

- (void) setModel:(CancelOrderReasonModel *)model isLastCell:(BOOL) isLast {
    _model = model;
    if (isLast) {
        _cellView.hidden = YES;
        _submitLabel.hidden = NO;
    } else {
        _cellView.hidden = NO;
        _submitLabel.hidden = YES;
        
        _label.text = (_model.reson ? _model.reson : @"");
        if (_model.isSelect) {
            _iv.image = [UIImage imageNamed:@"iconfont-gouxuan"];
        } else {
            _iv.image = [UIImage imageNamed:@"iconfont-notgouxuan"];
        }
    }
}

@end
