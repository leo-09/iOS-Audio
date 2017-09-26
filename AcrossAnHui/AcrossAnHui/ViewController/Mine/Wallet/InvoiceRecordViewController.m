//
//  InvoiceRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "InvoiceRecordViewController.h"
#import "CInvoiceRecordView.h"
#import "InvoiceRecordModel.h"
#import "WalletNetData.h"

#define startPage 1

@interface InvoiceRecordViewController ()

@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, retain) CInvoiceRecordView *invoiceRecordView;

@property (nonatomic, retain) WalletNetData *walletNetData;

@end

@implementation InvoiceRecordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请记录";
    
    [self.view addSubview:self.invoiceRecordView];
    [self.invoiceRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _walletNetData = [[WalletNetData alloc] init];
    _walletNetData.delegate = self;
    
    [self showHub];
    _currentPage = startPage - 1;
    [self selectTicketSend];
}

- (void) addRightBarButtonItem {
    // rightBarButtonItem
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editInvoiceRecord)];
    [_rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0f] };
    [_rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
}

// 没有数据 则不显示
- (void) removeRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = nil;
}

// 编辑／全选
- (void) editInvoiceRecord {
    if ([_rightBarButtonItem.title isEqualToString:@"编辑"]) {
        _rightBarButtonItem.title = @"全选";
        [_invoiceRecordView showEditStatus];
    } else {
        [_invoiceRecordView selectAllRecord];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectTicketSendTag"]) {
        int totalPage = [result[@"totalPage"] intValue];
        _currentPage = [result[@"currentPage"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *records = [InvoiceRecordModel convertFromArray:result[@"ticketSendVOlist"]];
        
        if (_currentPage <= startPage) {// 刷新
            [_invoiceRecordView endRefreshing];
            
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_invoiceRecordView refreshDataSource:records];
            
            if (records.count > 0) {
                [self addRightBarButtonItem];
            } else {
                [self removeRightBarButtonItem];
            }
        } else {
            [_invoiceRecordView addDataSource:records];
        }
        
        
        
        if (_currentPage >= totalPage) {
            [_invoiceRecordView removeFooter];
        } else {
            [_invoiceRecordView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"deleteTicketSendTag"]) {
        [self showTextHubWithContent:@"删除记录成功"];
        [self showHub];
        
        // 删除完成，再重新获取数据
        _currentPage = startPage - 1;
        [self selectTicketSend];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectTicketSendTag"]) {
        [_invoiceRecordView endRefreshing];
        [_invoiceRecordView hideFooter];
        
        if (_currentPage <= startPage) {
            [_invoiceRecordView refreshDataSource:nil];
            [self removeRightBarButtonItem];
        } else {
            [_invoiceRecordView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - network

// 查询申请发票记录
- (void)selectTicketSend {
    // 请求下一页数据
    _currentPage++;
    [_walletNetData selectTicketSendWithToken:self.loginModel.token
                                       userId:self.loginModel.loginID
                                         page:_currentPage
                                          tag:@"selectTicketSendTag"];
}

// 删除发票记录
- (void)deleteTicketSendWithTid:(NSString *)tid {
    [self showHubWithLoadText:@"删除中..."];
    
    [_walletNetData deleteTicketSendWithToken:self.loginModel.token tid:tid tag:@"deleteTicketSendTag"];
}

#pragma mark - getter/setter

- (CInvoiceRecordView *) invoiceRecordView {
    if (!_invoiceRecordView) {
        _invoiceRecordView = [[CInvoiceRecordView alloc] init];
        
        @weakify(self)
        [_invoiceRecordView setCancelListener:^ {
            @strongify(self)
            self.rightBarButtonItem.title = @"编辑";
        }];
        
        [_invoiceRecordView setDeleteRecordDataListener:^(id result) {
            @strongify(self)
            [self deleteTicketSendWithTid:(NSString *)result];
        }];
        
        [_invoiceRecordView setRefreshParkDataListener:^ (BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self selectTicketSend];
        }];
        
        [_invoiceRecordView setLoadParkDataListener:^ {
            @strongify(self)
            
            [self selectTicketSend];
        }];
    }
    
    return _invoiceRecordView;
}

@end
