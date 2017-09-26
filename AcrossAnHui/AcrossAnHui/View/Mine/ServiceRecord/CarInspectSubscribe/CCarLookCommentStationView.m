//
//  CCarLookCommentStationView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarLookCommentStationView.h"
#import "CarInspectThirdStationTableViewCell.h"

@interface CCarLookCommentStationView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView * tableView;

@end

@implementation CCarLookCommentStationView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)initUI{
    NSArray *titleArray = @[@"全部",@"晒图",@"差评"];
    NSArray *imageArray = @[@"",@"shait.png",@"chaping.png"];
    CGFloat buttonWidth = (CGRectGetWidth(self.frame)-(15*4))/titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(15*(i+1)+i*buttonWidth, 64+15, buttonWidth,40)];
        selectButton.tag = i+1000;
        [self addSubview:selectButton];
        [selectButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        selectButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,0,20);
        [selectButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.layer.borderWidth = 0.5;
        [selectButton.layer setMasksToBounds:YES];
        selectButton.layer.cornerRadius = 5.0;
        selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [selectButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0/255.0 green:163/255.0 blue:219/255.0 alpha:1]] forState:UIControlStateDisabled];
        [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
    //[self selectButtonAction:(UIButton *)[self viewWithTag:1000]];
}

-(void)selectButtonAction:(UIButton *)btn{


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarInspectThirdStationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CarInspectThirdStationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
#pragma mark - UIColor 转UIImage

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
