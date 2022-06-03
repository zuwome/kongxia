//
//  ZZChooseSkillViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChooseSkillViewController.h"
#import "ZZSkillEditViewController.h"
#import "ZZPostTaskBasicInfoController.h"
#import "ZZPostFreeTaskTaskInfoViewController.h"

#import "ZZChooseSkillCollectionViewCell.h"
#import "ZZSkillEditCellFooter.h"

#import "ZZSkillsSelectResponseModel.h"
#import "ZZTopic.h"

#define SkillItemIdentifier   @"SkillItemIdentifier"
#define SkillHeaderIdentifier   @"SkillHeaderIdentifier"

@interface ZZChooseSkillViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *skillCollection;

//dataSource
@property (nonatomic, strong) ZZSkillsSelectResponseModel *responseModel;
@property (nonatomic, strong) NSArray *skillList;
@property (nonatomic, strong) NSArray *catalogList;

@end

@implementation ZZChooseSkillViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    if (isNullString(self.navigationItem.title)) {
        self.navigationItem.title = @"选择技能";
    }
    
    [self.view addSubview:self.skillCollection];
    
    if (_isFromSkillSelectView) {
        [self fetchAllSkills];
    }
    else {
        [self requestSkillCatalog];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSkillCatalog {
    [[ZZSkillThemesHelper shareInstance] getSkillsCatalogList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!data)  return ;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *catalogDict in data) {
            NSDictionary *topicDict = @{@"price":@0, @"skills":@[catalogDict]};
            ZZTopic *topic = [[ZZTopic alloc] initWithDictionary:topicDict error:nil];
            BOOL flag = YES;
            for (ZZTopic *choosenTopic in self.choosenArray) {
                ZZSkill *skill = topic.skills[0];
                ZZSkill *choosenSkill = choosenTopic.skills[0];
                if ([choosenSkill.pid isEqualToString:skill.id]) {  //未添加取id为主题id，已添加去pid为主题id
                    flag = NO;
                    break;
                }
            }
            if (flag) {
                [tempArray addObject:topic];
            }
        }
        self.skillList = [tempArray copy];
        [self.skillCollection reloadData];
    }];
}

- (void)fetchAllSkills {
    [ZZRequest method:@"GET" path:@"/api/pd/getSkillWriting" params:@{@"gender" : @(UserHelper.loginer.gender), @"type": @2, @"entryType": _taskType == TaskFree ? @2 : @1,} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            _responseModel = [[ZZSkillsSelectResponseModel alloc] initWithDictionary:data error:nil];
            [self.skillCollection reloadData];
            //            [self fetchSkillslist];
        }
    }];
}

- (void)goToPost:(ZZSkill *)skill {
    if (_taskType == TaskFree) {
        ZZPostFreeTaskTaskInfoViewController *vc = [[ZZPostFreeTaskTaskInfoViewController alloc] initWithSkill:skill taskType:TaskFree];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        ZZPostTaskBasicInfoController *vc = [[ZZPostTaskBasicInfoController alloc] initWithSkill:skill taskType:_taskType];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isFromSkillSelectView) {
        return self.responseModel.skills.count;
    }
    else {
        return self.skillList.count;
    }

}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZChooseSkillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SkillItemIdentifier forIndexPath:indexPath];
    if (_isFromSkillSelectView) {
        [cell configureData:_responseModel.skills[indexPath.row]];
    }
    else {
        ZZTopic *model = self.skillList[indexPath.row];
        [cell setTopicData:model];
    }
   
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return ;
    }
    
    if (_isFromSkillSelectView) {
        if (_shouldPopBack) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didChooseSkill:)]) {
                [self.delegate controller:self didChooseSkill:_responseModel.skills[indexPath.row]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self goToPost:_responseModel.skills[indexPath.row]];
        }
        return;
    }
   
    if (_shouldPopBack) {
        ZZTopic *model = self.skillList[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didChooseSkill:)]) {
            [self.delegate controller:self didChooseSkill:model.skills.firstObject];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //model at indexPath
        ZZTopic *model = self.skillList[indexPath.row];
        
        ZZSkillEditViewController *controller = [[ZZSkillEditViewController alloc] init];
        controller.skillEditType = SkillEditTypeAddSystemTheme;
        controller.oldTopicModel = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        if (_taskType != TaskFree) {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SkillEditStageIdentifier forIndexPath:indexPath];
            footer.backgroundColor = kBGColor;
            //        [footer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            ZZSkillEditCellFooter *footerView = [[ZZSkillEditCellFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SkillEditCellFooterHeight)];
            footerView.stage = 1;
            [footer addSubview:footerView];
            return footer;
        }
        else {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SkillEditStageIdentifier forIndexPath:indexPath];
            return footer;
        }
    }
    return [UICollectionReusableView new];
}

#pragma mark -- lazy load
- (UICollectionView *)skillCollection {
    if (nil == _skillCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(AdaptedWidth(105), 140);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, SkillEditCellFooterHeight);
        
        _skillCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) collectionViewLayout:layout];
        _skillCollection.backgroundColor = [UIColor whiteColor];
        _skillCollection.showsVerticalScrollIndicator = NO;
        _skillCollection.showsHorizontalScrollIndicator = NO;
        _skillCollection.delegate = self;
        _skillCollection.dataSource = self;
        [_skillCollection registerClass:[ZZChooseSkillCollectionViewCell class] forCellWithReuseIdentifier:SkillItemIdentifier];
        [_skillCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SkillEditStageIdentifier];
    }
    return _skillCollection;
}
- (NSArray *)skillList {
    if (nil == _skillList) {
        _skillList = [NSArray array];
    }
    return _skillList;
}
- (NSArray *)catalogList {
    if (nil == _catalogList) {
        _catalogList = [NSArray array];
    }
    return _catalogList;
}
- (NSArray *)choosenArray {
    if (nil == _choosenArray) {
        _choosenArray = [NSArray array];
    }
    return _choosenArray;
}

@end
