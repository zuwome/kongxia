//
//  ZZRentDropdownMenuView.m
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentDropdownMenuView.h"
#import "ZZUserHelper.h"
#import "ZZRentDropdownCell.h"
#import "ZZRentDropdownModel.h"

@interface ZZRentDropdownMenuView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, copy) NSArray<ZZRentDropdownModel *> *historyLocationArray;

@end

@implementation ZZRentDropdownMenuView

- (id)initWithFrame:(CGRect)frame user:(ZZUser *)user {
    self = [super initWithFrame:frame];
    if (self) {
        _user = user;
        [self layout];
        [self configureData];
    }
    return self;
}

#pragma mark - private method
- (void)configureData {
    if (self.historyLocationArray.count == 0) {
        self.emptyView.hidden = NO;
    }
    else {
        _emptyView.hidden = YES;
    }
}

- (void)touchClearWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *mutablArr = _historyLocationArray.mutableCopy;
    [mutablArr removeObjectAtIndex:indexPath.row];
    _historyLocationArray = mutablArr.copy;
    [[ZZUserHelper shareInstance] setLocationArray:_historyLocationArray];
    [_tableView reloadData];

    if (_historyLocationArray.count) {
        _emptyView.hidden = YES;
    }
    else {
        _emptyView.hidden = NO;
    }
}

#pragma mark - response method
- (void)selecteMyLocation:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view.tag >= _user.userGooToAddress.count) {
        return;
    }
    ZZMyLocationModel *model = _user.userGooToAddress[recognizer.view.tag];
    ZZRentDropdownModel *dropModel = [[ZZRentDropdownModel alloc] init];
    dropModel.city = model.city;
    dropModel.province = model.province;
    dropModel.detaiString = model.address;
    dropModel.name = model.simple_address;
    dropModel.address_lat = model.address_lat;
    dropModel.address_lng = model.address_lng;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.address_lat longitude:model.address_lng];
    dropModel.location = location;
    if (_delegate && [_delegate respondsToSelector:@selector(selectLocation:)]) {
        [_delegate selectLocation:dropModel];
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyLocationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRentDropdownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentDropdownCell" forIndexPath:indexPath];
    ZZRentDropdownModel *model = self.historyLocationArray[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.contentLabel.text = model.detaiString;
    cell.touchClear = ^{
        [self touchClearWithIndexPath:indexPath];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZRentDropdownModel *model = self.historyLocationArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectLocation:)]) {
        [_delegate selectLocation:model];
    }
}

#pragma mark - Layout
- (void)layout {
    self.clipsToBounds = YES;
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.seperateLine];
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@7.0);
    }];
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view addSubview:self.titleLabel];
    [view addSubview:self.scrollView];
    [self addSubview:self.tableView];
    [self addSubview:self.emptyView];
    

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(_user.userGooToAddress.count == 0 ? @0 : @110.0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view).offset(16);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(view);
        make.height.equalTo(@44);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(view.mas_bottom);
    }];
    
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(view.mas_bottom);
    }];
    
    [self createMyLocations];
}

- (void)createMyLocations {
    CGFloat offsetX = 15.0;
    __block ZZRentDropdownMyLocationView *lastView = nil;
    
    NSMutableArray<ZZMyLocationModel *> *citys = @[].mutableCopy;
    [_user.userGooToAddress enumerateObjectsUsingBlock:^(ZZMyLocationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.city isEqualToString:[ZZUserHelper shareInstance].loginer.rent.city.name]) {
            [citys addObject:obj];
        }
    }];

    
    for (NSInteger i = 0; i < citys.count; i++) {
        ZZMyLocationModel *model = citys[i];
        ZZRentDropdownMyLocationView *view = [[ZZRentDropdownMyLocationView alloc] init];
        view.tag = i;
        [view configureTitle:model.simple_address
                    distance:[model currentDistance:[ZZUserHelper shareInstance].location]];
        CGFloat x = offsetX;
        if (i != 0) {
            x = lastView.right + 12.0;
        }
        view.frame = CGRectMake(x, 0.0, view.totalWidth, 44.0);
        [_scrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selecteMyLocation:)];
        [view addGestureRecognizer:tap];
        lastView = view;
    }
    
    _scrollView.contentSize = CGSizeMake(lastView.right + 15.0, 0.0);
}

#pragma mark - getters and setters
- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _seperateLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"TA的常去地点";
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 47.5;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        
        [_tableView registerClass:[ZZRentDropdownCell class] forCellReuseIdentifier:@"ZZRentDropdownCell"];
    }
    return _tableView;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.hidden = YES;
        _emptyView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *emptyImgView = [[UIImageView alloc] init];
        emptyImgView.image = [UIImage imageNamed:@"icon_rent_empty"];
        emptyImgView.contentMode = UIViewContentModeCenter;
        [_emptyView addSubview:emptyImgView];
        
        [emptyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_emptyView.mas_centerY).offset(-3);
            make.centerX.mas_equalTo(_emptyView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(27, 19));
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.textColor = kGrayTextColor;
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.text = @"您还没有地址历史纪录";
        [_emptyView addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_emptyView.mas_centerX);
            make.top.mas_equalTo(_emptyView.mas_centerY).offset(3);
        }];
    }
    return _emptyView;
}

- (NSArray *)historyLocationArray {
    if (!_historyLocationArray) {
        _historyLocationArray = [ZZUserHelper shareInstance].locationArray;
    }
    return _historyLocationArray;
}

@end

@interface ZZRentDropdownMyLocationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, assign) double distanceWidth;

@property (nonatomic, assign) double titleWidth;

@end

@implementation ZZRentDropdownMyLocationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

#pragma mark - public Method
- (void)configureTitle:(NSString *)title distance:(double)distance {
    _titleLabel.text = title;
    _distanceLabel.text = [NSString stringWithFormat:@"• %.2fKM", distance];
    [self calculateFrames];
    [self layout];
}

#pragma mark - private method
- (void)calculateFrames {
    CGFloat distanceWidth = [NSString findWidthForText:_distanceLabel.text havingWidth:SCREEN_WIDTH andFont:self.distanceLabel.font];
    _distanceWidth = distanceWidth;
    
    CGFloat titleWidth = [NSString findWidthForText:_titleLabel.text havingWidth:CGFLOAT_MAX andFont:self.titleLabel.font];
    _titleWidth = titleWidth;
    _totalWidth = 15 + _titleWidth + 5.0 + distanceWidth + 15.0;
}

#pragma mark - Layout
- (void)createViews {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    self.layer.cornerRadius = 22.0;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.distanceLabel];
}

- (void)layout {
    _titleLabel.frame = CGRectMake(15.0, 0.0, _titleWidth, 44.0);
    _distanceLabel.frame = CGRectMake(_titleLabel.right + 5.0, 0.0, _distanceWidth, 44.0);
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

@end
