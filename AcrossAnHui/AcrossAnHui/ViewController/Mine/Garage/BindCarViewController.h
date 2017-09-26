//
//  BindCarViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "BoundCarModel.h"

/**
 绑定车辆／编辑车辆
 */
@interface BindCarViewController : CTXBaseTableViewController<UITextViewDelegate> {
    NSArray *plateTypes;
    NSArray *plateTypeIDs;
}

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, retain) BoundCarModel *carModel;

@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *frameNumberBtn;
@property (weak, nonatomic) IBOutlet UILabel *plateTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tintLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *plateTypeCell;

- (instancetype) initWithStoryboard;

@end
