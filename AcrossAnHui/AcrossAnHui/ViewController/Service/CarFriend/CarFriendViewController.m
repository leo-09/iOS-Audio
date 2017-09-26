//
//  CarFriendViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendViewController.h"
#import "CarFriendInfoViewController.h"
#import "PublishInfoViewController.h"
#import "CarFriendGoodResultModel.h"
#import "CarFriendClassifyModel.h"
#import "CarFriendCardModel.h"
#import "CoreServeNetData.h"
#import "CarFriendView.h"

#define startPage 1

@interface CarFriendViewController ()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;
@property (nonatomic, retain) CarFriendView *carFriendView;

@property (nonatomic, retain) CarFriendCardModel *goodModel;    // 点赞的对象

@end

@implementation CarFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.themeName;
    if ([self.themeName isEqualToString:@"问小畅"]) {
        self.themeIndex = ThemeIndex_Ask;
    } else if ([self.themeName isEqualToString:@"随手拍"]) {
        self.themeIndex = ThemeIndex_ReadilyPhotograph;
    } else {
        self.themeIndex = ThemeIndex_Recommend;
    }
    
    [self.view addSubview:self.carFriendView];
    [self.carFriendView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    
    [self showHub];
    _currentPage = startPage - 1;
    
    // 一进来，就应该展示缓存数据
    [_coreServeNetData getClassifyListWithTag:@"getClassifyListTag"];// 获取分类列表信息
    [_coreServeNetData getannouncementcardlistWithIsBulletin:YES tag:@"getannouncementcardlistTag"];// 获取公告
    [self getislaudrecommendcardlist];// 获取帖子列表
    
    // 帖子详情页返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectModel:) name:CarFriendInfoNotificationName object:nil];
}

// 帖子详情页返回后，需要更新该model的属性
- (void) updateSelectModel:(NSNotification *)noti {
    CarFriendCardModel *model = (CarFriendCardModel *) noti.object;
    [_carFriendView updateSelectModel:model];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getClassifyListTag"]) {  // 获取分类列表信息
        NSArray * classifyModels = [CarFriendClassifyModel convertFromArray:(NSArray *) result];
        if (classifyModels.count > self.themeIndex) {
            CarFriendClassifyModel *model = classifyModels[self.themeIndex - 1];
            [_carFriendView setHeaderImageView:model.image];
        } else {
            [_carFriendView setHeaderImageView:nil];
        }
    }
    
    if ([tag isEqualToString:@"getannouncementcardlistTag"]) {  // 获取公告
        NSDictionary *dict = (NSDictionary *) result;
        NSArray * notices = [CarFriendCardModel convertFromArray:dict[@"data"]];
        [_carFriendView setCarFriendNoticeModel:notices];
    }
    
    if ([tag isEqualToString:@"getislaudrecommendcardlistTag"]) {   // 帖子列表
        [self hideHub];
        [_carFriendView endRefreshing];
        
        NSDictionary *dict = (NSDictionary *) result;
        int pageCount = [dict[@"pageCount"] intValue];  // 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *cards = [CarFriendCardModel convertFromArray:dict[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_carFriendView refreshDataSource:cards];
        } else {// 加载
            [_carFriendView addDataSource:cards page:_currentPage];
        }
        
        if (_currentPage >= pageCount) {
            [_carFriendView removeFooter];// 删除加载提示
        } else {
            [_carFriendView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"operatingpointlaudTag"]) {  // 点赞
        // 当前帖子的点赞数量
        CarFriendGoodResultModel *newModel = [CarFriendGoodResultModel convertFromDict:result];
        [_carFriendView updateCarFriendCardModel:self.goodModel withNewModel:newModel];
        
        self.goodModel = nil;// goodModel置nil，下次才可点击
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getislaudrecommendcardlistTag"]) {
        [_carFriendView endRefreshing];
        [_carFriendView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_carFriendView refreshDataSource:nil];
        } else {// 加载
            [_carFriendView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
    
    if ([tag isEqualToString:@"operatingpointlaudTag"]) {  // 点赞
        [_carFriendView updateCarFriendCardModel:self.goodModel withNewModel:nil];
        self.goodModel = nil;// goodModel置nil，下次才可点击
    }
}

#pragma mark - getter/setter

- (CarFriendView *) carFriendView {
    if (!_carFriendView) {
        _carFriendView = [[CarFriendView alloc] init];
        
        if ([self.themeName isEqualToString:@"问小畅"]) {
            [_carFriendView setSubmitBtnWithImageName:@"Carfriendicon_wxc"];
        } else if ([self.themeName isEqualToString:@"随手拍"]) {
            [_carFriendView setSubmitBtnWithImageName:@"Carfriendicon_ssp"];
        }
        
        @weakify(self)
        [_carFriendView setRefreshCardListener:^(BOOL isRequestFailure) {   // 刷新数据
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self getislaudrecommendcardlist];
        }];
        
        [_carFriendView setLoadcardListener:^ {                             // 加载数据
            @strongify(self)
            [self getislaudrecommendcardlist];
        }];
        
        [_carFriendView setShowCarFriendInfoListener:^(id result) {         // 展现公告／选择车友记的内容
            @strongify(self)
            CarFriendCardModel *model = (CarFriendCardModel *) result;
            
            CarFriendInfoViewController *controller = [[CarFriendInfoViewController alloc] init];
            controller.cardID = model.cardID;
            [self basePushViewController:controller];
        }];
        
        [_carFriendView setSubmitListener:^ {
            @strongify(self)
            PublishInfoViewController *controller = [[PublishInfoViewController alloc] init];
            
            if ([self.themeName isEqualToString:@"问小畅"]) {
                controller.publishInfoType = PublishInfoType_ASK;
            } else if ([self.themeName isEqualToString:@"随手拍"]) {
                controller.publishInfoType = PublishInfoType_PHOTO;
            }
            
            [self basePushViewController:controller];
        }];
        
        [_carFriendView setClickGoodListener:^(id result) {                 // 点赞
            @strongify(self)
            
            // 当前点赞对象还存在，说明网络请求没有完成，不允许不停点赞
            if (!self.goodModel) {
                self.goodModel = (CarFriendCardModel *)result;
                
                // 点赞接口
                [self.coreServeNetData operatingpointlaudWithToken:self.loginModel.token
                                                      laudType:0
                                                     operateID:self.goodModel.cardID
                                                   isRecommend:(self.goodModel.isRecommend ? @"1" : @"0")
                                                           tag:@"operatingpointlaudTag"];
            }
        }];
    }
    
    return _carFriendView;
}

// 获取帖子列表
- (void) getislaudrecommendcardlist {
    // 请求下一页数据
    _currentPage++;
    [_coreServeNetData getislaudrecommendcardlistWithToken:self.loginModel.token
                                                    userId:self.loginModel.loginID
                                                classifyID:self.themeIndex
                                                    offset:_currentPage
                                                       tag:@"getislaudrecommendcardlistTag"];
}

@end
