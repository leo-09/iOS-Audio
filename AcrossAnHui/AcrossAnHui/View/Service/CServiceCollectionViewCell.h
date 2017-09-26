//
//  CServiceCollectionViewCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeModel.h"

@interface CServiceCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) ServeModel *serveModel;
@property (nonatomic, assign) BOOL isShowEdit;

//图片
@property(strong, nonatomic)UIImageView *imageView;
//标题
@property(strong, nonatomic)UILabel *nameLabel;

@property (nonatomic, retain) UIImageView *showEditIV;

@end
