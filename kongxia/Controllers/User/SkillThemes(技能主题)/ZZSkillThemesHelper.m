//
//  ZZSkillThemesHelper.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillThemesHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZRequest.h"
#import "ZZUser.h"

static id _instance = nil;

@interface ZZSkillThemesHelper ()

@property (nonatomic, strong) NSDictionary *scheduleDict;   //档期对照表

@end

@implementation ZZSkillThemesHelper

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZZSkillThemesHelper alloc] init];
    });
    return _instance;
}

- (void)resetUpdateSign {
    self.tagUpdate = NO;
    self.introduceUpdate = NO;
    self.photoUpdate = NO;
    self.scheduleUpdate = NO;
}

- (NSDictionary *)scheduleDict {
    if (nil == _scheduleDict) {
        _scheduleDict = @{@"1":@"上午",
                          @"2":@"下午",
                          @"3":@"晚上",
                          @"4":@"深夜",
                          @"5":@"上午",
                          @"6":@"下午",
                          @"7":@"晚上",
                          @"8":@"深夜",
                          @"10":@"上午",
                          @"11":@"下午",
                          @"12":@"晚上",
                          };
    }
    return _scheduleDict;
}

- (id)scheduleConvertForKey:(id)key {
    return [self.scheduleDict objectForKey:key] ? [self.scheduleDict objectForKey:key] : @"";
}

+ (void)queryCameraAuthorization:(void (^)(BOOL))completion {
    __block BOOL isAuth = NO;
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (cameraAuthStatus) {
        case AVAuthorizationStatusNotDetermined: {  //第一次权限访问
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                isAuth = granted == YES ? YES : NO;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        } break;
        case AVAuthorizationStatusRestricted:       //不能授权
        case AVAuthorizationStatusDenied: {         //拒绝授权
            isAuth = NO;
        } break;
        case AVAuthorizationStatusAuthorized: {     //通过授权
            isAuth = YES;
        } break;
        default: break;
    }
    
    if (isAuth) {
        completion(YES);
    } else {
        [ZZSkillThemesHelper alertCameraAuthQuery];
        completion(NO);
    }
}

+ (void)alertCameraAuthQuery {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开启相机权限" message:@"在“设置-空虾”中开启相机就可以使用本功能哦~" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }];
    [alert addAction:settingAction];
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 出租接口管理
- (void)getSkillsCatalog:(requestCallback)next {  //获取用户已添加主题
    [ZZRequest method:@"GET" path:@"/api/skills/get_skill" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

- (void)getSkillsCatalogList:(requestCallback)next {  //获取系统主题
    NSString *path = [ZZUserHelper shareInstance].isLogin ? @"/api/skills/cataloglist" : @"/skills/cataloglist";
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

- (void)getTagsByCatalogId:(NSString *)catalogId next:(requestCallback)next {   //获取主题类别下的标签
    NSString *path = [NSString stringWithFormat:@"/api/skills/catalog_tags/%@",catalogId];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  出租技能添加
 *  @param  name
 *  @param  content
 *  @param  pid     默认主题，自定义传空
 *  @param  photo   url1,url2 逗号隔开,全路径，包括域名
 *  @param  time    工作日 上午1，下午2，晚上3，深夜4
                    节假日 上午5，下午6，晚上7，深夜8
 *  @param  price
 *  @param  addType "add" :添加,”apply“:申请    非达人用apply, 达人用add
 */
- (void)addSkill:(NSDictionary *)params next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/skills/add" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  获取主题详情
 */
- (void)getSkillById:(NSString *)_id next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/skills/getbyid/%@",_id];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  删除主题
 */
- (void)deleteSkillById:(NSString *)_id next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/skills/delete/%@",_id];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  编辑主题
 *  @param  price
 *  @param  content 未修改的话不用传，传了要重新审核
 *  @param  photo   url1,url2 逗号隔开,全路径，包括域名,未修改的话不用传，传了要重新审核
 *  @param  time    工作日 上午1，下午2，晚上3，深夜4
                    节假日 上午5，下午6，晚上7，深夜8
 */
- (void)editSkillById:(NSString *)_id params:(NSDictionary *)params next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/skills/edit/%@",_id];
    [ZZRequest method:@"POST" path:path params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  自我介绍示例
 */
- (void)getBioDemo:(requestCallback)next {
    NSString *path = @"/api/bio_demo/getone";
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  获取系统主题的介绍示例
 */
- (void)getSkillDemoBySid:(NSString *)sid next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/skills/sign_demo_getone/%@",sid];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  获取系统主题的图片示例
 */
- (void)getPhotoDemoListBySid:(NSString *)sid next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/skills/photo_demo_list/%@",sid];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

/**
 *  如何填写技能文字介绍
 */
- (void)howToWriteSkillDetail:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/skills/how_to_writedetail" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)fetchSkillByID:(NSString *)skillID next:(requestCallback)next {
    [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            ZZUser *user = [ZZUser yy_modelWithJSON:data];;
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            
            __block ZZTopic *currentTopic = nil;
            [user.rent.topics enumerateObjectsUsingBlock:^(ZZTopic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZZSkill *skill = obj.skills.firstObject;
                if ([skill.id isEqualToString:skillID]) {
                    currentTopic = obj;
                    *stop = YES;
                }
            }];
            
            if (next) {
                next(nil, currentTopic, nil);
            }
        }
    }];
//    [ZZRequest method:@"GET" path:@"/api/skill/findByIdToSkill" params:@{@"sid": skillID} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)getSkillsCustomService:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/get/skills/extends" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

- (void)requestAPriceIncrease:(requestCallback)next {
    NSString *path = @"/api/skills/apply";
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.message];
        else next(error, data, task);
    }];
}

@end
