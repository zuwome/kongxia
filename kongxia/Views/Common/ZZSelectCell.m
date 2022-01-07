//
//  ZZSelectCell.m
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSelectCell.h"

@implementation ZZSelectCell
- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder  {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_textLabel];
    
    self.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" andAlpha:1].CGColor;
    self.layer.borderWidth = self.selected ? 0: 1;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_textLabel sizeToFit];
    _textLabel.center = (CGPoint){self.width/2, self.height/2};
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderWidth = 0;
        self.backgroundColor = [UIColor colorWithHexString:ZWM_YELLOW andAlpha:1];
        self.textLabel.textColor = [UIColor blackColor];
    } else {
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
}


@end
