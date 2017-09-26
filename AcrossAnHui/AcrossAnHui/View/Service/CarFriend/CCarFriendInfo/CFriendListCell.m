//
//  CFriendListCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CFriendListCell.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation CFriendListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CFriendListCell";
    // 1.缓存中
    CFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 头像
        _headerImage = [[UIImageView alloc] init];
        CTXViewBorderRadius(_headerImage, 25, 0, [UIColor clearColor]);
        [self.contentView addSubview:_headerImage];
        [_headerImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@12);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        // 时间
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-2));
            make.centerY.equalTo(self.contentView.centerY);
            make.width.equalTo(@130);
        }];
        
        // 名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImage.right).offset(15);
            make.right.equalTo(_dateLabel.left).offset(-5);
            make.centerY.equalTo(self.contentView.centerY);
        }];
        
        // 分割线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendHeadImageModel *)model isLastCell:(BOOL) isLastCell {
    _model = model;
    
    // 设置头像
    NSURL *url = [NSURL URLWithString:_model.headImage];
    [_headerImage setImageWithURL:url placeholder:[UIImage imageNamed:@"touxiang_85x85"]];
    // 设置名称
    _nameLabel.text = (model.nickName ? model.nickName : @"");
    // 时间
    _dateLabel.text = _model.createTime;
    
    if (isLastCell) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
