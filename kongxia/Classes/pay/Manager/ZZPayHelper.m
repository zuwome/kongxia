//
//  ZZPayHelper.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/26.
//  Copyright © 2017年 潘杨. All rights reserved.
//

#import "ZZPayHelper.h"
#import <StoreKit/StoreKit.h>
#import "WBKeyChain.h"
#import "ZZDateHelper.h"
#import "SandBoxHelper.h"
#import "ZZPayManager.h"
static NSString * const receiptKey = @"receipt";//唯一凭证的key
static NSString * const dateKey = @"date_key";//交易时间
static NSString * const userIdKey = @"uid";//用户的idKey
static NSString * const transactionIDKey = @"transactionIdentifier";//交易id
static NSString * const productIdentifierKey = @"productIdentifier";//产品id
static NSString * const payStatekey = @"state";//交易状态


dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_iap_queue;
}

@interface ZZPayHelper ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL goodsRequestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *receipt; //交易成功后拿到的一个64编码字符串

@property (nonatomic, copy) NSString *date; //交易时间

@property (nonatomic, copy) NSString *userId; //交易人

@end

@implementation ZZPayHelper

singleton_implementation(ZZPayHelper)
+(void)startManager {
    [[ZZPayHelper shared] startManager];
}
- (void)startManager { //开启监听
    
    dispatch_async(iap_queue(), ^{
        
        self.goodsRequestFinished = YES;
        self.checkAfterPay = YES;
 
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        /**
         在程序启动时，检测本地是否有订单文件，有的话，去二次验证。
         */
        [self checkIAPFiles];
    });
}

- (void)stopManager{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

#pragma mark 查询

+ (void)requestProductWithId:(NSString *)productId {
    [[ZZPayHelper shared] requestProductWithId:productId];
}

- (void)requestProductWithId:(NSString *)productId {
    
    if (self.goodsRequestFinished) {
        
        if ([SKPaymentQueue canMakePayments]) { //用户允许app内购
         
            if (productId.length) {
                
                NSLog(@"%@商品正在请求中",productId);
                
                self.goodsRequestFinished = NO; //正在请求
                
                NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
                
                NSSet *set = [NSSet setWithArray:product];
                
                SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
                
                productRequest.delegate = self;
                
                [productRequest start];
                
            } else {
                
                NSLog(@"商品为空");
                
                [self filedWithErrorCode:IAP_FILEDCOED_EMPTYGOODS error:@"商品为空" transactionIdentifier:nil];
                
                self.goodsRequestFinished = YES; //完成请求
            }
            
        } else { //没有权限
            
            [self filedWithErrorCode:IAP_FILEDCOED_NORIGHT error:@"没有权限" transactionIdentifier:nil];
            
            self.goodsRequestFinished = YES; //完成请求
        }
        
    } else {
        
        NSLog(@"上次请求还未完成，请稍等");
//           [self filedWithErrorCode:IAP_FILEDCOED_WaitFinish error:@"上次请求还未完成，请稍等"];
    }
}

#pragma mark SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    
    if (product.count == 0) {
        
        NSLog(@"无法获取商品信息，请重试");
        
        [self filedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION error:@"无法获取产品信息，请重试" transactionIdentifier:nil];
        
        self.goodsRequestFinished = YES; //失败，请求完成
        
    } else {
        //发起购买请求
        SKPayment *payment = [SKPayment paymentWithProduct:product[0]];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark SKProductsRequestDelegate 查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self filedWithErrorCode:IAP_FILEDCOED_APPLECODE error:[error localizedDescription] transactionIdentifier:nil];
    self.goodsRequestFinished = YES; //失败，请求完成
}

#pragma Mark 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing://正在交易
                
                break;
                
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self getReceipt]; //获取交易成功后的购买凭证
                [self saveReceiptwithstate:@(transaction.transactionState) date:transaction.transactionDate transactionIdentifier:transaction.transactionIdentifier productIdentifier:transaction.payment.productIdentifier];//存储交易凭证
                
                [self checkIAPFiles];
                
                [self completeTransaction:transaction];
            }
                
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                
                [self failedTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                
                [self restoreTransaction:transaction];
                
                break;
                
            default:
                
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    self.goodsRequestFinished = YES; //成功，请求完成
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"transaction.error.code = %ld", transaction.error.code);
    NSLog(@"transaction error transactionIdentifier = %@", transaction.transactionIdentifier);
    NSLog(@"transaction error = %@", transaction.error);
    if(transaction.error.code != SKErrorPaymentCancelled) {
        
        [self filedWithErrorCode:IAP_FILEDCOED_BUYFILED error:@"购买失败，请重试" transactionIdentifier:transaction.transactionIdentifier];
        
    } else {
        
        [self filedWithErrorCode:IAP_FILEDCOED_USERCANCEL error:@"您已经取消交易" transactionIdentifier:transaction.transactionIdentifier];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    self.goodsRequestFinished = YES; //失败，请求完成
    
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    self.goodsRequestFinished = YES; //恢复购买，请求完成
    
}

#pragma mark 获取交易成功后的购买凭证

- (void)getReceipt {
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    self.receipt = [receiptData base64EncodedStringWithOptions:0];
}


/**
 存储用户的交易凭证到

 @param identifier 用户的交易id
 */
-(void)saveReceiptwithstate:(NSNumber*)state date:(NSDate *)date transactionIdentifier:(NSString *)identifier  productIdentifier:(NSString *)productIdentifier {
    
    self.date = [[ZZDateHelper shareInstance] chindDateFormate:date];

    self.userId = [ZZUserHelper shareInstance].loginerId;
    
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [SandBoxHelper iapReceiptPathWithUserId:self.userId], identifier];
    
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        self.receipt,                           receiptKey,
                        self.date,                              dateKey,
                        self.userId,                            userIdKey,
                        identifier,                         transactionIDKey,
                        productIdentifier,                  productIdentifierKey,
                        state,payStatekey,
                        nil];
    
    NSLog(@"%@",savedPath);
    
    [dic writeToFile:savedPath atomically:YES];
}

#pragma mark 将存储到本地的IAP文件发送给服务端 验证receipt失败,App启动后再次验证
- (void)checkIAPFiles{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[SandBoxHelper checkIapReceiptPathWithUserId:[ZZUserHelper shareInstance].loginerId] error:&error];
    
    if (error == nil) {
        
        for (NSString *name in cacheFileNameArray) {
            
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [SandBoxHelper checkIapReceiptPathWithUserId:[ZZUserHelper shareInstance].loginerId], name];
                
                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }
    
        
    } else {
        
        NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}

-(void)sendAppStoreRequestBuyPlist:(NSString *)plistPath {
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [dic objectForKey:receiptKey],          receiptKey,
                                   [dic objectForKey:dateKey],             dateKey,
                                   [dic objectForKey:userIdKey],           userIdKey,
                                    [dic objectForKey:transactionIDKey],           transactionIDKey,
                                   [dic objectForKey:payStatekey],           payStatekey,
                                   [dic objectForKey:productIdentifierKey],           productIdentifierKey,

                                   nil];
    
    if(params[receiptKey]){
        
            [ZZPayManager uploadToServerData:params completionCall:^(id payData) {
                //写在这里是测试用的 正常是在服务器返回接口的时候调用
                if (!payData[@"error"]) {
                    [ZZPayHelper removeReceiptWithTransactionID:payData[transactionIDKey]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ZZHUD dismiss];
                    });
                    if ([self.delegate respondsToSelector:@selector(paySuccessWithtransactionInfo:)]) {
                        [self.delegate paySuccessWithtransactionInfo:payData];//发送
                    }
                }
            }];
     
    } else {//凭证无效
        [self filedWithErrorCode:IAP_FILEDCOED_INVALID error:@"无法获取凭证" transactionIdentifier:nil];
    }
}

+ (void)removeReceiptWithTransactionID:(NSString *)transactionID {
    if (transactionID) {
        [[ZZPayHelper shared] removeReceiptWithTransactionID:transactionID];
    }
}

//验证成功就从plist中移除凭证
- (void)removeReceiptWithTransactionID:(NSString *)transactionID{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [SandBoxHelper checkIapReceiptPathWithUserId:[ZZUserHelper shareInstance].loginerId], transactionID];
    if ([fileManager fileExistsAtPath:savedPath]) {
        [fileManager removeItemAtPath:savedPath error:nil];
    }
}


#pragma mark 错误信息反馈
- (void)filedWithErrorCode:(IAPFiledCode)code error:(NSString *)error transactionIdentifier:(NSString *)transactionIdentifier; {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filedWithErrorCode:andError: transactionIdentifier:)]) {
        [self.delegate filedWithErrorCode:code andError:error transactionIdentifier:transactionIdentifier];
    }
}

@end


