//
//  PrideGainerInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PrideGainerInfoView.h"
#import "PrideGainerInfoCell.h"
#import "AppDelegate.h"
#import "DES3Util.h"

static CGFloat cellHeight = 284;

@interface PrideGainerInfoView()

@property(nonatomic, retain) PrideGainerInfoCell *cell;

@end

@implementation PrideGainerInfoView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerClass:[PrideGainerInfoCell class] forCellReuseIdentifier:@"PrideGainerInfoCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (void) showWithName:(NSString *)name phone:(NSString *)phone {
    self.name = name;
    self.phone = phone;
    
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@(CTXBarHeight + CTXNavigationBarHeight));
    }];
    
    [self showAnimation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iden"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        _cell = [PrideGainerInfoCell cellWithTableView:tableView];
        _cell.phoneTextField.text = self.phone;
        _cell.nameTextField.text = self.name;
        
        @weakify(self)
        [_cell setCloseListener:^ {
            @strongify(self)
            [self hideAnimation];
        }];
        
        [_cell setGainPrideListener:^(NSString *name, NSString *phone) {
            @strongify(self)
            
            if (name.length < 2) {
                [self showTextHubWithContent:@"请输入正确的姓名"];
                return;
            }
            
            if (![DES3Util isMobileNumber:phone]) {
                [self showTextHubWithContent:@"请输入正确的手机号码"];
                return;
            }
            
            if (self.gainPrideListener) {
                self.gainPrideListener(name, phone);
                
                [self hideAnimation];
            }
        }];
        
        return _cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        return (CTXScreenHeight - 64 - cellHeight) / 2;
    } else {
        return cellHeight;
    }
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.tableView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.tableView.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.tableView.center.x, self.tableView.center.y + CTXScreenHeight / 2)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.tableView.layer removeAllAnimations];
    [self.tableView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = CGPointMake(CTXScreenWidth / 2, (CTXScreenHeight - 64) / 2);
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.tableView.layer removeAllAnimations];
    [self.tableView.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}

@end
