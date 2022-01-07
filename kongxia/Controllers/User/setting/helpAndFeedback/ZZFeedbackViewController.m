//
//  ZZFeedbackViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFeedbackViewController.h"

#import "ZZOrderRefundTitleCell.h"
#import "ZZOrderRefundPhotoCell.h"

#import "TPKeyboardAvoidingTableView.h"
#import "ZZUploader.h"

@interface ZZFeedbackViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL                _show;
}

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UITextField *contactTF;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation ZZFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationRightDoneBtn];
    
    [self createViews];
    [self createHeadView];
}

- (void)createViews
{
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _imageArray = [NSMutableArray array];
    
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightDoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 285)];
    headView.backgroundColor = kBGColor;
    
    UIView *contactBgView = [[UIView alloc] init];
    contactBgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:contactBgView];
    
    [contactBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left);
        make.right.mas_equalTo(headView.mas_right);
        make.top.mas_equalTo(headView.mas_top).offset(15);
        make.height.mas_equalTo(@50);
    }];
    
    _contactTF = [[UITextField alloc] init];
    _contactTF.backgroundColor = [UIColor whiteColor];
    _contactTF.textAlignment = NSTextAlignmentLeft;
    _contactTF.textColor = kBlackTextColor;
    _contactTF.font = [UIFont systemFontOfSize:15];
    _contactTF.placeholder = @"联系方式 ( 电话／微信／QQ／微博）";
    _contactTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contactBgView addSubview:_contactTF];
    
    [_contactTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contactBgView.mas_left).offset(15);
        make.top.mas_equalTo(contactBgView.mas_top);
        make.bottom.mas_equalTo(contactBgView.mas_bottom);
        make.right.mas_equalTo(contactBgView.mas_right).offset(-15);
    }];
    
    UIView *contentBgView = [[UIView alloc] init];
    contentBgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:contentBgView];
    
    [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left);
        make.top.mas_equalTo(contactBgView.mas_bottom).offset(15);
        make.right.mas_equalTo(headView.mas_right);
        make.height.mas_equalTo(@190);
    }];
    
    _contentTV = [[UITextView alloc] init];
    _contentTV.textAlignment = NSTextAlignmentLeft;
    _contentTV.textColor = kBlackTextColor;
    _contentTV.font = [UIFont systemFontOfSize:15];
    _contentTV.placeholder = @"您的反馈是我们产品进步的原动力";
    _contentTV.delegate = self;
    [contentBgView addSubview:_contentTV];
    
    [_contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentBgView.mas_left).offset(15);
        make.right.mas_equalTo(contentBgView.mas_right).offset(-15);
        make.top.mas_equalTo(contentBgView.mas_top).offset(10);
        make.bottom.mas_equalTo(contentBgView.mas_bottom).offset(-20);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentLeft;
    _countLabel.textColor = kGrayTextColor;
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.text = @"0/200";
    [contentBgView addSubview:_countLabel];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentBgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(contentBgView.mas_bottom).offset(-5);
    }];
    
    _tableView.tableHeaderView = headView;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _show ? 2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"titlecell";
        
        ZZOrderRefundTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZOrderRefundTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (_show) {
            cell.arrowImgView.hidden = YES;
        } else {
            cell.arrowImgView.hidden = NO;
        }
        
        return cell;
    } else {
        static NSString *identifier = @"photocell";
        
        ZZOrderRefundPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZOrderRefundPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setData:_imageArray];
        
        WeakSelf;
        cell.touchAdd = ^{
            [weakSelf addImgBtnClick];
        };
        cell.touchImage = ^(NSInteger index) {
            [weakSelf imgBtnClic:index];
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    } else {
        return (SCREEN_WIDTH - 60)/3 + 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (SCREEN_WIDTH - 60)/3 + 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 60)/3 + 40)];
    footView.backgroundColor = kBGColor;
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_show) {
        _show = YES;
        [_tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)addImgBtnClick
{
    [UIActionSheet showInView:self.view
                    withTitle:@"上传照片"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex ==0) {
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setDelegate:self];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                             imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [_imageArray addObject:image];
                                     [_tableView reloadData];
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
                             [imgPicker setDelegate:self];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 IOS_11_NO_Show
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [_imageArray addObject:image];
                                     [_tableView reloadData];
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

- (void)imgBtnClic:(NSInteger)index
{
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:nil tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            [_imageArray removeObjectAtIndex:index];
            [_tableView reloadData];
        }
    }];
}

- (void)rightDoneBtnClick
{
    [self.view endEditing:YES];
    if (isNullString(_contentTV.text)) {
        [ZZHUD showErrorWithStatus:@"请输入您的反馈内容!"];
        return;
    }
    if (_imageArray.count) {
        [ZZHUD showWithStatus:@"图片上传中..."];
        [ZZUploader uploadImages:_imageArray progress:^(CGFloat progress) {
            
        } success:^(NSArray *urlArray) {
            [self feedbackWithImageArray:urlArray];
        } failure:^{
            [ZZHUD showErrorWithStatus:@"图片上传失败!"];
        }];
    } else {
        [self feedbackWithImageArray:nil];
    }
}

- (void)feedbackWithImageArray:(NSArray *)imageArray
{
    [ZZHUD showWithStatus:@"反馈中..."];
    NSMutableDictionary *aDict = [@{@"content":_contentTV.text} mutableCopy];
    
    if (!isNullString(_contactTF.text)) {
        [aDict setObject:_contactTF.text forKey:@"contact"];
    }
    if (imageArray.count) {
        [aDict setObject:imageArray forKey:@"photos"];
    }
    
    [ZZRequest method:@"POST" path:@"/system/suggestion" params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"感谢您的反馈"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextViewMethod

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
