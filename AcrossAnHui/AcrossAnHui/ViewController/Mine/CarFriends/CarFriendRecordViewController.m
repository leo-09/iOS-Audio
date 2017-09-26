//
//  CarFriendRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendRecordViewController.h"
#import "CarFriendRecordNetData.h"
#import "TopicRecordViewController.h"
#import "TrafficRecordViewController.h"
#import "CommentRecordViewController.h"
#import "CollectionRecordViewController.h"

@interface CarFriendRecordViewController ()

@property (nonatomic, retain) CarFriendRecordNetData *carFriendRecordNetData;

@end

@implementation CarFriendRecordViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"CarFriendRecordViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"随手拍";
    
    _carFriendRecordNetData = [[CarFriendRecordNetData alloc] init];
    _carFriendRecordNetData.delegate = self;
    
    [self getallkindsofcountNew];
    
    // 添加删除的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getallkindsofcountNew) name:CarFriendDeleteNotificationName object:nil];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getallkindsofcountNewTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        
        _topicCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"cardCount"] ? dict[@"cardCount"] : @"0"];
        _trafficCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"trafficCount"] ? dict[@"trafficCount"] : @"0"];
        _commentCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"commentCount"] ? dict[@"commentCount"] : @"0"];
        _collectionCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"houseCount"] ? dict[@"houseCount"] : @"0"];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (![_topicCountLabel.text isEqualToString:@"0"]) {
            TopicRecordViewController *controller = [[TopicRecordViewController alloc] init];
            [self basePushViewController:controller];
        }
    } else if (indexPath.row == 2) {
        if (![_trafficCountLabel.text isEqualToString:@"0"]) {
            TrafficRecordViewController *controller = [[TrafficRecordViewController alloc] init];
            [self basePushViewController:controller];
        }
    } else if (indexPath.row == 3) {
        if (![_commentCountLabel.text isEqualToString:@"0"]) {
            CommentRecordViewController *controller = [[CommentRecordViewController alloc] init];
            [self basePushViewController:controller];
        }
    } else if (indexPath.row == 4) {
        if (![_collectionCountLabel.text isEqualToString:@"0"]) {
            CollectionRecordViewController *controller = [[CollectionRecordViewController alloc] init];
            [self basePushViewController:controller];
        }
    }
}

#pragma mark - private method

- (void)getallkindsofcountNew {
    [self showHub];
    [_carFriendRecordNetData getallkindsofcountNewWithToken:self.loginModel.token
                                                     userId:self.loginModel.loginID
                                                        tag:@"getallkindsofcountNewTag"];
}

@end
