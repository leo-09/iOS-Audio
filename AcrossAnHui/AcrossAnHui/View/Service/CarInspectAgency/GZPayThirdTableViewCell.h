//
//  GZPayThirdTableViewCell.h
//  AcrossAnHui2
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 js. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZPayThirdTableViewCell : UITableViewCell

@property (nonatomic,copy) UIImageView *leftImageView;
@property (nonatomic,copy) UILabel *paylabel;
@property (nonatomic,copy) UILabel *introlabel;
@property (nonatomic,copy) UIButton *selectButton;
@property (nonatomic,copy) UILabel *linelabel;

-(id )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
