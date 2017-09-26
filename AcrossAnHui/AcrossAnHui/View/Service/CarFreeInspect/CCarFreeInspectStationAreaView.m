//
//  CCarFreeInspectStationAreaView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFreeInspectStationAreaView.h"
#import "CCarFreeInspectStationAreaCell.h"

@implementation CCarFreeInspectStationAreaView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        // tableView
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 44;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CCarFreeInspectStationAreaCell class] forCellReuseIdentifier:@"CCarFreeInspectStationAreaCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.townModel.village.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCarFreeInspectStationAreaCell *cell = [CCarFreeInspectStationAreaCell cellWithTableView:tableView];
    
    NSString *areaName;
    if (indexPath.row == 0) {
        areaName = self.townModel.areaName;
    } else {
        VillageModel *model = self.townModel.village[indexPath.row - 1];
        areaName = model.areaName;
    }
    
    if (indexPath.row == self.townModel.village.count) {
        [cell setAreaName:areaName isLastCell:YES];
    } else {
        [cell setAreaName:areaName isLastCell:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *areaName;
    NSString *areaid;
    if (indexPath.row == 0) {
        areaid = self.townModel.areaid;
        areaName = self.townModel.areaName;
    } else {
        VillageModel *model = self.townModel.village[indexPath.row - 1];
        areaid = model.areaid;
        areaName = model.areaName;
    }
    
    if (self.selectAreaCellListener) {
        VillageModel *model = [[VillageModel alloc] init];
        model.areaName = areaName;
        model.areaid = areaid;
        
        self.selectAreaCellListener(model);
    }
}

- (void) setTownModel:(TownModel *)townModel {
    _townModel = townModel;
    
    [self.tableView reloadData];
}

@end
