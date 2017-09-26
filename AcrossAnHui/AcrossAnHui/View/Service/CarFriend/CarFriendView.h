//
//  CarFriendView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "SelectView.h"
#import "CarFriendCardModel.h"
#import "CarFriendGoodResultModel.h"

/**
 问小畅、随手拍列表共同的View
 */
@interface CarFriendView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    CGFloat ivHeight;
    CGFloat noticeHeight;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *imageView;       // 分类图片
@property (nonatomic, retain) NSMutableArray *noticeViews;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *submitBtn;

@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshCardListener;
@property (nonatomic, copy) LoadDataListener loadcardListener;
@property (nonatomic, copy) SelectCellModelListener showCarFriendInfoListener;
@property (nonatomic, copy) SelectCellModelListener clickGoodListener;
@property (nonatomic, copy) ClickListener submitListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

/**
 第一次加载数据
 
 @param data 第一页数据
 */
- (void) refreshDataSource:(NSArray *)data;

/**
 加载数据
 
 @param data 分页数据
 @param page 当前页码
 */
- (void) addDataSource:(NSArray *)data page:(int) page;

// 设置分类图片
- (void) setHeaderImageView:(NSString *)path;
// 设置公告内容
- (void) setCarFriendNoticeModel:(NSArray *) notices;
// 设置发布按钮的图片
- (void) setSubmitBtnWithImageName:(NSString *)name;

// 更新选择的Model
- (void) updateSelectModel:(CarFriendCardModel *)model;

// 更新点赞的结果
- (void) updateCarFriendCardModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel;

@end
