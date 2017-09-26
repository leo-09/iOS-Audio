//
//  CTimeRemindCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTimeRemindCell.h"
#import "Masonry.h"
#import "UILabel+lineSpace.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation CTimeRemindCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CTimeRemindCell";
    // 1.缓存中
    CTimeRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CTimeRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
            make.top.equalTo(@15);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _timeLabel.font = [UIFont systemFontOfSize:30.0];
        [contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(12);
            make.width.equalTo(@100);
        }];
        
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _weekLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _weekLabel.numberOfLines = 0;
        [contentView addSubview:_weekLabel];
        [_weekLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeLabel.centerY);
            make.left.equalTo(_timeLabel.right);
            make.right.equalTo(@(-12));
        }];
        
        _pathLabel = [[UILabel alloc] init];
        _pathLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _pathLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _pathLabel.numberOfLines = 0;
        [contentView addSubview:_pathLabel];
        [_pathLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.bottom).offset(@20);
            make.left.equalTo(12);
            make.right.equalTo(@(-12));
        }];
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_pathLabel.bottom).offset(@10);
            make.height.equalTo(@0.5);
        }];
        
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"bianji_lu"] forState:UIControlStateNormal];
        [_editBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editListener) forControlEvents:UIControlEventTouchDown];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:_editBtn];
        [_editBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(lineView.bottom);
            make.height.equalTo(@50);
            make.width.equalTo((CTXScreenWidth-24) / 2);
        }];
        
        _showBtn = [[UIButton alloc] init];
        [_showBtn setTitle:@" 查看" forState:UIControlStateNormal];
        [_showBtn setImage:[UIImage imageNamed:@"chakan_lu"] forState:UIControlStateNormal];
        [_showBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showListener) forControlEvents:UIControlEventTouchDown];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:_showBtn];
        [_showBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.top.equalTo(lineView.bottom);
            make.height.equalTo(@50);
            make.width.equalTo((CTXScreenWidth-24) / 2);
        }];
        
        // 竖线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [contentView addSubview:bottomLine];
        [bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_editBtn.right);
            make.centerY.equalTo(_editBtn.centerY);
            make.height.equalTo(25);
            make.width.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) editListener {
    if (self.editRoadInfoCellListener) {
        self.editRoadInfoCellListener(self.model);
    }
}

- (void) showListener {
    if (self.showRoadInfoCellListener) {
        self.showRoadInfoCellListener(self.model);
    }
}

- (void) setModel:(OrderRoadModel *)model {
    _model = model;
    
    _timeLabel.text = model.time;
    _weekLabel.text = [model weekDesc];
    _pathLabel.text = [NSString stringWithFormat:@"%@ 到 %@", model.originAddr, model.destinationAddr];

    [UILabel changeLineSpaceForLabel:_pathLabel WithSpace:5];
    _pathLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

// 根绝数据计算cell的高度
- (CGFloat)heightForModel:(OrderRoadModel *)model {
    _pathLabel.text = [NSString stringWithFormat:@"%@ 到 %@", model.originAddr, model.destinationAddr];
    CGFloat height = [_pathLabel getLabelHeightWithLineSpace:5 WithWidth:(CTXScreenWidth - 24) WithNumline:0].height;
    
    return 15 + 10 + 36 + 20 + height + 10 + 50;
}

@end
