//
//  CTXBaseView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "MBProgressHUDTool.h"

@implementation CTXBaseView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    }
    
    return self;
}

- (void) showTextHubWithContent:(NSString *) content {
    [[MBProgressHUDTool sharedInstance] showTextHubWithContent:content superView:self];
}

@end
