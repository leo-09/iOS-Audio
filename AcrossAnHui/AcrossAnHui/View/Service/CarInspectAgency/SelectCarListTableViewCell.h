//
//  SelectCarListTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCarListTableViewCell : UITableViewCell

@property(nonatomic,copy)UILabel * CarName;
@property(nonatomic,copy)UILabel * weizhangLab;
@property(nonatomic,copy)UILabel * weizhangValue;
@property(nonatomic,copy)UILabel * carPaiLab;
@property(nonatomic,copy)UIImageView * CarImg;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
