//
//  ZZFilterViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterViewController.h"
#import "ZZFilterInputViewController.h"

#import "ZZFilterTitleCell.h"
#import "ZZFilterRangeCell.h"
#import "ZZFilterTimeCell.h"
#import "ZZFilterHeadView.h"

#import "ZZFilterModel.h"

@interface ZZFilterViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView                 *_tableView;
    ZZFilterHeadView            *_headView;
    
    NSInteger                   _selectIndex;
    BOOL                        _show;
    
    UILabel                     *_ageLabel;
    UILabel                     *_heightLabel;
    UILabel                     *_priceLabel;
}

@property (nonatomic, strong) ZZFilterModel *model;

@end

@implementation ZZFilterViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createNavigationRightDoneBtn {
    [super createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.navigationRightDoneBtn setTitle:@"确定" forState:(UIControlStateHighlighted)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"筛选";
    
    [self createNavigationRightDoneBtn];
    
    _model = [[ZZFilterModel alloc] init];
    
    if ([_filter objectForKey:@"age"]) {
        _model.ageStr = [NSString stringWithFormat:@"%@岁",[_filter objectForKey:@"age"]];
    } else {
        _model.ageStr = @"全部";
    }
    if ([_filter objectForKey:@"height"]) {
        _model.heightStr = [NSString stringWithFormat:@"%@cm",[_filter objectForKey:@"height"]];
    } else {
        _model.heightStr = @"全部";
    }
    if ([_filter objectForKey:@"price"]) {
        _model.moneyStr = [NSString stringWithFormat:@"%@元",[_filter objectForKey:@"price"]];
    } else {
        _model.moneyStr = @"全部";
    }
    
    NSArray *timeArray = [[_filter objectForKey:@"time"] componentsSeparatedByString:@","];
    if (timeArray) {
        _model.timeArray = [NSMutableArray arrayWithArray:timeArray];
    } else {
        _model.timeArray = [NSMutableArray array];
    }
    
    [self createViews];
}

- (void)createViews
{
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightDoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self createHeadView];
}

- (void)createHeadView
{
    __weak typeof(self)weakSelf = self;
    _headView = [[ZZFilterHeadView alloc] init];
    _headView.touchInput = ^{
        [weakSelf inputBtnClick];
    };
    CGFloat height = [_headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _tableView.tableHeaderView = _headView;
    
    if ([_filter objectForKey:@"gender"]) {
        int gender = [[_filter objectForKey:@"gender"] unsignedIntValue];
        if (gender == 1) {
            _model.sexTypeStr = @"男";
            [_headView.selectView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            _model.sexTypeStr = @"女";
            [_headView.selectView selectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    } else {
        _model.sexTypeStr = @"全部";
        [_headView.selectView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    _headView.selectView.didSeletedOptions = ^(NSMutableArray *items) {
        weakSelf.model.sexTypeStr = [[items lastObject] trimmedString];
    };
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;   //新版首页筛选条件去除档期选项
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 6) {
        ZZFilterTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
        
        if (!cell) {
            cell = [[ZZFilterTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timecell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectView.didSeletedOptions = ^(NSMutableArray *opts) {
            weakSelf.model.timeArray = opts;
        };
        if (_model.timeArray.count != 0) {
            [_model.timeArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger i = [cell.selectView.options indexOfObject:str];
                if (i != NSNotFound) {
                    [cell.selectView selectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
            }];
        }
        
        return cell;
    } else if (indexPath.row % 2 == 0) {
        
        ZZFilterTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titlecell"];
        
        if (!cell) {
            cell = [[ZZFilterTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titlecell"];
        }
        
        [cell setData:_model indexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
            {
                _ageLabel = cell.contentLabel;
            }
                break;
            case 2:
            {
                _heightLabel = cell.contentLabel;
            }
                break;
            case 4:
            {
                _priceLabel = cell.contentLabel;
            }
                break;
            default:
                break;
        }
        
        return cell;
    } else {
        ZZFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rangecell"];
        
        if (!cell) {
            cell = [[ZZFilterRangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rangecell"];
        }
        cell.sliderChange = ^(NSString *value) {
            [weakSelf sliderValueChange:indexPath valueStr:value];
        };
        [cell setData:_model indexPath:indexPath];
        
        return cell;
    }
}

- (void)sliderValueChange:(NSIndexPath *)indexPath valueStr:(NSString *)valueStr
{
    switch (indexPath.row) {
        case 1:
        {
            _model.ageStr = valueStr;
            _ageLabel.text = valueStr;
        }
            break;
        case 3:
        {
            _model.heightStr = valueStr;
            _heightLabel.text = valueStr;
        }
            break;
        case 5:
        {
            _model.moneyStr = valueStr;
            _priceLabel.text = valueStr;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        return 100;
    }
    if (indexPath.row % 2 == 0) {
        return 50;
    } else {
        return indexPath.row == _selectIndex + 1 && _show ? 80:0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        
        if (indexPath.row == _selectIndex) {
            if (_show) {
                _show = NO;
            } else {
                _show = YES;
            }
        } else {
            _show = YES;
        }
        _selectIndex = indexPath.row;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = kBGColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kGrayTextColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"邀约对象";
    [headView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

#pragma mark - UIButtonMethod

- (void)rightDoneBtnClick
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    if (![_model.ageStr isEqualToString:@"全部"]) {
        [aDict setObject:[_model.ageStr stringByReplacingOccurrencesOfString:@"岁" withString:@""] forKey:@"age"];
    }
    if (![_model.heightStr isEqualToString:@"全部"]) {
        [aDict setObject:[_model.heightStr stringByReplacingOccurrencesOfString:@"cm" withString:@""] forKey:@"height"];
    }
    if (![_model.moneyStr isEqualToString:@"全部"]) {
        [MobClick event:Event_search_price];
        [aDict setObject:[_model.moneyStr stringByReplacingOccurrencesOfString:@"元" withString:@""] forKey:@"price"];
    }
    if (![[_model.sexTypeStr trimmedString] isEqualToString:@"全部"]) {
        if ([[_model.sexTypeStr trimmedString] isEqualToString:@"男"]) {
            [MobClick event:Event_search_man];
            [aDict setObject:@"1" forKey:@"gender"];
        }
        if ([[_model.sexTypeStr trimmedString] isEqualToString:@"女"]) {
            [MobClick event:Event_search_woman];
            [aDict setObject:@"2" forKey:@"gender"];
        }
    }
    if (_model.timeArray.count != 0) {
        [MobClick event:Event_search_time];
        NSString *str = [_model.timeArray componentsJoinedByString:@","];;
        [aDict setObject:str forKey:@"time"];
    }
    if (_filterDone) {
        [self.navigationController popViewControllerAnimated:YES];
        _filterDone(aDict);
    }
}

- (void)inputBtnClick
{
    [MobClick event:Event_search_account];
    ZZFilterInputViewController *controller = [[ZZFilterInputViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
