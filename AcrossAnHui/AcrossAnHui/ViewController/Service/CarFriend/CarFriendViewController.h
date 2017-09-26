//
//  CarFriendViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

typedef enum {
    ThemeIndex_Recommend = 1,           // 推荐
    ThemeIndex_Ask = 2,                 // 问小畅
    ThemeIndex_ReadilyPhotograph = 3,   // 随手拍
    ThemeIndex_Driver = 4               // 老司机
} ThemeIndex;

/**
 问小畅、随手拍列表
 */
@interface CarFriendViewController : CTXBaseViewController

@property (nonatomic, copy) NSString *themeName;// 主题名称：问小畅、随手拍
@property (nonatomic, assign) ThemeIndex themeIndex;

@property (nonatomic, assign) int currentPage;

@end
