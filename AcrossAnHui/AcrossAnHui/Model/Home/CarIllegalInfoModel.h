//
//  CarIllegalInfoModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "BoundCarModel.h"


/**
 违章信息总述
 */
@interface ViolationSummaryModel : CTXBaseModel

@property (nonatomic, copy) NSString *fkjeSum;        // 机动车未处理罚款金额总额
@property (nonatomic, copy) NSString *itemCount;      // 机动车违法记录总条数
@property (nonatomic, copy) NSString *jdcwfxxSum;     // 机动车未处理违法记录总条数
@property (nonatomic, copy) NSString *ljwwzts;        // 累计未违章天数
@property (nonatomic, copy) NSString *wfjfsSum;       // 机动车未处理违法记分总数

@end


/**
 违章详情
 */
@interface ViolationInfoModel : CTXBaseModel

@property (nonatomic, copy) NSString *cjjgmc;         // 采集机关名称
@property (nonatomic, copy) NSString *clbj;           // 处理标记，只会返回“已处理”“未处理”两个结果
@property (nonatomic, copy) NSString *clsj;           // 处理时间，clbj为‘已处理’的会返回处理时间，时间格式”yyyy-MM-dd HH:mm:ss”
@property (nonatomic, copy) NSString *fkje;           // 罚款金额
// 暂时不清楚和罚款金额的关系，fkje和fkje_dut至少会返回一个，如果两者只返回一个，请以返回的为罚款金额，如果两者同时返回，请以fkje_dut为罚款金额
@property (nonatomic, copy) NSString *fkje_dut;
@property (nonatomic, copy) NSString *gxsj;           // 违法记录更新时间，时间格式”yyyy-MM-dd HH:mm:ss”
@property (nonatomic, copy) NSString *hphm;           // 号牌号码
@property (nonatomic, copy) NSString *hpzl;           // 号牌种类
@property (nonatomic, copy) NSString *jdsbh;          // 决定书编号，已处理的违章才会返回决定书编号
@property (nonatomic, copy) NSString *jkbj;           // 交款标记，只会返回”已交款”和”未交款”两个结果
@property (nonatomic, copy) NSString *jkrq;           // 交款日期，jkbj为”已交款”的会返回交款日期，时间格式”yyyy-MM-dd HH:mm:ss”
@property (nonatomic, copy) NSString *lrsj;           // 违法信息录入时间，时间格式”yyyy-MM-dd HH:mm:ss”
@property (nonatomic, copy) NSString *wfdz;           // 违法地址
@property (nonatomic, copy) NSString *wfjfs;          // 违法记分数
@property (nonatomic, copy) NSString *wfnr;           // 违法内容
@property (nonatomic, copy) NSString *wfsj;           // 违法时间，时间格式”yyyy-MM-dd HH:mm:ss”
@property (nonatomic, copy) NSString *wfxw;           // 违法行为
@property (nonatomic, copy) NSString *xh;             // 序号
@property (nonatomic, copy) NSString *zdbj;           // 转递标记

@end


/**
 违章信息Model
 */
@interface CarIllegalInfoModel : CTXBaseModel

// 车的信息
@property (nonatomic, retain) BoundCarModel *jdcjbxx;// 车的信息
// 违章信息总述
@property (nonatomic, retain) ViolationSummaryModel *jdcwfxxtj;
// 机动车违法信息列表，如果该机动车无违法记录，返回空数组
@property (nonatomic, retain) NSArray<ViolationInfoModel *> *jdcwfxxList;

// 已交款
@property (nonatomic, retain) NSMutableArray<ViolationInfoModel *> *alreadyPaid;
// 未交款
@property (nonatomic, retain) NSMutableArray<ViolationInfoModel *> *notPaid;

@end
