//
//  ZZSystemConfigModel.m
//  zuwome
//
//  Created by angBiu on 2016/11/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSystemConfigModel.h"

@implementation ZZSystemConfigSkModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZSystemYjConfigModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZSystemMMDConfigModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZDisableModuleModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZQchat

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZBannersModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZPdModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZTipsModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZCancelReasonModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZSkillCatalogModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ZZPriceConfigModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation SayhiConfigModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ZZUserInfomationDetailModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ZZUserInfomationModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ZZSystemConfigModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _min_bankcard_transfer = 50;
        _max_bankcard_transfer = 2000;
    }
    return self;
}

- (NSString *)getNameOfSkillByClassify:(NSInteger)classify {
    NSString *name = @"";
    for (ZZSkillCatalogModel *skill in self.skill_catalog) {
        if (classify == skill.classify) {
            name = skill.name;
            break;
        }
    }
    return name;
}

- (BOOL)isPriceConfigExit {
    return (_priceConfig && !isNullString(_priceConfig.per_unit_cost_card));
}

// 获取连麦等价格配置
- (void)fetchPriceConfig:(BOOL)needRetry
        inViewController:(UIViewController *)viewController
                   block:(void (^)(BOOL))block {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/room/%@/user_config",[ZZUserHelper shareInstance].loginer.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZPriceConfigModel* priceModel = [[ZZPriceConfigModel alloc] initWithDictionary:data error:nil];
            self.priceConfig = priceModel;
            if (block) {
                block(YES);
            }
        }
        else {
            if (needRetry) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取价格信息失败" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                
                // 错误重试
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self fetchPriceConfig:needRetry inViewController:viewController block:block];
                }];
                
                // 错误取消
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    if (block) {
                        block(NO);
                    }
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:retryAction];
                [viewController presentViewController:alert animated:YES completion:nil];
            }
            else {
                if (block) {
                    block(NO);
                }
            }
        }
    }];
}

#pragma mark - <#mark Title#>
/**
 *  MARK: 不需要真实头像也可以进行的操作
 */
- (BOOL)canProceedWithoutRealAvatar:(NavigationType)type {
    NSArray *shouldHaveAvatarArray = [ZZUserHelper shareInstance].configModel.disable_module.no_have_real_avatar;
    NSString *key = nil;
    if (type == NavigationTypeWeChat) {
        key = @"add_wechat";
    }
    else if (type == NavigationTypeOrder) {
        key = @"add_order";
    }
    else if (type == NavigationTypeApplyTalent) {
        key = @"release_rent";
    }
    if (!isNullString(key) && [shouldHaveAvatarArray indexOfObject:key] != NSNotFound) {
        return NO;
    }
    return YES;
}

/**
 *  MARK: 不需要人脸识别也可以进行的操作
 */
- (BOOL)canProceedWithoutRealFace:(NavigationType)type {
    NSArray *shouldHaveFaceArray = [ZZUserHelper shareInstance].configModel.disable_module.no_have_face;
    NSString *key = nil;
    if (type == NavigationTypeRent) {
        key = @"release_rent";
    }
    else if (type == NavigationTypeChat) {
        key = @"chat";
    }
    else if (type == NavigationTypeOrder) {
        key = @"chat";
    }
    else if (type == NavigationTypeIDPhoto) {
        key = @"id_photo";
    }
    
    if (!isNullString(key) && [shouldHaveFaceArray indexOfObject:key] != NSNotFound) {
        return NO;
    }
    return YES;
}

#pragma mark - Request
+ (void)fetchSysConfigWithCompleteHandler:(void (^)(BOOL))completeHandler {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/system/config"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZSystemConfigModel* model = [[ZZSystemConfigModel alloc] initWithDictionary:data error:nil];
            //            model.wechat_new = YES;
            model.open_rent_need_pay_module = NO;
            [ZZUserDefaultsHelper setObject:model.wechat forDestKey:@"WeiXinPingJia"];//存储微信评价的差评理由
            [ZZUserHelper shareInstance].configModel = model;
            
            // 下载价格配置信息
            [[ZZUserHelper shareInstance].configModel fetchPriceConfig:NO
                                                      inViewController:nil
                                                                 block:^(BOOL isComplete) {
                if (completeHandler) {
                    completeHandler(YES);
                }
            }];
            return ;
        }
        if (completeHandler) {
            completeHandler(NO);
        }
    }];
}

- (void)setMax_bankcard_transfer:(NSInteger)max_bankcard_transfer {
    if (max_bankcard_transfer == 0) {
        _max_bankcard_transfer = 2000;
    }
    else {
        _max_bankcard_transfer = max_bankcard_transfer;
    }
}

- (void)setMin_bankcard_transfer:(NSInteger)min_bankcard_transfer {
    if (min_bankcard_transfer == 0) {
        _min_bankcard_transfer = 50.0;
    }
    else {
        _min_bankcard_transfer = min_bankcard_transfer;
    }
}

@end
