//
//  ZZPictureExampleViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPictureExampleViewController.h"

#define PicExampleHeader @"PicExampleHeader"
#define PicExampleFooter @"PicExampleFooter"
#define PicExampleCell @"PicExampleCell"

@interface ZZPictureExampleViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *picCollect;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) NSArray *picArray;

@end

@implementation ZZPictureExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"照片示例";
    [self createView];
    [self getPictureExample];
}

- (void)createView {
    [self.view addSubview:self.picCollect];
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPictureExample {
    ZZSkill *skill = self.topic.skills[0];
    NSString *pid = skill.pid ? skill.pid : skill.id;
    [[ZZSkillThemesHelper shareInstance] getPhotoDemoListBySid:pid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            self.picArray = data;
            [self.picCollect reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicExampleCell forIndexPath:indexPath];
    UIImageView *exampleImg = [[UIImageView alloc] init];
    if (indexPath.row < self.picArray.count) {
        NSString *urlStr = [self.picArray[indexPath.row] objectForKey:@"url"];
        [exampleImg sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    } else {
//        exampleImg.image = [UIImage imageNamed:@"bitmapCopy4"];
        exampleImg.backgroundColor = kBGColor;
    }
    [cell.contentView addSubview:exampleImg];
    [exampleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [self createHeaderForCollectionView:collectionView atIndexPath:indexPath];
        return header;
    } else {
        UICollectionReusableView *footer = [self createFooterForCollectionView:collectionView atIndexPath:indexPath];
        return footer;
    }
}

- (UICollectionReusableView *)createHeaderForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PicExampleHeader forIndexPath:indexPath];
    [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ZZSkill *skill = self.topic.skills[0];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = skill.name;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    self.titleLab.textColor = [UIColor blackColor];
    [header addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.height.equalTo(@16);
        make.centerX.equalTo(header);
    }];
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.text = @"展示你的兴趣爱好或特长";
    subTitle.textAlignment = NSTextAlignmentCenter;
    subTitle.font = [UIFont systemFontOfSize:14];
    subTitle.textColor = RGBCOLOR(102, 102, 102);
    [header addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.height.equalTo(@14);
        make.centerX.equalTo(header);
    }];
    return header;
}

- (UICollectionReusableView *)createFooterForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PicExampleFooter forIndexPath:indexPath];
    [footer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"*照片中包含微信、QQ、手机号、二维码、低俗内容的照片会导致照片审核无法通过";
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = RGBCOLOR(153, 153, 153);
    [footer addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.bottom.trailing.equalTo(@-15);
        make.height.greaterThanOrEqualTo(@20);
    }];
    return footer;
}

#pragma mark -- lazy load
- (UICollectionView *)picCollect {
    if (nil == _picCollect) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40) / 3, (SCREEN_WIDTH - 40) / 3);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 70);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 70);
        
        _picCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50) collectionViewLayout:layout];
        _picCollect.backgroundColor = [UIColor whiteColor];
        _picCollect.delegate = self;
        _picCollect.dataSource = self;
        _picCollect.showsVerticalScrollIndicator = NO;
        _picCollect.showsHorizontalScrollIndicator = NO;
        [_picCollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PicExampleCell];
        [_picCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PicExampleHeader];
        [_picCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PicExampleFooter];
    }
    return _picCollect;
}
- (UIButton *)bottomBtn {
    if (nil == _bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        [_bottomBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:RGBCOLOR(244, 203, 7)];
        [_bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bottomBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (NSArray *)picArray {
    if (nil == _picArray) {
        _picArray = [NSArray array];
    }
    return _picArray;
}

@end
