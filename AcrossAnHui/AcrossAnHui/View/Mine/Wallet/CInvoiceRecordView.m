//
//  CInvoiceRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CInvoiceRecordView.h"
#import "CInvoiceRecordCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "InvoiceRecordModel.h"

@interface CInvoiceRecordView()

@property (nonatomic, retain) CInvoiceRecordCell *tempCell;

@end

@implementation CInvoiceRecordView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        [self addBottomView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CInvoiceRecordCell class] forCellReuseIdentifier:@"CInvoiceRecordCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(_bottomView.top);
        }];
    }
    
    self.tempCell = [[CInvoiceRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CInvoiceRecordCell"];
    
    return self;
}

// 添加 删除、取消按钮
- (void) addBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [self addSubview:_bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0);
    }];
    
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_deleteBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchDown];
    [_bottomView addSubview:_deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_cancelBtn addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchDown];
    [_bottomView addSubview:_cancelBtn];
    [_cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    UIView *vertialView = [[UIView alloc] init];
    vertialView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:vertialView];
    [vertialView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(0.8);
        make.height.equalTo(@30);
        make.center.equalTo(_bottomView.center);
    }];
}

// 删除
- (void) deleteRecord {
    NSMutableString *selectedCarID = [[NSMutableString alloc] init];
    for (InvoiceRecordModel *model in self.dataSource) {
        if (model.isSelected) {
            [selectedCarID appendString:[NSString stringWithFormat:@"%@,", model.tid]];
        }
    }
    
    if ([selectedCarID isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择发票申请记录"];
    } else {
        [self cancelRecord];
        
        if (self.deleteRecordDataListener) {
            NSString *result = [selectedCarID substringToIndex:(selectedCarID.length-1)];
            self.deleteRecordDataListener(result);
        }
    }
}

// 取消
- (void) cancelRecord {
    // 更新Cell的显示
    for (InvoiceRecordModel *model in self.dataSource) {
        model.isShowSelected = NO;
        model.isSelected = NO;
    }
    [self.tableView reloadData];
    
    // 隐藏 删除／取消 按钮
    [_bottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [self setNeedsLayout];
    
    // 改变rightBarButtomItem文字
    if (self.cancelListener) {
        self.cancelListener();
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CInvoiceRecordCell * cell = [CInvoiceRecordCell cellWithTableView:tableView];
    
    InvoiceRecordModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 更新选中状态
    InvoiceRecordModel *model = _dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    
    // 更新UI
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvoiceRecordModel *model = _dataSource[indexPath.row];
    
    CGFloat cellHeight = [self.tempCell heightForModel:model];
    model.cellHeight = cellHeight;// 缓存给model
    return cellHeight;
}

#pragma mark - getter/setter

- (void) hideFooter {
    CGFloat y = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.mj_footer.frame.size.height;
    CGPoint offset = CGPointMake(0, y - height);
    [self.tableView setContentOffset:offset animated:YES];
}

- (void) endRefreshing {
    [self.tableView.mj_footer endRefreshing];
}

- (void) removeFooter {
    self.tableView.mj_footer = nil;
}

- (void) addFooter {
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingBlock:^{
            if (self.loadParkDataListener) {
                self.loadParkDataListener();
            }
        }];
    }
}

// 全选
- (void) selectAllRecord {
    for (InvoiceRecordModel *model in self.dataSource) {
        model.isShowSelected = YES;
        model.isSelected = YES;
    }
    
    [self.tableView reloadData];
}

// 编辑状态
- (void) showEditStatus {
    for (InvoiceRecordModel *model in self.dataSource) {
        model.isShowSelected = YES;
        model.isSelected = NO;
    }
    
    [self.tableView reloadData];
    
    [_bottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
    }];
    
    [self setNeedsLayout];
}

- (void) addDataSource:(NSArray *)data {
    [_dataSource addObjectsFromArray:data];
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
    [self.tableView reloadData];
    
    [_dataSource addObjectsFromArray:data];
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"park_zwtcjl" tint:@"暂无发票申请记录" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshParkDataListener) {
                self.refreshParkDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
