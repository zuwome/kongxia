//
//  ZZTaskChooseViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskChooseViewController.h"

#import "ZZTaskChooseCell.h"

@interface ZZTaskChooseViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZZTaskChooseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择达人任务";
    self.view.backgroundColor = [UIColor clearColor];
    [self loadData];
}

- (void)createViews
{
    UIView *headerView = [self createTableViewHeaderView];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SCREEN_HEIGHT - 400));
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@60);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.leading.trailing.bottom.equalTo(@(0));
    }];
}

- (void)loadData {
    [ZZSkill syncWithParams:@{@"from" : @"pd"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
//            NSMutableArray *array = [ZZSkill arrayOfModelsFromDictionaries:data error:nil].mutableCopy;
//            [array addObject:array.lastObject];
//            self.dataArray = array;
            self.dataArray = [ZZSkill arrayOfModelsFromDictionaries:data error:nil];
            [self createViews];
        }
    }];
}

- (UIView *)createTableViewHeaderView {
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bgWhiteView = [UIView new];
    bgWhiteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bgWhiteView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgWhiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgWhiteView.bounds;
    maskLayer.path = maskPath.CGPath;
    bgWhiteView.layer.mask = maskLayer;
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [dismissBtn setTitle:@"取消" forState:(UIControlStateNormal)];
//    [dismissBtn setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
//    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = CustomFont(15.0);
    [dismissBtn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgWhiteView addSubview:dismissBtn];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"选择邀约主题";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [bgWhiteView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bgWhiteView);
    }];
    
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.leading.equalTo(@15);
        make.height.equalTo(@50);
        make.width.equalTo(@35);
    }];
    return view;
}

- (IBAction)dismissClick:(id)sender {
    BLOCK_SAFE_CALLS(self.dismissBlock);
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZTaskChooseCell class] forCellWithReuseIdentifier:@"mycell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.alwaysBounceVertical = YES;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTaskChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    ZZSkill *skill = self.dataArray[indexPath.row];
    [cell setData:skill];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZSkill *skill = self.dataArray[indexPath.row];
    [self getTask:skill];
}

- (void)getTask:(ZZSkill *)skill {
    
    if (!skill) {
        skill = [[ZZSkill alloc] init];
        skill.id = @"59644d1d2f17ad7a5f145544";
        skill.name = @"在线1对1视频";
        skill.type = 2;
    }
    if (_selectedTask) {
        _selectedTask(skill);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
