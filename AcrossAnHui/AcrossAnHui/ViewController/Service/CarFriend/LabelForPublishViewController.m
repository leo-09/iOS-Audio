//
//  LabelForPublishViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "LabelForPublishViewController.h"
#import "CLabelForPublishView.h"
#import "CoreServeNetData.h"

@interface LabelForPublishViewController ()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;
@property (nonatomic, retain) CLabelForPublishView *labelForPublishView;

@end

@implementation LabelForPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择标签";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureLabel)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.labelForPublishView];
    [self.labelForPublishView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    self.coreServeNetData = [[CoreServeNetData alloc] init];
    self.coreServeNetData.delegate = self;
    
    [self showHub];
    
    // 带model过来，则直接显示缓存数据
    BOOL isOnlyCache = NO;
    isOnlyCache = _currentModel ? YES : NO;
    
    if (self.publishInfoType == PublishInfoType_TRAFFIC) {// 报路况
        [self.coreServeNetData getTrafficLabelWithOnlyCache:isOnlyCache tag:@"getTrafficLabelTag"];
    } else {
        [self.coreServeNetData getclassfifytagnameWithOnlyCache:isOnlyCache tag:@"getclassfifytagnameTag"];
    }
}

// 确认选中的标签
- (void)sureLabel {
    _currentModel = _labelForPublishView.currentModel;
    if (_labelForPublishView.currentSuperModel) {
        _currentSuperModel = _labelForPublishView.currentSuperModel;
    }
    
    if (_currentModel) {
        //发送通知
        NSDictionary *result = @{ @"currentModel" : _currentModel,
                                  @"currentSuperModel" : _currentSuperModel };
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectLabelNotificationName object:nil userInfo:result];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showTextHubWithContent:@"请选择一个标签"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    // 报路况／随手拍的标签集合
    NSMutableArray *labels;
    
    if ([tag isEqualToString:@"getTrafficLabelTag"]) {
        SuperEventDetailModel *model = [[SuperEventDetailModel alloc] init];
        model.labelList = [EventDetailModel convertFromArray:(NSArray *)result];
        model.title = @"";// 报路况的标签
        model.superID = @"报路况";
        
        labels = [[NSMutableArray alloc] init];
        [labels addObject:model];
    }
    
    if ([tag isEqualToString:@"getclassfifytagnameTag"]) {
        labels = [SuperEventDetailModel convertFromArray:(NSArray *)result];
    }
    
    for (SuperEventDetailModel *superModel in labels) {
        // 在同一个标签组
        if ([superModel.superID isEqualToString:self.currentSuperModel.superID]) {
            for (EventDetailModel *model in superModel.labelList) {
                if ([model.eventID isEqualToString:_currentModel.eventID]) {
                    model.isSelected = YES;
                    
                    // labels添加到UI中
                    [_labelForPublishView setDataSource:labels currentModel:model];
                    
                    return;
                }
            }
        }
    }
    
    // labels添加到UI中
    [_labelForPublishView setDataSource:labels currentModel:nil];
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - getter/setter

- (CLabelForPublishView *) labelForPublishView {
    if (!_labelForPublishView) {
        _labelForPublishView = [[CLabelForPublishView alloc] init];
    }
    
    return _labelForPublishView;
}

@end
