//
//  ParkRecordHeadView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordHeadView.h"

@implementation ParkRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray *)dataArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        hight = 1;
        plateNumber = @"";
        value = @"";
        _dataArr = [NSMutableArray array];
        _dataArr = dataArr;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    if (_dataArr.count<1) {
        hight = 0;
    }
    for (int i=0; i<_dataArr.count; i++) {
        UIButton  * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(12+(i)*100, 10, 100*hight, 30*hight);
        but.tag = 100+i;
        [but addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString*string =_dataArr[i];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * plateNumberStr = [string substringToIndex:2];//截取掉下标2之后的字符串
        NSLog(@"截取的值为：%@",string);
        NSString * plateNumberStr1  = [string substringFromIndex:2];//截取掉下标2之前的字符串
        NSString * str = [NSString stringWithFormat:@"%@ %@",plateNumberStr,plateNumberStr1];
        [but setTitle:str forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:but];
   
        UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12+100*i, 10, 1*hight, 30*hight)];
        lineLab.backgroundColor = CTXColor(201, 201, 201);
        [self addSubview:lineLab];
        if (i==0) {
            lineLab.backgroundColor = [UIColor whiteColor];
        }
    }
    NSArray * payStatus = @[@"已付款",@"未付款"];
    for (int i=0; i<payStatus.count; i++) {
        UIButton  * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(12+(i)*80, 10+(30+15)*hight, 80, 30);
        but.tag = 10+i;
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [but addTarget:self action:@selector(onPayStatusClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitle:payStatus[i] forState:UIControlStateNormal];
        UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12+i*80, 10+(30+15)*hight, 1, 30)];
        lineLab.backgroundColor = CTXColor(201, 201, 201);
        [self addSubview:lineLab];
        if (i==0) {
            lineLab.backgroundColor = [UIColor whiteColor];
        }
    }


}

//选择车
-(void)onClick:(UIButton *)but{
    

    if (but.tag>99&&but.tag<100+_dataArr.count) {
        for (int i=100; i<=100+_dataArr.count; i++) {
            if (but.tag == i) {
               [but setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
                plateNumber = _dataArr[but.tag-100];
                if (selectCarListener) {
                    selectCarListener(plateNumber,value);
                }
            }else{
                UIButton * btn = (UIButton *)[self viewWithTag:i];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            }
        }
    }
}
-(void)freshData:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self initUI];

}
// 选择支付状态
-(void)onPayStatusClick:(UIButton *)but{
    
    if (but.tag-10==0) {
        //[but setTitle:@"已付款" forState:UIControlStateNormal];
        [but setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
        UIButton * btn = (UIButton *)[self viewWithTag:11];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (selectCarListener) {
            value = @"0";
            selectCarListener(plateNumber,value);
        }
        
        
    }else{
//        [but setTitle:@"未付款" forState:UIControlStateNormal];
        [but setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
        UIButton * btn = (UIButton *)[self viewWithTag:10];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (selectCarListener) {
            value = @"1";
            selectCarListener(plateNumber,value);
        }
        
     
    }

}

-(void)setSelectCarListener:(void (^)(NSString *, NSString *))listener{
    selectCarListener = listener;
}
@end
