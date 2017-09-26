//
//  CCarFriendInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "SelectView.h"
#import "CarFriendCardModel.h"
#import "CarFriendUserCommentModel.h"
#import "CarFriendGoodResultModel.h"

typedef void (^SubmitCommentListener)(id result, NSString *content);

/**
 问小畅、随手拍详情View
 */
@interface CCarFriendInfoView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    int countPerPage;// 每页的个数
}

@property (nonatomic, copy) NSString *userPhoto;  // 当前用户的头像
// 帖子详情
@property (nonatomic, retain) CarFriendCardModel *model;
// 评论
@property (nonatomic, retain) NSMutableArray<CarFriendUserCommentModel *> *dataSource;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) SelectView *bottomView;

@property (nonatomic, copy) RefreshDataListener refreshCardListener;            // 刷新
@property (nonatomic, copy) LoadDataListener loadCardListener;                  // 加载
@property (nonatomic, copy) SelectCellModelListener showFriendListListener;     // 显示点赞好友列表
@property (nonatomic, copy) SelectCellModelListener clickGoodCardListener;      // 点赞帖子
@property (nonatomic, copy) SelectCellModelListener clickGoodChangListener;     // 点赞小畅说
@property (nonatomic, copy) SelectCellModelListener clickGoodCommentListener;   // 点赞回复
@property (nonatomic, copy) SubmitCommentListener submitCommentListener;        // 发表评论

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

// 点赞小畅说后，刷新UI
- (void) updateChangModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel;
// 点赞帖子后，刷新UI
- (void) updateCardModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel;
// 点在回复后，刷新UI
- (void) updateCommentModel:(CarFriendUserCommentModel *)model withNewModel:(CarFriendGoodResultModel*)newModel;

// 清空 输入的评论内容
- (void) clearCommentContent;

@end
