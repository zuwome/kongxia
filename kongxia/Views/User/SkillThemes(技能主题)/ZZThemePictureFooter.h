//
//  ZZThemePictureFooter.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ThemePictureFooterIdentifier @"ThemePictureFooterIdentifier"

@interface ZZThemePictureFooter : UICollectionReusableView

@property (nonatomic, copy) void(^checkPictureExample)(void);

@end
