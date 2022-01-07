//
//  ZZPostTaskCellModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskCellModel.h"
#import "ZZPostTaskDefaultTableViewCell.h"
#import "ZZPostTaskGenderCell.h"
#import "ZZPostTaskPhotoCell.h"
#import "ZZOtherSettingCell.h"
#import "ZZPostTaskContentCell.h"
#import "ZZPostFreeThemeCell.h"
#import "ZZPostFreeDefaultCell.h"
#import "ZZPostTaskBasicInfoCell.h"
#import "ZZPostTaskPriceCell.h"

@implementation ZZPostTaskCellModel

- (instancetype)initWithTaskType:(TaskType)taskType itemType:(PostTaskItemType)itemType {
    self = [super init];
    if (self) {
        _cellHeight = UITableViewAutomaticDimension;
        _accessoryType = UITableViewCellAccessoryNone;
        _taskType = taskType;
        _type = itemType;
        [self baseConfigure];
    }
    return self;
}

#pragma mark - public Method
- (void)configureData:(id)data {
    _data = data;
}

#pragma mark - private method
- (void)baseConfigure {
    switch (_type) {
        case postTheme: {
            if (self.taskType == TaskNormal) {
                _title = @"通告主题";
                _icon = @"";
            }
            else if (self.taskType == TaskFree) {
                _title = @"活动技能";
            }
            
            if (_taskType == TaskFree) {
                _cellHeight = 79.0;
            }
            else {
               _cellHeight = 60;
            }
            
            if (_taskType == TaskFree) {
                _cellIdentifier = [ZZPostFreeThemeCell cellIdentifier];
            }
            else {
               _cellIdentifier = [ZZPostTaskDefaultTableViewCell cellIdentifier];
            }
            
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postThemeTag: {
            _cellHeight = UITableViewAutomaticDimension;
            _cellIdentifier = [ZZPostTaskContentCell cellIdentifier];
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postCotent: {
            if (self.taskType == TaskFree) {
                _title = @"活动介绍";
            }
            
            _cellHeight = 149.0;
            _cellIdentifier = [ZZPostTaskContentCell cellIdentifier];
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postGender: {
            _title = @"选择达人性别";
            if (self.taskType == TaskNormal) {
                _cellHeight = 75;
            }
            else {
                _cellHeight = 73.5;
            }
            
            _cellIdentifier = [ZZPostTaskGenderCell cellIdentifier];
            break;
        }
        case postLocation: {
            if (self.taskType == TaskNormal) {
                _icon = @"icJutiweizhi";
                _title = @"通告地点";
                _subTitle = @"您在哪里约见达人？";
            }
            else if (self.taskType == TaskFree) {
                _title = @"活动地点";
                _subTitle = @"选择地点";
            }
            
            if (_taskType == TaskFree) {
                _cellHeight = 100.5;
            }
            else {
                _cellHeight = 54;
            }
            
            if (_taskType == TaskFree) {
                _cellIdentifier = [ZZPostFreeDefaultCell cellIdentifier];
            }
            else {
                _cellIdentifier = [ZZPostTaskDefaultTableViewCell cellIdentifier];
            }
            
            _cellIdentifier = @"PostLocationItem";
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postTime: {
            if (self.taskType == TaskNormal) {
                _icon = @"icHuodongshijian";
                _title = @"通告时间";
                _subTitle = @"什么时候见面？";
            }
            else if (self.taskType == TaskFree) {
                _title = @"活动时间";
                _subTitle = @"选择你想要的活动开始时间";
            }
            
            if (_taskType == TaskFree) {
                _cellHeight = 100.5;
            }
            else {
                _cellHeight = 54;
            }
            
            if (_taskType == TaskFree) {
                _cellIdentifier = [ZZPostFreeDefaultCell cellIdentifier];
            }
            else {
                _cellIdentifier = [ZZPostTaskDefaultTableViewCell cellIdentifier];
            }
            _cellIdentifier = @"PostTimeItem";
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postDuration: {
            if (self.taskType == TaskNormal) {
                _icon = @"icShijianchangdu";
                _title = @"进行时长";
                _subTitle = @"邀约进行多久？";
            }
            
            _cellHeight = 54;
            _cellIdentifier = [ZZPostTaskDefaultTableViewCell cellIdentifier];
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postPrice: {
            if (self.taskType == TaskNormal) {
                _icon = @"icJine";
                _title = @"通告金额";
                _subTitle = @"输入金额";
            }
            else if (self.taskType == TaskFree) {
                _title = @"技能价格:";
                _subTitle = @"请输入你想获取的收益";
            }
            
            _cellHeight = 92;
            _cellIdentifier = [ZZPostTaskPriceCell cellIdentifier];
            _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case postPhoto: {
            _title = @"配图";
            _subTitle = @"(选填)";
            _subTitle1 = @"请上传与技能相关的图片，审核通过后展示";
            
            _cellHeight = 142.0;
            _cellIdentifier = [ZZPostTaskPhotoCell cellIdentifier];
            break;
        }
        case postOtherSetting: {
            if (_taskType == TaskNormal) {
                _title = @"发布规则";
                _subTitle = @"匿名发布";
            }
            else {
                _title = @"我已经阅读了《发布规则》";
            }
            
            _cellHeight = 50.0;
            _cellIdentifier = [ZZOtherSettingCell cellIdentifier];
            break;
        }
        case postBasicInfo: {
            _cellHeight = 204.0;
            _cellIdentifier = [ZZPostTaskBasicInfoCell cellIdentifier];
            break;
        }
        default:
            break;
    }
}

/**
 *  普通通告时间
 */
- (NSString *)fetchConfiguretartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript hour:(NSInteger)hour {
    NSString *dateString = nil;
        if ([startTimeDescript isEqualToString:@"尽快"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *date = [formatter dateFromString:startTime];
            return [NSString stringWithFormat:@"尽快, %@之前", [[ZZDateHelper shareInstance] getDetailDateStringWithDate:date]];
        }
        else if ([startTimeDescript isEqualToString:@"今天"] || [startTimeDescript isEqualToString:@"明天"] || [startTimeDescript isEqualToString:@"后天"]) {
            // 日期文案
            dateString = startTimeDescript;
            // 时间
            NSString *timeString = @"";
            NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:startTime];
            if (date) {
                timeString = [[ZZDateHelper shareInstance] getDetailDateStringWithDate:date];
            }
            // 小时
    //        NSString *hourString = [NSString stringWithFormat:@"%ld小时",hour];
            
            NSString *sumString = [NSString stringWithFormat:@"%@ %@",dateString,timeString];
            return sumString;
        }
        else {
            NSString *sumString = [NSString stringWithFormat:@"%@",startTime];
            return sumString;
        }
}

- (void)configureStartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript hour:(NSInteger)hour {
    _data = [self fetchConfiguretartTime:startTime startTimeDescript:startTimeDescript hour:hour];
}

/**
*  活动时间
*/
- (void)configureStartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes {
    _data = [NSString stringWithFormat:@"%@, %@, %@", startTimeDescript, startTime, durationDes];
}

- (void)configureThemeTags {
    if (![_data isKindOfClass:[ZZSkill class]]) {
        return;
    }
    
    ZZSkill *skill = (ZZSkill *)_data;
    if (skill.tags.count == 0) {
        _cellHeight = 0.0;
        _subTitle = @"让你的主题更具体";
        _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return;
    }
    
    CGFloat tagViewHeight = 26;
    CGFloat maxWidth = SCREEN_WIDTH - 15.0 * 2;
    
    CGFloat currentX = 15.0;
    CGFloat currentY = 12.0;
    CGFloat tagViewOffset = 15.0;
    
    NSMutableArray *frameArr = @[].mutableCopy;
    for (ZZSkillTag *tag in skill.tags) {
        CGFloat titleWidth = [NSString findWidthForText:tag.name havingWidth:SCREEN_WIDTH andFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
        CGFloat tagViewWidth = titleWidth + 16.0;
        if (tagViewWidth > maxWidth - 30.0) {
            tagViewWidth = maxWidth;
        }
        
        CGRect frame = CGRectZero;
        if (currentX == 15.0) {
            frame = CGRectMake(currentX, currentY, tagViewWidth, tagViewHeight);
            currentX += tagViewWidth + tagViewOffset;
        }
        else {
            if (maxWidth - currentX >= tagViewWidth) {
                frame = CGRectMake(currentX, currentY, tagViewWidth, tagViewHeight);
                currentX += tagViewWidth + tagViewOffset;
            }
            else {
                currentX = 15.0;
                currentY += tagViewHeight + 15.0;
                frame = CGRectMake(currentX, currentY, tagViewWidth, tagViewHeight);
                currentX += tagViewWidth + tagViewOffset;
            }
        }
        
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        [frameArr addObject:frameValue];
    }
    
    _tagsFrameArray = frameArr.copy;
    _cellHeight = currentY + tagViewHeight + 12.0;
    
    _subTitle = nil;
    _accessoryType = UITableViewCellAccessoryNone;
    
}

@end
