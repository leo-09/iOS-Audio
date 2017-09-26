//
//  CSearchParkingCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchParkingCell.h"
#import "Masonry.h"

@implementation CSearchParkingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CSearchParkingCell";
    // 1.缓存中
    CSearchParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CSearchParkingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        // distanceLabel
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _distanceLabel.font = [UIFont systemFontOfSize:14.0];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@(-15));
            make.width.equalTo(@70);
        }];
        
        // roadNameLabel
        _roadNameLabel = [[UILabel alloc] init];
        _roadNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _roadNameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_roadNameLabel];
        [_roadNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(_distanceLabel.left);
            make.top.equalTo(@15);
        }];
        
        // areaNameLabel
        _areaNameLabel = [[UILabel alloc] init];
        _areaNameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _areaNameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_areaNameLabel];
        [_areaNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(_distanceLabel.left);
            make.bottom.equalTo(@(-15));
        }];
        
        // tintLabel
        _tintLabel = [[UILabel alloc] init];
        _tintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _tintLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_tintLabel];
        [_tintLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        // lineView
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) setModel:(SiteModel *)model {
    _model = model;
    
    if ([_model.siteID isEqualToString:@"noSearchResult"] || [_model.siteID isEqualToString:@"noRecord"]) {
        _tintLabel.hidden = NO;
        _roadNameLabel.hidden = YES;
        _areaNameLabel.hidden = YES;
        _distanceLabel.hidden = YES;
        _lineView.hidden = YES;
        
        // 没有搜索到相关目的地
        _tintLabel.text = _model.sitename;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        _tintLabel.hidden = YES;
        _roadNameLabel.hidden = NO;
        _areaNameLabel.hidden = NO;
        _distanceLabel.hidden = NO;
        _lineView.hidden = NO;
        
        _roadNameLabel.text = _model.sitename;      // 道路名称
        _areaNameLabel.text = _model.areaname;      // 城市+区域
        _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", _model.distance];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

@end
