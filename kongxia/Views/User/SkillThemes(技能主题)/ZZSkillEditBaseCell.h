//
//  ZZSkillEditBaseCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopic.h"
@class ZZSkillEditInputCell;
@class ZZSkillEditPressCell;
@class ZZSkillEditIntroduceCell;
@class ZZSkillEditScheduleCell;
@class ZZSkillEditViewController;
@class ZZSkillOptionViewController;
#import "ZZSkillEditViewController.h"
#import "ZZSkillOptionViewController.h"

/**
 *   主题编辑cell
 */
#define SkillEditBaseCellId @"SkillEditBaseCellId"
#define SkillEditInputCellId @"SkillEditInputCellId"
#define SkillEditPressCellId @"SkillEditPressCellId"
#define SkillEditIntroduceCellId @"SkillEditIntroduceCellId"
#define SkillEditPictureCellId @"SkillEditPictureCellId"
#define SkillEditTagCellId @"SkillEditTagCellId"
#define SkillEditScheduleId @"SkillEditScheduleId"

typedef NS_ENUM(NSInteger, SkillEditCellType) {
    //baseCellType
    BaseCellType = 0,
    //inputCellType
    InputCellTypeSystemTheme,       //系统主题cell
    InputCellTypeCustomTheme,       //自定义主题cell
    InputCellTypePrice,             //价格cell
    //pressCellType
    PressCellTypeText,              //文字介绍
    PressCellTypeImage,             //主题图片
};

@interface ZZSkillEditBaseCell : UITableViewCell
//通用属性
@property (nonatomic, weak) ZZTopic *topicModel;
@property (nonatomic, assign) SkillEditCellType cellType;
@property (nonatomic, assign) BOOL isUpdated;   //是否做过修改，子类实现setter，并回调给控制器
@property (nonatomic, copy) void(^updateBlock)(BOOL isUpdated); //是否修改回调，子类调用

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withEditType:(SkillEditType)editType topicModel:(ZZTopic *)topicModel;

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath topicModel:(ZZTopic *)topicModel;

//inputCell
@property (nonatomic, assign) BOOL showEditIcon;        //控制输入栏icon显隐
@property (nonatomic) UIColor *inputTextColor;          //输入栏字体颜色
@property (nonatomic) UIFont *inputTextFont;            //输入栏字体
//PressCell

//introduceCell
@property (nonatomic, copy) void(^showIntroduceDialog)(void);
@property (nonatomic, copy) void(^beginEditIntroduce)(void);
- (void)hideDialog;
//pictureCell
- (void)addToParentViewController:(UIViewController *)viewController;

@end
