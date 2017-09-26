//
//  CHotCarTypeCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHotCarTypeCell.h"
#import "Masonry.h"

@implementation CHotCarTypeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CHotCarTypeCell";
    // 1.缓存中
    CHotCarTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CHotCarTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat distance = 12;
        CGFloat width = (CTXScreenWidth - distance * 4 - 20) / 3;
        CGFloat height = 40;
        NSArray *hotCars = @[ @"大众", @"奔驰", @"宝马", @"雪佛兰",
                              @"福特", @"奥迪", @"现代", @"丰田",
                              @"本田", @"路虎", @"起亚", @"雪铁龙"];
        
        for (int i = 0; i < hotCars.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.backgroundColor = [UIColor whiteColor];
            CTXViewBorderRadius(btn, 5.0, 0.6, UIColorFromRGB(CTXBaseFontColor));
            [btn setTitle:hotCars[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
            [btn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchDown];
            
            [self.contentView addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
                make.width.equalTo(width);
                make.left.equalTo(distance + (width + distance) * (i % 3));
                make.top.equalTo((height + 10) * (i / 3));
            }];
        }
    }
    
    return self;
}

- (void) selectButton:(UIButton *)btn {
    if (self.selectButtonModelListener) {
        self.selectButtonModelListener(btn.titleLabel.text);
    }
}

@end
