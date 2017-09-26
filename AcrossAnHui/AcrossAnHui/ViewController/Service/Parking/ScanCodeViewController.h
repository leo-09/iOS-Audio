//
//  ScanCodeViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 扫一扫二维码
 */
@interface ScanCodeViewController : CTXBaseViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *scanBarcodeView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (strong, nonatomic) CALayer *scanLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;     //捕捉会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//展示layer
@property (nonatomic, retain) NSTimer *timer;

- (BOOL) startReading;
- (void) stopReading;

- (instancetype) initWithStoryboard;

@end
