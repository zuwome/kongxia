//
//  ZZUserSkillChooseViewController.m
//  zuwome
//
//  Created by angBiu on 2016/10/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserSkillChooseViewController.h"

#import "TPKeyboardAvoidingCollectionView.h"
#import "ZZChuzuSkillCell.h"
#import "ZZChuzuReusableView.h"

#import <Underscore.h>

@interface ZZUserSkillChooseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TPKeyboardAvoidingCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) ZZChuzuReusableView *resusableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSString *priceStr;

@end

@implementation ZZUserSkillChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"编辑技能";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_topic) {
        _topic = [[ZZTopic alloc] init];
        _topic.skills = (NSMutableArray<ZZSkill> *)self.selectedArray;
    }
    [self loadData];
}

#pragma mark - Loaddata

- (void)loadData
{
    [ZZSkill syncWithParams:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            self.dataArray = [ZZSkill arrayOfModelsFromDictionaries:data error:nil];
            
            // 排除掉其他已经选的
            NSArray *array =  Underscore.reject(self.dataArray, ^BOOL (ZZSkill *skill) {
                return [_extSkills containsObject:skill.name];
            });
            self.dataArray = [NSMutableArray arrayWithArray:array];
            
            // 重新编辑
            [_topic.skills enumerateObjectsUsingBlock:^(ZZSkill *skill, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.selectedArray addObject:skill];
                [self.dataArray addObject:skill];
            }];
            
            _priceStr = _topic.price;
            [self.view addSubview:self.collectionView];
        }
    }];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZChuzuSkillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    
    ZZSkill *skill = self.dataArray[indexPath.row];
    cell.titleLabel.text = skill.name;
    [cell setCellSelected:[self.selectedArray containsObject:skill]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        WeakSelf;
        _resusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath: indexPath];
        _resusableView.textField.text = _priceStr;
        [_resusableView setPriceValue];
        _resusableView.textChange = ^{
            weakSelf.priceStr = weakSelf.resusableView.textField.text;
        };
        _resusableView.textField.valueChanged = ^{
            [weakSelf managerInfoText];
        };
        
        return _resusableView;
    }
    
    return [UIView new];
}

- (void)managerInfoText
{
    if ([_resusableView.textField.text floatValue] > 200) {
        _resusableView.infoLabel.text = @"建议价格可以调低一些哦~人气高了咱再涨";
        if ([_resusableView.textField.text floatValue] > 300) {
            _resusableView.infoLabel.text = @"价格现在不能超过300元/小时";
        }
        if (!_resusableView.showInfo) {
            _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 115);
            [_collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_resusableView.textField becomeFirstResponder];
            });
        }
        _resusableView.showInfo = YES;
    } else {
        if (_resusableView.showInfo) {
            _resusableView.infoLabel.text = nil;
            _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 85);
            [_collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_resusableView.textField becomeFirstResponder];
            });
        }
        _resusableView.showInfo = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSkill *skill = self.dataArray[indexPath.row];
    if ([self.selectedArray containsObject:skill]) {
        [self.selectedArray removeObject:skill];
    } else {
        [self.selectedArray addObject:skill];
    }
    
    ZZChuzuSkillCell *cell = (ZZChuzuSkillCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCellSelected:[self.selectedArray containsObject:skill]];
    
    [self.view endEditing:YES];
}

#pragma mark - UIButtonMethod

- (void)done
{
    if (self.selectedArray.count == 0 ) {
        [ZZHUD showInfoWithStatus:@"至少选择1个技能"];
        return;
    }
    _topic.price = _resusableView.textField.text;
    _topic.skills = (NSMutableArray<ZZSkill> *)self.selectedArray;
    if ([_extPirces containsObject:_topic.price]) {
        [ZZHUD showInfoWithStatus:@"该价格已存在"];
        return;
    }
    
    if (_resusableView.textField.text.length == 0) {
        [ZZHUD showInfoWithStatus:@"请填写价格"];
        return;
    }
    
    if ([_topic.price doubleValue] > 300) {
        [ZZHUD showInfoWithStatus:@"价格不能超过300"];
        return;
    }
    
    if ([_topic.price doubleValue] < 1) {
        [ZZHUD showInfoWithStatus:@"价格最小单位为1"];
        return;
    }
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:
                                   @"^[0-9]+([.][0-9]{1,2})?$" options:NSRegularExpressionCaseInsensitive error:nil];
    if (![regex numberOfMatchesInString:_resusableView.textField.text options:0 range:NSMakeRange(0, [_resusableView.textField.text length])]) {
        [ZZHUD showInfoWithStatus:@"价格错误"];
        return;
    }
    
    if (_isAdd) {
        if (_addCallBack) {
            _addCallBack(_topic);
        }
    } else {
        if (_callBack) {
            _callBack();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazyload

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat width = [ZZUtils widthForCellWithText:@"哈哈哈哈" fontSize:15];
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(width+16, 32);
        _layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 85);
        
        _collectionView = [[TPKeyboardAvoidingCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_layout];
        [_collectionView registerClass:[ZZChuzuSkillCell class] forCellWithReuseIdentifier:@"mycell"];
        [_collectionView registerClass:[ZZChuzuReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
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
