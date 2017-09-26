//
//  NewsInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CNewsInfoView.h"

/**
 新闻资讯
 */
@interface NewsInfoViewController : CTXBaseViewController

@property (nonatomic, retain) CNewsInfoView *newsInfoView;

@property (nonatomic, copy) NSString *naviTitle;      // 新闻资讯 or 搜索结果
@property (nonatomic, copy) NSString *searchkeyWord;  // 搜索关键字
@property (nonatomic, copy) NSString *nilDataTint;    // 空数据的提示

@property (nonatomic, assign) int currentPage;

@end
