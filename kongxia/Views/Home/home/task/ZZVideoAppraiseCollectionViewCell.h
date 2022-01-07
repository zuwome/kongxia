//
//  ZZVideoAppraiseCollectionViewCell.h
//  zuwome
//
//  Created by YuTianLong on 2018/1/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZVideoAppraiseCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithString:(NSString *)itemString;

@property (nonatomic, assign) BOOL isSelect;    // 是否被选中

@property (nonatomic, copy) void (^selectItemBlock)(void);

@end
