//
//  ScanCodeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "ParkRecordModel.h"
#import "ScanCodePayViewController.h"
#import "CarInspectRecordNetData.h"

@interface ScanCodeViewController ()

@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, copy) NSString *isPay;

@end

@implementation ScanCodeViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Parking" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanCodeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    CTXViewBorderRadius(_contentView, 0, 1.0, [UIColor whiteColor]);
    [_openBtn setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    [_openBtn setImage:[UIImage imageNamed:@"icon_kd"] forState:UIControlStateSelected];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startReading];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopReading];
}

#pragma mark - 扫码

- (void) stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode,             // 二维码
                                                     AVMetadataObjectTypeEAN13Code,
                                                     AVMetadataObjectTypeEAN8Code,
                                                     AVMetadataObjectTypeCode128Code,
                                                     AVMetadataObjectTypeCode39Code ]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:self.scanBarcodeView.layer.bounds];
    //9.将图层添加到预览view的图层上
    [self.scanBarcodeView.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight);
    //10.1.扫描框 _scanBarcodeView
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    
    _scanLayer.frame = CGRectMake(10, 0, CTXScreenWidth - 90 - 20, 1);
    _scanLayer.backgroundColor = UIColorFromRGB(CTXThemeColor).CGColor;
    [self.contentView.layer addSublayer:_scanLayer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

- (void)moveScanLayer:(NSTimer *)timer {
    CGRect frame = _scanLayer.frame;
    
    if (self.contentView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = -3;
        _scanLayer.frame = frame;
    } else {
        frame.origin.y += 3;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        
        // 获取二维码信息
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        //  {"recordID":"98924","isPay":"1"} 转化为字典
        NSData *jsonData = [metadataObject.stringValue dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        self.recordID = dict[@"recordID"];
        self.isPay = dict[@"isPay"];
        
        [self performSelectorOnMainThread:@selector(selectParkingDetail) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - event response

// 开灯／关灯
- (IBAction)openClose:(id)sender {
    _openBtn.selected = !_openBtn.selected;
    
    if (_openBtn.selected) {
        [self turnTorchOn:YES];
    } else {
        [self turnTorchOn:NO];
    }
}

- (void) turnTorchOn: (bool) on {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - netWork

// 查询停车记录详情
-(void)selectParkingDetail {
    [self showHub];
    
    CarInspectRecordNetData *recordNetData = [[CarInspectRecordNetData alloc] init];
    recordNetData.delegate = self;
    [recordNetData queryParkingDetailRecordWithToken:self.loginModel.token carID:self.recordID isPay:self.isPay tag:@"queryParkingDetailRecordTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryParkingDetailRecordTag"]) {
        // 扫码后，获取订单号
        ScanCodePayViewController *controller = [[ScanCodePayViewController alloc] initWithStoryboard];
        controller.ubalance = result[@"ubalance"];
        controller.model = [ParkRecordModel convertFromDict:result[@"parkingDetail"]];
        [self basePushViewController:controller];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryParkingDetailRecordTag"]) {
        [self startReading];// 重新扫码
    }
}

@end
