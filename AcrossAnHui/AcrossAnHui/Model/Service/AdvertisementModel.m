//
//  AdvertisementModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AdvertisementModel.h"

@implementation AdvertisementModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [AdvertisementModel modelWithDictionary:dict];
}

- (NSString *) getActualURLWithToken:(NSString *)token userID:(NSString *)userID {
    
    if (token) {
        if ([self.url containsString:@"?"]) {
            self.url = [NSString stringWithFormat:@"%@&token=%@", self.url, token];
        } else {
            self.url = [NSString stringWithFormat:@"%@?token=%@", self.url, token];
        }
    }
    
//    if (userID) {
//        if ([self.url containsString:@"?"]) {
//            self.url = [NSString stringWithFormat:@"%@&id=%@", self.url, userID];
//        } else {
//            self.url = [NSString stringWithFormat:@"%@?id=%@", self.url, userID];
//        }
//    }
    
    return self.url;
}

- (NSString *) desc {
    return (_desc ? _desc : @"");
}

@end
