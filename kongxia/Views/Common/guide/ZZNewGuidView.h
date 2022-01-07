//
//  ZZNewGuidView.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZZNewGuidViewDelegate <NSObject>

- (void)guideViewDidFinish;

@end

@interface ZZNewGuidView : UIView

@property (nonatomic, weak) id<ZZNewGuidViewDelegate>delegate;

@end

@interface ZZNewGuidSubView : UIView



- (void)configureTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
