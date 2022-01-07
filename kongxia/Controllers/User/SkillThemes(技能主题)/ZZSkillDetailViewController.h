//
//  ZZSkillDetailViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger, SkillDetailType) {
    SkillDetailTypeShow = 0,    //技能展示
    SkillDetailTypePreview,     //编辑技能前的预览
};

@interface ZZSkillDetailViewController : ZZViewController

@property (nonatomic, strong) ZZTopic *topic;   //所选他人的技能
@property (nonatomic, strong) ZZUser *user;     //所选他人的用户信息

@property (nonatomic, assign) BOOL isHideBar;//从搜索、他人页等过来隐藏导航栏的viewcontroller
@property (nonatomic, assign) NSInteger chooseType;//线下选达人列表实时刷新个人页是否可以选TA : 1、选他 2、已选定 3、不可选
@property (nonatomic, assign) BOOL fromLiveStream;//只显示底部跟她视频 或 选择线下达人

@property (nonatomic, assign) SkillDetailType type;

@end
