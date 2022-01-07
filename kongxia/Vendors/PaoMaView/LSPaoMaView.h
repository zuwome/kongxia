//
//  LSPaoMaView.h
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTCOLOR HEXCOLOR(0xDDA200)
#define TEXTFONTSIZE 13

@interface LSPaoMaView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
//增加新的跑马的判断
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(CGFloat )fontsize;
- (void)start;//开始跑马
- (void)stop;//停止跑马

@end
