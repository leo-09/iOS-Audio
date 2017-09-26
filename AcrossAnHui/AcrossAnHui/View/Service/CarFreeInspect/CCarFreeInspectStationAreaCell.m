//
//  CCarFreeInspectStationAreaCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFreeInspectStationAreaCell.h"
#import "Masonry.h"

@implementation CCarFreeInspectStationAreaCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFreeInspectStationAreaCell";
    // 1.缓存中
    CCarFreeInspectStationAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarFreeInspectStationAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // _label
        _label = [[UILabel alloc] init];
        _label.textColor = UIColorFromRGB(CTXTextBlackColor);
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.centerY.equalTo(self.contentView.centerY);
        }];
    }
    
    return self;
}

- (void) setAreaName:(NSString *)areaName isLastCell:(BOOL)isLastCell {
    _label.text = areaName;
    
    if (!isLastCell) {
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
}

@end
