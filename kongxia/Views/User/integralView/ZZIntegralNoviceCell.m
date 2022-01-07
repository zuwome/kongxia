//
//  ZZIntegralNoviceCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralNoviceCell.h"
#import "ZZIntegralNoviceRollingView.h"
@interface ZZIntegralNoviceCell()<ZZIntegralNoviceRollingViewDelegate>
@property (nonatomic,strong)ZZIntegralNoviceRollingView *rollingView;
@property (nonatomic,strong)UILabel *newtaskLab;
@property (nonatomic,strong) UIImageView *newtaskImageView;
@property (nonatomic,strong) UIImageView *integralNewView;



@end
@implementation ZZIntegralNoviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.integralNewView];
        [self.contentView addSubview:self.newtaskImageView];
        [self.contentView addSubview:self.newtaskLab];
        [self.contentView addSubview:self.rollingView];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.integralNewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(26);
    }];
    [self.newtaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(2+17);
        make.size.mas_equalTo(CGSizeMake(16.5, 18));
    }];
    [self.newtaskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.newtaskImageView.mas_centerY);
        make.left.equalTo(self.newtaskImageView.mas_right).offset(6);
    }];
    [self.rollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.newtaskImageView.mas_bottom).offset(2);
        make.bottom.offset(0);
    }];
}

- (void)setModel:(ZZIntegralModel *)model {
    if (_model != model) {
        _model = model;
        self.rollingView.modelArray = model.rookie_task;
    }
}
#pragma mark - 懒加载

-(UIImageView *)newtaskImageView {
    if (!_newtaskImageView) {
        _newtaskImageView = [[UIImageView alloc]init];
        _newtaskImageView.contentMode = UIViewContentModeScaleAspectFit;
        _newtaskImageView.image = [UIImage imageNamed:@"icXsrwWdjf"];
    }
    return _newtaskImageView;
}

/**
 新手任务

 */
-(UILabel *)newtaskLab {
    if (!_newtaskLab) {
        _newtaskLab = [[UILabel alloc]init];
        _newtaskLab.text = @"新手任务";
        _newtaskLab.textColor = kBlackColor;
        _newtaskLab.textAlignment = NSTextAlignmentCenter;
        _newtaskLab.font = ADaptedFontMediumSize(17);
    }
    return _newtaskLab;
}

- (ZZIntegralNoviceRollingView *)rollingView {
    if (!_rollingView) {
        _rollingView = [[ZZIntegralNoviceRollingView alloc]initWithFrame:CGRectZero cellArray:@[@"ZZIntegralNewCell"]];
        _rollingView.delegate = self;
        _rollingView.loop = NO;
        _rollingView.automaticallyScrollDuration= 0;
    }
    return _rollingView;
}
- (UIImageView *)integralNewView {
    if (!_integralNewView) {
        _integralNewView = [[UIImageView alloc]init];
        _integralNewView.image = [UIImage imageNamed:@"integralNew"];
        _integralNewView.contentMode = UIViewContentModeScaleToFill;
    }
    return _integralNewView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZIntegralNewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZIntegralNewCellID" forIndexPath:indexPath];
    cell.model = self.model.rookie_task[indexPath.item];
    WS(weakSelf);
    __weak typeof(cell)weakSelfCell = cell;
    cell.goToComplete = ^(ZZIntegralNewCell *curentCell) {
        if (weakSelf.goToComplete) {
            weakSelf.goToComplete(weakSelfCell.model,curentCell);
        }
    };
    return cell;
}

@end
