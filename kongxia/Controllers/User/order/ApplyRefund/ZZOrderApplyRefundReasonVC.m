//
//  ZZOrderApplyRefundReasonVC.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderApplyRefundReasonVC.h"
#import "ZZOrderARSelectButtonCell.h"
#import "ZZOrderARPriceCell.h"
#import "ZZOrderArOtherARPriceCell.h"
#import "ZZOrderOptionModel.h"
#import "ZZOrderArUploadImageCell.h"
#import "ZZOrderARFootView.h"
#import "ZZApplyUploadView.h"//上传证据
#import "TPKeyboardAvoidingTableView.h"
#import "ZZChatViewController.h"
#import "ZZARRentAlertView.h"
#import "ZZOrderDetailViewController.h"//邀约详情
@interface ZZOrderApplyRefundReasonVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) TPKeyboardAvoidingTableView *tableView;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UILabel *headerViewTitleLab;
@property (nonatomic, strong) ZZApplyUploadView *bottomView;
@property (strong, nonatomic) NSMutableArray *imageArray;//上传的图片
@property (strong, nonatomic) UIButton *submitButton;//提交按钮
@property (nonatomic,strong)  ZZOrderARBaseCell *lastSelectCell;
@property (nonatomic,strong) UITextField *refundAmountTF;//最大可输入退款金额

@end

@implementation ZZOrderApplyRefundReasonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    
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
    self.tableView.tableHeaderView = self.headerView;
    self.headerViewTitleLab.text = self.model.title;
    
    if (!self.model.isResponsible) {
        self.tableView.tableFooterView  =  self.bottomView;
    }
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerViewTitleLab = [[UILabel alloc]init];
        _headerViewTitleLab.textColor = kBlackColor;
        _headerViewTitleLab.textAlignment = NSTextAlignmentLeft;
        _headerViewTitleLab.font = CustomFont(15);
        _headerViewTitleLab.frame = CGRectMake(15, 0, SCREEN_WIDTH-15, 50);
        [_headerView addSubview:_headerViewTitleLab];
    }
    return _headerView;
}
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZZOrderARSelectButtonCell class] forCellReuseIdentifier:@"ZZOrderARSelectButtonCellID"];
        [_tableView registerClass:[ZZOrderARPriceCell class] forCellReuseIdentifier:@"ZZOrderARPriceCellID"];
         [_tableView registerClass:[ZZOrderArOtherARPriceCell class] forCellReuseIdentifier:@"ZZOrderArOtherARPriceCellID"];
        [_tableView registerClass:[ZZOrderArUploadImageCell class] forCellReuseIdentifier:@"ZZOrderArUploadImageCellID"];
        [_tableView registerClass:[ZZOrderARFootView class] forHeaderFooterViewReuseIdentifier:@"ZZOrderARFootViewID"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
        tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
        [_tableView addGestureRecognizer:tableViewGesture];
        
       
        if (self.model.isResponsible){
            _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        }else{
            _tableView.backgroundColor = [UIColor whiteColor];
        }
    
        _tableView.dataSource = self;
        _tableView.delegate = self;

    }
    return _tableView;
}
- (void)tableViewTouchInSide {
//    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.isResponsible?2:3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?(self.model.isResponsible?self.model.detailArray.count:self.model.detailArray.count+1):1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row <= self.model.detailArray.count-1) {
            ZZOrderARSelectButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderARSelectButtonCellID"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZZOrderOptionModel *model = self.model.detailArray[indexPath.row];
            cell.currentTitle = model.content;
            cell.model = model;
            WS(weakSelf);
            cell.selecetBlock = ^(ZZOrderARSelectButtonCell *currentCell) {
                if (currentCell.button.selected == NO) {
                    weakSelf.lastSelectCell = nil;
                    return ;
                }
                
                [weakSelf changeCellSelect:currentCell];
            };
           
               return cell;
        }
        else{
            ZZOrderArOtherARPriceCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderArOtherARPriceCellID"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WS(weakSelf);
            cell.selecetBlock = ^(ZZOrderArOtherARPriceCell *currentCell) {
                if (currentCell.button.selected == NO) {
                    weakSelf.lastSelectCell = nil;
                     return ;
                }
                [weakSelf changeCellSelect:currentCell];
            };
            return cell;
        }
    }else if (indexPath.section==1) {
        ZZOrderARPriceCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderARPriceCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        ZZOrderOptionModel *model = self.model.detailArray[0];
        self.refundAmountTF = cell.priceTF;
        if ([self.order.status isEqualToString:@"paying"]) {
            [cell setOrder:self.order showInputMoney:NO responsible:self.model.isResponsible percent:model.percent];
        }else {
            [cell setOrder:self.order showInputMoney:YES responsible:self.model.isResponsible percent:model.percent];
        }
        return cell;
    }
    else {
        ZZOrderArUploadImageCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderArUploadImageCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row<=self.model.detailArray.count-1) {
            return 50;
        }else{
            return 154;
        }
    }else{
        if (indexPath.section ==2) {
            return 50;
        }
        return 72;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.model.isResponsible&&section==0) {
            return 28;
        }
    }
    return section==3?0:10.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.model.isResponsible&&section==0) {
         ZZOrderARFootView *footView = (ZZOrderARFootView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZZOrderARFootViewID"];
        if ([self.order.status isEqualToString:@"paying"]) {
            footView.titleLab.text = @"为保证双方的公平性，自己原因意向金将赔付给达人。";
        }else{
            footView.titleLab.text = @"为保证双方的公平性，自己原因将赔付部分租金给达人。";
        }
        return footView;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)changeCellSelect:(ZZOrderARBaseCell *)currentCell {
    if (self.lastSelectCell) {
            self.lastSelectCell.button.selected = NO;
        if ([self.lastSelectCell isKindOfClass:[ZZOrderArOtherARPriceCell class]]) {
            ZZOrderArOtherARPriceCell *lastCell = (ZZOrderArOtherARPriceCell*)self.lastSelectCell;
            [lastCell.textView resignFirstResponder];
        }
    }
    self.lastSelectCell = currentCell;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
    ZZOrderArUploadImageCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    if ([currentCell.currentTitle isEqualToString:@"无法联系对方"]) {
        cell.uploadInstructions = @"(选填)";
    }else{
        cell.uploadInstructions = @"(必填)";

    }
}

- (ZZApplyUploadView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZApplyUploadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 60)/3.0f*2.0f + 40)];
        _bottomView.selectMaxNumber = 6;
        _bottomView.selectIndex = ^(NSInteger index) {
            [weakSelf selectIndexWithIndex:index];
        };
    }
    return _bottomView;
}
#pragma mark -

- (void)selectIndexWithIndex:(NSInteger)index
{
    if (self.imageArray.count && index < self.imageArray.count) {
        [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:nil tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                return ;
            }
            [self.imageArray removeObjectAtIndex:index];
            self.bottomView.dataArray = self.imageArray;
        }];
    } else if (index == self.imageArray.count) {
        [self addImage];
    }
}
- (void)addImage
{
    WeakSelf;
    [UIActionSheet showInView:self.view
                    withTitle:@"上传照片"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"拍照上传",@"相册上传"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex ==0) {
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                             imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [weakSelf addImageWithImage:image];
                                 }];
                             };
                             imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                                 [picker dismissViewControllerAnimated:YES completion:nil];
                             };
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                         }
                         if (buttonIndex ==1) {
                             IOS_11_Show
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 IOS_11_NO_Show
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [weakSelf addImageWithImage:image];
                                 }];
                             };
                             imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                                 IOS_11_NO_Show
                                 [picker dismissViewControllerAnimated:YES completion:nil];
                             };
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                         }
                     }];
}
- (void)addImageWithImage:(UIImage *)image
{
    [self.imageArray addObject:image];
    self.bottomView.dataArray = self.imageArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
    }
    return _submitButton;
}

/**
 提交
 */
- (void)submitButtonClick {
    if (!_lastSelectCell) {
        if (self.model.isResponsible) {
            //自己原因
            [ZZHUD showErrorWithStatus:@"请选择理由"];
        }else{
            //对方原因
            [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
        }
        return;
    }
    
    if (_lastSelectCell&&!self.model.isResponsible) {
        if ([_lastSelectCell isKindOfClass:[ZZOrderArOtherARPriceCell class]]) {
            [ZZHUD showErrorWithStatus:@"请输入退款原因"];
        }
    }
    
    [self.view endEditing:YES];
    
    if (![self.order.status isEqualToString:@"paying"]) {
        //付全款
        if (self.refundAmountTF.text.length<=0) {
            [ZZHUD showErrorWithStatus:@"请填写退款金额"];
            return;
        }
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:
                                       @"^[0-9]+([.][0-9]{1,2})?$" options:NSRegularExpressionCaseInsensitive error:nil];
           ZZOrderOptionModel *model = self.model.detailArray[0];
        if (![regex numberOfMatchesInString:self.refundAmountTF.text options:0 range:NSMakeRange(0, [self.refundAmountTF.text length])]) {
            [ZZHUD showErrorWithStatus:@"金额错误"];
            return;
        }
        double maxPrice = [self.order.price doubleValue] * self.order.hours * model.percent;
        if ([ZZUtils compareWithValue1:self.refundAmountTF.text value2:[NSNumber numberWithFloat:maxPrice]] == NSOrderedDescending) {
            [ZZHUD showErrorWithStatus:@"金额大于可退款金额"];
            return;
        }
    }
    NSString *currentSelectReason = nil;
    if ([self.lastSelectCell isKindOfClass:[ZZOrderARSelectButtonCell class]]) {
        ZZOrderARSelectButtonCell *lastCell = (ZZOrderARSelectButtonCell*)self.lastSelectCell;
        currentSelectReason = lastCell.currentTitle;
    }
    else {
        ZZOrderArOtherARPriceCell *cell =  (ZZOrderArOtherARPriceCell*)self.lastSelectCell;;
        currentSelectReason = cell.textView.text;
        if (isNullString(currentSelectReason)) {
            [ZZHUD showErrorWithStatus:@"请输入申请原因!"];
            return;
        }
        if (currentSelectReason.length <=6) {
            [ZZHUD showErrorWithStatus:@"请至少输入6个字符"];
            return;
        }
    }
    if (self.model.isResponsible==NO) {
        //选对方要上传图片  //除了对方无响应
        if ([currentSelectReason isEqualToString:@"无法联系对方"]&&![self.order.status isEqualToString:@"refunding"]) {
             NSLog(@"PY_弹出弹窗告诉用户你先联系对方");
            WS(weakSelf);
            ZZARRentAlertView *alertView =   [[ZZARRentAlertView alloc]init];
          if ([self.order.status isEqualToString:@"paying"]) {//意向金
              alertView.detailTitleLab.text = @"对方可能在忙，再给TA发条消息吧";
          }
            [alertView showAlertView];
            alertView.sureBlock = ^{
                [weakSelf uploadReasonWithType:2 reason:currentSelectReason];
            };
            alertView.seeBlock = ^{
                ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
                controller.orderId = weakSelf.order.id;
                controller.isFromChat = weakSelf.isFromChat;
                [self.navigationController pushViewController:controller animated:YES];
                
            };
            return;
        }
        else if (![self.order.status isEqualToString:@"refunding"]) {
            if (self.imageArray.count<=0) {
                [ZZHUD showErrorWithStatus:@"请上传证据"];
                return;
            }
        }
        [self uploadReasonWithType:2 reason:currentSelectReason];

        return;
    }
    else {
        //判断是不是退款
        if (![self.order.status isEqualToString:@"paying"]) {
            [self uploadReasonWithType:1 reason:currentSelectReason];
        }
        else {
            [self cancelDepositWithParam:currentSelectReason];
        }
    }
    
}

/**
 取消邀约,选自己原因意向金

 @param content 原因
 */
- (void)cancelDepositWithParam:(NSString *)content {//意向金退款
    NSDictionary *param = @{@"reason":content,
                            @"reason_type":@1};
    [ZZOrder cancelOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self requestCallBack:data error:error];
    }];
}
/**
 上传

 @param type 责任人  type 1 用户自己的责任  type2 达人的责任
 @param reasonContent 上传具体的理由
 */
- (void)uploadReasonWithType:(NSInteger )type  reason:(NSString *)reasonContent {
 
    if ([self.lastSelectCell isKindOfClass:[ZZOrderARSelectButtonCell class]]) {
        //选择
        NSMutableDictionary *param = [@{@"price":[NSNumber numberWithDouble:self.order.deposit],
                                        @"dispute":[NSNumber numberWithBool:NO],//是否要申述
                                        @"is_deposit":[NSNumber numberWithBool:YES],//
                                        @"reason_type":[NSNumber numberWithInteger:type]} mutableCopy];
        
        if (![self.order.status isEqualToString:@"paying"]) {//退款
            NSNumber *price = [NSNumber numberWithDouble:[self.refundAmountTF.text doubleValue]];
           param = [@{@"price":price,
                                    @"dispute":[NSNumber numberWithBool:self.order.refund.dispute],
                                    @"reason_type":[NSNumber numberWithInteger:type]}mutableCopy];
        }
        [param setObject:reasonContent forKey:@"remarks"];
        [param setObject:reasonContent forKey:@"reason"];
        //选择
        if (_imageArray.count>0) {
            [ZZHUD showWithStatus:@"图片上传中..."];
            [ZZUploader uploadImages:_imageArray progress:^(CGFloat progress) {
                
            } success:^(NSArray *urlArray) {
                [param setObject:urlArray forKey:@"photos"];
                NSDictionary *aDict = @{@"refund":param};
                if (![self.order.status isEqualToString:@"paying"]) {
                    //退款
                    [self refundModifyDepositWithParam:aDict];
                } else {
                    //意向金
                    [self refundDepositWithParam:aDict];
                }
             
            } failure:^{
                [ZZHUD showErrorWithStatus:@"图片上传失败!"];
            }];
        } else {
            NSDictionary *aDict = @{@"refund":param};
            if (![self.order.status isEqualToString:@"paying"]) {
                //退款
                [self refundModifyDepositWithParam:aDict];
            } else {
                //意向金
                [self refundDepositWithParam:aDict];
            }
        }
    }else{
        //选其他的原因
        ZZOrderArOtherARPriceCell *lastCell = (ZZOrderArOtherARPriceCell*)self.lastSelectCell;
   
        NSString *string  =  [lastCell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableDictionary *param = [@{@"price":[NSNumber numberWithDouble:self.order.deposit],
                                        @"dispute":[NSNumber numberWithBool:NO],
                                        @"is_deposit":[NSNumber numberWithBool:YES],
                                        @"remarks":string,
                                        @"reason":string,
                                        @"reason_type":[NSNumber numberWithInteger:type]} mutableCopy];
        if (![self.order.status isEqualToString:@"paying"]) {//退款
            NSNumber *price = [NSNumber numberWithDouble:[self.refundAmountTF.text doubleValue]];

            param = [@{@"price":price,
                                    @"dispute":[NSNumber numberWithBool:self.order.refund.dispute],
                                    @"remarks":string,
                                    @"reason":string,
                                    @"reason_type":[NSNumber numberWithInteger:type]} mutableCopy];
        }
        if (_imageArray.count>0) {
            [ZZHUD showWithStatus:@"图片上传中..."];
            [ZZUploader uploadImages:_imageArray progress:^(CGFloat progress) {
                
            } success:^(NSArray *urlArray) {
                [param setObject:urlArray forKey:@"photos"];
                NSDictionary *aDict = @{@"refund":param};
                if (![self.order.status isEqualToString:@"paying"]) {
                    //退款
                    [self refundModifyDepositWithParam:aDict];
                } else {
                    //意向金
                    [self refundDepositWithParam:aDict];
                }
            } failure:^{
                [ZZHUD showErrorWithStatus:@"图片上传失败!"];
            }];
        } else {
            NSDictionary *aDict = @{@"refund":param};
            if (![self.order.status isEqualToString:@"paying"]) {
                //退款
                [self refundModifyDepositWithParam:aDict];
            } else {
                //意向金
                [self refundDepositWithParam:aDict];
            }
        }
    }
}

- (void)requestCallBack:(id)data error:(ZZError *)error {
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
        self.tableView.userInteractionEnabled = YES;
    }
    else {
        [ZZHUD dismiss];
        if (_callBack) {
            _callBack(data[@"status"]);
        }
        BOOL isPop =NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZZChatViewController class]]) {
                ZZChatViewController *chatView =(ZZChatViewController *)controller;
                isPop = YES;
                [self.navigationController popToViewController:chatView animated:YES];
            }
        }
        if (!isPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/**
退款的
 @param param  修改邀约
 */
- (void)refundModifyDepositWithParam:(NSDictionary *)param {
    if (self.isModify) {
        [ZZHUD showWithStatus:@"正在修改退款申请.."];
        [ZZOrder editRefundOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    }
    else {
        [ZZHUD showWithStatus:@"正在申请退款.."];
        [ZZOrder refundOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    }
}

//意向金退款
- (void)refundDepositWithParam:(NSDictionary *)param {
    [ZZHUD showWithStatus:@"正在申请退意向金.."];
    [ZZOrder refundOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            if (_callBack) {
                _callBack(data[@"status"]);
            }
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZOrderDetailViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
