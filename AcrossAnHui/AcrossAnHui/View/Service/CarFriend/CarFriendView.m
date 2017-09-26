//
//  CarFriendView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendView.h"
#import "CarFriendCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"

@interface CarFriendView()

@property (nonatomic, retain) CarFriendCell *tempCell;
@property (nonatomic, retain) NSIndexPath *goodIndexPath;;  // 点赞的位置
@property (nonatomic, retain) NSIndexPath *selectIndexPath;;  // 选择的位置

@end

@implementation CarFriendView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        // imageView的高度
        ivHeight = CTXScreenWidth * 115.0 / 320.0;
        noticeHeight = 45;
        self.noticeViews = [[NSMutableArray alloc] init];
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // headerView
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    [_headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(ivHeight));
    }];
    
    // 分类信息
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"cheyouji_zwt"];
    [_headerView addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(ivHeight));
    }];
    
    // tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self.tableView registerClass:[CarFriendCell class] forCellReuseIdentifier:@"CarFriendCell"];
    // 刷新header
    self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
        if (self.refreshCardListener) {
            self.refreshCardListener(NO);
        }
    }];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_headerView.bottom);
    }];
    
    // submitBtn
    _submitBtn = [[UIButton alloc] init];
    [_submitBtn setImage:[UIImage imageNamed:@"Carfriendicon_wxc"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_submitBtn];
    [_submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-10));
    }];
    
    // 创建cell
    self.tempCell = [[CarFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarFriendCell"];
}

- (void) submit {
    if (self.submitListener) {
        self.submitListener();
    }
}

#pragma mark - public method

- (void) setHeaderImageView:(NSString *)path {
    if (path) {
        NSURL *url = [NSURL URLWithString:path];
        [_imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"cheyouji_zwt"]];
    }
}

- (void) setCarFriendNoticeModel:(NSArray *) notices {
    if (!notices) {
        return;
    }
    
    if (self.noticeViews.count > 0) {
        for (SelectView *view in self.noticeViews) {
            [view removeFromSuperview];
        }
        
        [self.noticeViews removeAllObjects];
    }
    
    [_headerView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ivHeight + noticeHeight * notices.count);
    }];
    
    [self setNeedsLayout];
    
    for (CarFriendCardModel *model in notices) {
        // 公告
        SelectView *noticeView = [[SelectView alloc] init];
        [noticeView setClickListener:^(id sender) {
            if (self.showCarFriendInfoListener) {
                self.showCarFriendInfoListener(model);
            }
        }];
        [_headerView addSubview:noticeView];
        [noticeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(noticeHeight);
            
            SelectView *lastView = self.noticeViews.lastObject;
            if (lastView) {
                make.top.equalTo(lastView.bottom);
            } else {
                make.top.equalTo(_imageView.bottom);
            }
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor redColor];
        nameLabel.text = @"公告";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CTXViewBorderRadius(nameLabel, 3.0, 0, [UIColor clearColor]);
        [noticeView addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(noticeView.centerY);
            make.width.equalTo(@42);
            make.height.equalTo(@20);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = model.title;
        contentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        contentLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [noticeView addSubview:contentLabel];
        [contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.right).offset(@8);
            make.right.equalTo(@(-12));
            make.centerY.equalTo(noticeView.centerY);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [noticeView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        [self.noticeViews addObject:noticeView];
    }
}

- (void) setSubmitBtnWithImageName:(NSString *)name {
    [_submitBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

- (void) updateSelectModel:(CarFriendCardModel *)model {
    if (model && self.selectIndexPath && (self.selectIndexPath.row < _dataSource.count)) {
        // 更新值
        [_dataSource replaceObjectAtIndex:self.selectIndexPath.row withObject:model];
        [self.tableView reloadRowAtIndexPath:self.selectIndexPath withRowAnimation:UITableViewRowAnimationNone];
    }
    
    self.selectIndexPath = nil;
}

- (void) updateCarFriendCardModel:(CarFriendCardModel *)model withNewModel:(CarFriendGoodResultModel*)newModel {
    if (self.goodIndexPath) {
        
        if (_dataSource.count <= self.goodIndexPath.row) {
            return;
        }
        
        if (newModel) {
            // 更新model
            CarFriendCardModel *model = _dataSource[self.goodIndexPath.row];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarFriendCell *cell = [CarFriendCell cellWithTableView:tableView];
    
    if (indexPath.row < self.dataSource.count) {
        cell.model = self.dataSource[indexPath.row];
        
        // 点赞
        [cell setClickGoodListener:^(id result) {
            if (!self.goodIndexPath) {
                self.goodIndexPath = indexPath; // 记住当前点赞的位置
                
                if (self.clickGoodListener) {
                    self.clickGoodListener(result);
                }
            }
        }];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.dataSource.count) {
        if (self.showCarFriendInfoListener) {
            self.selectIndexPath = indexPath;
            self.showCarFriendInfoListener(self.dataSource[indexPath.row]);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarFriendCardModel *model = _dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
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
            if (self.loadcardListener) {
                self.loadcardListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data page:(int) page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 第一次取缓存数据，第二次取网络数据，所以需要对比，替换掉缓存数据／添加缓存数据
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    // 遍历查找数据
    for (CarFriendCardModel *newMdoel in data) {
        BOOL isEqual = NO;
        // 和原数据比对
        for (int i = 0; i < _dataSource.count; i++) {
            CarFriendCardModel *oldModel = _dataSource[i];
            // 找到相同的数据，则替换
            if ([newMdoel.cardID isEqualToString:oldModel.cardID]) {
                isEqual = YES;
                [_dataSource replaceObjectAtIndex:i withObject:newMdoel];
                break;
            }
        }
        // 数据没有出现重复的，则记录该数据
        if (!isEqual) {
            [newData addObject:newMdoel];
        }
    }
    // 添加没有出现重复的数据
    [_dataSource addObjectsFromArray:newData];
    
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray *)data {
    if (!data) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:data];
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无数据" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    [self.tableView reloadData];
}

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
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_headerView.bottom);
    }];
}

@end
