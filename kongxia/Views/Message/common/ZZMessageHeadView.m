//
//  ZZMessageHeadView.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageHeadView.h"

#define MsgHeaderCollectionCell @"MsgHeaderCollectionCell"

@interface ZZMessageHeadView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation ZZMessageHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createView {
    [self addSubview: self.collection];
}

- (UICollectionView *)collection {
    if (nil == _collection) {
        NSArray *itemArray = self.msgListSystemUIDict[@"title"];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / itemArray.count, MsgHeaderHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MsgHeaderHeight) collectionViewLayout:layout];
        [_collection registerClass:[ZZMessageHeadViewCell class] forCellWithReuseIdentifier:MsgHeaderCollectionCell];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor whiteColor];
    }
    return _collection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *itemArray = self.msgListSystemUIDict[@"title"];
    return itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZMessageHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MsgHeaderCollectionCell forIndexPath:indexPath];
    [cell setMessageStyleWithIndexPath:indexPath uiDict:self.msgListSystemUIDict unReadCountArray:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZMessageHeadViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    !self.systemCellClick ? : self.systemCellClick(cell, indexPath);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)setMsgListSystemUIDict:(NSDictionary *)msgListSystemUIDict {
    _msgListSystemUIDict = msgListSystemUIDict;
    [self createView];
}

@end
