//
//  LoginView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

typedef void (^LoginListener)(NSString *account, NSString *psw);

@interface CLoginView : CTXBaseView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) ClickListener backListener;
@property (nonatomic, strong) ClickListener registerListener;
@property (nonatomic, strong) ClickListener forgetPasswordistener;
@property (nonatomic, strong) LoginListener loginListener;

- (instancetype) initWithMyFrame:(CGRect)frame;

- (void) setAccount:(NSString *) account password:(NSString *)password;

@end
