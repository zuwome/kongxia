//
//  ZZOrderTimeLineView.m
//  zuwome
//
//  Created by angBiu on 16/7/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderTimeLineView.h"
#import "ZZTimelineCell.h"
#import "ZZOrder.h"

@implementation ZZOrderTimeLineView
{
    UIView                  *_bgView;
    UIView                  *_colorView;
    NSArray                 *_dataArray;
}

- (id)initWithFrame:(CGRect)frame order:(ZZOrder *)order
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:_bgView];
        
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = kBlackTextColor;
        _colorView.alpha = 0.0;
        [_bgView addSubview:_colorView];
        
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:15];
        _numberLabel.text = [NSString stringWithFormat:@"订单号：%@",order.id];
        [_bgView addSubview:_numberLabel];
        
      
        
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        [cancelBtn setImage:[UIImage imageNamed:@"icon_order_cancel"] forState:UIControlStateNormal];
     
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT - 120)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZZTimelineCell class] forCellReuseIdentifier:@"timelinecell"];
        [_bgView addSubview:_tableView];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.bottom.equalTo(_tableView.mas_top).offset(-30);
        }];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_tableView.mas_top).offset(-30);
            make.right.mas_equalTo(_bgView.mas_right);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
    }
    
    return self;
}

- (void)setMessageArray:(NSMutableArray *)messageArray
{
    _dataArray = [NSArray arrayWithArray:messageArray];
    [self.tableView reloadData];
    [self showView];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelinecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(ZZTimelineCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell setMessage:_dataArray[indexPath.row] indexPath:indexPath count:_dataArray.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"timelinecell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self setupCell:cell indexPath:indexPath];
    }];
}

#pragma mark - Animation

- (void)showView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _colorView.alpha = 0.88;
    }];
}

- (void)hideView
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _colorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
