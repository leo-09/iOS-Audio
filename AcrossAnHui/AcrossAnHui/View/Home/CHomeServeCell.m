//
//  CHomeServeTableViewCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHomeServeCell.h"
#import "Masonry.h"
#import "SelectView.h"

@implementation CHomeServeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CHomeServeCell";
    // 1.缓存中
    CHomeServeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CHomeServeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(@15);
        }];
    }
    
    return self;
}

- (void) setServeModels:(NSArray<ServeModel *> *)serveModels {
    _serveModels = serveModels;
    
    CGFloat width = CTXScreenWidth / 4;
    CGFloat height = width + 8;
    
    while (_bgView.subviews.count) {
        [_bgView.subviews.lastObject removeFromSuperview];
    }
    
    for (int i = 0; i < _serveModels.count; i++) {
        ServeModel *model = _serveModels[i];
        
        // item view
        SelectView *view = [[SelectView alloc] init];
        [view setClickListener:^(id sender) {
            if (self.selectServeListener) {
                self.selectServeListener(model);
            }
        }];
        
        [_bgView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
            make.height.equalTo(height);
            make.left.equalTo(width * (i % 4));
            make.top.equalTo(height * (i / 4));
        }];
        
        // 添加图片和文字
        UIImageView *iv = [[UIImageView alloc] init];
        [iv setImage:[UIImage imageNamed:model.image]];
        iv.contentMode = UIViewContentModeCenter;
        [view addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.centerX);
            make.top.equalTo(@10);
            make.width.equalTo(width-35);
            make.height.equalTo(width-35);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        
        if (i == _serveModels.count - 1) {
            label.textColor = UIColorFromRGB(CTXBaseFontColor);
        } else {
            label.textColor = UIColorFromRGB(CTXTextBlackColor);
        }
        
        label.text = model.name;
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.centerX);
            make.bottom.equalTo(@(-8));
        }];
    }
}

@end
