//
//  CarInspectStationAlbumViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationAlbumViewController.h"
#import "CustomLayout.h"
#import "CustomCollectionViewCell.h"
#import "CarInspectStationModel.h"
#import "YYKit.h"
#import "StationAlbumModel.h"
#import "CarInspectStationPhotoViewController.h"
#import "CarInspectNetData.h"
#import "PromptView.h"

@interface CarInspectStationAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
}

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@property (nonatomic, retain) PromptView *promptview;

@end

@implementation CarInspectStationAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stationImageArray = [NSMutableArray array];
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    [self initUI];
    [_carInspectNetData quertStationAlbumStationID:_stationid tag:@"stationPic"];
}

-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    self.navigationItem.title = @"车检站相册";
    CustomLayout *layout = [[CustomLayout alloc]init];
    layout.delegate = self;
    layout.itemWidth = (CTXScreenWidth-25-22/2)/2.0;
    layout.column = 2;
    layout.sectionInsets = UIEdgeInsetsMake(15, 12.5, 11, 11);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64)   collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

-(void)noDataVeiw{
    
    self.promptview = [[PromptView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.promptview];
    [self.promptview setNilDataWithImagePath:@"sb_1" tint:@"暂无相册" btnTitle:nil];
}

//UICollectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    return 20;
    return self.stationImageArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    StationAlbumModel *stationImage = self.stationImageArray[indexPath.row];
    [cell.albumView setImageWithURL:[NSURL URLWithString:stationImage.picAddr] placeholder:[UIImage imageNamed:@"zet-1.png"]];
    return cell;
}

- (float)cellHeightWithIndexPath:(NSIndexPath *)indexPath{
    
    float height = 104;
    return height ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StationAlbumModel *stationImage = self.stationImageArray[indexPath.row];
    CarInspectStationPhotoViewController * controller = [[CarInspectStationPhotoViewController alloc]init];
    controller.picStr = stationImage.picAddr;
    [self basePushViewController:controller];
}

#pragma mark - CTXNetDataDelegate
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"stationPic"]) {
        // 处理数据结果
        
        NSMutableArray * arr = [NSMutableArray array];
       
        for (NSDictionary * dic in (NSArray *)result) {
            StationAlbumModel *models = [StationAlbumModel convertFromDict:dic];
            [arr addObject:models];
        }
        self.stationImageArray = arr;
        
        if (self.stationImageArray.count<1) {
            if (self.promptview==nil) {
                self.promptview = [[PromptView alloc]initWithFrame:self.view.frame];
                [self.view addSubview:self.promptview];
                [self.promptview setNilDataWithImagePath:@"sb_1" tint:@"暂无图片" btnTitle:nil];
            }
        } else {
            if (self.promptview) {
                [self.promptview removeFromSuperview];
                self.promptview = nil;
            }
            [_collectionView reloadData];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    if (self.promptview==nil) {
        self.promptview = [[PromptView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:self.promptview];
        [self.promptview  setRequestFailureImageView];
        @weakify(self)
        [self.promptview setPromptRefreshListener:^{
            @strongify(self)
            [self.carInspectNetData quertStationAlbumStationID:self.stationid tag:@"stationPic"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
