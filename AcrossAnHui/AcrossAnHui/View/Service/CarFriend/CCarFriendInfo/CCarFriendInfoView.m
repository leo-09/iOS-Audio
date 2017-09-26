//
//  CCarFriendInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendInfoView.h"
#import "CCarFriendInfoCardCell.h"
#import "CCarFriendInfoGoodCell.h"
#import "CCarFriendInfoChangCell.h"
#import "CCarFriendInfoCommentCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "CCarFriendCommentView.h"
#import "SelectView.h"

static CGFloat headerViewHeight = 50;

@interface CCarFriendInfoView ()

@property (nonatomic, retain) CCarFriendInfoCardCell *tempCardCell;
@property (nonatomic, retain) CCarFriendInfoGoodCell *tempGoodCell;
@property (nonatomic, retain) CCarFriendInfoChangCell *tempChangCell;
@property (nonatomic, retain) CCarFriendInfoCommentCell *tempCommentCell;

@property (nonatomic, retain) NSIndexPath *goodIndexPath;;  // 点赞评论的位置

@property (nonatomic, retain) CCarFriendCommentView *commentView;// 评论的view

@end

@implementation CCarFriendInfoView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        // 评论按钮
        SelectView *bottomView = [[SelectView alloc] init];
        [bottomView setDefaultColor:CTXBaseViewColor];
        [bottomView setSelectColor:CTXBaseViewColor];
        [bottomView setClickListener:^(id sender) {
            // 显示评论输入
            [self showCommentView];
        }];
        [self addSubview:bottomView];
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@50);
        }];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.backgroundColor = [UIColor whiteColor];
        bottomLabel.text = @"   回复 楼主：说点啥～";
        bottomLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        bottomLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [bottomView addSubview:bottomLabel];
        [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@8);
            make.bottom.equalTo(@(-8));
        }];
        
        // tableView
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshCardListener) {
                self.refreshCardListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(bottomView.top);
        }];
        
        self.tempCardCell = [[CCarFriendInfoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarFriendInfoCardCell"];
        self.tempGoodCell = [[CCarFriendInfoGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarFriendInfoGoodCell"];
        self.tempChangCell = [[CCarFriendInfoChangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarFriendInfoChangCell"];
        self.tempCommentCell = [[CCarFriendInfoCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarFriendInfoCommentCell"];
        
        // 默认是 “空白页”
        [self addNilDataView];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.model.replyContents && ![self.model.replyContents isEqualToString:@""]) {
            return 3;   // 话题内容、点赞头像、小畅说
        } else {
            return 2;   // 话题内容、点赞头像
        }
    } else {
        return _dataSource.count;   // 车友评论
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {           // 话题内容
            CCarFriendInfoCardCell *cell = [CCarFriendInfoCardCell cellWithTableView:tableView];
            cell.model = self.model;
            cell.userPhoto = self.userPhoto;
            // 点赞
            [cell setClickGoodListener:^(id oldResult, id copyResult) {
                self.model = (CarFriendCardModel *) oldResult;
                
                // 更新 点赞信息Cell
                [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                
                if (self.clickGoodCardListener) {
                    self.clickGoodCardListener(copyResult);
                }
            }];
            // 评论
            [cell setClickCommentListener:^(id oldResult, id copyResult) {
                [self showCommentView];
            }];
            
            return cell;
        } else if (indexPath.row == 1) {   // 点赞头像
            CCarFriendInfoGoodCell *cell = [CCarFriendInfoGoodCell cellWithTableView:tableView];
            cell.model = self.model;
            return cell;
        } else {                            // 小畅说
            CCarFriendInfoChangCell *cell = [CCarFriendInfoChangCell cellWithTableView:tableView];
            cell.model = self.model;
            
            // 点赞
            [cell setClickGoodListener:^(id result) {
                if (self.clickGoodChangListener) {
                    self.clickGoodChangListener(result);
                }
            }];
            
            return cell;
        }
    } else {                                // 车友评论
        CCarFriendInfoCommentCell *cell = [CCarFriendInfoCommentCell cellWithTableView:tableView];
        CarFriendUserCommentModel *model = _dataSource[indexPath.row];
        
        if (indexPath.row < _dataSource.count-1) {
            [cell setModel:model isLastCell:NO];
        } else {
            [cell setModel:model isLastCell:YES];
        }
        
        // 点赞回复
        [cell setClickGoodListener:^(id result) {
            if (!self.goodIndexPath) {
                self.goodIndexPath = indexPath; // 记住当前点赞的位置
                
                if (self.clickGoodCommentListener) {
                    self.clickGoodCommentListener(result);
                }
            }
        }];
        
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { // 进入点赞的好友列表
        if (self.model.headImageList && self.model.headImageList.count > 0) {
            if (self.showFriendListListener) {
                self.showFriendListListener(self.model.cardID);
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return headerViewHeight;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {           // 话题内容
            if (self.model.cardCellHeight == 0) {
                CGFloat cellHeight = [self.tempCardCell heightForModel:self.model];
                self.model.cardCellHeight = cellHeight;// 缓存给model
                return cellHeight;
            } else {
                return self.model.cardCellHeight;
            }
        } else if (indexPath.row == 1) {   // 点赞头像
            CGFloat cellHeight = [self.tempGoodCell heightForModel:self.model];
            return cellHeight;
        } else {                            // 小畅说
            if (self.model.changCellHeight == 0) {
                CGFloat cellHeight = [self.tempChangCell heightForModel:self.model];
                self.model.changCellHeight = cellHeight;// 缓存给model
                return cellHeight;
            } else {
                return self.model.changCellHeight;
            }
        }
    } else {                                // 车友评论
        CarFriendUserCommentModel *model = _dataSource[indexPath.row];
        if (model.cellHeight == 0) {
            CGFloat cellHeight = [self.tempCommentCell heightForModel:model];
            model.cellHeight = cellHeight;// 缓存给model
            return cellHeight;
        } else {
            return model.cellHeight;
        }
    }
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, headerViewHeight)];
        view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, CTXScreenWidth-24, headerViewHeight)];
        label.text = @"车友评论";
        label.textColor = UIColorFromRGB(CTXTextBlackColor);
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        [view addSubview:label];
        
        return view;
    }
    
    return nil;
}

#pragma mark - getter/setter

- (void) hideFooter {
    CGFloat y = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.mj_footer.frame.size.height;
    CGPoint offset = CGPointMake(0, y - height);
    [self.tableView setContentOffset:offset animated:YES];
}

- (void) endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void) removeFooter {
    self.tableView.mj_footer = nil;
}

- (void) addFooter {
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingBlock:^{
            if (self.loadCardListener) {
                self.loadCardListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data page:(int)page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 找出本页数据开始的下标
    int startIndex = countPerPage * (page - 1);  // 因为分页从1开始
    startIndex = (startIndex < 0 ? 0 : startIndex);
    
    // 1、还没有到该页数据, 说明是加载缓存数据，则直接添加
    if (_dataSource.count < startIndex) {
        [_dataSource addObjectsFromArray:data];
    } else {
        // 2、再进来，就是加载的网络数据，则需要替换掉缓存数据
        
        int endIndex = countPerPage * page;  // 下一页开始的下标
        NSRange range;                          // 当前页的下标范围
        
        if (_dataSource.count < endIndex) {     // _dataSource数据不足当前页的最大下标
            int lack = endIndex - (int)_dataSource.count;   // _dataSource中缺少该页数据的个数
            range = NSMakeRange(startIndex, countPerPage - lack);
        } else {
            range = NSMakeRange(startIndex, countPerPage);
        }
        
        // 替换掉缓存数据
        [_dataSource replaceObjectsInRange:range withObjectsFromArray:data];
    }
    
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray *)data {
    if (data) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:data];
        
        if (_dataSource.count == 0) {
            CarFriendUserCommentModel *model = [[CarFriendUserCommentModel alloc] init];
            [_dataSource addObject:model];
        }
        
        countPerPage = (int) _dataSource.count;// 第一页数据个数就是每页的个数，否则就没有下一页了
        [self.tableView reloadData];
    }
}

// 设置帖子详情
- (void) setModel:(CarFriendCardModel *)model {
    if (model) {
        if (model.cardID) {
            if (promptView) {
                [promptView removeFromSuperview];
                promptView = nil;
            }
            
            _model = model;
            [self.tableView reloadData];
        } else {
            [self addNilDataView];
            [promptView setNilDataWithImagePath:@"sb_1" tint:@"此帖已被删除" btnTitle:nil];
        }
    } else {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
    }
}

// 添加提示页面
- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshCardListener) {
                self.refreshCardListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void) updateChangModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel {
    if (newModel) {
        self.model.replyCount = newModel.laudCount;
        self.model.isReplyLaud = newModel.isLaud;
    } else {
        self.model = model;
    }
    
    [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void) updateCardModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel {
    if (newModel) {
        self.model.laudCount = newModel.laudCount;
        self.model.isLaud = newModel.isLaud;
        self.model.headImageList = newModel.data;
    } else {
        self.model = model;
    }
    
    [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void) updateCommentModel:(CarFriendUserCommentModel *)model withNewModel:(CarFriendGoodResultModel*)newModel {
    if (self.goodIndexPath) {
        
        if (_dataSource.count <= self.goodIndexPath.row) {
            return;
        }
        
        if (newModel) {
            // 更新model
            CarFriendUserCommentModel *model = _dataSource[self.goodIndexPath.row];
            model.laudCount = newModel.laudCount;
            model.isLaud = newModel.isLaud;
        } else {
            // 点赞失败，则回顾原来的model
            [_dataSource replaceObjectAtIndex:self.goodIndexPath.row withObject:model];
        }
        
        // 更新cell
        [self.tableView reloadRowAtIndexPath:self.goodIndexPath withRowAnimation:UITableViewRowAnimationNone];
    }
    
    self.goodIndexPath = nil;
}

#pragma mark - 显示评论输入

- (void) showCommentView {
    if (!_commentView) {
        _commentView = [[CCarFriendCommentView alloc] init];
        
        @weakify(self)
        [_commentView setSubmitCommentListener:^(id result) {
            @strongify(self)
            
            if (self.submitCommentListener) {
                self.submitCommentListener(self.model, result);
            }
        }];
    }
    
    [_commentView showView];
}

// 清空 输入的评论内容
- (void) clearCommentContent {
    if (_commentView) {
        [_commentView clearCommentContent];
    }
}

@end
