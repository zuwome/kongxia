//
//  ZZRentPayCompleteCreateTaskCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentPayCompleteCreateTaskCell.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZRentPayCompleteCreateTaskCell () <UIActionSheetDelegate>

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *rule1IconImageView;

@property (nonatomic, strong) UILabel *rule1Label;

@property (nonatomic, strong) UIImageView *rule2IconImageView;

@property (nonatomic, strong) UILabel *rule2Label;

@property (nonatomic, strong) UIImageView *rule3IconImageView;

@property (nonatomic, strong) UILabel *rule3Label;

@property (nonatomic, strong) UIImageView *customerServiceImageView;

@property (nonatomic, strong) UILabel *customerServiceLabel;

@end

@implementation ZZRentPayCompleteCreateTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)saveToAlbum:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存图片",nil];

                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [actionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:  (NSInteger)buttonIndex
{
    if(buttonIndex ==0) {
        if(_customerServiceImageView.image){
            UIImageWriteToSavedPhotosAlbum(_customerServiceImageView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo:(void*)contextInfo
{
    NSString*message =@"";
    
    if(!error) {
        
        message =@"成功保存到相册";
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        
        [alert show];
        
    }else{
        message = [error description];
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        
        [alert show];
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存照片失败");
    }
    else {
        [ZZHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.infoView];
    [_infoView addSubview:self.titleLabel];
    [_infoView addSubview:self.rule1IconImageView];
    [_infoView addSubview:self.rule1Label];
    [_infoView addSubview:self.rule2IconImageView];
    [_infoView addSubview:self.rule2Label];
    [_infoView addSubview:self.customerServiceImageView];
    [_infoView addSubview:self.customerServiceLabel];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(26);
        make.size.mas_equalTo(CGSizeMake(315, 360));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoView).offset(15);
        make.left.equalTo(_infoView).offset(30.0);
        make.right.equalTo(_infoView).offset(-30);
    }];
    
    [_rule1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView).offset(51);
        make.right.equalTo(_infoView).offset(-30.0);
        make.top.equalTo(_titleLabel.mas_bottom).offset(18);
    }];
    
    [_rule1IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rule1Label).offset(3);
        make.right.equalTo(_rule1Label.mas_left).offset(-6);
    }];
    
    [_rule2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView).offset(51);
        make.right.equalTo(_infoView).offset(-30.0);
        make.top.equalTo(_rule1Label.mas_bottom).offset(8);
    }];
    
    [_rule2IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rule2Label).offset(3);
        make.right.equalTo(_rule2Label.mas_left).offset(-6);
    }];
    
    [_customerServiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_infoView);
        make.top.equalTo(_rule2Label.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    
    [_customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_infoView);
        make.top.equalTo(_customerServiceImageView.mas_bottom).offset(5);
    }];
}

#pragma mark - getters and setters
- (void)setTipsDic:(NSDictionary *)tipsDic {
    _tipsDic = tipsDic;
    
    if ([_tipsDic[@"img"] isKindOfClass:[NSString class]] && !isNullString(_tipsDic[@"img"])) {
//        _titleLabel.text = [NSString stringWithFormat:@"%@", _tipsDic[@"tip_tip"]];
        [_customerServiceImageView sd_setImageWithURL:[NSURL URLWithString:_tipsDic[@"img"]]];
    }
    
    if ([_tipsDic[@"list"] isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)_tipsDic[@"list"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]] && !isNullString(obj)) {
                if (idx == 0) {
                    _rule1Label.text = (NSString *)obj;
                }
                else if (idx == 1) {
                    _rule2Label.text = (NSString *)obj;
                }
                else if (idx == 2) {
                    _rule3Label.text = (NSString *)obj;
                }
            }
        }];
    }
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = UIColor.whiteColor;
        _infoView.layer.cornerRadius = 10.0;
    }
    return _infoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = [NSString stringWithFormat:@"扫码添加客服微信"];
        _titleLabel.textColor = RGBCOLOR(250, 115, 78);
        _titleLabel.font = ADaptedFontMediumSize(16);//[UIFont fontWithName:@"Alibaba-PuHuiTi-B" size:22];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)rule1IconImageView {
    if (!_rule1IconImageView) {
        _rule1IconImageView = [[UIImageView alloc] init];
        _rule1IconImageView.image = [UIImage imageNamed:@"icXuhao1"];
    }
    return _rule1IconImageView;
}

- (UIImageView *)rule2IconImageView {
    if (!_rule2IconImageView) {
        _rule2IconImageView = [[UIImageView alloc] init];
        _rule2IconImageView.image = [UIImage imageNamed:@"icXuhao2"];
    }
    return _rule2IconImageView;
}

- (UIImageView *)rule3IconImageView {
    if (!_rule3IconImageView) {
        _rule3IconImageView = [[UIImageView alloc] init];
        _rule3IconImageView.image = [UIImage imageNamed:@"icXuhao3"];
    }
    return _rule3IconImageView;
}

- (UILabel *)rule1Label {
    if (!_rule1Label) {
        _rule1Label = [[UILabel alloc] init];
        _rule1Label.text = @"一键发布，众多达人主动报名供您选择";
        _rule1Label.textColor = RGBCOLOR(63, 58, 58);
        _rule1Label.font = ADaptedFontMediumSize(15);
        _rule1Label.numberOfLines = 0;
    }
    return _rule1Label;
}

- (UILabel *)rule2Label {
    if (!_rule2Label) {
        _rule2Label = [[UILabel alloc] init];
        _rule2Label.text = @"一次发布，可随心选择多位达人进行本次邀约";
        _rule2Label.textColor = RGBCOLOR(63, 58, 58);
        _rule2Label.font = ADaptedFontMediumSize(15);
        _rule2Label.numberOfLines = 0;
    }
    return _rule2Label;
}

- (UILabel *)rule3Label {
    if (!_rule3Label) {
        _rule3Label = [[UILabel alloc] init];
        _rule3Label.text = @"发布成功30分钟后无人报名时取消发布，发布服务费全额退回";
        _rule3Label.textColor = RGBCOLOR(63, 58, 58);
        _rule3Label.font = ADaptedFontMediumSize(15);
        _rule3Label.numberOfLines = 0;
    }
    return _rule3Label;
}

- (UIImageView *)customerServiceImageView {
    if (!_customerServiceImageView) {
        _customerServiceImageView = [[UIImageView alloc] init];
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbum:)];
//        press.minimumPressDuration = 1;
        _customerServiceImageView.userInteractionEnabled = YES;
        [_customerServiceImageView addGestureRecognizer:press];
    }
    return _customerServiceImageView;
}

- (UILabel *)customerServiceLabel {
    if (!_customerServiceLabel) {
        _customerServiceLabel = [[UILabel alloc] init];
        _customerServiceLabel.text = @"长按保存 微信扫码添加好友";
        _customerServiceLabel.textColor = UIColor.lightGrayColor	;
        _customerServiceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _customerServiceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _customerServiceLabel;
}


@end
