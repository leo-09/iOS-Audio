//
//  CarTypeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"


/**
 汽车品牌
 */
@interface CBModel : CTXBaseModel

@property (nonatomic, copy) NSString *carImgPath;
@property (nonatomic, copy) NSString *CBID;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;

@end


@interface CarTypeModel : CTXBaseModel

@property (nonatomic, retain) CBModel *cb;
@property (nonatomic, retain) NSArray<CBModel *> *cs;

@end
