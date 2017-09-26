//
//  FilterAlertView.h
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/3.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "CTXBaseView.h"

@interface FilterAlertView : CTXBaseView {
    void (^filterRoadListener)();
    void (^filterParkListener)();
    void (^filterAllListener)();
}

- (void) show;

- (void) setFilterRoadListener:(void(^)())listener;
- (void) setFilterParkListener:(void(^)())listener;
- (void) setFilterAllListener:(void(^)())listener;

@end
