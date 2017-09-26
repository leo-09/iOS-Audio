//
//  CServiceCollectionViewCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CServiceCollectionViewCell.h"

@implementation CServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.bounds.size.width-50) / 2, 15, 50, 50)];
        _imageView.layer.masksToBounds = YES;
        CTXViewBorderRadius(_imageView, 25, 0, [UIColor clearColor]);
        [self.contentView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75 , self.contentView.bounds.size.width, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_nameLabel];
    }
    
    return self;
}

- (void) setServeModel:(ServeModel *)serveModel {
    _serveModel = serveModel;
    
    self.imageView.image = [UIImage imageNamed:_serveModel.image];
    self.nameLabel.text = _serveModel.name;
}

- (void) setIsShowEdit:(BOOL)isShowEdit {
    if (isShowEdit) {
        if (_showEditIV) {
            [_showEditIV removeFromSuperview];
            _showEditIV = nil;
        }
        
        CGFloat x = self.contentView.bounds.size.width - (self.contentView.bounds.size.width-50) / 2 - 6;
        CGRect frame = CGRectMake(x, 15 - 6, 12, 12);
        _showEditIV = [[UIImageView alloc] initWithFrame:frame];
        _showEditIV.image = [UIImage imageNamed:[_serveModel selectStatusImage]];
        
        [self.contentView addSubview:_showEditIV];
    }
}

@end
