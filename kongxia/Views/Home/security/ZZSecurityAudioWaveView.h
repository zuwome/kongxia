//
//  ZZSecurityAudioWaveView.h
//  zuwome
//
//  Created by angBiu on 2017/8/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZSecurityAudioWaveView : UIView

@property (nonatomic, copy) void (^waverLevelCallback)(ZZSecurityAudioWaveView * waver);

@property (nonatomic) NSUInteger numberOfWaves;

@property (nonatomic) UIColor * waveColor;

@property (nonatomic) CGFloat level;

@property (nonatomic) CGFloat mainWaveWidth;

@property (nonatomic) CGFloat decorativeWavesWidth;

@property (nonatomic) CGFloat idleAmplitude;

@property (nonatomic) CGFloat frequency;

@property (nonatomic, readonly) CGFloat amplitude;

@property (nonatomic) CGFloat density;

@property (nonatomic) CGFloat phaseShift;

@property (nonatomic, readonly) NSMutableArray * waves;

@end
