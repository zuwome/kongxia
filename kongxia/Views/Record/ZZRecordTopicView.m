//
//  ZZRecordTopicView.m
//  zuwome
//
//  Created by angBiu on 2017/4/26.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordTopicView.h"

@interface ZZRecordTopicCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZTopicModel *)model;

@end

@implementation ZZRecordTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_record_topic"];
        [self.contentView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(17, 15));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(8);
            make.centerY.mas_equalTo(imgView.mas_centerY);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HEXACOLOR(0xffffff, 0.7);
        _countLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXACOLOR(0xffffff, 0.7);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_countLabel.mas_right);
            make.top.mas_equalTo(imgView.mas_bottom).offset(8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
            make.width.mas_equalTo(SCREEN_WIDTH - 15 - 17 - 8 - 20);
        }];
    }
    
    return self;
}

- (void)setData:(ZZTopicModel *)model
{
    _titleLabel.text = model.group.content;
    _countLabel.text = [NSString stringWithFormat:@"%ld人围观",model.group.browser_count];
    _contentLabel.text = model.group.desc;
}

@end

@interface ZZRecordTopicView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZRecordTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:effectview];
        
        self.titleLabel.text = @"添加话题 获得更多关注";
        [self bringSubviewToFront:self.bgView];
        [self.bgView addSubview:self.tableView];
        [self loadData];
        
    }
    
    return self;
}

#pragma mark - 

- (void)loadData
{
    WeakSelf;
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZTopicModel *model = [weakSelf.dataArray lastObject];
        [self pullRequest:model.sort_value];
    }];
    [self pullRequest:nil];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSDictionary *aDict = nil;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    }
    [ZZTopicModel getSKTopicWithParam:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSArray *array = [ZZTopicModel arrayOfModelsFromDictionaries:data error:nil];
            if (!sort_value && _labelId) {
                for (ZZTopicModel *model in array) {
                    if ([model.group.groupId isEqualToString:_labelId]) {
                        [self chooseTopic:model];
                        break;
                    }
                }
            }
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.dataArray addObjectsFromArray:array];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - private

- (void)show
{
    _bgView.top = -SCREEN_HEIGHT;
    self.hidden = NO;
    [[self superview] bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top = 0;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disssMiss {
    if (self.closeClickCallBack) {
        self.closeClickCallBack();
    }
    [self hide];
}
- (void)hide
{
    _bgView.top = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top = -SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZRecordTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(ZZRecordTopicCell *)cell indexPath:(NSIndexPath *)indexPath
{
    ZZTopicModel *model = self.dataArray[indexPath.row];
    [cell setData:model];
    if ([model.group.groupId isEqualToString:_labelId]) {
        cell.titleLabel.textColor = kYellowColor;
    } else {
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    return [tableView fd_heightForCellWithIdentifier:@"mycell" cacheByIndexPath:indexPath configuration:^(ZZRecordTopicCell *cell) {
        [weakSelf setupCell:cell indexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = HEXACOLOR(0xffffff, 0.7);
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"话题推荐";
    [headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_top).offset(10);
        make.left.mas_equalTo(headView.mas_left).offset(15);
    }];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    
    ZZTopicModel *model = self.dataArray[indexPath.row];
    [self chooseTopic:model];
    _labelId = model.group.groupId;
    [self.tableView reloadData];
}

- (void)chooseTopic:(ZZTopicModel *)model
{
    if (_selectedTopic) {
        _selectedTopic(model.group);
    }
}

#pragma mark - lazyload

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:_bgView];
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, isIPhoneX ? 24 : 0, 60, 60)];
        [leftBtn addTarget:self action:@selector(disssMiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:leftBtn];
        [leftBtn setImage:[UIImage imageNamed:@"icon_record_cancel"] forState:UIControlStateNormal];
        
        UIImageView *titleImgView = [[UIImageView alloc] init];
        titleImgView.image = [UIImage imageNamed:@"icon_record_topic"];
        [_bgView addSubview:titleImgView];
        
        [titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_right);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(17, 15));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleImgView.mas_right).offset(6);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.right.mas_equalTo(_bgView.mas_right).offset(0);
        }];
        
        [_bgView bringSubviewToFront:leftBtn];
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
        [_tableView registerClass:[ZZRecordTopicCell class] forCellReuseIdentifier:@"mycell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
