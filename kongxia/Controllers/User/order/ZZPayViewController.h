//
//  ZZPayViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger,PayType) {
    PayTypeOrder=0,       // 支付订单
    PayTypeMMD,           // 么么答支付
    PayTypeDashang,       // 打赏
    PayTypeTask,          // 发布线下任务预付金
    PayTypeTaskSum,       // 发布线下任务全款
    PayTypeRents,         // 出租费
    PayTypePrepayTonggao, // 通告付支付发布服务费
    payTypePayTonggao,     // 通告付尾款
};

#import "ZZViewController.h"
#import "ZZOrder.h"
@class ZZMMDModel;
/**
 *  支付方式
 */
@interface ZZPayViewController : ZZViewController

@property (copy, nonatomic) void(^didPay)(void);
@property (strong, nonatomic) ZZOrder *order;
@property (strong, nonatomic) ZZMMDModel *model;
@property (assign, nonatomic) double price;
@property (assign, nonatomic) PayType type;
@property (assign, nonatomic) NSInteger popIndex;//1、个人页 2、查看视频 3、聊天
@property (nonatomic, strong) NSString *pId;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger validate_count;
@property (nonatomic, strong) NSMutableArray *values;

@property (nonatomic, copy) NSArray *tonggaoSelectIDs;
@property (nonatomic, copy) NSString *tonggaoAgencyPrice;

@property (nonatomic, copy) void (^backBlock)(void);

- (void)paymentRecall:(NSDictionary *)paymentData;  //没获取到支付回调时，查询支付状态后调用

@end

@interface PaymentFooterView: UIView

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIButton *showDetailsBtn;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *subPriceLabel;

- (instancetype)initWithPrice:(double)price payType:(PayType)payType;

@end

@interface PaymentDetailsView: UIView

@property (assign, nonatomic) PayType type;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *hideBtn;

@property (nonatomic, strong) UILabel *price1DesLabel;

@property (nonatomic, strong) UILabel *price1Label;

@property (nonatomic, strong) UILabel *price2DesLabel;

@property (nonatomic, strong) UILabel *price2Label;

+ (void)showWithTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency bottom:(CGFloat)bottom payType:(PayType)payType;

+ (void)showWithTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency counts:(NSInteger)counts bottom:(CGFloat)bottom payType:(PayType)payType;

- (instancetype)initWithFrame:(CGRect)frame bottom:(CGFloat)bottom payType:(PayType)payType;

- (instancetype)initWithFrame:(CGRect)frame bottom:(CGFloat)bottom counts:(NSInteger)counts payType:(PayType)payType;

- (instancetype)initWithFrame:(CGRect)frame desLocation:(CGFloat)desLocation;

- (void)setTaskTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency;

- (void)show;

@end
