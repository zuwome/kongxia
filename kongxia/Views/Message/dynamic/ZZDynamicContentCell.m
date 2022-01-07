//
//  ZZDynamicContentCell.m
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDynamicContentCell.h"
#import "ZZAttentDynamicMMDCell.h"
#import "ZZAttentDynamicUserCell.h"

@implementation ZZDynamicContentCell
{
    NSInteger                       _type;//1：显示用户 2:显示时刻 3：显示么么答
    
    CGFloat                         _width;
    UIButton                        *_statusBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    
    WeakSelf;
    self.headImgView.touchHead = ^{
        [weakSelf headImgClick];
    };
    self.typeImgView.hidden = NO;
    self.nameLabel.text = @"潇洒电线杆电线杆电线杆";
    [self.levelImgView setLevel:1];
    self.timeLabel.text = @" 15分钟前";
    self.contentLabel.text = @"回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元";
    self.statusLabel.text = @"收起";
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_width);
    }];
}

- (void)setData:(ZZMessageAttentDynamicModel *)model
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    } else {
        [_dataArray removeAllObjects];
    }
    __weak typeof(self)weakSelf = self;
    if (model.users.count) {
        _type = 1;
        if (model.users.count > 4) {
            _statusBtn.hidden = NO;
        } else {
            _statusBtn.hidden = YES;
        }
        if (model.show) {
            [_dataArray addObjectsFromArray:model.users];
        } else {
            [model.users enumerateObjectsUsingBlock:^(ZZUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 3) {
                    *stop = YES;
                } else {
                    [weakSelf.dataArray addObject:user];
                }
            }];
        }
    } else if (model.sks.count) {
        _type = 2;
        if (model.sks.count > 4) {
            _statusBtn.hidden = NO;
        } else {
            _statusBtn.hidden = YES;
        }
        if (model.show) {
            [_dataArray addObjectsFromArray:model.sks];
        } else {
            [model.sks enumerateObjectsUsingBlock:^(ZZSKModel *skModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 3) {
                    *stop = YES;
                } else {
                    [weakSelf.dataArray addObject:skModel];
                }
            }];
        }
    } else {
        _type = 3;
        if (model.mmds.count > 4) {
            _statusBtn.hidden = NO;
        } else {
            _statusBtn.hidden = YES;
        }
        if (model.show) {
            [_dataArray addObjectsFromArray:model.mmds];
        } else {
            [model.mmds enumerateObjectsUsingBlock:^(ZZMMDModel *mmdModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 3) {
                    *stop = YES;
                } else {
                    [weakSelf.dataArray addObject:mmdModel];
                }
            }];
        }
    }
    self.recommendView.hidden = YES;
    if ([model.type isEqualToString:@"mmd_tip"] || [model.type isEqualToString:@"sk_tip"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_packet"];
        if (model.star == 1) {
            self.recommendView.hidden = NO;
        }
    } else if ([model.type isEqualToString:@"following"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_attent"];
    } else if ([model.type isEqualToString:@"mmd_like"] || [model.type isEqualToString:@"sk_like"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_zan"];
    } else if ([model.type isEqualToString:@"mmd_reply"] || [model.type isEqualToString:@"sk_reply"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_comment"];
    }
    NSInteger count = self.dataArray.count / 4.1;
    CGFloat height = (count + 1)*_width + count*10;
    if (self.dataArray.count == 0) {
        height = 0;
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    [_headImgView setUser:model.from width:38 vWidth:8];
    _nameLabel.text = model.from.nickname;
    _timeLabel.text = model.created_at_text;
    _contentLabel.text = model.content;
    [_levelImgView setLevel:model.from.level];
    
    CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:11];
    CGFloat maxWidth = SCREEN_WIDTH - 10 - 38 - 3 - 30 - 8 - 5 - 30 - 5 - timeWidth - 10;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:13];
    if (nameWidth>maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    if (model.show) {
        _statusLabel.text = @"收起";
        _statusImgView.image = [UIImage imageNamed:@"icon_dynamic_attent_up"];
    } else {
        _statusLabel.text = @"展开";
        _statusImgView.image = [UIImage imageNamed:@"icon_dynamic_attent_down"];
    }
    
    [_collectionView reloadData];
}

#pragma mark - UIButtonMethod

- (void)statusBtnClick
{
    if (_touchStatus) {
        _touchStatus();
    }
}

- (void)headImgClick
{
    if (_touchHead) {
        _touchHead();
    }
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 2 || _type == 3) {
        ZZAttentDynamicMMDCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mmdcell" forIndexPath:indexPath];
        if (_type == 2) {
            ZZSKModel *model = _dataArray[indexPath.row];
            [cell.headImgView sd_setImageWithURL:[model.video.cover_url qiniuURL]];
        } else {
            ZZMMDModel *model = _dataArray[indexPath.row];
            if (model.answers.count) {
                ZZMMDAnswersModel *answerModel = model.answers[0];
                [cell.headImgView sd_setImageWithURL:[answerModel.video.cover_url qiniuURL]];
            }
        }
        return cell;
    } else {
        ZZAttentDynamicUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"usercell" forIndexPath:indexPath];
        [cell setUser:_dataArray[indexPath.row] width:_width];
        cell.headImgView.userInteractionEnabled = NO;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_type) {
        case 1:
        {
            if (_userSelectIndex) {
                _userSelectIndex(indexPath.row);
            }
        }
            break;
        case 2:
        {
            if (_skSelectIndex) {
                _skSelectIndex(indexPath.row);
            }
        }
            break;
        case 3:
        {
            if (_mmdSelectIndex) {
                _mmdSelectIndex(indexPath.row);
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazyload

- (ZZHeadImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
    }
    return _headImgView;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(18);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@1.5);
        }];
        
        _typeImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineView.mas_centerX);
            make.centerY.mas_equalTo(_headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _typeImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kYellowColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(8);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
    }
    return _nameLabel;
}

- (ZZLevelImgView *)levelImgView
{
    if (!_levelImgView) {
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
    }
    return _levelImgView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        }];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-65);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
        }];
    }
    return _contentLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusBtn = [[UIButton alloc] init];
        [_statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.clipsToBounds = YES;
        _statusBtn.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_statusBtn];
        
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(_contentLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(60, 25));
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = kYellowColor;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.userInteractionEnabled = NO;
        _statusLabel.backgroundColor = [UIColor whiteColor];
        [_statusBtn addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_statusBtn.mas_right).offset(-20);
            make.top.mas_equalTo(_statusBtn.mas_top);
        }];
        
        _statusImgView = [[UIImageView alloc] init];
        _statusImgView.contentMode = UIViewContentModeScaleToFill;
        _statusImgView.userInteractionEnabled = NO;
        _statusImgView.backgroundColor = [UIColor whiteColor];
        [_statusBtn addSubview:_statusImgView];
        
        [_statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_statusBtn.mas_right);
            make.centerY.mas_equalTo(_statusLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 8));
        }];
    }
    return _statusLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGFloat scale = SCREEN_WIDTH/375.0;
        _width = (SCREEN_WIDTH - 10 - 40 - 18 - 1.5 - 10 - 3*15*scale)/4.0;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(_width, _width);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[ZZAttentDynamicMMDCell class] forCellWithReuseIdentifier:@"mmdcell"];
        [_collectionView registerClass:[ZZAttentDynamicUserCell class] forCellWithReuseIdentifier:@"usercell"];
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.left.mas_equalTo(_headImgView.mas_right).offset(18+1.5+10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return _collectionView;
}

- (ZZDynamicRecomendView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[ZZDynamicRecomendView alloc] init];
        [self.contentView addSubview:_recommendView];
        
        [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return _recommendView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
