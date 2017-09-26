//
//  CarInspectStationPhotoViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationPhotoViewController.h"

@interface CarInspectStationPhotoViewController ()

@end

@implementation CarInspectStationPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title=@"查看照片";
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView * imageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    [imageview setImageWithURL:[NSURL URLWithString:self.picStr] placeholder:[UIImage imageNamed:@"zet-1.png"]];
    [self.view addSubview:imageview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
