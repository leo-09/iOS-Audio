//
//  CSubmitRecordTCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSubmitRecordTCell.h"
#import "Masonry.h"

@implementation CSubmitRecordTCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CSubmitRecordTCell";
    // 1.缓存中
    CSubmitRecordTCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CSubmitRecordTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.labels = [[NSMutableArray alloc] init];
        
        // contentView
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@10);
        }];
        
        UILabel *lastLabel;
        for (int i = 0; i < 7; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(CTXTextBlackColor);
            [contentView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.right.equalTo(@(-15));
                
                if (lastLabel) {
                    make.top.equalTo(lastLabel.bottom).offset(@15);
                } else {
                    make.top.equalTo(@15);
                }
                
            }];
            
            [self.labels addObject:label];
            lastLabel = label;
        }
    }
    
    return self;
}

@end
