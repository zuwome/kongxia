//
//  ZZAddPersonalLabelViewController.m
//  zuwome
//
//  Created by angBiu on 16/6/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAddPersonalLabelViewController.h"
#import "ZZUserLabel.h"

#import "ZZAddLabelCell.h"
#import <YYModel.h>

@interface ZZAddPersonalLabelViewController () <UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) ZZUserLabel *selectLabel;

@end

@implementation ZZAddPersonalLabelViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (UICollectionView *)tagCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(80, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZAddLabelCell class] forCellWithReuseIdentifier:@"mycell"];
    }
    
    return _collectionView;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithArray:_user.tags_new];
    }
    
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.user) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    self.navigationItem.title = @"个人标签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightDoneBtn];
    
    [self sendRequest];
    [self.view addSubview:self.tagCollectionView];
}

- (void)createRightDoneBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(rightDoneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *leftBarButon = [[UIBarButtonItem alloc]initWithCustomView:btn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, leftBarButon];
}

- (void)rightDoneClick
{
    ZZUserLabel *label = [[ZZUserLabel alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    [_selectedArray enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[label toDictionary]];
    }];
    NSDictionary *param = @{@"tags_new":array};
    [label updateDataWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (data) {
            [ZZHUD showSuccessWithStatus:@"更新成功!"];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            _user.tags_new = user.tags_new;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            if (_updateLabel) {
                _updateLabel();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 

- (void)sendRequest
{
    [ZZHUD showWithStatus:@"加载中..."];
    ZZUserLabel *label = [[ZZUserLabel alloc] init];
    [label getData:@"/system/tags" next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _tagArray = [NSArray yy_modelArrayWithClass:[ZZUserLabel class] json:data].mutableCopy;
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZAddLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    
    ZZUserLabel *model = _tagArray[indexPath.row];
    [cell setData:model selected:[self isContain:model]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZUserLabel *model = _tagArray[indexPath.row];
    BOOL contain = [self isContain:model];
    if (contain) {
        [self.selectedArray removeObject:_selectLabel];
    } else {
        
        if (self.selectedArray.count == 5) {
            [ZZHUD showInfoWithStatus:@"最多选择5个标签"];
            return;
        }
        [self.selectedArray addObject:model];
    }
    
    [_collectionView reloadData];
}

- (BOOL)isContain:(ZZUserLabel *)model
{
    __block BOOL contain = NO;
    
    WeakSelf;
    [self.selectedArray enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([label.id isEqualToString:model.id]) {
            contain = YES;
            weakSelf.selectLabel = label;
            *stop = YES;
        }
    }];
    
    return contain;
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
