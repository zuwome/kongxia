//
//  ZZUserRegistedGuidView.h
//  kongxia
//
//  Created by qiming xiao on 2019/9/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZZUserRegistedGuidView;
@protocol ZZUserRegistedGuidViewDelegate <NSObject>

- (void)viewDidConfirm:(ZZUserRegistedGuidView *)view;

- (void)viewDidDismiss:(ZZUserRegistedGuidView *)view;

@end

@interface ZZUserRegistedGuidView : UIView

@property (nonatomic, weak) id<ZZUserRegistedGuidViewDelegate> delegate;

- (void)configureInfos:(NSDictionary *)infosDic;

@end

NS_ASSUME_NONNULL_END
