//
//  ZZPostTaskViewModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskViewModel.h"

#import "ZZRequest.h"
#import "ZZTasksServer.h"

#import "ZZPostTaskDefaultTableViewCell.h"
#import "ZZPostTaskGenderCell.h"
#import "ZZPostTaskPhotoCell.h"
#import "ZZOtherSettingCell.h"
#import "ZZPostTaskContentCell.h"
#import "ZZPostFreeThemeCell.h"
#import "ZZPostFreeDefaultCell.h"
#import "ZZPostTaskThmemeCell.h"
#import "ZZPostTaskThemeTagsCell.h"
#import "ZZPostTaskBasicInfoCell.h"
#import "ZZPostTaskPriceCell.h"

#import "ZZDateHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface ZZPostTaskViewModel () <ZZOtherSettingCellDelegate, ZZPostTaskGenderCellDelegate, ZZPostTaskPhotoCellDelegate, ZZPostTaskContentCellDelegate, ZZPostTaskBasicInfoCellDelegate, ZZPostTaskThmemeCellDelegate, ZZPostTaskPriceCellDelegate >

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSArray<ZZPostTaskCellModel *> *cellModelArray;

@property (nonatomic, assign) NSInteger currentChoosePhotoIndex;

@end

@implementation ZZPostTaskViewModel

- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _taskType = taskType;
        _currentSkill = skill;
        [self defaultSetting:nil];

        if (_taskType == TaskNormal) {
            _isFirstTime = [ZZUserDefaultsHelper objectForDestKey:@"FisrtTimePostNormalTask"] ? NO : YES;
        }
    }
    return self;
}

- (instancetype)initTaskType:(TaskType)taskType taskInfo:(NSDictionary *)taskInfo {
    self = [super init];
    if (self) {
        [self defaultSetting:taskInfo];
        _taskType = taskType;
        _currentSkill = taskInfo[@"skill"];
        
        if (_taskType == TaskNormal) {
            _isFirstTime = [ZZUserDefaultsHelper objectForDestKey:@"FisrtTimePostNormalTask"] ? NO : YES;
        }
    }
    return self;
}

#pragma mark - public Method

/**
 *  确认发布
 */
- (void)confirm {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    // 必须要有技能
    if (!_currentSkill) {
        [ZZHUD showErrorWithStatus:@"请选择任务"];
        return;
    }
    
    // 简介
    if (_taskType == TaskFree) {
        if (!_content || isNullString(_content)) {
            [ZZHUD showErrorWithStatus:@"请填写补充说明"];
            return;
        }
    }
    
    // 必须要有地点
    if (!_location || isNullString(_location.name)) {
        [ZZHUD showErrorWithStatus:@"请选择地点"];
        return;
    }
    
    // 必须要有时长
    if (_taskType == TaskNormal) {
        if (_durantion <= 0) {
            [ZZHUD showErrorWithStatus:@"请选择时间"];
            return;
        }
    }
    else {
        if (isNullString(_startTime) || isNullString(_durantionDes)) {
            [ZZHUD showErrorWithStatus:@"请选择时间"];
            return;
        }
    }
    
    // 必须要有价格
    if (_taskType == TaskNormal) {
        if (isNullString(_price)) {
            [ZZHUD showErrorWithStatus:@"请填写价格"];
            return;
        }
    }
    
    if (isNullString(self.location.name) || !self.location.location) {
        [ZZHUD showErrorWithStatus:@"地点有误,请重新选择"];
        return;
    }
    
    // 必须要同意规则才能发布
    if (_taskType == TaskFree) {
        if (!_didAgreed) {
            [ZZHUD showErrorWithStatus:@"请先同意发布规则, 才能发布活动"];
            return;
        }
    }
    
    [self publishPhotos];
}

#pragma mark - private method
- (void)defaultSetting:(NSDictionary *)taskInfo {
    _currentChoosePhotoIndex = -1;
    _isAnonymous = NO;
    _gender = 2;
    _didAgreed = YES;
    
    if (taskInfo) {
        // 性别
        if (taskInfo[@"gender"]) {
            _gender = [taskInfo[@"gender"] integerValue];
        }
        
        // 时常
        if (taskInfo[@"hour"]) {
            _durantion = [taskInfo[@"hour"] integerValue];
        }
        
        // 时间
        if (taskInfo[@"date"] && taskInfo[@"date_type"]) {
            NSDate *date = taskInfo[@"date"];
            _startTime = [[ZZDateHelper shareInstance] getDateStringWithDate:date];
            
            NSInteger type = [taskInfo[@"date_type"] integerValue];
            if (type == 1) {
                _startTimeDescript = @"尽快";
            }
            else {
                if (taskInfo[@"selectDate"]) {
                    _startTimeDescript = taskInfo[@"selectDate"];
                }
            }
        }
        return;
    }
    else {
        NSDictionary *param = nil;
        
        if (_taskType == TaskFree) {
            param = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].publicFreeTask];
        }
        else {
            param = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].publicTask];
        }
        
        if (!param) {
            return;
        }
        
        // 地点
        if (_taskType == TaskNormal) {
            if (!isNullString(param[@"address"])
                && !isNullString(param[@"address_city_name"])
                && param[@"address_lng"]
                && param[@"address_lat"]
                && !isNullString(param[@"city_name"])
                ) {

                if (!_location) {
                    _location = [[ZZRentDropdownModel alloc] init];
                }

                _location.name = param[@"address"];
                _location.city = param[@"address_city_name"];

                CLLocation *location = [[CLLocation alloc] initWithLatitude:[param[@"address_lat"] floatValue] longitude:[param[@"address_lng"] floatValue]];
                _location.location = location;
                _location.city = param[@"city_name"];
            }
        }
        
        // 时间
        if (_taskType == TaskNormal) {
            if (!isNullString(param[@"dated_at"])
                && param[@"dated_at_type"]
                && param[@"hours"]) {
                if (![[ZZDateHelper shareInstance] taskIsPassLimitedTime:param[@"dated_at"]]) {
                    _startTime = param[@"dated_at"];
                    _startTimeDescript = [param[@"dated_at_type"] integerValue] == 1 ? @"尽快" : nil;
                    _durantion = [param[@"hours"] integerValue];
                }
            }
        }

        // 1: 男 2: 女
        if (param[@"gender"]) {
            _gender = [param[@"gender"] integerValue];
        }
        else {
            if (_taskType == TaskFree) {
                _gender = 3;
            }
            else {
                _gender = 2;
            }
        }
        
        // 是否匿名
        if (_taskType == TaskNormal) {
            BOOL is_anonymous = [param[@"is_anonymous"] integerValue] == 2;
            _isAnonymous = is_anonymous;
        }
        
        // 是否同意
        if (_taskType == TaskFree) {
            BOOL didAgreed = [param[@"agreed"] boolValue];
            _didAgreed = didAgreed;
        }
    }
}

/*
 点击图片
 */
- (void)showPhotoSelections:(NSInteger)index {
    
    BOOL canDelete = NO;
    if (!_photosArray || _photosArray.count == 0) {
        canDelete = NO;
    }
    else {
        if (index == 0) {
            canDelete = _photosArray.count >= 1;
        }
        else if (index == 1) {
            canDelete = _photosArray.count >= 2;
        }
        else if (index == 2) {
            canDelete = _photosArray.count == 3;
        }
    }
    
    _currentChoosePhotoIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showSelection:)]) {
        [self.delegate viewModel:self showSelection:canDelete];
    }
}

- (void)saveConfigToLocal:(NSDictionary *)params {
    if (_taskType == TaskFree) {
        NSMutableDictionary *paramsM = params.mutableCopy;
        
        //保存一下 是否同意
        paramsM[@"agreed"] = @(_didAgreed);
        
        [ZZKeyValueStore saveValue:paramsM key:[ZZStoreKey sharedInstance].publicFreeTask];
    }
    else {
        [ZZKeyValueStore saveValue:params key:[ZZStoreKey sharedInstance].publicTask];
    }
}

#pragma mark - public Method
- (void)chooseSkill:(ZZSkill *)skill {
    if (![skill.id isEqualToString:_currentSkill.id]) {
        _currentSkill = skill;
        if (_taskType == TaskNormal) {
            [self createTaskNormalStep1CellModels];
        }
        else {
            [self updateCellModel:postTheme];
            [self updateCellModel:postThemeTag];
        }
    }
}

- (void)updateSkillTags:(ZZSkill *)skill {
    _currentSkill = skill;
//    [self updateCellModel:postThemeTag];
    [self createTaskNormalStep1CellModels];
    
    [_tableView reloadData];
}

- (void)chooseCity:(ZZCity *)city {
    _city = city;
    if (![_city.name isEqualToString:_location.city]) {
        _location = nil;
    }
    if (_taskType == TaskNormal) {
        [self updateCellModel:postBasicInfo];
    }
    else {
        [self updateCellModel:postCity];
    }
}

- (void)chooseLocation:(ZZRentDropdownModel *)location {
    _location = location;
    if (_taskType == TaskNormal) {
        [self updateCellModel:postBasicInfo];
    }
    else {
        [self updateCellModel:postLocation];
    }
}

- (void)choosePrice:(NSString *)price {
    _price = price;
    [self updateCellModel:postPrice];
    
    NSInteger s = [self.tableView numberOfSections];  //有多少组
       if (s<1) return;  //无数据时不执行 要不会crash
       NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
       if (r<1) return;
       NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
       [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES]; //滚动到最后一行

}

- (void)starTime:(NSString *)startTime startDescript:(NSString *)startTimeDescript durantion:(NSInteger)durantion {
    _startTime = startTime;
    _startTimeDescript = startTimeDescript;
    if (_taskType == TaskNormal) {
        [self updateCellModel:postBasicInfo];
    }
    else {
        [self updateCellModel:postTime];
    }
}

- (void)configureDuration:(NSInteger)duration {
    _durantion = duration;
    if (_taskType == TaskNormal) {
        [self updateCellModel:postBasicInfo];
    }
    else {
        [self updateCellModel:postDuration];
    }
}

- (void)starTime:(NSString *)startTime startDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes {
    _startTime = startTime;
    _startTimeDescript = startTimeDescript;
    _durantionDes = durationDes;
    [self updateCellModel:postTime];
}

- (void)choosePhoto:(UIImage *)photo {
    if (!photo) {
        // 删除
        if (_currentChoosePhotoIndex != -1 && _currentChoosePhotoIndex <= _photosArray.count) {
            NSMutableArray *photos = _photosArray.mutableCopy;
            [photos removeObjectAtIndex:_currentChoosePhotoIndex];
            _photosArray = photos.copy;
            _currentChoosePhotoIndex = -1;
            [self updateCellModel:postPhoto];
        }
    }
    else {
        // 添加
        if (_currentChoosePhotoIndex != -1) {
            ZZPhoto *photoModel = [[ZZPhoto alloc] init];
            photoModel.image = photo;
            
            NSMutableArray *photos = _photosArray.mutableCopy;
            
            if (!photos) {
                photos = @[].mutableCopy;
            }

            if (_currentChoosePhotoIndex < _photosArray.count && photos.count > 0) {
                [photos replaceObjectAtIndex:_currentChoosePhotoIndex withObject:photoModel];
            }
            else {
                [photos addObject:photoModel];
            }
            _photosArray = photos.copy;
            _currentChoosePhotoIndex = -1;
            [self updateCellModel:postPhoto];
        }
    }
}


#pragma mark - ZZPostTaskPriceCellDelegate
- (void)priceCellChoosePrice:(ZZPostTaskPriceCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePrice:)]) {
       [self.delegate choosePrice:self];
   }
}


#pragma mark - ZZPostTaskThmemeCellDelegate
- (void)themeCellChooseTags:(ZZPostTaskThmemeCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chooseTags:)]) {
        [self.delegate viewModel:self chooseTags:_currentSkill];
    }
}


#pragma mark - ZZPostTaskBasicInfoCellDelegate
- (void)basicInfoCellChooseDuration:(ZZPostTaskBasicInfoCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseDuration:)]) {
        [self.delegate chooseDuration:self];
    }
}

- (void)basicInfoCellChooseTime:(ZZPostTaskBasicInfoCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseTime:)]) {
        [self.delegate chooseTime:self];
    }
}

- (void)basicInfoCellChooseLocation:(ZZPostTaskBasicInfoCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLocationView:)]) {
        [self.delegate showLocationView:self];
    }
}

#pragma mark - ZZPostTaskContentCell
/**
 输入的详情
 */
- (void)cell:(ZZPostTaskContentCell *)cell didInputContent:(NSString *)content {
    _content = content;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:taskFreeDidInputContent:)]) {
        [self.delegate viewModel:self taskFreeDidInputContent:_content];
    }
}

- (void)cell:(ZZPostTaskContentCell *)cell cellHeight:(CGFloat)cellHeight {
    __block BOOL heightDidChanged = NO;
    [_cellModelArray enumerateObjectsUsingBlock:^(ZZPostTaskCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == postCotent) {
            obj.cellHeight = cellHeight;
            *stop = YES;
            heightDidChanged = YES;
        }
    }];
    
    if (heightDidChanged) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - ZZPostTaskGenderCellDelegate
/**
 MARK: 选择的性别
 */
- (void)cell:(ZZPostTaskGenderCell *)cell chooseGender:(NSInteger)gender {
    _gender = gender;
    [self updateCellModel:postGender];
}

#pragma mark - ZZPostTaskPhotoCellDelegate
- (void)cell:(ZZPostTaskPhotoCell *)cell selectedIndex:(NSInteger)index {
    [self showPhotoSelections:index];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ZZPostTaskCellModel *cellModel = _cellModelArray[indexPath.section];
    [self currentAction:cellModel indexPath:indexPath];
}

#pragma mark - ZZOtherSettingCellDelegate
- (void)cell:(ZZOtherSettingCell *)cell anonymous:(BOOL)anonymous {
    _isAnonymous = anonymous;
    [self updateCellModel:postOtherSetting];
}

- (void)showRules:(ZZOtherSettingCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRules:)]) {
        [self.delegate showRules:self];
    }
}

- (void)cell:(ZZOtherSettingCell *)cell didAgreed:(BOOL)didAgreed {
    _didAgreed = didAgreed;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ZZPostTaskCellModel *cellModel = _cellModelArray[indexPath.section];
    [self currentAction:cellModel indexPath:indexPath];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZPostTaskCellModel *cellModel = _cellModelArray[indexPath.section];
    
    switch (cellModel.type) {
        case postTheme: {
            if (_taskType == TaskFree) {
                ZZPostFreeThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostFreeThemeCell cellIdentifier] forIndexPath:indexPath];
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else {
                ZZPostTaskThmemeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskThmemeCell cellIdentifier] forIndexPath:indexPath];
                cell.delegate = self;
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            break;
        }
        case postThemeTag: {
            ZZPostTaskThemeTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskThemeTagsCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case postCotent: {
            ZZPostTaskContentCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskContentCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case postGender: {
            ZZPostTaskGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskGenderCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case postCity: {
            ZZPostFreeDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostFreeDefaultCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case postLocation: {
            if (_taskType == TaskFree) {
                ZZPostFreeDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostFreeDefaultCell cellIdentifier] forIndexPath:indexPath];
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else {
                ZZPostTaskDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskDefaultTableViewCell cellIdentifier] forIndexPath:indexPath];
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            break;
        }
        case postTime: {
            if (_taskType == TaskFree) {
                ZZPostFreeDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostFreeDefaultCell cellIdentifier] forIndexPath:indexPath];
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else {
                ZZPostTaskDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskDefaultTableViewCell cellIdentifier] forIndexPath:indexPath];
                cell.cellModel = cellModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            break;
        }
        case postDuration: {
            ZZPostTaskDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskDefaultTableViewCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case postPrice: {
            ZZPostTaskPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskPriceCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case postPhoto: {
            ZZPostTaskPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskPhotoCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case postOtherSetting: {
            ZZOtherSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZOtherSettingCell cellIdentifier] forIndexPath:indexPath];
            cell.cellModel = cellModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            _cell = cell;
            return cell;
            break;
        }
        case postBasicInfo: {
            ZZPostTaskBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPostTaskBasicInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.cellModel = cellModel;
            return cell;
            break;
        }
        default: {
            ZZPostTaskDefaultTableViewCell *cell = [ZZPostTaskDefaultTableViewCell new];
            return cell;
            break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_taskType == TaskFree && section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 32.0)];
        label.text = @"活动为免费发布，请勿发布低俗内容，活动内容审核通过后展示";
        label.textColor = RGBCOLOR(205, 136, 49);
        label.backgroundColor = RGBCOLOR(252, 250, 228);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        return label;
    }
    else {
        return [[UIView alloc] initWithFrame: CGRectZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZZPostTaskCellModel *item = _cellModelArray[section];
    if (_taskType == TaskFree && item.type == postPrice) {
         UIView *label = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 16.0)];
         label.backgroundColor = RGBCOLOR(247, 247, 247);
         return label;
    }
    else {
        return [[UIView alloc] initWithFrame: CGRectZero];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZPostTaskCellModel *cellModel = _cellModelArray[indexPath.section];
    switch (cellModel.type) {
        case postTheme: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showSkillThemes:)]) {
                [self.delegate showSkillThemes:self];
            }
            break;
        }
        case postThemeTag: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chooseTags:)]) {
                [self.delegate viewModel:self chooseTags:_currentSkill];
            }
            break;
        }
        case postCity: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showCityView:)]) {
                [self.delegate showCityView:self];
            }
            [self currentAction:cellModel indexPath:indexPath];
            break;
        }
        case postLocation: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showLocationView:)]) {
                [self.delegate showLocationView:self];
            }
            [self currentAction:cellModel indexPath:indexPath];
            break;
        }
        case postTime: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chooseTime:)]) {
                [self.delegate chooseTime:self];
            }
            [self currentAction:cellModel indexPath:indexPath];
            break;
        }
        case postDuration: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chooseDuration:)]) {
                [self.delegate chooseDuration:self];
            }
            [self currentAction:cellModel indexPath:indexPath];
            break;
        }
        case postPrice: {

            break;
        }
        default: {
            break;
        }
    }
}

- (void)currentAction:(ZZPostTaskCellModel *)cellModel indexPath:(NSIndexPath *)indexPath {
    if (_taskType != TaskFree) {
        return;
    }
    if (cellModel.type == postCity || cellModel.type == postLocation || cellModel.type == postPhoto || cellModel.type == postOtherSetting || cellModel.type == postTime || cellModel.type == postDuration) {
        CGRect rectInTableView = [_tableView rectForRowAtIndexPath:indexPath];
        CGRect rect = [_tableView convertRect:rectInTableView toView:[_tableView superview]];
        if (rect.origin.y > SCREEN_HEIGHT * 0.3) {
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_taskType == TaskFree && section == 0) ? 32.0 : 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZZPostTaskCellModel *item = _cellModelArray[section];
    if (_taskType == TaskFree && section == 0) {
         return _taskType == 32.0;
    }
    else {
        if (item.type == postPrice) {
            return 16.0;
        }
        else {
            return 0.0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZPostTaskCellModel *item = _cellModelArray[indexPath.section];
    return item.cellHeight;
}

#pragma mark - request
- (void)publishPhotos {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [ZZUploader uploadPhotos:_photosArray progress:^(CGFloat progress) {
        
    } success:^(NSArray *urlArray) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self publishTask];
    } failure:^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [ZZHUD showErrorWithStatus:@"上传失败,请重试"];
    }];
}

/**
 *  添加、上传图片到七牛
 */
- (void)uploadImage:(UIImage *)image
            handler:(void(^)(BOOL isSuccess, ZZPhoto *photo))handler {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSData *data = [ZZUtils userImageRepresentationDataWithImage:image];
    
    // 上传七牛
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            ZZPhoto *photo = [[ZZPhoto alloc] init];
            photo.url = resp[@"key"];
            
            // 上传自己服务器
            [photo add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                    if (handler) {
                        handler(NO, nil);
                    }
                } else {
                    [ZZHUD dismiss];
                    ZZPhoto *newPhoto = [[ZZPhoto alloc] initWithDictionary:data error:nil];
                    if (handler) {
                        handler(YES, newPhoto);
                    }
                }
            }];
        }
        else {
            // 上传到七牛失败
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [ZZHUD showErrorWithStatus:@"上传失败"];
            // 不确定是否需要, 反正先写着
            if ([ZZUserHelper shareInstance].unreadModel.open_log) {
                NSString *string = @"上传用户证件照错误";
                
                NSMutableDictionary *param = [@{@"type":string} mutableCopy];
                if ([ZZUserHelper shareInstance].uploadToken) {
                    [param setObject:[ZZUserHelper shareInstance].uploadToken forKey:@"uploadToken"];
                }
                if (info.error) {
                    [param setObject:[NSString stringWithFormat:@"%@",info.error] forKey:@"error"];
                }
                if (info.statusCode) {
                    [param setObject:[NSNumber numberWithInt:info.statusCode] forKey:@"statusCode"];
                }
                NSDictionary *dict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                       @"content":[ZZUtils dictionaryToJson:param]};
                [ZZUserHelper uploadLogWithParam:dict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    
                }];
                if (handler) {
                    handler(NO, nil);
                }
            }
        }
    }];
}

/**
 *  发布闪租任务
 */
- (void)publishTask {
    [MobClick event:Event_click_publish];
    NSMutableDictionary *param = @{
                                   @"address":           self.location.name,
                                   @"address_city_name": self.location.city ?: UserHelper.cityName,
                                   @"address_lng":       @(self.location.location.coordinate.longitude),
                                   @"address_lat":       @(self.location.location.coordinate.latitude),
                                   @"city_name":         self.location.city?: UserHelper.cityName,
                                   @"dated_at":          self.startTime,
                                   @"dated_at_type":     @([_startTimeDescript isEqualToString:@"尽快"] ? 1 : 0),
                                   @"expand_auto":       @1,
                                   @"gender":            @(self.gender),
                                   @"hours":             @(self.durantion),
                                   @"is_anonymous":      @(self.isAnonymous ? 2 : 1),
                                   @"region":            @3,
                                   @"skill_id":          self.currentSkill.id,
                                   @"type":              @3,
                                   }.mutableCopy;
    
    // 介绍
    if (_taskType == TaskFree) {
        param[@"brief_text"] = _content;
    }
    
    // 价格
    if (_taskType == TaskNormal) {
        param[@"price"] = self.price;
    }
    else {
        param[@"price"] = @"0";
    }
    
    // 时间
    if (_taskType == TaskNormal) {
        param[@"dated_at_type"] = @([_startTimeDescript isEqualToString:@"尽快"] ? 1 : 0);
        param[@"dated_at"] = self.startTime;
    }
    else {
        NSInteger dateType = -1;
        NSString *dated_at = nil;
        if ([_durantionDes isEqualToString:@"深夜"]) {
            dateType = 2;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"04:59"];
        }
        else if ([_durantionDes isEqualToString:@"上午"]) {
            dateType = 3;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"10:59"];
        }
        else if ([_durantionDes isEqualToString:@"中午"]) {
            dateType = 4;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"12:59"];
        }
        else if ([_durantionDes isEqualToString:@"下午"]) {
            dateType = 5;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"16:59"];
        }
        else if ([_durantionDes isEqualToString:@"傍晚"]) {
            dateType = 6;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"18:59"];
        }
        else if ([_durantionDes isEqualToString:@"晚上"]) {
            dateType = 7;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"23:59"];
        }
        else if ([_durantionDes isEqualToString:@"整天"]) {
            dateType = 8;
            dated_at = [NSString stringWithFormat:@"%@ %@",self.startTime, @"23:59"];
        }
        param[@"dated_at_type"] = @(dateType);
        param[@"dated_at"] = dated_at;
    }
    
    // 照片字段
    if (_photosArray.count != 0) {
        NSMutableArray *imageArray = @[].mutableCopy;
        [_photosArray enumerateObjectsUsingBlock:^(ZZPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!isNullString(obj.url)) {
                [imageArray addObject:obj.url];
            }
        }];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageArray.copy options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *imgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        param[@"imgs"] = imgStr;
    }
    
    // 主题技能标签
    if (_taskType == TaskNormal && _currentSkill.tags.count > 0) {
        NSMutableArray *arr = @[].mutableCopy;
        [_currentSkill.tags enumerateObjectsUsingBlock:^(ZZSkillTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject: obj.name];
        }];
        
        param[@"tags"] = arr.copy;
    }
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [ZZTasksServer postTaskWithParams:param.copy taskType:_taskType handler:^(ZZError *error, id data) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [self saveConfigToLocal:param];
            if (_taskType == TaskNormal) {
                // 跳转支付页面
                ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:data[@"pd"] error:nil];
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:orderID:price:)]) {
                    [self.delegate viewModel:self orderID:model.id price:self.price];
                }
            }
            else if (_taskType == TaskFree) {
                [ZZHUD showSuccessWithStatus:@"发布成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishedTaskNotification object:nil];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(taskFreePublished:)]) {
                    [self.delegate taskFreePublished:self];
                }
            }
        }
    }];
}

#pragma mark - TableView configures
- (void)configTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    // 注册cell
    [self registerTableViewCell];
    
    // 创建视图
    [self createCellModels];
}

/*
 创建cellModels
*/
- (void)createCellModels {
    if (_taskType == TaskNormal) {
        if (_currentStep == TaskStep1) {
            [self createTaskNormalStep1CellModels];
        }
        else if (_currentStep == TaskStep2) {
            [self createTaskNormalStep2CellModels];
        }
    }
    else {
        if (_currentStep == TaskStep2) {
            [self createTaskFreeStepTwoCellModels];
        }
        else {
            [self createTaskFreeStepThreeCellModels];
        }
    }
}

/*
 创建通告视图
*/
- (void)createTaskNormalStep1CellModels {
    NSMutableArray *itemsArray = @[].mutableCopy;
    
    // 主题
    ZZPostTaskCellModel *themeCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postTheme];
    if (_currentSkill) {
        themeCellModel.data = _currentSkill;
    }
    [itemsArray addObject:themeCellModel];
    
    // 主题标签
    if (_currentSkill.tags.count > 0) {
        ZZPostTaskCellModel *themeTagCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postThemeTag];
        themeTagCellModel.data = _currentSkill;
        [themeTagCellModel configureThemeTags];
        [itemsArray addObject:themeTagCellModel];
    }
    
    // 基础信息(地点、 时间、 时长)
    ZZPostTaskCellModel *basicInfoCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postBasicInfo];
    
    NSMutableDictionary *info = @{}.mutableCopy;
    if (!isNullString(_location.name)) {
        info[@"location"] = _location.name;
    }
    
    if (!isNullString(_startTime)) {
        info[@"startTime"] = _startTime;
    }
    
    NSString *time = [basicInfoCellModel fetchConfiguretartTime:_startTime startTimeDescript:_startTimeDescript hour:_durantion];
    if (!isNullString(time) && ![time isEqualToString:@"(null)"]) {
        info[@"time"] = time;
    }
    
    if (_durantion > 0) {
        info[@"duration"] = [NSString stringWithFormat:@"%ld小时",_durantion];
    }
    basicInfoCellModel.data = info.copy;
    [itemsArray addObject:basicInfoCellModel];
    
    _cellModelArray = itemsArray.copy;
    
    [_tableView reloadData];
}

- (void)createTaskNormalStep2CellModels {
    NSMutableArray *itemsArray = @[].mutableCopy;
    
    // 性别
    ZZPostTaskCellModel *genderCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postGender];
    genderCellModel.data = @(_gender);
    [itemsArray addObject:genderCellModel];
    
    // 钱
    ZZPostTaskCellModel *priceCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postPrice];
    if (!isNullString(_price) && _durantion > 0) {
        priceCellModel.data = [NSString stringWithFormat:@"%ld小时 共%@元",_durantion , _price];
    }
    [itemsArray addObject:priceCellModel];
    
    
    // 配图
    ZZPostTaskCellModel *photoCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postPhoto];
    photoCellModel.data = _photosArray;
    [itemsArray addObject:photoCellModel];
    
    
    // 其他设置
    ZZPostTaskCellModel *otherSettingCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postOtherSetting];
    otherSettingCellModel.data = [NSNumber numberWithBool:_isAnonymous];
    [itemsArray addObject:otherSettingCellModel];
    
    _cellModelArray = itemsArray.copy;
    
    [_tableView reloadData];
}

/*
 创建活动步骤2视图
 */
- (void)createTaskFreeStepTwoCellModels {
    NSMutableArray *itemsArray = @[].mutableCopy;
    
    // 主题
    ZZPostTaskCellModel *themeCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postTheme];
    if (_currentSkill) {
        if (_taskType == TaskFree) {
            themeCellModel.data = _currentSkill;
        }
        else {
            themeCellModel.data = _currentSkill.name;
        }
    }
    [itemsArray addObject:themeCellModel];
    
    // 活动详情
    ZZPostTaskCellModel *contentCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postCotent];
    [itemsArray addObject:contentCellModel];
    
    // 配图
    ZZPostTaskCellModel *photoCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postPhoto];
    photoCellModel.data = _photosArray;
    [itemsArray addObject:photoCellModel];
    
    _cellModelArray = itemsArray.copy;
    
    [_tableView reloadData];
}

/*
 创建活动步骤3视图
 */
- (void)createTaskFreeStepThreeCellModels {
    NSMutableArray *itemsArray = @[].mutableCopy;
    
    // 时间
    ZZPostTaskCellModel *timeCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postTime];
    if (!isNullString(_startTime)) {
        if (_taskType == TaskNormal) {
            [timeCellModel configureStartTime:_startTime startTimeDescript:_startTimeDescript hour:_durantion];
        }
        else {
            [timeCellModel configureStartTime:_startTime startTimeDescript:_startTimeDescript durationDes:_durantionDes];
        }
    }
    [itemsArray addObject:timeCellModel];
    
    // 地点
    ZZPostTaskCellModel *locationCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postLocation];
    if (_location) {
        NSMutableString *locationName = _location.name.mutableCopy;
        NSRange cityRange = [locationName rangeOfString:_location.city];
        if (cityRange.location != NSNotFound) {
            [locationName deleteCharactersInRange:cityRange];
        }
        
        if (!isNullString(_location.city)) {
            [locationName insertString:[NSString stringWithFormat:@"%@ • ", _location.city] atIndex:0];
        }
        
        locationCellModel.data = locationName.copy;
    }
    [itemsArray addObject:locationCellModel];
    
    // 其他设置
    ZZPostTaskCellModel *otherSettingCellModel = [[ZZPostTaskCellModel alloc] initWithTaskType:_taskType itemType:postOtherSetting];
    otherSettingCellModel.data = [NSNumber numberWithBool:_didAgreed];
    [itemsArray addObject:otherSettingCellModel];
    
    _cellModelArray = itemsArray.copy;
    
    [_tableView reloadData];
}

- (void)updateCellModel:(PostTaskItemType)itemType {
    __block ZZPostTaskCellModel *model = nil;
    [_cellModelArray enumerateObjectsUsingBlock:^(ZZPostTaskCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (itemType == obj.type) {
            model = obj;
            *stop = YES;
        }
    }];
    
    if (!model) {
        return;
    }
    
    switch (model.type) {
        case postTheme: {
            if (_currentSkill) {
                model.data = _currentSkill;
            }
            break;
        }
        case postThemeTag: {
            if (_currentSkill) {
                model.data = _currentSkill;
                [model configureThemeTags];
            }
            break;
        }
        case postGender: {
            model.data = @(_gender);
            break;
        }
        case postLocation: {
            if (_taskType == TaskFree) {
                if (_location) {
                    NSMutableString *locationName = _location.name.mutableCopy;
                    NSRange cityRange = [locationName rangeOfString:_location.city];
                    if (cityRange.location != NSNotFound) {
                        [locationName deleteCharactersInRange:cityRange];
                    }
                    
                    if (!isNullString(_location.city)) {
                        [locationName insertString:[NSString stringWithFormat:@"%@ • ", _location.city] atIndex:0];
                    }
                    
                    model.data = locationName.copy;
                }
            }
            else {
                if (_location) {
                    model.data = _location.name;
                }
            }
            break;
        }
        case postTime: {
            if (!isNullString(_startTime)) {
                if (_taskType == TaskNormal) {
                    [model configureStartTime:_startTime startTimeDescript:_startTimeDescript hour:_durantion];
                }
                else {
                    [model configureStartTime:_startTime startTimeDescript:_startTimeDescript durationDes:_durantionDes];
                }
            }
            break;
        }
        case postDuration: {
            if (_durantion > 0) {
                model.data = [NSString stringWithFormat:@"%ld小时",_durantion];
            }
            break;
        }
        case postPrice: {
            if (!isNullString(_price) && _durantion > 0) {
                model.data = [NSString stringWithFormat:@"%ld小时 共%@元",_durantion, _price];
            }
            break;
        }
        case postPhoto: {
            model.data = _photosArray;
            break;
        }
        case postOtherSetting: {
            if (_taskType == TaskFree) {
                model.data = [NSNumber numberWithBool:_didAgreed];
            }
            else {
                model.data = [NSNumber numberWithBool:_isAnonymous];
            }
            break;
        }
        case postBasicInfo: {
            
            NSMutableDictionary *info = @{}.mutableCopy;
            if (!isNullString(_location.name)) {
                info[@"location"] = _location.name;
            }
            
            if (!isNullString(_startTime)) {
                info[@"startTime"] = _startTime;
            }
            
            NSString *time = [model fetchConfiguretartTime:_startTime startTimeDescript:_startTimeDescript hour:_durantion];
            if (!isNullString(time) && ![time isEqualToString:@"(null)"]) {
                info[@"time"] = time;
            }
            
            if (_durantion > 0) {
                info[@"duration"] = [NSString stringWithFormat:@"%ld小时",_durantion];
            }
            model.data = info.copy;
            
            break;
        }
        default: {

            break;
        }
    }
    [_tableView reloadData];
}

/*
 注册cell
 */
- (void)registerTableViewCell {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[ZZPostTaskDefaultTableViewCell class]
       forCellReuseIdentifier:[ZZPostTaskDefaultTableViewCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskGenderCell class]
       forCellReuseIdentifier:[ZZPostTaskGenderCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskPhotoCell class]
       forCellReuseIdentifier:[ZZPostTaskPhotoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZOtherSettingCell class]
       forCellReuseIdentifier:[ZZOtherSettingCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskContentCell class]
       forCellReuseIdentifier:[ZZPostTaskContentCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostFreeThemeCell class]
       forCellReuseIdentifier:[ZZPostFreeThemeCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostFreeDefaultCell class]
       forCellReuseIdentifier:[ZZPostFreeDefaultCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskThmemeCell class]
    forCellReuseIdentifier:[ZZPostTaskThmemeCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskThemeTagsCell class]
       forCellReuseIdentifier:[ZZPostTaskThemeTagsCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskBasicInfoCell class]
    forCellReuseIdentifier:[ZZPostTaskBasicInfoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZPostTaskPriceCell class]
    forCellReuseIdentifier:[ZZPostTaskPriceCell cellIdentifier]];
}

@end
