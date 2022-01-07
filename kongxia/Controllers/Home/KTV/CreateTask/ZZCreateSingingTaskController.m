//
//  ZZCreateSingingTaskController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCreateSingingTaskController.h"
#import "ZZSongsController.h"

#import "ZZKTVGiftsView.h"
#import "ZZKTVSongCell.h"
#import "ZZKTVChooseSongsCell.h"
#import "ZZKTVChoosenSongCell.h"
#import "ZZKTVChooseGenderCell.h"
#import "ZZKTVChooseGiftCell.h"
#import "ZZKTVChooseGiftCountsCell.h"
#import "ZZKTVAnonymousCell.h"
#import "ZZKTVTaskPrePayView.h"

#import "ZZGiftHelper.h"
#import "ZZGiftModel.h"
#import "ZZKTVConfig.h"

@interface ZZCreateSingingTaskController ()<UITableViewDelegate, UITableViewDataSource, ZZKTVChooseGenderCellDelegate, ZZKTVAnonymousCellDelegate, ZZKTVChooseGiftCountsCellDelegate, ZZSongsControllerDelegate, ZZKTVChoosenSongCellDelegate, ZZKTVGiftsViewDelegate, ZZKTVTaskPrePayViewDelegate>

@property (nonatomic, strong) ZZBaseTableView *tableView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) ZZKTVModel *taskModel;

@end

@implementation ZZCreateSingingTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicConfig];
    [self layout];
}

#pragma mark - response method
- (void)confirmAction {
    
    if (!_taskModel) {
        return;
    }
    
    // 必须有歌
    if (_taskModel.song_list.count == 0) {
        [ZZHUD showErrorWithStatus:@"请选择歌曲"];
        return;
    }
    
    // 必须选择性别
    if (_taskModel.gender == -99) {
        [ZZHUD showErrorWithStatus:@"请选择歌曲"];
        return;
    }
    
    // 必须选择礼物
    if (!_taskModel.gift) {
        [ZZHUD showErrorWithStatus:@"请选择礼物"];
        return;
    }
    
    // 必须选择礼物数量
    if (_taskModel.gift_count == 0) {
        [ZZHUD showErrorWithStatus:@"请选择赠送礼物数量"];
        return;
    }
    
//    [self createSingingTask];
    [self showPrePayView];
}

- (void)goChooseSong {
    [self chooseSongs];
}


#pragma mark - private method
- (void)basicConfig {
    _taskModel = [[ZZKTVModel alloc] init];
    
    NSDictionary *param = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedSingingTask"];
    if (param && param.count > 0) {
        _taskModel.gender = [param[@"gender"] integerValue];
        _taskModel.gift_count = [param[@"gift_count"] integerValue];
        _taskModel.is_anonymous = [param[@"is_anonymous"] integerValue];
        
        ZZGiftModel *gift = [[ZZGiftModel alloc] init];
        gift.name = param[@"gift_name"];
        gift._id = param[@"gift_id"];
        gift.icon = param[@"gift_icon"];
        gift.mcoin = [param[@"gift_mcoin"] integerValue];
        gift.price = [param[@"gift_price"] doubleValue];
        _taskModel.gift = gift;
    }
    
    [_tableView reloadData];
}

- (void)saveTaskInfoToLocal {
    NSMutableDictionary *param = @{
        @"gender": @(_taskModel.gender),
        @"gift_count" : @(_taskModel.gift_count),
        @"is_anonymous": @(_taskModel.is_anonymous),
    }.mutableCopy;
    
    if (!isNullString(_taskModel.gift._id) && !isNullString(_taskModel.gift.name)) {
        param[@"gift_id"] = _taskModel.gift._id;
        param[@"gift_name"] = _taskModel.gift.name;
        param[@"gift_icon"] = _taskModel.gift.icon;
        param[@"gift_mcoin"] = @(_taskModel.gift.mcoin);
        param[@"gift_price"] = @(_taskModel.gift.price);
    }
    [[NSUserDefaults standardUserDefaults] setObject:param.copy forKey:@"cachedSingingTask"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - ZZKTVTaskPrePayViewDelegate
- (void)viewCreateTask:(ZZKTVTaskPrePayView *)view {
    [self createSingingTask];
}


#pragma mark - ZZKTVGiftsViewDelegate
- (void)giftView:(ZZKTVGiftsView *)view chooseGift:(ZZGiftModel *)giftModel {
    _taskModel.gift = giftModel;
    [_tableView reloadData];
}


#pragma mark - ZZKTVSongCellDelegate
- (void)cell:(ZZKTVSongCell *)cell addSong:(ZZKTVSongModel *)songModel {
    songModel.isSelected = NO;
    NSMutableArray<ZZKTVSongModel *> *arr = _taskModel.song_list.mutableCopy;
    __block NSInteger index = -1;
    [arr enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj._id isEqualToString:songModel._id]) {
            *stop = YES;
            index = idx;
        }
    }];
    
    if (index != -1) {
        ZZKTVSongModel *song = _taskModel.song_list[index];
        song.isSelected = NO;
        [arr removeObjectAtIndex:index];
        _taskModel.song_list = arr.copy;
        [_tableView reloadData];
    }
}


#pragma mark - ZZKTVChooseGenderCellDelegate
- (void)cell:(ZZKTVChooseGenderCell *)cell chooseGender:(NSInteger)gender {
    _taskModel.gender = gender;
}


#pragma mark - ZZKTVAnonymousCellDelegate
- (void)cell:(ZZKTVAnonymousCell *)cell anonymous:(BOOL)anonymous {
    _taskModel.is_anonymous = anonymous ? 2 : 1;
}


#pragma mark - ZZKTVChooseGiftCountsCellDelegate
- (void)cell:(ZZKTVChooseGiftCountsCell *)cell counts:(NSInteger)count {
    _taskModel.gift_count = count;
}


#pragma mark - ZZSongsListControllerDelegate
- (void)controller:(ZZSongsController *)controller choosedSongs:(NSArray *)songs {
    _taskModel.song_list = songs;
    [_tableView reloadData];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _taskModel.song_list.count == 0 ? 1 : _taskModel.song_list.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_taskModel.song_list.count == 0) {
            ZZKTVChooseSongsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVChooseSongsCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            ZZKTVChoosenSongCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVChoosenSongCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell configureSong:_taskModel.song_list[indexPath.row]];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        ZZKTVChooseGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVChooseGenderCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        [cell configureKTVModel:_taskModel];
        return cell;
    }
    else if (indexPath.section == 2) {
        ZZKTVChooseGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVChooseGiftCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureKTVModel:_taskModel];
        return cell;
    }
    else if (indexPath.section == 3) {
        ZZKTVChooseGiftCountsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVChooseGiftCountsCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configureKTVModel:_taskModel];
        return cell;
    }
    else {
        ZZKTVAnonymousCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVAnonymousCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configureKTVModel:_taskModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && _taskModel.song_list.count > 0) {
        return 38.5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && _taskModel.song_list.count > 0) {
        return self.footerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_taskModel.song_list.count == 0) {
            return 90;
        }
        else {
            return UITableViewAutomaticDimension;
        }
    }
    else if (indexPath.section == 4) {
        return 40.0;
    }
    else {
        return 90.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _taskModel.song_list.count == 0) {
        // 选择音乐 
        [self chooseSongs];
    }
    else if (indexPath.section == 2) {
        // 选择礼物
        [self showGiftsView];
    }
}


#pragma mark - Request
- (void)createSingingTask {
    [ZZHUD show];
    [ZZKTVServer createSingingTask:_taskModel
                   completeHandler:^(BOOL isSuccess) {
        [ZZHUD dismiss];
        
        if (!isSuccess) {
            return ;
        }
        [self saveTaskInfoToLocal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(controllerCreateSuccess:)]) {
            [self.delegate controllerCreateSuccess:self];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - Navigator
- (void)chooseSongs {
    ZZSongsController *controller = [[ZZSongsController alloc] init];
    controller.delegate = self;
    controller.selectedSongs = _taskModel.song_list.copy;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showGiftsView {
    ZZKTVGiftsView *giftView = [[ZZKTVGiftsView alloc] initWithFrame:self.view.bounds];
    
    ZZGiftHelper *giftHelper = [[ZZGiftHelper alloc] initWithUser:nil];
    giftHelper.entry = GiftEntryKTV;
    
    giftView.giftHelper = giftHelper;
    giftView.parentVC = self;
    giftView.delegate = self;
    [self.view addSubview:giftView];
    
    [giftView show];
}

- (void)showPrePayView {
    ZZKTVTaskPrePayView *prePayView = [[ZZKTVTaskPrePayView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    prePayView.taskModel = _taskModel;
    prePayView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:prePayView];
    [prePayView show];
}


#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR( 245, 245, 245);
    
    self.title = @"发起点唱Party任务";
    
    UIView *headerBgView = [[UIView alloc] init];
    headerBgView.backgroundColor = kYellowColor;
    
    [self.view addSubview:headerBgView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirmBtn];
    
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30);
        } else {
            make.bottom.equalTo(self.view).offset(-30);
        }
        make.size.mas_equalTo(CGSizeMake(228, 50));
    }];
}


#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZZBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 90;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 110)];
        
        [_tableView registerClass:[ZZKTVChooseSongsCell class]
           forCellReuseIdentifier:[ZZKTVChooseSongsCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVChoosenSongCell class]
           forCellReuseIdentifier:[ZZKTVChoosenSongCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVChooseGenderCell class]
           forCellReuseIdentifier:[ZZKTVChooseGenderCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVChooseGiftCell class]
           forCellReuseIdentifier:[ZZKTVChooseGiftCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVChooseGiftCountsCell class] forCellReuseIdentifier:[ZZKTVChooseGiftCountsCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVAnonymousCell class]
           forCellReuseIdentifier:[ZZKTVAnonymousCell cellIdentifier]];
    }
    return _tableView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"生成唱趴任务";
        _confirmBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmBtn.titleLabel.font = ADaptedFontMediumSize(16);
        _confirmBtn.layer.cornerRadius = 25.0;
        _confirmBtn.backgroundColor = kGoldenRod;
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 38.5)];
        _footerView.backgroundColor = UIColor.clearColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColor.whiteColor;
        [_footerView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"icTip"];
        [bgView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"达人成功演唱其中一首即可领取红包";
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        titleLabel.textColor = RGBCOLOR(153, 153, 153);
        [bgView addSubview:titleLabel];
        
        UIButton *chooseBtn = [[UIButton alloc] init];
        chooseBtn.normalTitle = @"继续添加";
        chooseBtn.normalTitleColor = RGBCOLOR(29, 125, 212);
        chooseBtn.titleLabel.font = ADaptedFontMediumSize(13);
        chooseBtn.normalImage = [UIImage imageNamed:@"icGengduoWddch"];
        [chooseBtn setImagePosition:LXMImagePositionRight spacing:4];
        [chooseBtn addTarget:self action:@selector(goChooseSong) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:chooseBtn];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_footerView);
            make.left.equalTo(_footerView).offset(10.0);
            make.right.equalTo(_footerView).offset(-10.0);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(15.0);
            make.size.mas_equalTo(CGSizeMake(17, 11));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(imageView.mas_right).offset(5.0);
        }];
        
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-15.0);
        }];
        
    }
    return _footerView;
}

@end
