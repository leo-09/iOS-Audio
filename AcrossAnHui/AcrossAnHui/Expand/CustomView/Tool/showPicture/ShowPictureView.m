//
//  ShowPictureView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ShowPictureView.h"
#import "AppDelegate.h"
#import "PicInfo.h"
#import "YYKit.h"

#define kPicTag     1000
#define kSubScrTag  2000
#define kImageSize  10

@interface ShowPictureView() {
    NSMutableArray *_picInfoArr; // 保存图片模型数组
    
    BOOL doubleClick;
    
    NSInteger currentPage;      // 当前页数
}

@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) UILabel *titleLabel;          // 滑动的位置描述

@end

@implementation ShowPictureView

//多张图片
- (void)createUIWithPicInfoArr:(NSMutableArray *)marr andIndex:(NSInteger)index {
    // 保存图片模型数组为全局的
    _picInfoArr = marr;
    currentPage = index;
    
    // 添加到屏幕上
    [self setFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 创建主滚动视图
    [self createMainScrollView];
    
    // 创建主滚动视图内容
    [self createMainScrollViewContent];
    
    // 根据index判断当前显示第几张图 通过设置主滚动视图偏移量得到
    [self.mainScrollView setContentOffset:CGPointMake(CTXScreenWidth * currentPage, 0) animated:NO];
    
    // 把当前显示的图片位置设为原始frame 再通过动画展示出来
    [self createAnimationShowPicWithIndex:currentPage];
    
    // 滑动的位置描述
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CTXScreenWidth, 44)];
    _titleLabel.text = [NSString stringWithFormat:@"%ld／%lu", (long)(currentPage+1), (unsigned long)_picInfoArr.count];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_titleLabel];
}

#pragma mark - 把第一次进入的当前显示图片位置设为原始frame 再通过动画展示出来

- (void)createAnimationShowPicWithIndex:(NSInteger)index {
    // 取出当前显示的图片
    PicInfo *info = _picInfoArr[index];
    // 原始frame
    CGRect oldframe = info.picOldFrame;
    UIImageView *currentShowPic = (UIImageView *)[self.mainScrollView viewWithTag:kPicTag + index];
    currentShowPic.frame = oldframe;
    currentShowPic.contentMode = UIViewContentModeScaleAspectFit;
    
    self.mainScrollView.alpha = 1;
    self.mainScrollView.contentOffset = CGPointMake(index * (CTXScreenWidth + kImageSize), 0);
    [UIView animateWithDuration:0.3 animations:^{
        currentShowPic.frame = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight);
    } completion:^(BOOL finished) {
        CGSize imageSize = currentShowPic.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        currentShowPic.frame = CGRectMake((CTXScreenWidth - width) / 2.0, (CTXScreenHeight - height) / 2.0, width, height);
    }];
}

#pragma mark - 创建主滚动视图

- (void)createMainScrollView {
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth + kImageSize, CTXScreenHeight)];
    self.mainScrollView.contentSize = CGSizeMake((CTXScreenWidth + kImageSize) * _picInfoArr.count, CTXScreenHeight);
    self.mainScrollView.bounces = YES;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.minimumZoomScale = 1.0;
    self.mainScrollView.maximumZoomScale = 2.0;
    self.mainScrollView.backgroundColor = UIColorFromRGBA(0x000000, 0.8);
    [self addSubview:self.mainScrollView];
}

#pragma mark - 创建主滚动视图内容
- (void)createMainScrollViewContent {
    doubleClick = YES;
    
    for (int i = 0; i < _picInfoArr.count; i++) {
        UIScrollView *subScr = [[UIScrollView alloc]initWithFrame:CGRectMake((CTXScreenWidth + kImageSize) * i, 0, CTXScreenWidth, CTXScreenHeight)];
        // 子滚动视图不能开启分页否则会晃动
        subScr.contentSize = CGSizeMake(CTXScreenWidth, CTXScreenHeight);
        subScr.showsHorizontalScrollIndicator = YES;
        subScr.showsVerticalScrollIndicator = YES;
        subScr.delegate = self;
        subScr.minimumZoomScale = 1.0;
        subScr.maximumZoomScale = 2.0;
        subScr.tag = kSubScrTag + i;
        [self.mainScrollView addSubview:subScr];
        
        PicInfo *info = _picInfoArr[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:subScr.bounds];
        imageView.tag = kPicTag + i;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [subScr addSubview:imageView];
        
        NSURL* url = [NSURL URLWithString:info.imageURL];
        [imageView setImageWithURL:url placeholder:[info image]];
        
        // 单击
        UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImages:)];
        oneTap.numberOfTouchesRequired = 1;
        oneTap.numberOfTapsRequired = 1;
        [subScr addGestureRecognizer:oneTap];
        
        // 双击
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapBig:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        
        // 指定当oneTap手势发生时,即便oneTap已经滿足条件了,也不会立刻触发,会等到指定的手势doubleTap确定失败之后才触发。
        [oneTap requireGestureRecognizerToFail:doubleTap];
    }
}

#pragma mark - 图片点击隐藏还原回原来位置

-(void)hideImages:(UITapGestureRecognizer*)tap {
    //获取第几张图片点击
    PicInfo *info = _picInfoArr[tap.view.tag - kSubScrTag];
    UIImageView *imageView = (UIImageView *)[self.mainScrollView viewWithTag:tap.view.tag - kPicTag];
    
    if (imageView.isHidden) {// 已经在隐藏
        return;
    }
    
    imageView.hidden = YES;
    
    __block UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [tempImageView setImage:info.image];
    [self addSubview:tempImageView];
    
    [UIView animateWithDuration:0.2 animations:^{
        tempImageView.frame = info.picOldFrame;
        self.mainScrollView.alpha = 0.9;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.mainScrollView removeFromSuperview];
        [tempImageView removeFromSuperview];
        
        tempImageView = nil;
        self.mainScrollView = nil;
    }];
}

#pragma mark - 双击放大

- (void) doubleTapBig:(UITapGestureRecognizer *)tap {
    CGFloat newscale = 2;
    UIScrollView *currentScrollView = (UIScrollView *)[self.mainScrollView viewWithTag:tap.view.tag + kPicTag];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tap locationInView:tap.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        [currentScrollView zoomToRect:zoomRect animated:YES];
    } else {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    doubleClick = !doubleClick;
}

- (CGRect) zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV {
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imageView = (UIImageView *)[self.mainScrollView viewWithTag:scrollView.tag-kPicTag];
    return imageView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = self.mainScrollView.contentOffset;
    NSInteger page = offset.x / CTXScreenWidth ;
    currentPage = page;
    
    if (page != 0) {
        UIScrollView *scrollV_next = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag - 1]; //前一页
        scrollV_next.zoomScale = 1.0;
    }
    
    if (page != _picInfoArr.count) {
        UIScrollView *scollV_pre = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag+1]; //后一页
        scollV_pre.zoomScale = 1.0;
    }
    
    if (page == 0) {
        UIScrollView *scollV_pre = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag+1]; //后一页
        scollV_pre.zoomScale = 1.0;
    }
    
    if (page == _picInfoArr.count) {
        UIScrollView *scrollV_next = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag - 1]; //前一页
        scrollV_next.zoomScale = 1.0;
    }
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:scrollView.tag - kPicTag];
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    
    // 水平居中
    if (imageView.frame.size.width <= scrollView.frame.size.width) {
        centerPoint.x = scrollView.frame.size.width / 2;
    }
    
    // 垂直居中
    if (imageView.frame.size.height <= scrollView.frame.size.height) {
        centerPoint.y = scrollView.frame.size.height / 2;
    }
    
    imageView.center = centerPoint;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        CGPoint point = scrollView.contentOffset;
        int index = point.x / scrollView.frame.size.width;
        
        _titleLabel.text = [NSString stringWithFormat:@"%d／%lu", (index + 1), (unsigned long)_picInfoArr.count];
    }
}

@end
