//
//  NearByMAPointAnnotation.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NearByMAPointAnnotation.h"

@implementation NearByMAPointAnnotation

// 解码
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.tag = [aDecoder decodeObjectForKey:@"tag"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        
        double latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        double longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    return self;
}

// 编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeDouble:self.coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.coordinate.longitude forKey:@"longitude"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@; phone:%@; tag:%@; latitude:%f; longitude:%f", self.title, self.phone, self.tag, self.coordinate.latitude, self.coordinate.longitude];
}

@end
