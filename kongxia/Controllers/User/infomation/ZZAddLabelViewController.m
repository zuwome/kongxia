//
//  ZZAddLabelViewController.m
//  zuwome
//
//  Created by angBiu on 16/6/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAddLabelViewController.h"

#import "ZZAddLabelTableCell.h"
#import "ZZAddLabelCell.h"
#import "ZZUserLabel.h"

@interface ZZAddLabelViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) ZZUserLabel *selectLabel;

@end

@implementation ZZAddLabelViewController

#pragma mark - 懒加载

- (UITableView *)typeTableView
{
    if (!_typeTableView) {
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 78, SCREEN_HEIGHT - 64)];
        _typeTableView.dataSource = self;
        _typeTableView.delegate = self;
        _typeTableView.backgroundColor = HEXCOLOR(0xF8F9E2);
        _typeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _typeTableView;
}

- (UICollectionView *)tagCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(80, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(78, 0, SCREEN_WIDTH - 78, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
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
        _selectedArray = [NSMutableArray array];
        switch (_type) {
            case RentLabelTypeInterest:
            {
                [_selectedArray addObjectsFromArray:_user.interests_new];
            }
                break;
            case RentLabelTypeJob:
            {
                [_selectedArray addObjectsFromArray:_user.works_new];
            }
                break;
            default:
                break;
        }
    }
    
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationLeftButton];
    [self createRightDoneBtn];
    
    [self request];
    [self.view addSubview:self.typeTableView];
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
    NSDictionary *param;
    switch (_type) {
        case RentLabelTypeInterest:
        {
            param = @{@"interests_new":array};
        }
            break;
        case RentLabelTypeJob:
        {
            param = @{@"works_new":array};
        }
            break;
        default:
            break;
    }
    [label updateDataWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            [ZZHUD showSuccessWithStatus:@"更新成功!"];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            
            _user.interests_new = user.interests_new;
            _user.works_new = user.works_new;
            if (_updateLabel) {
                _updateLabel();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Request

- (void)request
{
    [ZZHUD showWithStatus:@"加载中..."];
    ZZUserLabel *label = [[ZZUserLabel alloc] init];
    
    NSString *urlString = @"";
    switch (_type) {
        case RentLabelTypeInterest:
        {
            self.navigationItem.title = @"添加兴趣爱好";
            urlString = @"/system/interests";
        }
            break;
        case RentLabelTypeJob:
        {
            self.navigationItem.title = @"选择职业";
            urlString = @"/system/jobs";
        }
        default:
            break;
    }
    [label getData:urlString next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _dataArray = [NSArray arrayWithArray:data];
            _tagArray = [NSMutableArray array];
            _typeArray = [NSMutableArray array];
            [_dataArray enumerateObjectsUsingBlock:^(NSDictionary *aDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *cateDict = nil;
                switch (_type) {
                    case RentLabelTypeInterest:
                    {
                        cateDict = [aDict objectForKey:@"interest_cate"];
                    }
                        break;
                    case RentLabelTypeJob:
                    {
                        cateDict = [aDict objectForKey:@"job_cate"];
                    }
                        break;
                    default:
                        break;
                }
                ZZUserLabel *userLabel = [[ZZUserLabel alloc] initWithDictionary:cateDict error:nil];
                [_typeArray addObject:userLabel];
            }];
            
            if (_dataArray.count) {
                [self manageTagViewWithDict:_dataArray[0]];
                [_typeTableView reloadData];
            }
        }
    }];
}

- (void)manageTagViewWithDict:(NSDictionary *)aDict
{
    NSArray *subArray = nil;
    switch (_type) {
        case RentLabelTypeInterest:
        {
            subArray = [aDict objectForKey:@"sub_interests"];
        }
            break;
        case RentLabelTypeJob:
        {
            subArray = [aDict objectForKey:@"sub_jobs"];
        }
            break;
        default:
            break;
    }
    
    [_tagArray removeAllObjects];
    _tagArray = [ZZUserLabel arrayOfModelsFromDictionaries:subArray error:nil];
    [_collectionView reloadData];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZAddLabelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZAddLabelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZUserLabel *label = _typeArray[indexPath.row];
    cell.titleLabel.text = label.content;
    if (_selectIndex == indexPath.row) {
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = kYellowColor;
    } else {
        cell.bgView.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = kBlackTextColor;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex != indexPath.row) {
        _selectIndex = indexPath.row;
        [_typeTableView reloadData];
        
        [self manageTagViewWithDict:_dataArray[indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        if (self.selectedArray.count == _maxCount) {
            [ZZHUD showInfoWithStatus:[NSString stringWithFormat:@"最多选择%ld个标签",_maxCount]];
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
        if ([label.labelId isEqualToString:model.labelId]) {
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
