//
//  ZZMyLocationsViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyLocationsViewController.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZMultipleSelectMapViewController.h"

#import "ZZMyLocationModel.h"

@interface ZZMyLocationsViewController () <MyLocationViewDelegate, ZZMultipleSelectMapViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, copy) NSArray<MyLocationView *> *locationViewsArray;

@property (nonatomic, assign) NSInteger maxLocationCounts;

@property (nonatomic, copy) NSArray<ZZMyLocationModel *> *locationsArray;

@property (nonatomic, copy) NSArray<ZZMyLocationModel *> *deleteLocationArray;

@property (nonatomic, assign) BOOL didUpdate;

@end

@implementation ZZMyLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _didUpdate = NO;
    _maxLocationCounts = 5;
    _locationsArray = [ZZUserHelper shareInstance].loginer.userGooToAddress;
    [self layoutNavigations];
    [self createViews];
    [self layout];
    _titleLabel.text = [NSString stringWithFormat:@"常出没的地点 %ld/5个（最多5个）", _locationsArray.count];
}

#pragma mark - private method
- (void)deleteLocationAt:(NSInteger)deleteIdx {
    if (deleteIdx >= _locationsArray.count) {
        return;
    }
    _didUpdate = YES;
    NSMutableArray *arr = _locationsArray.mutableCopy;
    [arr removeObjectAtIndex:deleteIdx];
    _locationsArray = arr.copy;
    [self layout];
    _titleLabel.text = [NSString stringWithFormat:@"常出没的地点 %ld/5个（最多5个）", _locationsArray.count];
}

#pragma mark - response method
- (void)navigationLeftBtnClick {
    if (_didUpdate) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已修改，是否保存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self finish];
        }];
        [alertController addAction:doneAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finish {
    if (!_didUpdate) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [SVProgressHUD show];
    NSMutableArray *addedArr = @[].mutableCopy;
    // 新增加的
    for (NSInteger i = 0; i < _locationsArray.count; i++) {
        ZZMyLocationModel *currentModel = _locationsArray[i];
        
        BOOL isExist = NO;
        for (NSInteger j = 0; j < [ZZUserHelper shareInstance].loginer.userGooToAddress.count; j++) {
            ZZMyLocationModel *oldModel = [ZZUserHelper shareInstance].loginer.userGooToAddress[j];
            if ([currentModel.province isEqualToString: oldModel.province] && [currentModel.city isEqualToString: oldModel.city] && [currentModel.simple_address isEqualToString: oldModel.simple_address] && [currentModel.address isEqualToString: oldModel.address]) {
                isExist = YES;
                break;
            }
        }
        
        if (!isExist) {
            NSDictionary *infoDic = @{
                @"province" : currentModel.province,
                @"city" : currentModel.city,
                @"address" : currentModel.address,
                @"address_lng" : @(currentModel.address_lng),
                @"address_lat" : @(currentModel.address_lat),
                @"simple_address" : currentModel.simple_address,
            };
            [addedArr addObject:infoDic];
        }
    }
    
    NSMutableArray *deletedArr = @[].mutableCopy;
    for (NSInteger i = 0; i < [ZZUserHelper shareInstance].loginer.userGooToAddress.count; i++) {
        ZZMyLocationModel *oldModel = [ZZUserHelper shareInstance].loginer.userGooToAddress[i];
        
        BOOL isExist = NO;
        for (NSInteger j = 0; j < _locationsArray.count; j++) {
            ZZMyLocationModel *currentModel = _locationsArray[j];
            if ([currentModel.province isEqualToString: oldModel.province] && [currentModel.city isEqualToString: oldModel.city] && [currentModel.simple_address isEqualToString: oldModel.simple_address] && [currentModel.address isEqualToString: oldModel.address]) {
                isExist = YES;
                break;
            }
        }
        
        if (!isExist && !isNullString(oldModel._id)) {
            [deletedArr addObject:oldModel._id];
        }
    }
    
    if (deletedArr.count == 0 && addedArr.count == 0) {
        [ZZHUD showErrorWithStatus:@"请选择地点"];
        return;
    }
    
    [self editLocationsAdd:addedArr.copy deleteLocs:deletedArr.copy];
}

- (void)addLocations {
    WeakSelf
    if ([ZZUserHelper shareInstance].isAbroad) {
        // 海外
        ZZRentAbroadLocationViewController *controller = [[ZZRentAbroadLocationViewController alloc] init];
        controller.selectPoiDone = ^(ZZRentDropdownModel *model) {
            NSMutableArray *locationArr = weakSelf.locationsArray.mutableCopy;
            if (locationArr.count == 5) {
                [ZZHUD showTaskInfoWithStatus:@"最多只能添加5个"];
            }
            
            ZZMyLocationModel *locationModel = [[ZZMyLocationModel alloc] init];
            locationModel.simple_address = model.name;
            locationModel.address = model.detaiString;
            locationModel.city = model.city;
            locationModel.province = model.province;
            locationModel.address_lat = model.location.coordinate.latitude;
            locationModel.address_lng = model.location.coordinate.longitude;
            
            [locationArr addObject:locationModel];
            weakSelf.locationsArray = locationArr.copy;
            
            [weakSelf layout];
        };
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self goToSearchLocationView];
    }
}

#pragma mark - ZZMultipleSelectMapViewControllerDelegate
- (void)controller:(ZZMultipleSelectMapViewController *)controller didSelectLocations:(NSArray<ZZMyLocationModel *> *)locations {
    _didUpdate = YES;
    _locationsArray = locations;
    _titleLabel.text = [NSString stringWithFormat:@"常出没的地点 %ld/5个（最多5个）", _locationsArray.count];
    [self layout];
}

#pragma mark - MyLocationViewDelegate
- (void)view:(MyLocationView *)view delete:(NSInteger)deleteIdx {
    [self deleteLocationAt:deleteIdx];
}

#pragma mark - Navigator
- (void)goToSearchLocationView {
    ZZMultipleSelectMapViewController *vc = [[ZZMultipleSelectMapViewController alloc] initWithCurrentSelectLocations:_locationsArray];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request
- (void)editLocationsAdd:(NSArray *)addlocations deleteLocs:(NSArray *)deleteLocations {
    if (![ZZUserHelper shareInstance].isLogin) {
        return;
    }
    
    NSMutableDictionary *params = @{
        @"uid" : [ZZUserHelper shareInstance].loginer.uid,
        @"addList" : addlocations,
        @"removeList" : deleteLocations,
        @"open_pdg_sms" : @([ZZUserHelper shareInstance].loginer.open_pdg_sms),
        @"open_pd_sms" : @([ZZUserHelper shareInstance].loginer.open_pd_sms),
    }.mutableCopy;
    
    [ZZRequest method:@"POST"
                 path:@"/api/userOftenGoAddress"
               params:params.copy
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [SVProgressHUD dismiss];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD showSuccessWithStatus:@"编辑成功"];
            
            ZZUser *user = [ZZUserHelper shareInstance].loginer;
            user.userGooToAddress = _locationsArray;
            [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controllerDidEdited:)]) {
                [self.delegate controllerDidEdited:self];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Layout
- (void)layoutNavigations {
    self.title = @"选择常去的地点";
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action: @selector(finish)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)createViews {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.addBtn];
    _titleLabel.frame = CGRectMake(20.0, 24.0, SCREEN_WIDTH - 20.0, 22.5);
    
    NSMutableArray *locationViewsArray = @[].mutableCopy;
    for (int i = 0; i < _maxLocationCounts; i++) {
        MyLocationView *view = [[MyLocationView alloc] initWithTitle:nil distance:-1];
        view.hidden = YES;
        view.delegate = self;
        [self.view addSubview:view];
        [locationViewsArray addObject:view];
    }
    _locationViewsArray = locationViewsArray.copy;
}

- (void)layout {
    _titleLabel.frame = CGRectMake(20.0, 24.0, SCREEN_WIDTH - 20.0, 22.5);
    
    __block UIView *lastView = _titleLabel;
    [_locationViewsArray enumerateObjectsUsingBlock:^(MyLocationView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _locationsArray.count) {
            ZZMyLocationModel *model = _locationsArray[idx];
            NSString *title = model.simple_address;
            [obj configureTitle:title distance:[model currentDistance:[ZZUserHelper shareInstance].location]];
            obj.hidden = NO;
            obj.tag = idx;
            
            if (!lastView) {
                obj.frame = CGRectMake(15.0, _titleLabel.bottom + 20.0, obj.totalWidth, 44.0);
            }
            else {
                CGFloat leftWidth = SCREEN_WIDTH - lastView.right - 12 - 15;
                if (leftWidth >= obj.totalWidth) {
                    obj.frame = CGRectMake(lastView.right + 12, lastView.top, obj.totalWidth, 44);
                }
                else {
                    obj.frame = CGRectMake(15.0, lastView.bottom + 12.0, obj.totalWidth, 44);
                }
            }
            lastView = obj;
        }
        else {
            obj.hidden = YES;
            obj.frame = CGRectZero;
        }
    }];
    
    if (_locationsArray.count == 5) {
        _addBtn.hidden = YES;
    }
    else {
        _addBtn.hidden = NO;
    }
    _addBtn.frame = CGRectMake(20.0, lastView.bottom + 20.0, 76, 44.0);
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"常出没的地点 0/5个（最多5个）";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _titleLabel;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.normalTitle = @"添加";
        _addBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _addBtn.normalImage = [UIImage imageNamed:@"icGreetingAdd"];
        [_addBtn addTarget:self action:@selector(addLocations) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _addBtn.layer.cornerRadius = 22;
        [_addBtn setImagePosition:LXMImagePositionRight spacing:4];
    }
    return _addBtn;
}

@end

@interface MyLocationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) double distanceWidth;

@property (nonatomic, assign) double titleWidth;

@end

@implementation MyLocationView

- (instancetype)initWithTitle:(NSString *)title distance:(double)distance {
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)configureTitle:(NSString *)title distance:(double)distance {
    _titleLabel.text = title;
    _distanceLabel.text = [NSString stringWithFormat:@"• %.2fKM", distance];
    [self calculateFrames];
    [self layout];
}

#pragma mark - private method
- (void)calculateFrames {
    CGFloat maximunWidth = SCREEN_WIDTH - 15 * 2;
    CGFloat btnWidth = 33.0;
    
    CGFloat distanceWidth = [NSString findWidthForText:_distanceLabel.text havingWidth:maximunWidth andFont:self.distanceLabel.font];
    _distanceWidth = distanceWidth;
    
    CGFloat titleWidth = [NSString findWidthForText:_titleLabel.text havingWidth:maximunWidth andFont:self.titleLabel.font];
    CGFloat leftForTitleWidth = maximunWidth - 15.0 - 5.0 - btnWidth - distanceWidth;
    if (titleWidth > leftForTitleWidth) {
        _titleWidth = leftForTitleWidth;
    }
    else {
        _titleWidth = titleWidth;
    }
    _totalWidth = 15 + _titleWidth + 5.0 + distanceWidth  + btnWidth;
}

#pragma mark - response method
- (void)delete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:delete:)]) {
        [self.delegate view:self delete:self.tag];
    }
}

#pragma mark - Layout
- (void)createViews {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    self.layer.cornerRadius = 22.0;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.deleteBtn];
}

- (void)layout {
    _titleLabel.frame = CGRectMake(15.0, 0.0, _titleWidth, 44.0);
    _distanceLabel.frame = CGRectMake(_titleLabel.right + 5.0, 0.0, _distanceWidth, 44.0);
    _deleteBtn.frame = CGRectMake(_distanceLabel.right, 0.0, 33, 44);
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _distanceLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _distanceLabel;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.normalImage = [UIImage imageNamed:@"close_small"];
        [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
