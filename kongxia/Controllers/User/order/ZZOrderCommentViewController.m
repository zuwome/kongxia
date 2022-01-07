//
//  ZZOrderCommentViewController.m
//  zuwome
//
//  Created by angBiu on 2017/3/31.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZOrderCommentViewController.h"

#import "TPKeyboardAvoidingTableView.h"
#import "ZZCommentStarCell.h"
#import "ZZCommentLabelCell.h"
#import "ZZCommentInputCell.h"

@interface ZZOrderCommentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, assign) int currentScore;
@property (nonatomic, strong) NSString *selectLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSDictionary *commentDict;

@end

@implementation ZZOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"评价";
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)loadData
{
    _labelHeight = 90 + 12;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.applyBtn];
}

- (void)setComments:(NSInteger)index
{
    CGFloat offset = 14;
    __block CGFloat labelWidth = 0;
    __block NSInteger j = 0;
    NSArray *array = [self.commentDict objectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ZZHUD dismiss];
        
        CGFloat width = [ZZUtils widthForCellWithText:obj fontSize:14] + 16;
        if (labelWidth + offset + width >= SCREEN_WIDTH - 30) {
            labelWidth = 0;
            j++;
        } else {
            labelWidth = labelWidth + width + offset;
        }
    }];
    
    _labelArray = [NSMutableArray arrayWithArray:array];
    _labelHeight = j*(26+offset) + 26 + 90 + 24;
    
    if (_tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            ZZCommentStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"star"];
            cell.currentScore = ^(int score) {
                weakSelf.currentScore = score;
                weakSelf.applyBtn.backgroundColor = kYellowColor;
                weakSelf.applyBtn.userInteractionEnabled = YES;
                [weakSelf setComments:score];
            };
            if (self.currentScore) {
                cell.starView.currentScore = self.currentScore;
            }
            return cell;
        }
            break;
        case 1:
        {
            ZZCommentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"label"];
            cell.labelArray = _labelArray;
            cell.chooseLabel = ^(NSString *label) {
                weakSelf.selectLabel = label;
            };
            return cell;
        }
            break;
        default:
        {
            ZZCommentInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"input"];
            self.textView = cell.textView;
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 132;
        }
            break;
        case 1:
        {
            return _labelHeight;
        }
            break;
        default:
        {
            return 150;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = kBGColor;
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? 0.1:8;
}

#pragma mark -

- (void)applyBtnClick
{
    NSMutableDictionary *param = [@{@"score":[NSNumber numberWithInt:self.currentScore]} mutableCopy];
    if (!isNullString(self.selectLabel)) {
        [param setObject:@[self.selectLabel] forKey:@"content"];
    }
    if (!isNullString(self.textView.text)) {
        [param setObject:self.textView.text forKey:@"feeling"];
    }
    _applyBtn.userInteractionEnabled = NO;
    [ZZHUD showWithStatus:@"正在发布评论..."];
    [ZZOrder commentOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _applyBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"评论成功"];
            if (_successCallBack) {
                _successCallBack();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - lazyload

- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[ZZCommentStarCell class] forCellReuseIdentifier:@"star"];
        [_tableView registerClass:[ZZCommentLabelCell class] forCellReuseIdentifier:@"label"];
        [_tableView registerClass:[ZZCommentInputCell class] forCellReuseIdentifier:@"input"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)applyBtn
{
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50-SafeAreaBottomHeight, SCREEN_WIDTH, 50)];
        [_applyBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _applyBtn.backgroundColor = HEXCOLOR(0xD8D8D8);
        _applyBtn.userInteractionEnabled = NO;
        [_applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (NSDictionary *)commentDict
{
    if (!_commentDict) {
        _commentDict = [ZZUserHelper shareInstance].configModel.comments;
        if (_commentDict == nil) {
            _commentDict = @{@"1":@[@"迟到",@"提早离开",@"心不在焉",@"一直玩手机",@"大量额外花费",@"本人与资料不符"],
                             @"2":@[@"迟到",@"提早离开",@"心不在焉",@"玩手机",@"额外花费",@"本人与资料不符"],
                             @"3":@[@"迟到",@"提早离开",@"心不在焉",@"没共同话题",@"玩手机",@"额外花费",@"本人与资料一致"],
                             @"4":@[@"迟到",@"提早离开",@"心不在焉",@"共同话题少",@"玩手机",@"额外花费",@"本人与资料一致"],
                             @"5":@[@"准时",@"气质好",@"态度非常好",@"很健谈",@"形象佳"]};
        }
    }
    return _commentDict;
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
