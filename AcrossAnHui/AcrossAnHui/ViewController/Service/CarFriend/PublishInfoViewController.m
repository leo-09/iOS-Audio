//
//  PublishInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PublishInfoViewController.h"
#import "LabelForPublishViewController.h"
#import "AddressForPublishViewController.h"
#import "PreviewImageViewController.h"
#import "CarFriendMAPointAnnotation.h"
#import "CPublishInfoView.h"
#import "EventDetailModel.h"
#import "CoreServeNetData.h"
#import "ISRDataHelper.h"
#import "SuPhotoPicker.h"
#import "IATConfig.h"
#import "TextViewContentTool.h"
#import "ImageTool.h"

static NSString *locationTint = @"定位失败，请打开定位";

@interface PublishInfoViewController () {
    NSString *delimiter;    // 图片的分隔符
}

@property (nonatomic, retain) CPublishInfoView *publishInfoView;
@property (nonatomic, retain) CoreServeNetData *coreServeNetData;

@property (nonatomic, retain) EventDetailModel *currentModel;   // 选中的标签
@property (nonatomic, retain) SuperEventDetailModel *currentSuperModel; // 选中的标签组
@property (nonatomic, retain) CarFriendMAPointAnnotation * selectAnno;  // 当前选择的点

@end

@implementation PublishInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 添加View
    [self.view addSubview:self.publishInfoView];
    [self.publishInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    if (self.publishInfoType == PublishInfoType_ASK) {
        self.navigationItem.title = @"问小畅";
        [_publishInfoView setTextViewPlaceholder:@"有什么想问小畅的,在这里写下你的疑问~"];
        [_publishInfoView setLabelHide];
        _publishInfoView.textCount = 300;
        delimiter = @"#";
    } else if (self.publishInfoType == PublishInfoType_PHOTO) {
        self.navigationItem.title = @"随手拍";
        [_publishInfoView setTextViewPlaceholder:@"文明出行,从你我做起~"];
        _publishInfoView.textCount = 300;
        delimiter = @"#";
    } else {
        self.navigationItem.title = @"报路况";
        [_publishInfoView setTextViewPlaceholder:@"实时路况,人人分享"];
        _publishInfoView.textCount = 200;
        delimiter = @",";
    }
    
    [self startUpdatingLocationWithBlock:^{
        if (!_selectAnno) {
            _selectAnno = [[CarFriendMAPointAnnotation alloc] init];
        }
        _selectAnno.province = [AppDelegate sharedDelegate].aMapLocationModel.province;
        _selectAnno.city = [AppDelegate sharedDelegate].aMapLocationModel.city;
        _selectAnno.district = [AppDelegate sharedDelegate].aMapLocationModel.district;
        _selectAnno.address = [[AppDelegate sharedDelegate].aMapLocationModel areaAddress];
        _selectAnno.latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        _selectAnno.longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        
        // 定位失败
        if (!_selectAnno.address) {
            _selectAnno.address = locationTint;
        }
        
        [_publishInfoView setCurrentAddress:_selectAnno.address];
    }];
    
    // 标签的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectLabel:) name:SelectLabelNotificationName object:nil];
    // 地址的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddress:) name:CurrentAddressNotificationName object:nil];
    // 删除图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:DeleteImageNotificationName object:nil];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
}

// 获取选择的标签
- (void) selectLabel:(NSNotification *)noti {
    NSDictionary *result = noti.userInfo;
    _currentModel = result[@"currentModel"];
    _currentSuperModel = result[@"currentSuperModel"];
    
    [_publishInfoView setLabelText:_currentModel.name];// 更新UI
}

// 获取选择的地址
- (void) selectAddress:(NSNotification *)noti {
    _selectAnno = (CarFriendMAPointAnnotation *) noti.object;
    [_publishInfoView setCurrentAddress:_selectAnno.address];// 更新UI
}

// 删除图片
- (void) deleteImage:(NSNotification *)noti {
    UIImage *image = (UIImage *) noti.object;
    [_publishInfoView deleteRecordImage:image];// 更新UI
}

#pragma mark - event response

// 发表
- (void) publish {
    [_publishInfoView.textView resignFirstResponder];
    
    NSString *content = [TextViewContentTool isContaintContent:_publishInfoView.textView.text];
    if (!content) {
        [self showTextHubWithContent:@"请输入发表内容"];
        return;
    }
    
    _publishInfoView.textView.text = content;
    
    if (self.publishInfoType != PublishInfoType_ASK) {
        if (!_currentModel) {
            [self showTextHubWithContent:@"请添加标签"];
            return;
        }
    }
    
    // 随手拍／报路况 必须要定位信息
    if ([_selectAnno.address isEqualToString:locationTint]) {
        [self showTextHubWithContent:locationTint];
        return;
    }
    
    // 随手拍必须要上传图片
    if (self.publishInfoType == PublishInfoType_PHOTO) {
        if (_publishInfoView.images.count == 0) {
            [self showTextHubWithContent:@"请选择图片"];
            return;
        }
    }
    
    if (_publishInfoView.images.count > 0) {
        [self uploadImage];
    } else {
        [self publishWithImagePath:@""];
    }
}

// 上传图片
- (void) uploadImage {
    [self showHubWithLoadText:@"图片上传中 0%"];
    
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (UIImage *image in _publishInfoView.images) {
        NSData * data = [ImageTool compressImage:image];
        [datas addObject:data];
    }
    
    [_coreServeNetData fileUploadswithDataArray:datas tag:@"fileUploadsTag"];
}

// 发表内容
- (void) publishWithImagePath:(NSString *)imgPath {
    [self showHubWithLoadText:@"正在提交..."];
    
    if (self.publishInfoType == PublishInfoType_TRAFFIC) {
        [_coreServeNetData addTrafficUpWithToken:self.loginModel.token province:_selectAnno.province city:_selectAnno.city
                                            addr:_selectAnno.address latitude:_selectAnno.latitude
                                       longitude:_selectAnno.longitude tagName:_currentModel.name
                                        contents:_publishInfoView.textView.text imgURL:imgPath tag:@"addTrafficUpTag"];
    } else {
        NSString *classifyID = @"3";// 随手拍
        if (self.publishInfoType == PublishInfoType_ASK) {
            classifyID = @"2";// 问小畅
        }
        
        NSString *address;
        if ([_selectAnno.address isEqualToString:locationTint]) {
            address = _selectAnno.address;
        } else if ([_selectAnno.address containsString:_selectAnno.district]) {
            address = [NSString stringWithFormat:@"%@%@%@", _selectAnno.province, _selectAnno.city, _selectAnno.address];
        } else {
            address = [NSString stringWithFormat:@"%@%@%@%@", _selectAnno.province, _selectAnno.city, _selectAnno.district, _selectAnno.address];
        }
        
        [_coreServeNetData publishpostWithToken:self.loginModel.token
                                         userID:self.loginModel.loginID
                                     classifyID:classifyID
                                          tagID:_currentModel.eventID
                                       contents:_publishInfoView.textView.text
                                       cityName:_selectAnno.city
                                        address:address
                                         imgURL:imgPath
                                       province:_selectAnno.province
                                           town:_selectAnno.district
                                       latitude:_selectAnno.latitude
                                      longitude:_selectAnno.longitude
                                            tag:@"publishpostTag"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) uploadFileWithTag:(NSString *)tag progress:(float)progress {
    if ([tag isEqualToString:@"fileUploadsTag"]) {
        [self showHubWithLoadText:[NSString stringWithFormat:@"图片上传中 %.0f%%", (progress * 100.0)]];
    }
}

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"fileUploadsTag"]) {// 图片上传成功
        // 图片上传后的地址
        NSArray *array = (NSArray *) result;
        
        NSMutableString *imgPath = [[NSMutableString alloc] init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *item = array[i];
            
            [imgPath appendString:item[@"img"]];
            // 逗号分隔
            if (i < array.count-1) {
                [imgPath appendString:delimiter];
            }
        }
        
        // 发表
        [self publishWithImagePath:imgPath];
    }
    
    if ([tag isEqualToString:@"publishpostTag"]) {
        [self showTextHubWithContent:@"正在审核，请耐心等待"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([tag isEqualToString:@"addTrafficUpTag"]) {
        [self showTextHubWithContent:@"上传成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"fileUploadsTag"]) {// 图片上传失败
        [self showTextHubWithContent:@"图片上传失败"];
    } else {
        [self showTextHubWithContent:tint];
    }
}

#pragma mark - getter/setter

- (IFlySpeechRecognizer *) iFlySpeechRecod {
    if (!_iFlySpeechRecod) {
        _iFlySpeechRecod = [IFlySpeechRecognizer sharedInstance];
        [_iFlySpeechRecod setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        [_iFlySpeechRecod setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];// 设置为听写模式
        
        // 设置最长录音时长
        IATConfig *config = [IATConfig sharedInstance];
        [_iFlySpeechRecod setParameter:config.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        [_iFlySpeechRecod setParameter:config.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        [_iFlySpeechRecod setParameter:config.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        [_iFlySpeechRecod setParameter:config.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        // 设置语言
        [_iFlySpeechRecod setParameter:config.language forKey:[IFlySpeechConstant LANGUAGE]];
        if ([config.language isEqualToString:[IATConfig chinese]]) {
            // 设置方言
            [_iFlySpeechRecod setParameter:config.accent forKey:[IFlySpeechConstant ACCENT]];
        }
        
        // 设置是否返回标点
        [_iFlySpeechRecod setParameter:config.dot forKey:[IFlySpeechConstant ASR_PTT]];
    }
    
    return _iFlySpeechRecod;
}

- (CPublishInfoView *) publishInfoView {
    if (!_publishInfoView) {
        _publishInfoView = [[CPublishInfoView alloc] init];
        
        @weakify(self)
        
        // 选择标签
        [_publishInfoView setAddLabelListener:^ {
            @strongify(self)
            
            LabelForPublishViewController *controller = [[LabelForPublishViewController alloc] init];
            controller.publishInfoType = self.publishInfoType;
            controller.currentModel = self.currentModel;
            controller.currentSuperModel = self.currentSuperModel;
            [self basePushViewController:controller];
        }];
        
        // 选择当前位置
        [_publishInfoView setAddAddressListener:^ {
            @strongify(self)
            
            AddressForPublishViewController *controller = [[AddressForPublishViewController alloc] init];
            controller.selectAnno = self.selectAnno;
            [self basePushViewController:controller];
        }];
        
        // 选择图片
        [_publishInfoView setAddImageListener:^ {
            @strongify(self)
            [self showPhotoAlertController];
        }];
        
        // 语音识别
        [_publishInfoView setAddRecordListener:^ {
            @strongify(self)
            
            self.iFlySpeechRecod.delegate = self;
            [self.iFlySpeechRecod startListening];//启动识别服务
        }];
        
        // 取消语音识别
        [_publishInfoView setCancelRecordListener:^ {
            @strongify(self)
            
            // 取消本次会话
            [self.iFlySpeechRecod cancel];
        }];
        
        // 图片预览
        [_publishInfoView setPreviewImageListener:^(id result) {
            @strongify(self)
            
            PreviewImageViewController *controller = [[PreviewImageViewController alloc] init];
            controller.image = (UIImage *) result;
            [self basePushViewController:controller];
        }];
    }
    
    return _publishInfoView;
}

#pragma mark - IFlySpeechRecognizerDelegate

//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast {
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        [_publishInfoView setTextViewContent:[ISRDataHelper stringFromJson:key]];
    }
}

// 识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error {
    [_publishInfoView cancelRecord];
}

//音量回调函数
- (void) onVolumeChanged: (int)volume {
    if (volume < 6) {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_1"];
    } else if (volume < 12) {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_2"];
    } else if (volume < 18) {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_3"];
    } else if (volume < 24) {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_4"];
    } else if (volume < 30) {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_5"];
    } else {
        _publishInfoView.recordView.imageView.image = [UIImage imageNamed:@"fasan_5"];
    }
}

#pragma mark - private method

- (void) showPhotoAlertController {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoPicker];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:photoAction];
    [controller addAction:cameraAction];
    [controller addAction:cancleAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) openPhotoPicker {
    SuPhotoPicker *picker = [[SuPhotoPicker alloc] init];
    picker.selectedCount = 9 - _publishInfoView.images.count;
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        [_publishInfoView addRecordImage:photos];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString*)kUTTypeImage]) {
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self performSelector:@selector(showImage:) withObject:image afterDelay:0];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) showImage:(UIImage*) image {
    [_publishInfoView addRecordImage:@[ image ]];
}

@end
