//
//  Saveselfl.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SaveSubscribeModel.h"

@implementation SaveSubscribeModel

- (NSMutableDictionary *) toDictionary {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (self.carLisence) {
        [params setObject:self.carLisence forKey:@"carLisence"];
    }
    
    if (self.lastFrame) {
        [params setObject:self.lastFrame forKey:@"lastFrame"];
    }
    
    if (self.paymethod) {
        [params setObject:self.paymethod forKey:@"paymethod"];
    }
    
    if (self.stationid) {
        [params setObject:self.stationid forKey:@"stationid"];
    }
    
    if (self.jdarea) {
        [params setObject:self.jdarea forKey:@"jdarea"];
    }
    
    if (self.detailAddr) {
        [params setObject:self.detailAddr forKey:@"detailAddr"];
    }
    
    if (self.sjareaid) {
        [params setObject:self.sjareaid forKey:@"sjareaid"];
    }
    
    if (self.sjDetailAdd) {
        [params setObject:self.sjDetailAdd forKey:@"sjDetailAdd"];
    }
    
    if (self.contactPerson) {
        [params setObject:self.contactPerson forKey:@"contactPerson"];
    }
    
    if (self.contactPhone) {
        [params setObject:self.contactPhone forKey:@"contactPhone"];
    }
    
    if (self.ordertimeid) {
        [params setObject:self.ordertimeid forKey:@"ordertimeid"];
    }
    
    if (self.isAutoReg) {
        [params setObject:self.isAutoReg forKey:@"isAutoReg"];
    }
    
    if (self.businessType) {
        [params setObject:self.businessType forKey:@"businessType"];
    }
    
    if (self.carType) {
        [params setObject:self.carType forKey:@"carType"];
    }
    
    if (self.subscribeDate) {
        [params setObject:self.subscribeDate forKey:@"subscribeDate"];
    }
    
    if (self.avator) {
        [params setObject:self.avator forKey:@"avator"];
    }
    
    if (self.postCode) {
        [params setObject:self.postCode forKey:@"postCode"];
    }
    
    if (self.sjPostCode) {
        [params setObject:self.sjPostCode forKey:@"sjPostCode"];
    }
    
    if (self.expressType) {
        [params setObject:self.expressType forKey:@"expressType"];
    }
    
    if (self.sourcebu) {
        [params setObject:self.sourcebu forKey:@"sourcebu"];
    }
    
    if (self.couponcodeid) {
        [params setObject:self.couponcodeid forKey:@"couponcodeid"];
    }
    
    if (self.lng) {
        [params setObject:self.lng forKey:@"lng"];
    }
    
    if (self.lat) {
        [params setObject:self.lat forKey:@"lat"];
    }
    
    if (self.hlng) {
        [params setObject:self.hlng forKey:@"hlng"];
    }
    
    if (self.hlat) {
        [params setObject:self.hlat forKey:@"hlat"];
    }
    
    return params;
}

@end
