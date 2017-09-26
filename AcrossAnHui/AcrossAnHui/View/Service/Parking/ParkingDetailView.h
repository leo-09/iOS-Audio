//
//  ParkingDetailView.h
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/3.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "CTXBaseView.h"
#import "SiteModel.h"
#import "SitefeeModel.h"
#import "PromptView.h"

typedef void (^RefreshParkInfoListener)(BOOL isRequestFailure);

/**
 路边停车位详情View
 */
@interface ParkingDetailView : CTXBaseView {
    void (^showTrafficListener)();
    void (^showNavigationListener)(double latitude, double longitude);
    
    NSArray *managerIcons;
    NSArray *managertitles;
    NSArray *chargetitles;
    
    PromptView *promptView;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, retain) UIView *chargeRuleView;
@property (nonatomic, retain) UIView *buttonView;

@property (nonatomic, retain) SiteModel *siteModel;     // 路段数据
@property (nonatomic, retain) NSArray *sitefeeModels;   // 路段收费表

@property (nonatomic, copy) RefreshParkInfoListener refreshParkInfoListener;

- (void) addSiteModel:(SiteModel *) siteModel sitefeeModels:(NSArray *) sitefeeModels;

- (void) setShowTrafficListener:(void(^)())listener;
- (void) setShowNavigationListener:(void(^)(double latitude, double longitude))listener;

@end
