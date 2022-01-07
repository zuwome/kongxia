//
//  ZZPayHelper.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/26.
//  Copyright © 2017年 潘杨. All rights reserved.
//内购支付

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IAPFiledCode) {
    /**
     *  苹果返回错误信息
     */
    IAP_FILEDCOED_APPLECODE = 0,
    
    /**
     *  用户禁止应用内付费购买
     */
    IAP_FILEDCOED_NORIGHT = 1,
    
    /**
     *  商品为空
     */
    IAP_FILEDCOED_EMPTYGOODS = 2,
    /**
     *  无法获取产品信息，请重试
     */
    IAP_FILEDCOED_CANNOTGETINFORMATION = 3,
    /**
     *  购买失败，请重试
     */
    IAP_FILEDCOED_BUYFILED = 4,
    /**
     *  用户取消交易
     */
    IAP_FILEDCOED_USERCANCEL = 5,
    /**
     *  无效的凭证
     */
    IAP_FILEDCOED_INVALID = 6,
    /**
     * 上次请求还未完成
     */
    IAP_FILEDCOED_WaitFinish = 7,
    
};
@protocol ZZPayHelperDelegate <NSObject>
//支付失败状态码
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error transactionIdentifier:(NSString *)transactionIdentifier;
//支付成功
- (void)paySuccessWithtransactionInfo:(NSDictionary *) infoDic;
@end

@interface ZZPayHelper : NSObject
singleton_interface(ZZPayHelper)
@property (nonatomic, weak)id<ZZPayHelperDelegate>delegate;
/**
 *  购买完后是否在iOS端向苹果服务器验证一次,默认为YES
 */
@property(nonatomic)BOOL checkAfterPay;
/**
 启动内购工具
 */
+ (void)startManager;

/**
 结束内购工具
 */
- (void)stopManager;

/**
 请求内购商品列表
 */
+ (void)requestProductWithId:(NSString *)productId;

/**
 上传到我们自己的服务器成功后删除当前的产品id

 @param proID 产品id
 */
+ (void)removeReceiptWithTransactionID:(NSString *)transactionID;
@end
