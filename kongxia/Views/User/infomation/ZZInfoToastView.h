//
//  ZZInfoToastView.h
//  zuwome
//
//  Created by qiming xiao on 2019/2/14.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ToastType) {
    ToastRealAvatarNotMatch = 0, // 真实头像匹配失败
    ToastRealAvatarFail,         // 真实头像上传失败
    ToastRealAvatarFailInPerfect, // 真实头像上传失败在完善资料页
    ToastRealAvatarReviewFail,   // 人工审核失败
    ToastRealAvatarNotFound,     // 没有真实头像
    
    ToastRealNameAuthenticationFailed, // 实名认证失败
    
    ToastTaskConfirmChoose,      // 任务确认选取用户
    ToastTaskConfirmSignUp,      // 再次确认报名
    ToastTaskConfirmCloseSignUp, // 确认结束报名
    ToastTaskCancel,             // 确认取消订单
    ToastTaskCancelPost,         // 确认取消发布
    ToastTaskConfirmPost,        // 确认报名
    
    ToastTaskActivityCancel,      // 活动取消
    ToastActivityPublishFailDueToNotShow, // 发布活动失败,原因: 隐身中
    ToastActivityPublishFailDueToNotRent, // 发布活动失败,原因: 未出租
    ToastActivityPublishFailDueToInReview, // 发布活动失败,原因: 审核中
    
    ToastPayTonggao,            // 新-通告去付尾款
    ToastTonggaoCancelStyle1,   // 新-通告取消
    ToastTonggaoCancelStyle2,   // 新-通告取消 (超过30分钟并且无人报名)
    ToastPayTonggaoCancel,      // 新-通告选人付钱取消
    
    ToastRemindRent,            // 成为达人提醒
    ToastRemindWechat,          // 填写微信提醒
    
    
    ToastUnknow, 
};

@class ZZInfoToastView;
@class ZZTask;
@protocol ZZInfoToastViewDelegate <NSObject>

- (void)toastView:(ZZInfoToastView *)toastView leftActionWithType:(ToastType)toastType;

- (void)toastView:(ZZInfoToastView *)toastView rightActionWithType:(ToastType)toastType;

@end

@interface ZZInfoToastView : UIView

@property (nonatomic,   weak) id<ZZInfoToastViewDelegate> delegate;

@property (nonatomic, assign) ToastType toastType;

+ (instancetype)showWithType:(ToastType)type;

+ (instancetype)showOnceWithType:(ToastType)type action:(void(^)(NSInteger actionIndex, ToastType type))action;

/**
 *  显示toastView
 *  actionIndex 0:leftAction 1:rightAction
 */
+ (instancetype)showWithType:(ToastType)type action:(void(^)(NSInteger actionIndex, ToastType type))action;

+ (instancetype)showWithType:(ToastType)type keyStr:(NSString *)keyStr action:(void(^)(NSInteger actionIndex, ToastType type))action;

+ (instancetype)showWithType:(ToastType)type task:(ZZTask *)task action:(void(^)(NSInteger actionIndex, ToastType type))action;

+ (instancetype)showWithType:(ToastType)type title:(NSString *)title subTitle:(NSString *)subtitle action:(void(^)(NSInteger actionIndex, ToastType type))action;

@end


@interface ZZToast1View: UIView

@property (nonatomic, copy) NSString *keyStr;

@property (nonatomic, assign) ToastType toastType;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *descriptLabel;

@property (nonatomic, strong) UIButton *leftActionButton;

@property (nonatomic, strong) UIButton *rightActionButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) ZZTask *task;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

- (void)configToastInfoWithType:(ToastType)type;

- (void)configToastInfoWithType:(ToastType)type task:(ZZTask *)task;

@end

NS_ASSUME_NONNULL_END
