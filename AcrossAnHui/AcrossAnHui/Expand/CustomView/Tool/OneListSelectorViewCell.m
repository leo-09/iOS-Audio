//
//  OneListSelectorViewCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "OneListSelectorViewCell.h"
#import "Masonry.h"

@implementation OneListSelectorModel

@end

@implementation OneListSelectorViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OneListSelectorViewCell";
    // 1.缓存中
    OneListSelectorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[OneListSelectorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _iv = [[UIImageView alloc] init];

        [self.contentView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(self.contentView.centerY);
            make.width.equalTo(@15);
        }];
        
        _label = [[UILabel alloc] init];
        _label.text = self.model.name;
        _label.textColor = UIColorFromRGB(CTXBaseFontColor);
        _label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iv.right).offset(@10);
            make.right.equalTo(-10);
            make.centerY.equalTo(self.contentView.centerY);
        }];
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void) setModel:(OneListSelectorModel *)model {
    _model = model;
    
    if (_model.isMultiSelect) {
        [_iv updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@15);
        }];
        
        if (self.model.isSelected) {
            _iv.image = [UIImage imageNamed:@"gouxuan_lu"];
        } else {
            _iv.image = [UIImage imageNamed:@"weigouxuan_lu"];
        }
    } else {
        [_iv updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    _label.text = self.model.name;
}

@end
