//
//  ZZAttentSortTypeView.m
//  zuwome
//
//  Created by angBiu on 2016/12/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAttentSortTypeView.h"

@interface ZZAttentSortTypeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZZAttentSortTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x3F3A3A);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _selectedImgView = [[UIImageView alloc] init];
        _selectedImgView.image = [UIImage imageNamed:@"icon_type_selected"];
        [self.contentView addSubview:_selectedImgView];
        
        [_selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15.5, 11));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

@end

@interface ZZAttentSortTypeView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) BOOL isViewDown;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZZAttentSortTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgBtn];
        [self addSubview:self.topView];
    }
    
    return self;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZAttentSortTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZAttentSortTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == _selectedIndex) {
        cell.selectedImgView.hidden = NO;
        cell.titleLabel.textColor = kYellowColor;
    } else {
        cell.selectedImgView.hidden = YES;
        cell.titleLabel.textColor = HEXCOLOR(0x3F3A3A);
    }
    cell.lineView.hidden = NO;
    cell.titleLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self viewUp];
    if (_selectedIndex != indexPath.row) {
        if (_selectedCallBack) {
            _selectedCallBack();
        }
        _typeLabel.text = self.dataArray[indexPath.row];
        _selectedIndex = indexPath.row;
        [self.tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Animation

- (void)typeBtnClick
{
    if (_isViewDown) {
        [self viewUp];
    } else {
        [self viewDown];
    }
}

- (void)viewUp
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 0;
        self.arrowImgView.transform = CGAffineTransformMakeRotation(1/2*M_PI);
    } completion:^(BOOL finished) {
        _isViewDown = NO;
        _bgBtn.hidden = YES;
        _bgBtn.height = 0;
    }];
}

- (void)viewDown
{
    _bgBtn.hidden = NO;
    _bgBtn.height = SCREEN_HEIGHT - 64;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 250;
        self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        _isViewDown = YES;
    }];
}

#pragma mark - lazyload

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _bgBtn.backgroundColor = HEXACOLOR(0x202020, 0.8);
        _bgBtn.hidden = YES;
        [_bgBtn addTarget:self action:@selector(viewUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        _topView.backgroundColor = HEXCOLOR(0xE2E2E4);
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HEXCOLOR(0x3F3A3A);
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.text = @"100位关注用户";
        [_topView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topView.mas_left).offset(15);
            make.centerY.mas_equalTo(_topView.mas_centerY);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_type_triangle"];
        [_topView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_topView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_topView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 10));
        }];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0x3F3A3A);
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.text = @"默认排序";
        [_topView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-3);
            make.centerY.mas_equalTo(_topView.mas_centerY);
        }];
        
        UIButton *typeBtn = [[UIButton alloc] init];
        [typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:typeBtn];
        
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_topView);
        }];
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.height, SCREEN_WIDTH, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"默认排序",@"等级最高",@"离我最近",@"女士优先",@"男士优先"];
    }
    return _dataArray;
}

//防止按钮超出不能点击
- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if (v == nil) {
        CGPoint touchPoint = [_bgBtn convertPoint:point fromView:self];
        if (CGRectContainsPoint(_bgBtn.bounds, touchPoint)) {
            v = _bgBtn;
        }
        CGPoint tp = [self.tableView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.tableView.bounds, tp)) {
            v = self.tableView;
        }
    }
    
    return v;
}

@end
