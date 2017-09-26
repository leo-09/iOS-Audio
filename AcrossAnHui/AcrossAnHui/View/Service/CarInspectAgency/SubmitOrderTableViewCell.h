//
//  SubmitOrderTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *  nameLab;
@property(nonatomic,strong)UITextField *  textFiled;
@property(nonatomic,strong)UIImageView * img;
@property(nonatomic,strong)UILabel * carAddressLab;
@property(nonatomic,strong)UILabel * lineLab;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
