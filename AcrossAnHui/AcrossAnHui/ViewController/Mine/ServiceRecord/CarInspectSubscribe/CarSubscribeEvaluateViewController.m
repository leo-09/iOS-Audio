//
//  CarSubscribeEvaluateViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarSubscribeEvaluateViewController.h"
#import "CarInspectNetData.h"
#import "CarInspectStationCommentView.h"
#import "ImageTool.h"
#import "CarInspectStationModel.h"

@interface CarSubscribeEvaluateViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    int _selectBtn;
}

@property (nonatomic,retain)CarInspectNetData * carInspectNetData;

@property (nonatomic,retain)CarInspectStationCommentView * commectView;

@property (nonatomic,retain)NSMutableDictionary * mutabDic;
@property (nonatomic,retain)NSString * phoneStr;

@end

@implementation CarSubscribeEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车检站点评";
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self initUI];
    
    self.mutabDic = [NSMutableDictionary dictionary];
    
    _carInspectNetData = [[CarInspectNetData alloc]init];
    _carInspectNetData.delegate = self;
    [self initStationInfoData];
}

-(void)initStationInfoData {
    [self showHub];
    
    CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
    CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
    [_carInspectNetData stationDetailWithLatitude:latitude longitude:longitude stationId:self.model.stationid tag:@"stationInfoTag"];
}

-(void)initUI {
    _commectView = [[CarInspectStationCommentView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64) model:self.model];
    [self.view addSubview:_commectView];
    
    @weakify(self)
    
    [_commectView setSubmitPhotoListener:^(int value){
        @strongify(self)
        _selectBtn = value;
        [self alertAction];
    
    }];
    
    [_commectView setSubmitListener:^(NSString *assessStar, NSString *textViewStr, NSString *businessid) {
        @strongify(self)
        
        NSMutableArray * arr = [NSMutableArray array];
        if (self.mutabDic.count>0) {
            for (NSString * str in self.mutabDic.allValues) {
                [arr addObject:str];
            }
            self.phoneStr = [arr componentsJoinedByString:@"|"];
        }
        
        [self showHubWithLoadText:@"提交中..."];
        [self.carInspectNetData submitStationCommentWithToken:self.loginModel.token assessStar:assessStar assessContent:textViewStr imgUrl:self.phoneStr businessid:businessid tag:@"submitStationTag"];
    }];
}

- (void)alertAction {
    UIAlertAction *photoAction;
    UIAlertAction *imagAction;
    UIAlertAction *cameralAction;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //支持相机
        cameralAction = [UIAlertAction actionWithTitle:@"相机选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imaePicket = [[UIImagePickerController alloc]init];
            imaePicket.delegate = self;
            imaePicket.allowsEditing = YES;
            imaePicket.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imaePicket animated:YES completion:nil];
        }];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        //支持相片库
        photoAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imaePicket = [[UIImagePickerController alloc]init];
            imaePicket.delegate = self;
            imaePicket.allowsEditing = YES;
            imaePicket.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imaePicket animated:YES completion:nil];
        }];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //支持图片库
        imagAction = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imaePicket = [[UIImagePickerController alloc]init];
            imaePicket.delegate = self;
            imaePicket.allowsEditing = YES;
            imaePicket.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imaePicket animated:YES completion:nil];
        }];
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:@"请从相册或者相机拍摄" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    if (photoAction!=nil) {
        [alertControl addAction:photoAction];
    }
    if (cameralAction !=nil) {
        [alertControl addAction:cameralAction];
    }
    if (imagAction!=nil) {
        [alertControl addAction:imagAction];
    }
    [alertControl addAction:cancleAction];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //UIImage *currentImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(400, 400)];
    NSData *imagedata = [ImageTool compressImage:image];
    [self.commectView getChangeBtnImage:_selectBtn data:imagedata];
    [_carInspectNetData uploadUserHeaderImageWithData:imagedata tag:@"updateStationImageTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"updateStationImageTag"]) {
        [self showTextHubWithContent:@"图片上传成功"];
        
        NSDictionary * dic = (NSDictionary *)result;
        NSString * photoStr = dic[@"imgUrl"];
        NSString * valueKey = [NSString stringWithFormat:@"%d",_selectBtn];
        [self.mutabDic setObject:photoStr forKey:valueKey];
    }
    
    if ([tag isEqualToString:@"submitStationTag"]) {
        [self showTextHubWithContent:tint];
        [self.navigationController popViewControllerAnimated:true];
        if (getbackViewController) {
            getbackViewController();
        }
    }
    
    if ([tag isEqualToString:@"stationInfoTag"]) {
        CarInspectStationModel * stationModel = [CarInspectStationModel convertFromDict:(NSDictionary *)result isCarInspectAgency:NO];
        [_commectView refreshData:stationModel];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"uploadUserHeaderImageTag"]) {
        [self showTextHubWithContent:@"头像上传失败"];
    }
}

-(void)setGetbackViewController:(void (^)())listener{
    getbackViewController = listener;
}

@end
