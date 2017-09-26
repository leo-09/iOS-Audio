//
//  CIllegalQueryEmptyDataCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalQueryEmptyDataCell.h"
#import "Masonry.h"

@implementation CIllegalQueryEmptyDataCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CIllegalQueryEmptyDataCell";
    // 1.缓存中
    CIllegalQueryEmptyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CIllegalQueryEmptyDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_Illegal"]];
        [self.contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.centerY.equalTo(self.contentView.centerY).offset(-20);
        }];
        
        _label = [[UILabel alloc] init];
        _label.text = @"恭喜您，暂时没有未处理的违章信息哦！";
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        _label.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.top.equalTo(iv.bottom).offset(20);
        }];
    }
    
    return self;
}

- (void) setLabelText:(NSString *)text {
    _label.text = text;
}

@end
