//
//  TrafficEventInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TrafficEventInfoView.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "ShowPictureView.h"
#import "AppDelegate.h"
#import "PicInfo.h"

static CGFloat contentViewDistance = 15;
static CGFloat contentLabelDistance = 10;
static CGFloat vertiDistance = 15;

@implementation TrafficEventInfoView

#pragma mark - init

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // 整体可见的view
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(contentViewDistance);
        make.right.equalTo(-contentViewDistance);
        make.height.equalTo(@300);// 零时值
    }];
    
    // 关闭按钮 高40
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"drawable_gban"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideInfoView) forControlEvents:UIControlEventTouchDown];
    [_contentView addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(26);
        make.height.equalTo(40);
        make.right.equalTo(_contentView.right).offset(@(-12));
    }];
    
    // 主view
    _mainView = [[UIView alloc] init];
    CTXViewBorderRadius(_mainView, 5.0, 0, [UIColor clearColor]);
    _mainView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_mainView];
    [_mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@300);// 零时值
    }];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [_mainView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabelDistance);
        make.right.equalTo(@(-contentLabelDistance));
        make.top.equalTo(vertiDistance);
    }];
    
    // 介绍
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = [UIFont systemFontOfSize:14.0];
    _infoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _infoLabel.numberOfLines = 0;
    [_mainView addSubview:_infoLabel];
    [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabelDistance);
        make.right.equalTo(@(-contentLabelDistance));
        make.top.equalTo(_titleLabel.bottom).offset(vertiDistance);
    }];
    
    // 无用
    _unUseableBtn = [[UIButton alloc] init];
    [_unUseableBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    _unUseableBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_unUseableBtn setTitle:@" 无用(0)" forState:UIControlStateNormal];
    [_unUseableBtn setImage:[UIImage imageNamed:@"drawable_bdianji"] forState:UIControlStateNormal];
    [_unUseableBtn addTarget:self action:@selector(unuseable) forControlEvents:UIControlEventTouchDown];
    [_mainView addSubview:_unUseableBtn];
    [_unUseableBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-contentLabelDistance));
        make.bottom.equalTo(-vertiDistance);
    }];
    
    // 有用
    _useableBtn = [[UIButton alloc] init];
    [_useableBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    _useableBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_useableBtn setTitle:@" 有用(0)" forState:UIControlStateNormal];
    [_useableBtn setImage:[UIImage imageNamed:@"drawable_dz"] forState:UIControlStateNormal];
    [_useableBtn addTarget:self action:@selector(unuseable) forControlEvents:UIControlEventTouchDown];
    [_mainView addSubview:_useableBtn];
    [_useableBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_unUseableBtn.left).offset(-contentLabelDistance);
        make.bottom.equalTo(-vertiDistance);
    }];
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    [_mainView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabelDistance);
        make.right.equalTo(@(-contentLabelDistance));
        make.bottom.equalTo(_useableBtn.top).offset(-vertiDistance);
    }];
}

#pragma mark - public method

- (void) setModel:(TrafficEventModel *)model {
    _model = model;
    
    // 赋值
    _titleLabel.text = _model.type;
    _timeLabel.text = _model.time;
    
    // 事件描述不超过200字
    if (_model.desc.length > 200) {
        _infoLabel.text = [_model.desc substringToIndex:200];
    } else {
        _infoLabel.text = _model.desc;
    }
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:3];
    
    [_useableBtn setTitle:[NSString stringWithFormat:@" 有用(%@)", _model.useful] forState:UIControlStateNormal];
    [_unUseableBtn setTitle:[NSString stringWithFormat:@" 无用(%@)", _model.useless] forState:UIControlStateNormal];
    
    // 是否有图片
    CGFloat imageWidth = (CTXScreenWidth- contentViewDistance * 2 - contentLabelDistance * 3) / 2;
    CGFloat imageHeight = imageWidth * 3 / 4;
    NSArray * scenePhotos = [_model sceneImagePaths];
    if (scenePhotos) {
        [self addScrollViewWithHeight:imageHeight imageWidth:imageWidth scenePhotos:scenePhotos];
    } else {
        imageHeight = 0;
    }
    
    // mainView的高度 从上往下计算：
    CGFloat infoHeght = [_infoLabel getLabelHeightWithLineSpace:3 WithWidth:(CTXScreenWidth - contentViewDistance * 2 - contentLabelDistance * 2) WithNumline:0].height;
    if (imageHeight > 0) {
        imageHeight += vertiDistance;
    }
    CGFloat mainViewHeight = vertiDistance + 15 +
                             vertiDistance + infoHeght +
                             imageHeight +
                             vertiDistance + 15 +
                             vertiDistance + 20 +
                             vertiDistance;
    
    [_mainView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(mainViewHeight);
    }];
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40 + mainViewHeight));
    }];
}

// 添加图片
- (void) addScrollViewWithHeight:(CGFloat)imageHeight imageWidth:(CGFloat)imageWidth scenePhotos:(NSArray *)scenePhotos {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        [_mainView addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentLabelDistance);
            make.right.equalTo(@(-contentLabelDistance));
            make.top.equalTo(_infoLabel.bottom).offset(vertiDistance);
            make.height.equalTo(imageHeight);
        }];
        
        _svConentView = [[UIView alloc] init];
        _svConentView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_svConentView];
        [_svConentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.height.equalTo(_scrollView);
        }];
    }
    
    [_svConentView removeAllSubviews];
    
    if (imageViewArray) {
        [imageViewArray removeAllObjects];
    } else {
        imageViewArray = [[NSMutableArray alloc] init];
    }
    
    UIImageView *lastIV;
    for (int i = 0; i < scenePhotos.count; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        NSURL *url = [NSURL URLWithString:scenePhotos[i]];
        [iv setImageWithURL:url placeholder:[UIImage imageNamed:@"no_photo"]];
        [_svConentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(imageWidth);
            if (lastIV) {
                make.left.equalTo(lastIV.right).offset(contentLabelDistance);
            } else {
                make.left.equalTo(@0);
            }
        }];
        
        lastIV = iv;
        
        // 添加单击手势
        iv.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageInWindow:)];
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:gesture];
        
        [imageViewArray addObject:iv];
    }
    
    [_svConentView makeConstraints:^(MASConstraintMaker *make) {
        if (lastIV) {
            make.right.equalTo(lastIV.right);
        } else {
            make.right.equalTo(@0);
        }
    }];
}

#pragma mark - event response

// 显示大图
- (void) showImageInWindow:(UITapGestureRecognizer*) gesture {
    UIImageView *iv = (UIImageView *) gesture.view;
    int index = (int) iv.tag;   // 当前选中图片的下标
    
    NSMutableArray* pics = [[NSMutableArray alloc] init];
    
    NSArray * scenePhotos = [_model sceneImagePaths];
    for (int i = 0; i < scenePhotos.count; i++) {
        // 图片的对象
        PicInfo* pic = [[PicInfo alloc] init];
        // 设置图片的url路径
        [pic setImageURL:scenePhotos[i]];
        
        // 设置图片在列表中的frame
        pic.picOldFrame = [iv convertRect:iv.bounds toView:[AppDelegate sharedDelegate].window];
        
        if ([imageViewArray count] > i) {
            UIImageView *imageView = imageViewArray[i];
            // 设置图片的image
            [pic setImage:imageView.image];
        }
        
        [pics addObject:pic];
    }
    
    ShowPictureView* picShowView = [[ShowPictureView alloc] init];
    [picShowView createUIWithPicInfoArr:pics andIndex:index];
}

// 无用
- (void) unuseable {
    currentBtnIndex = @"2";
    if (self.trafficCountListener) {
        self.trafficCountListener(self.model.eventID, @"2");
    }
}

// 有用
- (void) useable {
    currentBtnIndex = @"1";
    if (self.trafficCountListener) {
        self.trafficCountListener(self.model.eventID, @"1");
    }
}

- (void) updateBtnTitle {
    if ([currentBtnIndex isEqualToString:@"1"]) {
        int useful = [_model.useful intValue] + 1;
        [_useableBtn setTitle:[NSString stringWithFormat:@" 有用(%d)", useful] forState:UIControlStateNormal];
    } else {
        int useless = [_model.useless intValue] + 1;
        [_unUseableBtn setTitle:[NSString stringWithFormat:@" 无用(%d)", useless] forState:UIControlStateNormal];
    }
}

#pragma mark - event response

- (void) showInfoView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

- (void) hideInfoView {
    if (self.hideViewListener) {
        self.hideViewListener();
    }
    
    [self hideAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.contentView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.contentView.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.contentView.center.x, self.contentView.center.y + CTXScreenHeight / 2)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentView.layer removeAllAnimations];
    [self.contentView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = [AppDelegate sharedDelegate].window.center;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentView.layer removeAllAnimations];
    [self.contentView.layer addAnimation:animation forKey:@"show-layer"];
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
