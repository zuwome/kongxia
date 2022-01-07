//
//  ZZSignRecommendViewController.m
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSignRecommendViewController.h"

#import "ZZSignRecommendCell.h"

@interface ZZSignRecommendViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *attentBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation ZZSignRecommendViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    _scale = SCREEN_WIDTH/375.0;
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.attentBtn addTarget:self action:@selector(attentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionView];
    self.titleLabel.text = @"推荐达人";
}

- (void)loadData
{
    NSMutableDictionary *aDict = [@{} mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        [aDict setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
        [aDict setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
    }
    [ZZRequest method:@"GET" path:@"/api/recommend/users" params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            self.dataArray = [ZZUser arrayOfModelsFromDictionaries:data error:nil];
            [self.selectedArray addObjectsFromArray:self.dataArray];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSignRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    ZZUser *user = self.dataArray[indexPath.row];
    [cell setData:user];
    if ([self.selectedArray containsObject:user]) {
        cell.statusBtn.selected = YES;
        cell.coverView.hidden = YES;
    } else {
        cell.statusBtn.selected = NO;
        cell.coverView.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZUser *user = self.dataArray[indexPath.row];
    ZZSignRecommendCell *cell = (ZZSignRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedArray containsObject:user]) {
        [self.selectedArray removeObject:user];
        cell.statusBtn.selected = NO;
        cell.coverView.hidden = NO;
    } else {
        [self.selectedArray addObject:user];
        cell.statusBtn.selected = YES;
        cell.coverView.hidden = YES;
    }
}

#pragma mark - UIButtonMethod

- (void)skipBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserDidRegister object:self];
    }];
}

- (void)attentBtnClick
{
    _attentBtn.userInteractionEnabled = NO;
    NSMutableArray *array = [NSMutableArray array];
    for (ZZUser *user in self.selectedArray) {
        [array addObject:user.uid];
    }
    [ZZHUD showWithStatus:@""];
    [ZZRequest method:@"POST" path:@"/api/user/batch_follow" params:@{@"uids":array} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _attentBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"关注成功"];
            [self skipBtnClick];
        }
    }];
}

#pragma mark - lazyload

- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 20, 70, 44)];
        [self.view addSubview:_skipBtn];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_order_right"];
        imgView.userInteractionEnabled = NO;
        [_skipBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_skipBtn.mas_right).offset(-15);
            make.centerY.mas_equalTo(_skipBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 16.5));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"直接进入";
        titleLabel.userInteractionEnabled = NO;
        [_skipBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imgView.mas_left).offset(-6);
            make.centerY.mas_equalTo(_skipBtn.mas_centerY);
        }];
    }
    return _skipBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UIView *bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = NO;
        [self.view addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            make.bottom.mas_equalTo(_collectionView.mas_top);
        }];
        
        UIView *contentBgViwe = [[UIView alloc] init];
        [bgView addSubview:contentBgViwe];
        
        [contentBgViwe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(bgView);
            make.centerY.mas_equalTo(bgView.mas_centerY).offset(10);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:19];
        [contentBgViwe addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(contentBgViwe);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXACOLOR(0x000000, 0.52);
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.text = @"关注即可第一时间获取TA的动态";
        [contentBgViwe addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.mas_equalTo(contentBgViwe);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8);
        }];
    }
    return _titleLabel;
}

- (UIButton *)attentBtn
{
    if (!_attentBtn) {
        _attentBtn = [[UIButton alloc] init];
        [_attentBtn setTitle:@"关注并进入空虾" forState:UIControlStateNormal];
        [_attentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _attentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _attentBtn.layer.cornerRadius = 5;
        _attentBtn.backgroundColor = kYellowColor;
        [self.view addSubview:_attentBtn];
        
        [_attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(15);
            make.right.mas_equalTo(self.view.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-_scale*30);
            make.height.mas_equalTo(@50);
        }];
    }
    return _attentBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        CGFloat width = _scale*100;
        CGFloat space = (SCREEN_WIDTH - 30 - 3*width - 1)/2.0;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 30) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZSignRecommendCell class] forCellWithReuseIdentifier:@"mycell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(SCREEN_WIDTH - 30);
            make.bottom.mas_equalTo(_attentBtn.mas_top).offset(-60*_scale);
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
