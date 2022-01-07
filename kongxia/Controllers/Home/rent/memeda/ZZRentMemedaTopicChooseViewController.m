//
//  ZZRentMemedaTopicChooseViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaTopicChooseViewController.h"

#import "ZZRentMemedaTopicCell.h"

#import "ZZMemedaTopicModel.h"

@interface ZZRentMemedaTopicChooseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView                    *_collectionView;
    NSArray                             *_dataArray;
}

@end

@implementation ZZRentMemedaTopicChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"添加标签";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createViews];
    [self loadData];
}

- (void)loadData
{
    ZZMemedaTopicModel *topicModel = [[ZZMemedaTopicModel alloc] init];
    [topicModel getMemedaTopics:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _dataArray = [ZZMemedaTopicModel arrayOfModelsFromDictionaries:data error:nil];
            [_collectionView reloadData];
        }
    }];
}

- (void)createViews
{
    CGFloat width = (SCREEN_WIDTH - 30 - 8)/2;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, 50);
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = kBGColor;
    [_collectionView registerClass:[ZZRentMemedaTopicCell class] forCellWithReuseIdentifier:@"mycell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZRentMemedaTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    [cell setData:_dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectCallBack) {
        _selectCallBack(_dataArray[indexPath.row]);
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
