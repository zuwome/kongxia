//
//  ZZChooseTagViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChooseTagViewController.h"
#import "ZZChooseTagCell.h"

@interface ZZChooseTagViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation ZZChooseTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择技能标签";
    
    [self createNavigationRightDoneBtn];
    [self createView];
    [self getTags];
}

- (void)createNavigationRightDoneBtn {
    [super createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightDoneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)rightDoneBtnClick {
    !self.chooseTagCallback ? : self.chooseTagCallback(self.selectedArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createView {
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

- (void)getTags {
    [[ZZSkillThemesHelper shareInstance] getTagsByCatalogId:self.catalogId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *tagDict in data) {
            ZZSkillTag *tag = [[ZZSkillTag alloc] initWithDictionary:tagDict error:nil];
            [tempArray addObject:tag];
        }
        self.tagsArray = [tempArray copy];
        [self.collection reloadData];
    }];
}

- (BOOL)haveChoosenTag:(ZZSkillTag *)tag {
    BOOL flag = NO;
    for (ZZSkillTag *selectedTag in self.selectedArray) {
        if ([selectedTag.id isEqualToString:tag.id]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (NSInteger)indexOfSelectedTag:(ZZSkillTag *)tag {
    NSInteger index = -1;
    for (int i = 0; i < self.selectedArray.count; i++) {
        ZZSkillTag *selectedTag = self.selectedArray[i];
        if ([selectedTag.id isEqualToString:tag.id]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZChooseTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseTagCellId forIndexPath:indexPath];
    [cell setTags:self.tagsArray[indexPath.row]];
    if ([self haveChoosenTag:self.tagsArray[indexPath.row]]) {
        cell.cellSelected = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZChooseTagCell *cell = (ZZChooseTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.cellSelected == NO && self.selectedArray.count >= 5) {
        [ZZHUD showTaskInfoWithStatus:@"最多选择5个标签"];
        return;
    }
    cell.cellSelected = !cell.cellSelected;
    if (cell.cellSelected) {
        [self.selectedArray addObject:self.tagsArray[indexPath.row]];
    } else {
        NSInteger removeIndex = [self indexOfSelectedTag:self.tagsArray[indexPath.row]];
        if (removeIndex != -1) {
            [self.selectedArray removeObjectAtIndex:removeIndex];
        }
    }
}

- (UICollectionView *)collection {
    if (nil == _collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 30;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 * 2 - 30 * 2) / 3, 35);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        [_collection registerClass:[ZZChooseTagCell class] forCellWithReuseIdentifier:ChooseTagCellId];
    }
    return _collection;
}

- (NSMutableArray *)selectedArray {
    if (nil == _selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
