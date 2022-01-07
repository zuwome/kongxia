//
//  ZZFindGroupsCell.h
//  zuwome
//
//  Created by YuTianLong on 2018/2/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZFindGroupModel;

@interface ZZFindGroupsCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(ZZFindGroupModel *)model;

@property (nonatomic, assign) BOOL isSelectGruops;

@end
