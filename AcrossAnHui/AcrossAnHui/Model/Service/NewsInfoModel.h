//
//  NewsInfoModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 新闻资讯的Model
 */
@interface NewsInfoModel : CTXBaseModel

@property (nonatomic, copy) NSString *newsInfoID;     // 资讯编号
@property (nonatomic, copy) NSString *name;           // 资讯名称
@property (nonatomic, copy) NSString *addtime;        // 添加时间(秒)
@property (nonatomic, copy) NSString *typeimg;        // 类型图片路径
@property (nonatomic, copy) NSString *title;          // 新闻摘要
@property (nonatomic, copy) NSString *appNewsUrl;     // APP新闻链接

- (NSString *)dataTime;

@end
