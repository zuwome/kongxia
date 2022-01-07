//
//  ZZNewHomeTopicCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeTopicCell.h"
#import "ZZNewHomeTopicItemCell.h"

@interface ZZNewHomeTopicCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *topicCollection;

@end

@implementation ZZNewHomeTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.topics = [NSArray array];
    
    [self.contentView addSubview:self.topicCollection];
    [self.topicCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setTopics:(NSArray *)topics {
    [super setTopics:topics];
    [self.topicCollection reloadData];
}

#pragma mark -- uicollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topics.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZNewHomeTopicItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicItemCellId forIndexPath:indexPath];
    [cell setTopic:self.topics[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.topicChooseCallback ? : self.topicChooseCallback(self.topics[indexPath.row]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UICollectionView *)topicCollection {
    if (nil == _topicCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AdaptedWidth(375 / 5) - 1, AdaptedWidth(375 / 5));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _topicCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _topicCollection.backgroundColor = [UIColor whiteColor];
        _topicCollection.delegate = self;
        _topicCollection.dataSource = self;
        _topicCollection.showsVerticalScrollIndicator = NO;
        _topicCollection.showsHorizontalScrollIndicator = NO;
        _topicCollection.bounces = NO;
        [_topicCollection registerClass:[ZZNewHomeTopicItemCell class] forCellWithReuseIdentifier:TopicItemCellId];
    }
    return _topicCollection;
}

@end
