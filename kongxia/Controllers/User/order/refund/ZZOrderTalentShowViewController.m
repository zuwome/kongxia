//
//  ZZOrderTalentShowViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderTalentShowViewController.h"
#import "ZZRuleHelper.h"
#import "ZZOrderOptionModel.h"
#import "ZZLinkWebViewController.h"
#import "ZZPlatformRentRulesFootView.h"
#import "ZZOrderARSelectButtonCell.h"
#import "TYAttributedLabel.h"
#import "ZZReportViewController.h"
#import "ZZOrderRefuseReasonCell.h"

@interface ZZOrderTalentShowViewController ()<UITableViewDelegate,UITableViewDataSource,TYAttributedLabelDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitButton;//提交按钮
@property (nonatomic,strong) ZZOrderRefundModel *refundModel;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UILabel *headerViewTitleLab;
@property (nonatomic,strong)  ZZOrderARBaseCell *lastSelectCell;
@property (nonatomic,strong) UIView *footView;
@end

@implementation ZZOrderTalentShowViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFrom) {
        self.navigationItem.title = @"选择理由";
    }else  if(self.isRefusedInvitation){
        self.navigationItem.title = @"拒绝理由";
    }else{
          self.navigationItem.title = @"取消预约";
    }
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
    [self loadCancel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.refundModel.data.count-1>=indexPath.row) {
        return 50;
    }
    return 154;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refundModel.data.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.refundModel.data.count-1>=indexPath.row) {
        ZZOrderARSelectButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderARSelectButtonCellID"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentTitle  = self.refundModel.data[indexPath.row];
        WS(weakSelf);
        cell.selecetBlock = ^(ZZOrderARSelectButtonCell *currentCell) {
            if (currentCell.button.selected == NO) {
                weakSelf.lastSelectCell = nil;
                return  ;
            }
            
            [weakSelf changeCellSelect:currentCell];
        };
        return cell;
    }else{
        ZZOrderRefuseReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderRefuseReasonCellID"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentTitle = @"其他";
        if ([self.order.status isEqualToString:@"pending"]) {
            //达人没有接受,用户取消
            cell.textView.placeholder = @"请输入退款原因";
        }
        WS(weakSelf);
        cell.selecetBlock = ^(ZZOrderRefuseReasonCell *currentCell) {
            if (currentCell.button.selected == NO) {
                weakSelf.lastSelectCell = nil;
                return ;
            }
            [weakSelf changeCellSelect:currentCell];
        };
        return cell;
    }
}
- (void)changeCellSelect:(ZZOrderARBaseCell *)currentCell {
    if (self.lastSelectCell) {
        self.lastSelectCell.button.selected = NO;
        if ([self.lastSelectCell isKindOfClass:[ZZOrderRefuseReasonCell class]]) {
            ZZOrderRefuseReasonCell *lastCell = (ZZOrderRefuseReasonCell*)self.lastSelectCell;
            [lastCell.textView resignFirstResponder];
        }
    }
    self.lastSelectCell = currentCell;
 
}
- (void)loadCancel {
    [ZZRuleHelper pullCancelList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            _refundModel = [[ZZOrderRefundModel alloc] initWithDictionary:data error:nil];
            ZZPlatformRentRulesFootView *view = [[ZZPlatformRentRulesFootView alloc]init];
            
            if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:self.order.from.uid]) {
                //用户查看违规行为手册
                [view setRentRulesString:_refundModel.illegal_to];
                
            }else{    //达人查看违规行为手册
                [view setRentRulesString:_refundModel.illegal_from];
            }
            WS(weakSelf);
            view.touchHead = ^{
                [weakSelf goToRuleInfo];
            };
            _tableView.tableFooterView  = view;
            
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 懒加载
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZZOrderARSelectButtonCell class] forCellReuseIdentifier:@"ZZOrderARSelectButtonCellID"];
        [_tableView registerClass:[ZZOrderRefuseReasonCell class] forCellReuseIdentifier:@"ZZOrderRefuseReasonCellID"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerViewTitleLab = [[UILabel alloc]init];
        _headerViewTitleLab.textColor = RGBCOLOR(63, 58, 58);
        _headerViewTitleLab.textAlignment = NSTextAlignmentLeft;
        _headerViewTitleLab.font = CustomFont(15);
        _headerViewTitleLab.text = @"自己的原因";
        _headerViewTitleLab.frame = CGRectMake(15, 0, SCREEN_WIDTH-15, 50);
        [_headerView addSubview:_headerViewTitleLab];
        
    }
    return _headerView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc]init];
        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        TYAttributedLabel *moreInstructionLab = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-30, 40)];
        
        moreInstructionLab.textColor = kBlackColor;
        moreInstructionLab.font = CustomFont(12);
        moreInstructionLab.lineBreakMode = kCTLineBreakByCharWrapping;
        moreInstructionLab.backgroundColor = HEXCOLOR(0xf5f5f5);
        moreInstructionLab.delegate = self;
        moreInstructionLab.numberOfLines = 0;
        moreInstructionLab.linkColor = RGBCOLOR(74, 144, 226);
        if (self.isFrom) {
        moreInstructionLab.text = @"对方还未接受预约，现在取消预约意向金将返还至您的钱包。如遇对方违规，点击此处";
        }else if(!self.isRefusedInvitation){
            moreInstructionLab.text = @"自己的原因将扣除信任值10分，减少推荐的机会。如遇对方违规，点击此处";
        }else{
            moreInstructionLab.text = @"现在拒绝预约，意向金将返还至对方的钱包。如遇对方违规，点击此处";
        }
        [moreInstructionLab appendLinkWithText:@"匿名举报" linkFont:ADaptedFontBoldSize(12) linkData:@"匿名举报"];
        [moreInstructionLab appendText:@"，并获得赔偿"];
        [_footView addSubview:moreInstructionLab];
    }
    return _footView;
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"匿名举报"]) {
            ZZReportViewController *controller = [[ZZReportViewController alloc] init];
            controller.uid = self.uid;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
/**
 违规行为手册
 */
- (void)goToRuleInfo {
    NSString *urlString = H5Url.violationManual;
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.isPush = YES;
    controller.isShowLeftButton = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)submitButtonClick {
     NSLog(@"PY_ 达人接受预约后又取消了");
    if (!self.lastSelectCell) {
        [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
        return;
    }
    [self.view endEditing:YES];
    NSString * currentSelectReason;
    if ([self.lastSelectCell isKindOfClass:[ZZOrderARSelectButtonCell class]]) {
        ZZOrderARSelectButtonCell *lastCell = (ZZOrderARSelectButtonCell*)self.lastSelectCell;
        currentSelectReason = lastCell.currentTitle;
    }else{
        ZZOrderRefuseReasonCell *cell =  (ZZOrderRefuseReasonCell*)self.lastSelectCell;
        NSString *string =  [cell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        currentSelectReason = string;
        if (currentSelectReason.length<6) {
            [ZZHUD showTastInfoErrorWithString:@"请至少输入6个字符"];
            return;
        }
    }
    if (isNullString(currentSelectReason)) {
        [ZZHUD showTastInfoErrorWithString:@"请输入拒绝原因"];
        return;
    }
    
    if ([_order.status isEqualToString:@"paying"]) {
        [self showOkCancelAlert:@"提示"
                        message:@"你已经接受对方的邀请，主动取消将会扣除信任值，是否确认取消邀约"
                   confirmTitle:@"确定"
                 confirmHandler:^(UIAlertAction * _Nonnull action) {
            [self doneContent:currentSelectReason];
        }
                    cancelTitle:@"取消"
                  cancelHandler:nil];
    } else {
        if (_order.paid_at) {
            [self showOkCancelAlert:@"提示"
                            message:@"对方已通过平台担保支付全款，取消预约租金将退还给对方。"
                       confirmTitle:@"确定"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self doneContent:currentSelectReason];
            }
                        cancelTitle:@"取消"
                      cancelHandler:nil];
        } else {
            [self doneContent:currentSelectReason];
        }
    }
}


- (void)doneContent:(NSString *)content
{
    NSDictionary *param = @{@"reason":content,
                            @"reason_type":[NSNumber numberWithInteger:2]};
    [self request:param];
}

- (void)request:(NSDictionary *)param
{
    self.tableView.userInteractionEnabled = NO;
    if (self.isRefusedInvitation) {
        [ZZHUD showWithStatus:@"正在拒绝..."];
        [ZZOrder refuseOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    }else {
        [ZZHUD showWithStatus:@"正在取消.."];
        [ZZOrder cancelOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBack:data error:error];
        }];
    }
  
}

- (void)requestCallBack:(id)data error:(ZZError *)error
{
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
        self.tableView.userInteractionEnabled = YES;
    } else {
        [ZZHUD dismiss];
        if (_callBack) {
            _callBack(data[@"status"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
