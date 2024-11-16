//
//  UMRiskManager.h
//  UMRiskSDK
//
//  Created by yanke on 2022/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UYuMaoManager : NSObject

+ (NSString *)version;
+ (void)logEnable:(BOOL)enable;

+ (void)ym1Off;
+ (void)ym2Off;
+ (void)ym3Off;

@end

NS_ASSUME_NONNULL_END
