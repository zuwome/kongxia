//
//  ZZSkillThemesHelper.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZSkillThemesHelper : NSObject

//技能更新标识，表示是否修改过
@property (nonatomic, assign) BOOL introduceUpdate;
@property (nonatomic, assign) BOOL tagUpdate;
@property (nonatomic, assign) BOOL photoUpdate;
@property (nonatomic, assign) BOOL scheduleUpdate;

+ (instancetype)shareInstance;

//重置技能更新标识
- (void)resetUpdateSign;

//档期对照转换
- (id)scheduleConvertForKey:(id)key;
//请求相机权限
+ (void)queryCameraAuthorization:(void(^)(BOOL isAuth))completion;

/**
 *  接口管理
 */
- (void)getSkillsCatalog:(requestCallback)next;   //获取用户已添加主题
- (void)getSkillsCatalogList:(requestCallback)next; //获取系统主题
- (void)getTagsByCatalogId:(NSString *)catalogId next:(requestCallback)next;    //获取主题类别下的标签
- (void)addSkill:(NSDictionary *)params next:(requestCallback)next; //出租技能添加
- (void)getSkillById:(NSString *)id next:(requestCallback)next; //获取主题详情
- (void)deleteSkillById:(NSString *)_id next:(requestCallback)next; //删除主题
- (void)editSkillById:(NSString *)_id params:(NSDictionary *)params next:(requestCallback)next; //编辑主题
- (void)getBioDemo:(requestCallback)next;    //自我介绍示例
- (void)getSkillDemoBySid:(NSString *)sid next:(requestCallback)next;   //获取系统主题的介绍示例
- (void)getPhotoDemoListBySid:(NSString *)sid next:(requestCallback)next;   //获取系统主题的图片示例
- (void)howToWriteSkillDetail:(requestCallback)next;    //如何填写技能文字介绍tip

// 获取技能通过ID
- (void)fetchSkillByID:(NSString *)skillID next:(requestCallback)next;
@end
