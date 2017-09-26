//
//  PrideGainerInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "TPKeyboardAvoidingTableView.h"

typedef void (^GainPrideListener)(NSString *name, NSString *phone);

/**
 领取奖品人的信息：填写领取信息
 */
@interface PrideGainerInfoView : CTXBaseView<CAAnimationDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, retain) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) GainPrideListener gainPrideListener;

- (void) showWithName:(NSString *)name phone:(NSString *)phone;

@end
