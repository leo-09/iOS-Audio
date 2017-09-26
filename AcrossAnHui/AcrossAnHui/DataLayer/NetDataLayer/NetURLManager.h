//
//  NetURLManager.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

// 所有网络请求的路径名

#ifndef NetURLManager_h
#define NetURLManager_h

// 上传头像
#define UploadHeaderImageUrl    @"http://file.ah122.cn/file-platform/appservice/upload"

// 生成短信验证码接口
#define GenerateSMSCodeUrl      @"http://userint.ah122.cn/user-platform/service/user/captchaSend"

// 正式环境服务器
#define NewsHost                @"http://misi.ah122.cn/news/service/cxah3_0/"                   // 韩森
#define CarCheckHost            @"http://user.ahjtxx.com/"                                      // 王博文

#define MainHost                @"http://app.ah122.cn/"                                         // 俞刚
#define MainAppHost             @"http://app.ah122.cn/app3_0-webservice/app/"                   // 俞刚
#define UserHost                @"http://userint.ah122.cn/user-platform/service/appuser/"       // 王平
#define CarInspectHost          @"http://chejianapp.ah122.cn/keli_client/web"                   // 俞刚、耿香宝
#define ParkingHost             @"http://parkint.ah122.cn/parking/service/"                     // 韩森

// 测试环境服务器
//#define MainHost                @"http://192.168.23.50/"
//#define MainAppHost             @"http://192.168.23.50:8810/app3_0-webservice/app/"
//#define UserHost                @"http://192.168.23.50:8081/user-platform/service/appuser/"
//#define CarInspectHost          @"http://192.168.23.50:2222/keli_client/web"
//#define ParkingHost             @"http://192.168.23.50:8084/parking/service/"


// ---------------------- MainHost ----------------------
// 路况图片上传接口
#define RoadPic_Url                 MainHost"traffic/appUpload"
// 删除路况图片接口
#define DeleteRoadPic_Url           MainHost"traffic/delAppFile"
// 多图上传
#define MoreImage_UPLOAD_URL        MainHost"sys/upload/fileUploads"
// 分享链接
#define CarFriend_SHARE_Url         MainHost"template/findShareCard?id="

// ---------------------- NewsHost ----------------------
// 获取轮播图接口
#define AdvList_Url                 NewsHost"getAdvListById"
// 获取栏目资讯列表接口(首页)
#define ModularNews_Url             NewsHost"getModularNews"
// 获取栏目资讯列表接口(服务)/模糊搜索）
#define NewsList_Url                NewsHost"getNewsList"
// 资讯名称（模糊搜索）
#define MorenewsList_Url            NewsHost"getNewsList"
// 获取热门搜索关键词接口
#define getHotkeywords_URl          NewsHost"getHotkeywords"

// ---------------------- UserHost ----------------------
// 注册用户接口
#define Register_Url                UserHost"register"
// 用户登录接口
#define Login_Url                   UserHost"userLogin"
// 获取用户信息接口
#define UserInFo_Url                UserHost"findById"
// 验证票据接口
#define ValidateToken_Url           UserHost"validateToken"
// 修改用户手机号接口
#define UpdatePhone_Url             UserHost"updatePhone"
// 修改用户信息接口
#define UpdateUser_Url              UserHost"updateUser"
// 修改用户密码接口
#define UpdatePassword              UserHost"updatePassword"
// 忘记密码
#define forgetPassword_Url          UserHost"forgetPassword"

// ---------------------- MainAppHost ----------------------
// 油价查询
#define OilPrice_Url                MainAppHost"getOilPriceList"
// 天气接口
#define Weather_Url                 MainAppHost"getWeather"
// 活动查询
#define Activity_Url                MainAppHost"getActiviteList"
// 帮助中心接口
#define Help_Url                    MainAppHost"getHelpList"
// 快处中心接口
#define FasterCenter_URL            MainAppHost"getAllFastDealInfo"
// 违章查询处理点接口
#define WeiZhangStation_URL         MainAppHost"getAllIllegalDisposalSiteInfo"
// 实时路况事件列表查询接口
#define TrafficList_Url             MainAppHost"getNewTrafficList"
#define RoadRecode_Url              MainAppHost"getTrafficCount"
// 路况信息接口
#define RoadInformation_Url         MainAppHost"addTrafficUp"
// 路况反馈接口
#define addTrafficCount_URL         MainAppHost"addTrafficCount"
// 违章缴费
#define JiaoFei_Url                 MainAppHost"queryBill"
// 意见反馈接口
#define Opinion_Url                 MainAppHost"addFeedBack"
// 缴费订单接口
#define JiaoFeiOrder_Url            MainAppHost"getOrderInfo"
// 删除订单接口
#define DeleteJiaofei_Url           MainAppHost"delIllegal"
// 银联接口
#define TN_Url                      MainAppHost"illegalPay"
// 绑定车辆列表接口
#define BindCarList_Url             MainAppHost"getBoundCarList"
// 默认车辆接口
#define MoRenCar_url                MainAppHost"setDefaultCar"
// 解绑车辆接口
#define  JieBindCar_Url             MainAppHost"unbindCar"
// 机动车违章查询接口
#define WZCX_Url                    MainAppHost"queryJdcwfxx"
// 绑定 编辑车辆
#define BindCar_URl                 MainAppHost"bindCar"
#define BandCarTypeList             MainAppHost"getCarType"
// 增加定制路况接口
#define CustomRoad_URL              MainAppHost"addCustomRoad"
// 获取定制路况接口
#define GetCusTomRoad_URL           MainAppHost"getUserCustomRoadList"
// 删除定制路况
#define DeleteCusTomroad_URL        MainAppHost"delCustomRoad"
// 编辑定制路况
#define EditeCusTomRoad_URL         MainAppHost"updateCustomRoad"
// 帖子列表接口(个人中心)
#define Topic_Url                   MainAppHost"carfriendrecord/getmyrecommendcardlist"
// 获取我的评论和收藏列表接口
#define CommendAndCollect_Url       MainAppHost"carfriendrecord/getusercommentlist"
// 删除我的评论或者话题帖子接口
#define DelectComment_Url           MainAppHost"carfriendrecord/deleteusercommenorcardtlist"
// 高速路况
#define HighRoad_Url                MainAppHost"getHighSpeed"
// 路况标签
#define RoadLabel_Url               MainAppHost"getTrafficLabel"
// 获取事件订阅
#define GetEvent_Url                MainAppHost"getEvent"
// 获取交通事件详情
#define TrafficDetailInfoById       MainAppHost"getNewTrafficDetailInfoById"
// 删除我的评论或者话题帖子接口
#define DeleteCommenorcardtlist_Url MainAppHost"carfriendrecord/deleteusercommenorcardtlist"
// 获取事件订阅
#define getEvent_url                MainAppHost"getEvent"
// 事件订阅
#define addEvent_Url                MainAppHost"addEvent"
// 阅读消息
#define getMsgCount_Url             MainAppHost"getMsgCount"
// 删除收藏
#define DelectCollect_Url           MainAppHost"carfriendrecord/operatinghourse"
// 获取最新消息数量
#define MsgCount_Url                MainAppHost"getMsgCount"
// 消息列表
#define MsgList_URl                 MainAppHost"getMsgList"
// 消息内容
#define clickRead_URl               MainAppHost"clickRead"
// 获取分类列表接口
#define getClassifyList_URl         MainAppHost"carfriendrecord/getClassifyList"
// 获取推送开关
#define getJpushState_URl           MainAppHost"getJpushState"
// 关闭开启推送
#define updateJpushState_Url        MainAppHost"updateJpushState"
// 绑定极光
#define Jpush_BindingUrl            MainAppHost"jpushBinding"

// 获取随手拍标签
#define Get_TakePhoto_Url           MainAppHost"carfriendrecord/getclassfifytagnameNew"    // carfriendrecord/getclassfifytagname
// 获取收藏 路况 话题 等个获取最新消息数量
#define Getallkindsofcount_Url      MainAppHost"carfriendrecord/getallkindsofcountNew"
// 提交卖车信息
#define CarSellInfo_Url             MainAppHost"saveAppSellInfo"
// 卖车记录
#define APPSellCarList_Url          MainAppHost"getAPPSellCarList"
// 发布帖子话题接口
#define CarFriend_CommitMesg_URL    MainAppHost"carfriendrecord/publishpost"
// 帖子列表
#define Tiezi_List_Url              MainAppHost"carfriendrecord/getislaudrecommendcardlist"
// 公告列表
#define Notice_List_Url             MainAppHost"carfriendrecord/getannouncementcardlist"
// 帖子详情接口
#define Tiezi_Detail_Url            MainAppHost"carfriendrecord/getmycarddetail"
// 获取详情界面更多评论的信息
#define Tiezi_Detail_GetMoreComment     MainAppHost"carfriendrecord/getmorecardlauduserphoto"
// 点赞和取消点赞接口
#define Tiezi_Good_Cancle_Comment_Url   MainAppHost"carfriendrecord/operatingpointlaud"
// 发布话题评论接口
#define Tiezi_Detail_Commit_Url     MainAppHost"carfriendrecord/publishreply"
// 获取评论列表信息
#define Tiezi_Commont_Msg_Url       MainAppHost"carfriendrecord/getmorecardcomment"
// 获取分类列表信息
#define Tiezi_Get_Header_Url        MainAppHost"carfriendrecord/getClassifyList"
// 收藏和取消收藏
#define Collec_Cancle_Favrite       MainAppHost"carfriendrecord/operatinghourse"
// 获取更多点赞信息
#define CarFriend_Get_Comment_Url   MainAppHost"carfriendrecord/getmorecardlauduserphoto"

// 获取奖品列表信息
#define Award_URL                   MainAppHost"getRewardList"
// 领取奖品
#define ReceivePrizes               MainAppHost"receivePrizes"
// 用户中心个人数据tip
#define GetUserTip_URL              MainAppHost"getUserTip"
// 用户签到
#define User_Sign_Url               MainAppHost"userSign"
// 签到信息
#define User_Sign_ContentInfo       MainAppHost"signInfo"
// 奖品列表获取  -- 得到参与人数
#define User_GetCount               MainAppHost"getGoodsList"
// 获取滚动信息列表
#define User_LUckList               MainAppHost"getWinRewardList"
// 开始抽奖
#define User_StartLuck              MainAppHost"drawReward"
// 分享
#define User_ShareWay               MainAppHost"share"

// ---------------------- CarCheckHost ----------------------
// 车牌号车架号年检信息查询
#define CarSixYear_URl              CarCheckHost@"userApi/njwzcx"
// 车牌号车架号免检信息查询
#define CarMianJian_URl             CarCheckHost@"userApi/mjwzcx"
// 验证年检接口
#define CODING_YEAR_URL             CarCheckHost@"userApi/njwzcx"

// ---------------------- CarInspectHost ----------------------
// 查询预约时间段
#define YYSJ_URl                    CarInspectHost"/station/subscribeTime"
// 条件搜索车检站列表
#define SSCJZLIST_URL               CarInspectHost"/station/searchSTByKeyword"
// 查询车检站图片列表
#define CXCJZTP_URL                 CarInspectHost"/station/imgList"
// 查看车检站列表
#define LookUpStation_Url           CarInspectHost"/station/list"
// 选择车辆类型
#define SELECT_CAR_MODEL_URL        CarInspectHost"/station/queryCarTypeList"
// 保存预约记录接口
#define SAVE_RECOARD_URL            CarInspectHost"/station/saveSubscribe"
// 查询预约记录接口
#define CXYY_Recoard_Url            CarInspectHost"/station/subscribeList"
// 查询评价的信息
#define LookUpComment_Info_Url      CarInspectHost"/station/evaluateList"
// 查询车检站详情页面Url
#define LookUp_StationDetail_Url    CarInspectHost"/station/detail"
// 取消预约记录接口
#define Cancle_Bussinessid_Url      CarInspectHost"/station/cancelSubscribe"
// 上传文件接口
#define UpLoadImage_Url             CarInspectHost"/station/upload"
// 保存评价记录接口
#define Save_Comment_Url            CarInspectHost"/station/saveEvaluate"
// 申请退款接口
#define ApalyTK_Url                 CarInspectHost"/station/applyRefund"
// 查看物流
#define ChaWuLiu_Url                CarInspectHost"/station/querySFBno"
// 查询评价记录总数
#define evaluateCount_Url           CarInspectHost"/station/evaluateCount"

// 微信支付
#define wxPay_Url                   CarInspectHost"/wxpay/wxPayForClient"
// 支付宝支付
#define zfbPay_Url                  CarInspectHost"/alipay/appPay"
// 银联支付
#define ylPay_url                   CarInspectHost"/union/anon/toUnionPayForApp"
// 获取已支付信息详情
#define Order_Detail_Url            CarInspectHost"/station/orderDetail"

// 车检代办新增接口
// 最近车检站
#define NearByStation_Url           CarInspectHost"/station/daiban/list"
// 司机轨迹
#define GetDriverPosition_Url       CarInspectHost"/station/daiban/getDriverPosition"
// 订单跟踪
#define GetOrderRecord_Url          CarInspectHost"/station/daiban/getOrderRecord"
// 代办订单详情
#define DBOrderDetail_Url           CarInspectHost"/station/daiban/getOrderDetail"
// 代办确认订单
#define DBSrueOrder_Url             CarInspectHost"/station/sureOrder"
// 代办记录
#define DBRecordList_Url            CarInspectHost"/station/daiban/getDaiBanRecord"
// 代办申请退款
#define DBApplyRefund_Url           CarInspectHost"/station/applyDbRefund"
// 代办申请退款原因
#define DBReturnMoneyReson_Url      CarInspectHost"/station/getReturnMoneyReson"
// 保存代办评价
#define DBOrderComment              CarInspectHost"/station/saveOrderComment"
// 车检站时间(取车时间)
#define DBgetStationTimeList_Url    CarInspectHost"/station/daiban/getStationTimeList"
// 优惠码接口
#define DBCouponCode_Url            CarInspectHost"/station/daiban/isCouponCode"
// 车检代办须知
#define DBNotiy_Url                 @"http://ah122.cn/zhuanti/cjdbxz/"
// 查询代办取消原因
#define FindCancelResonList_Url     CarInspectHost"/station/findCancelResonList"
// 代办申请退款原因
#define GetReturnMoneyReson_Url     CarInspectHost"/station/getReturnMoneyReson"
// 车检代办重新下单
#define SaveOrderAgain_Url          CarInspectHost"/station/saveOrderAgain"

// ---------------------- 停车新增接口 ----------------------
// 查询用户绑定停车服务车辆
#define SelectCarParkService_URl    ParkingHost"client/parkservice/selectCarParkService"
// 绑定停车服务
#define AddCarParkService_Url       ParkingHost"client/parkservice/addCarParkService"
// 删除用户绑定停车服务车辆
#define DeleteCarParkService_Url    ParkingHost"client/parkservice/deleteCarParkService"

// 停车服务首页数据
#define Parking_Home_URL            ParkingHost"client/site/selectPackinfoByCard"
// 查询所有路段信息
#define Select_All_Site_List        ParkingHost"client/site/selectAllSiteList"
// 查询停车详情
#define Get_Site_By_Id              ParkingHost"client/site/getSiteById"
// 查询绑定车辆停车记录
#define SelectParkingRecords_Url    ParkingHost"client/car/selectParkingRecords"
// 查询停车记录详情
#define SelectParkingDetail_Url     ParkingHost"client/car/selectParkingDetail"
// 查询附近列表页
#define SelectSiteList_URL          ParkingHost"client/site/selectSiteList"
// 查询所有区域及对应的路段分组
#define SelectAreaGroupList_URL     ParkingHost"client/area/selectAreaGroupList"
// 补缴欠费
#define ImmediatePaymentFinish_URL  ParkingHost"/client/car/immediatePaymentFinish"

// 用户余额查询
#define SelectBalance_URL           ParkingHost"client/user/selectBalance"
// 自动付款状态修改
#define UpdatePayType_URL           ParkingHost"client/user/updatePayType"
// 查询发票申请余额
#define SeleteTicketSendMoney_URL   ParkingHost"client/ticket/seleteTicketSendMoney"
// 添加发票记录
#define AddTicketSend_URL           ParkingHost"client/ticket/addTicketSend"
// 充值记录查询
#define SelectRecharge_URL          ParkingHost"client/recharge/selectRecharge"
// 查询申请发票记录
#define SelectTicketSend_URL        ParkingHost"client/ticket/selectTicketSend"
// 删除发票记录
#define DeleteTicketSend_URL        ParkingHost"client/ticket/deleteTicketSend"
// 通知收费管理员收费
#define PushToOperator_URL          ParkingHost"client/user/pushToOperator"
// 欠费金额查询
#define SelectOdue_URL              ParkingHost"client/recharge/selectOdue"
// 消费记录查询
#define CostRecords_URL             ParkingHost"client/recharge/costRecords"

// 支付宝APP支付
#define Parking_AppPay_URL          ParkingHost"web/alipay/appPay"
// 微信APP支付
#define Parking_WxPayForAPP_URL     ParkingHost"web/wxpay/wxPayForAPP"

#endif /* NetURLManager_h */
