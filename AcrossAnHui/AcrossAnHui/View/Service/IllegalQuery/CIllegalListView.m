//
//  CIllegalListView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalListView.h"
#import "CIllegalQueryCell.h"

@implementation CIllegalListView

- (instancetype) init {
    if (self = [super init]) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.alreadyPaid.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CIllegalQueryCell *cell = [CIllegalQueryCell cellWithTableView:tableView];
    
    // 找出违章信息详情
    ViolationInfoModel *violationInfoModel = _model.alreadyPaid[indexPath.row];
    cell.model = violationInfoModel;
    [cell setCountLabelText:[NSString stringWithFormat:@"%d", ((int)(indexPath.row) + 1)]];
    
    // 第一个cell 隐藏leftTopLineView
    if (indexPath.row == 0) {
        [cell showLeftTopLineView:YES];
    } else {
        [cell showLeftTopLineView:NO];
    }
    
    // 最后一个cell 隐藏bottomLineView
    if (indexPath.row == (_model.alreadyPaid.count - 1)) {
        [cell showBottomLineView:YES];
    } else {
        [cell showBottomLineView:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.model.alreadyPaid.count) {
        // 找出违章信息详情
        ViolationInfoModel *violationInfoModel = self.model.alreadyPaid[indexPath.row];
        
        if (self.selectCarIllegalInfoCellListener) {
            self.selectCarIllegalInfoCellListener(violationInfoModel);
        }
    }
}

#pragma mark - public method

- (void) setModel:(CarIllegalInfoModel *)model {
    if (!model) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    _model = model;
    
    if (_model.alreadyPaid.count == 0) {
        [self addNilDataView];
        
        NSString *tint = @"恭喜您，暂无历史违章信息";
        if ([model.jdcjbxx.success isEqualToString:@"0"]) {
            tint = @"系统维护中,暂时无法查询该车辆的违章信息";
        }
        
        [promptView setNilDataWithImagePath:@"no_Illegal_record" tint:tint btnTitle:nil isNeedAddData:YES];
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
        
        [promptView setPromptRefreshListener:^{
            // 不刷新
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
