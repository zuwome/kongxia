//
//  ZZOrderOptionsTableViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderOptionsTableViewController.h"
#import "ZZOrderRefundViewController.h"

#import "ZZOrderOptionTextViewCell.h"
#import "ZZOrderOptionCell.h"

#import "ZZOrderOptionModel.h"
#import "ZZRuleHelper.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZZMoneyTextField.h"

@interface ZZOrderOptionsTableViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
    
    // refund
    UILabel             *_maxPriceLabel;
    ZZMoneyTextField    *_priceTextField;
    NSInteger           _selectIndex;
    BOOL                _firstLoad;
    UIButton            *_rightBtn;
    CGFloat             _priceScale;
}

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *submitButton;//提交按钮

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@end

@implementation ZZOrderOptionsTableViewController

- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBGColor;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择理由";
    
    _firstLoad = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.equalTo(self.submitButton.mas_top);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@49);
        make.bottom.equalTo(@(-SafeAreaBottomHeight));
    }];
    switch (_type) {
        case OptionTypeCancel:
        {
            [self loadCancel];
        }
            break;
        case OptionTypeRefuse:
        {
            [self loadRefuse];
        }
            break;
        default:
            break;
    }
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(rightDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
    }
    return _submitButton;
}


#pragma mark - Data

- (void)loadRefuse {
    [ZZRuleHelper pullRefuseList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            _data = data;
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
}

- (void)loadCancel {
    [ZZRuleHelper pullCancelList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            _data = data;
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UIButtonMethod

- (void)rightDoneClick{
    
    if (!_firstLoad) {
        if (_selectIndex == _data.count) {
            if (_textView.text.length == 0) {
                [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
                return;
            }
        }
    } else {
        [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
        return;
    }
    
    if ((_type == OptionTypeCancel && [_order.status isEqualToString:@"paying"])) {
        if (_isFrom) {
            [self showOkCancelAlert:@"提示"
                            message:@"对方已接受预约，如是因为您的原因取消预约后将赔付意向金给对方"
                       confirmTitle:@"确定"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self done];
            }
                        cancelTitle:@"取消"
                      cancelHandler:nil];
        } else {
            [self showOkCancelAlert:@"提示"
                            message:@"你已经接受对方的邀请，主动取消将会扣除信任值，是否确认取消邀约"
                       confirmTitle:@"确定"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self done];
            }
                        cancelTitle:@"取消"
                      cancelHandler:nil];
        }
    } else {
        if (_type == OptionTypeCancel && !_isFrom && _order.paid_at) {
            [self showOkCancelAlert:@"提示"
                            message:@"对方已通过平台担保支付全款，取消预约租金将退还给对方。"
                       confirmTitle:@"确定"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self done];
            }
                        cancelTitle:@"取消"
                      cancelHandler:nil];
        } else {
            [self done];
        }
    }
}

- (void)done
{
    NSString *reason = @"";
    if (_selectIndex == _data.count) {
        if (_textView.text.length == 0) {
            return [ZZHUD showErrorWithStatus:@"请填写理由"];
        } else {
            reason = _textView.text;
        }
    } else {
        reason = _data[_selectIndex];
    }
    NSDictionary *param = @{@"reason":reason,
                            @"reason_type":[NSNumber numberWithInteger:2]};
    [self request:param];
}

- (void)request:(NSDictionary *)param
{
    _rightBtn.userInteractionEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
    if (_type == OptionTypeCancel) {
        [ZZHUD showWithStatus:@"正在取消.."];
        [ZZOrder cancelOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    } else {
        [ZZHUD showWithStatus:@"正在拒绝..."];
        [ZZOrder refuseOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    }
}

- (void)requestCallBack:(id)data error:(ZZError *)error
{
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
        _rightBtn.userInteractionEnabled = YES;
        self.tableView.userInteractionEnabled = YES;
    } else {
        [ZZHUD dismiss];
        if (_callBack) {
            _callBack(data[@"status"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectIndex == _data.count ? _data.count + 2:_data.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _data.count + 1) {
        ZZOrderOptionTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textviewcell"];
        
        if (!cell) {
            cell = [[ZZOrderOptionTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textviewcell"];
        }
        _textView = cell.textView;
        _textView.delegate = self;
        switch (_type) {
            case OptionTypeRefuse:
            {
                _textView.placeholder = @"请输入拒绝原因";
            }
                break;
            case OptionTypeCancel:
            {
                _textView.placeholder = @"请输入取消原因";
            }
                break;
            default:
                break;
        }
        return cell;
    } else {
        ZZOrderOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
        
        if (!cell) {
            cell = [[ZZOrderOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"];
        }
        if (indexPath.row == _data.count) {
            cell.titleLabel.text = @"其他";
        } else {
//            NSString *name = _data[indexPath.row];
//            cell.titleLabel.text = name;
        }
        if (_selectIndex == indexPath.row && !_firstLoad) {
            cell.imgView.hidden = NO;
        } else {
            cell.imgView.hidden = YES;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == _data.count+1 ? 104:50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_type == OptionTypeRefuse || _type == OptionTypeCancel) {
        return 50;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = kGrayTextColor;
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"对方接受预约后，取消预约将要赔付意向金给对方，如是对方原因，请通知对方取消，意向金将全额退还给您，如有争议请联系客服";
    [footView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footView.mas_top).offset(8);
        make.left.mas_equalTo(footView.mas_left).offset(15);
        make.right.mas_equalTo(footView.mas_right).offset(-15);
    }];
    
    switch (_type) {
        case OptionTypeRefuse:
        {
            infoLabel.text = @"现在拒绝预约，意向金将返还至对方的钱包";
            
            return footView;
        }
            break;
        case OptionTypeCancel:
        {
            if (_isFrom) {
                infoLabel.text = @"对方还未接受预约，现在取消预约意向金将返还至您的钱包";
            } else if (_order.paid_at) {
                infoLabel.text = @"现在取消预约，所有租金将返还至对方的钱包";
            } else {
                infoLabel.text = @"现在取消预约，意向金将返还至对方的钱包";
            }
            
            return footView;
        }
            break;
        default:
            break;
    }
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _data.count + 1) {
        return;
    }
    
    _maxPriceLabel.hidden = NO;
    _firstLoad = NO;
    _rightBtn.userInteractionEnabled = YES;
    _selectIndex = indexPath.row;
    [self manageTotolValue];
    [self.tableView reloadData];
}

- (UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    headView.backgroundColor = kBGColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = _order.skill.name;
    [bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(15);
        make.left.mas_equalTo(bgView.mas_left).offset(15);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = kGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = [NSString stringWithFormat:@"%d小时", _order.hours];
    [bgView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    UIView *grayBgView = [[UIView alloc] init];
    grayBgView.backgroundColor = kBGColor;
    [bgView addSubview:grayBgView];
    
    [grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.top.mas_equalTo(bgView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 32));
    }];
    
    UILabel *yuanLabel = [[UILabel alloc] init];
    yuanLabel.textAlignment = NSTextAlignmentRight;
    yuanLabel.textColor = kBlackTextColor;
    yuanLabel.font = [UIFont systemFontOfSize:13];
    yuanLabel.text = @"元";
    [grayBgView addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(grayBgView.mas_right).offset(-10);
        make.centerY.mas_equalTo(grayBgView.mas_centerY);
        make.width.mas_equalTo(13);
    }];
    
    _priceTextField = [[ZZMoneyTextField alloc] init];
    _priceTextField.textAlignment = NSTextAlignmentRight;
    _priceTextField.textColor = kBlackTextColor;
    _priceTextField.font = [UIFont systemFontOfSize:13];
    _priceTextField.tintColor = kYellowColor;
    _priceTextField.clearButtonMode = UITextFieldViewModeNever;
    [grayBgView addSubview:_priceTextField];
    
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(yuanLabel.mas_left).offset(-2);
        make.left.mas_equalTo(grayBgView.mas_left).offset(2);
        make.top.mas_equalTo(grayBgView.mas_top);
        make.bottom.mas_equalTo(grayBgView.mas_bottom);
    }];
    
    _maxPriceLabel = [[UILabel alloc] init];
    _maxPriceLabel.textAlignment = NSTextAlignmentRight;
    _maxPriceLabel.textColor = kBlackTextColor;
    _maxPriceLabel.font = [UIFont systemFontOfSize:13];
    _maxPriceLabel.tintColor = kYellowColor;
    _maxPriceLabel.text = [NSString stringWithFormat:@"最多可退%.2f元", [_order.totalPrice doubleValue]];
    [bgView addSubview:_maxPriceLabel];
    
    [_maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayBgView.mas_bottom).offset(4);
        make.right.mas_equalTo(grayBgView.mas_right);
    }];
    
    return headView;
}

- (void)manageTotolValue
{
    _maxPriceLabel.text = [NSString stringWithFormat:@"最多可退%.2f元", [_order.totalPrice doubleValue]*_priceScale];
}

#pragma mark - UITextViewMethod

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
