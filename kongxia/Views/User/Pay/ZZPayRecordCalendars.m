//
//  ZZPayRecordCalendars.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPayRecordCalendars.h"
@interface ZZPayRecordCalendars()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy) NSString *chooseTimeStr;
@property(nonatomic,copy) NSString *chooseYearStr;
@property(nonatomic,copy) NSString *chooseMonthStr;


@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong,nonatomic)void(^blockChoose)(NSString *string,NSString *yearStr,NSString *monthStr);
@property (strong,nonatomic)void(^canceBlock)(NSString *string);
@property (strong, nonatomic)  NSMutableArray *yearArray;
@property (strong, nonatomic)  NSMutableArray *monthArray;

@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIView *lineView, *alertView;
@property (strong, nonatomic) UILabel *selectTimeLab;//当前选中的时间

@end
@implementation ZZPayRecordCalendars
singleton_implementation(ZZPayRecordCalendars)

- (void)dealloc {
    NSLog(@"%s",__func__);
}
/**
 时间选择器
 
 @param array 传入的数组
 @param sureBlock 确认按钮
 @param cancelBtnClick 取消按钮
 */
+ (void)timeChoosePickerViewShowWithNSArray:(NSArray *)array showView:(UIView *)showView completionSureBlock:(void(^)(NSString *chooseTime,NSString *yearStr,NSString *monthStr))sureBlock completionCanceBlock:(void(^)(NSString *chooseTime))cancelBtnClick  {
    _instance = nil;
    singleton_onceToken = 0;
    singleton_share_onceToken= 0;
    if (array.count>0) {
        [ZZPayRecordCalendars shared].yearArray = (NSMutableArray *)array;
        [ZZPayRecordCalendars shared].chooseYearStr = [NSString stringWithFormat:@"%@",array[0]];
        [ZZPayRecordCalendars shared].chooseTimeStr = [NSString stringWithFormat:@"%@ - %d",array[0],1];
    }else {
        NSInteger year =  [[NSDate date] year];
        NSInteger month =  [[NSDate date] month];
        //公司在2015年成立的所以
        for (int x= 0; x<(year - 2014); x++) {
            [[ZZPayRecordCalendars shared].yearArray addObject:[NSString stringWithFormat:@"%ld",year-x]];
        }
       [ZZPayRecordCalendars shared].chooseYearStr = [NSString stringWithFormat:@"%ld",year];
       [ZZPayRecordCalendars shared].chooseMonthStr = [NSString stringWithFormat:@"%ld",month];
       [ZZPayRecordCalendars shared].chooseTimeStr = [NSString stringWithFormat:@"%ld - %ld",year,month];
    }
    
    [[ZZPayRecordCalendars shared] showWithShowView:showView];
    [ZZPayRecordCalendars shared].blockChoose = sureBlock;
}

- (void)sureBtnClick {
    [self dissMiss];
    if (self.blockChoose) {
    self.blockChoose(self.chooseTimeStr,self.chooseYearStr,self.chooseMonthStr);
    }
}

- (void)cancelBtnClick {
    [self dissMiss];
    if (self.canceBlock) {
        self.canceBlock(self.chooseTimeStr);
    }
}




- (void)showWithShowView:(UIView *)showView{
    if (showView) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, showView.height);
    }
    else{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
     NSLog(@"PY_传进来的view的frame %@", NSStringFromCGRect(showView.frame));
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.31];

    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height- AdaptedHeight(261)-SafeAreaBottomHeight, SCREEN_WIDTH, AdaptedHeight(261)+SafeAreaBottomHeight)];
    [self addSubview:_alertView];
    _alertView.backgroundColor = [UIColor whiteColor];
    
    [_alertView addSubview:self.cancelBtn];
    [_alertView addSubview:self.sureBtn];
    [_alertView addSubview:self.lineView];
    [_alertView addSubview:self.pickerView];
    [_alertView addSubview:self.selectTimeLab];
    [self setUpConstraints];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    
    if (showView) {
        [showView addSubview:self];
        [showView bringSubviewToFront:self];
    }
    else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    }

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
    } completion:nil];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint locationIn = [recognizer locationInView:self];
    if (locationIn.y>(SCREEN_HEIGHT- AdaptedHeight(261)-SafeAreaBottomHeight)) {
        return;
    }
    [self dissMiss];
}
- (void)dissMiss {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            _instance = nil;
            singleton_onceToken = 0;
            singleton_share_onceToken= 0;
        }
    }];
}
#pragma mark pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
         return [_yearArray count];
    }else{
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        if (selectedRow == 0) {
            return [[NSDate date] month];
        }
         return [self.monthArray count];
    }
   
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return AdaptedHeight(51);
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  AdaptedWidth(98);
}

//// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        for(UIView *singleLine in pickerView.subviews)
        {
            if (singleLine.frame.size.height < 1)
            {
                singleLine.backgroundColor = [UIColor blackColor];
            }
        }
        view = [[UIView alloc]init];
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AdaptedWidth(98), AdaptedHeight(51))];
        text.textAlignment = NSTextAlignmentCenter;
        text.font = AdaptedFontSize(18);
        if (component == 0) {
            text.text = [self.yearArray objectAtIndex:row];
        }else{
            text.text = [self.monthArray objectAtIndex:row];
        }

        [view addSubview:text];
    }

    return view;
}


//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        if (component == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        self.chooseYearStr =[_yearArray objectAtIndex:row];
        self.chooseMonthStr = @"1";

    }else{
        self.chooseMonthStr = [NSString stringWithFormat:@"%ld",row+1];
    }
    _chooseTimeStr = [NSString stringWithFormat:@"%@ - %@",_chooseYearStr,_chooseMonthStr];
    self.selectTimeLab.text = _chooseTimeStr;
}



#pragma mark - 懒加载

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


-(UIButton *)sureBtn {
    if (!_sureBtn) {
       _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:RGBCOLOR(34, 134, 251) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = [UIColor whiteColor];

    }
    return _sureBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor =  RGBCOLOR(237, 237, 237);
    }
    return _lineView;
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    
    }
    return _pickerView;
}
- (UILabel *)selectTimeLab {
    if (!_selectTimeLab) {
        _selectTimeLab = [[UILabel alloc]init];
        _selectTimeLab.font =AdaptedFontSize(17);
        _selectTimeLab.textColor = RGBCOLOR(244, 203, 7);
        _selectTimeLab.textAlignment = NSTextAlignmentCenter;
        _selectTimeLab.text = _chooseTimeStr;
    }
    return _selectTimeLab;
}

- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [NSMutableArray arrayWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil];
    }
    return _monthArray;
}

#pragma mark - 设置约束
- (void)setUpConstraints {
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.sureBtn.mas_centerY);
        make.width.equalTo(self.cancelBtn.mas_height);
        make.height.equalTo(@(AdaptedWidth(50)));
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectTimeLab.mas_centerY);
        make.width.equalTo(self.sureBtn.mas_height);
        make.height.equalTo(@(AdaptedWidth(50)));
        make.right.offset(-15);
    }];
    
    [self.selectTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView.mas_centerX);
        make.top.offset(0);
        make.height.equalTo(@(AdaptedWidth(50)));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.selectTimeLab.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(AdaptedWidth(200)));
        make.centerX.equalTo(self.alertView.mas_centerX);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.equalTo(@(AdaptedHeight(210)));
    }];
}

@end
