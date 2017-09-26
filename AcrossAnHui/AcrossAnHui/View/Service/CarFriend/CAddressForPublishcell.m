//
//  CAddressForPublishcell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CAddressForPublishcell.h"
#import "Masonry.h"

@implementation CAddressForPublishcell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CAddressForPublishcell";
    // 1.缓存中
    CAddressForPublishcell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CAddressForPublishcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 地名
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
        }];
        
        // 地址
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-7));
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
        }];
    }
    
    return self;
}

- (void) setAnno:(CarFriendMAPointAnnotation *)anno {
    _anno = anno;
    
    _nameLabel.text = _anno.title;
    _addressLabel.text = _anno.address;
    
    if (_anno.isSelected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
