//
//  ZZScheduleTableCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZScheduleTableCell.h"
#import "ZZSchduleEditCell.h"

@interface ZZScheduleTableCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UICollectionView *scheduleCollect;

@end

@implementation ZZScheduleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.scheduleCollect];
    [self.scheduleCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
        make.leading.trailing.equalTo(@0);
    }];
}

#pragma mark -- collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZSchduleEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    NSString *scheduleStr = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    if ([self.scheduleArray containsObject:scheduleStr]) {
        cell.cellSelected = YES;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZSchduleEditCell *cell = (ZZSchduleEditCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cellSelected = !cell.cellSelected;
    if (cell.cellSelected) {
        [self.scheduleArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    } else {
        [self.scheduleArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    }
    !self.chooseCallback ? : self.chooseCallback();
}

#pragma mark -- collectionViewDelegate
- (UILabel *)cellTitle {
    if (nil == _cellTitle) {
        _cellTitle = [[UILabel alloc] init];
        _cellTitle.font = [UIFont systemFontOfSize:14];
        _cellTitle.textColor = [UIColor blackColor];
    }
    return _cellTitle;
}
- (UICollectionView *)scheduleCollect {
    if (nil == _scheduleCollect) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 60) / 4, 30);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _scheduleCollect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _scheduleCollect.backgroundColor = [UIColor whiteColor];
        _scheduleCollect.delegate = self;
        _scheduleCollect.dataSource = self;
        _scheduleCollect.showsVerticalScrollIndicator = NO;
        _scheduleCollect.showsHorizontalScrollIndicator = NO;
        _scheduleCollect.bounces = NO;
        [_scheduleCollect registerClass:[ZZSchduleEditCell class] forCellWithReuseIdentifier:ScheduleCellIdentifier];
    }
    return _scheduleCollect;
}

@end
