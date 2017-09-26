//
//  CCarFreeInspectAddressCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFreeInspectAddressCell.h"
#import "Masonry.h"

@implementation CCarFreeInspectAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFreeInspectAddressCell";
    // 1.缓存中
    CCarFreeInspectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarFreeInspectAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        _label.textColor = UIColorFromRGB(CTXTextBlackColor);
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.centerY.equalTo(self.contentView.centerY);
        }];
    }
    
    return self;
}

- (void) setAreaName:(NSString *)areaName {
    _areaName = areaName;
    
    self.label.text = _areaName;
}

@end
