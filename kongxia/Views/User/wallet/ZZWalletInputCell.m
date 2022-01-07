//
//  ZZWalletInputCell.m
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZWalletInputCell.h"

@interface ZZWalletRechargeMoneyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZWalletRechargeMoneyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 2;
        _bgView.clipsToBounds = YES;
        _bgView.layer.borderColor = kBlackTextColor.CGColor;
        _bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
    }
    
    return self;
}

@end

@interface ZZWalletInputCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *moneyArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *lastStr;

@end

@implementation ZZWalletInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _lastStr = @"";
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _moneyArray = @[@"10",@"50",@"100",@"500",@"1000",@"5000"];
        [self.contentView addSubview:self.collectionView];
        
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(125);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_textField.mas_left);
            make.right.mas_equalTo(_textField.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moneyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZWalletRechargeMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@元",_moneyArray[indexPath.row]];
    if (indexPath == _indexPath) {
        cell.bgView.backgroundColor = kYellowColor;
        cell.bgView.layer.borderWidth = 0;
    } else {
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.bgView.layer.borderWidth = 0.5;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != _indexPath) {
        _indexPath = indexPath;
        [self updateMoney:_moneyArray[indexPath.row]];
        [self endEditing:YES];
        self.textField.text = nil;
        [self.collectionView reloadData];
    }
}

- (void)updateMoney:(NSString *)money
{
    if (_moneyChanged) {
        _moneyChanged(money);
    }
}

#pragma mark - UITextFieldMethod

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_indexPath) {
        _indexPath = nil;
        [self.collectionView reloadData];
    }
    if (textField.text.length > _lastStr.length)
    {
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:_lastStr withString:@""];
        BOOL isPure = [self isPureInt:str];
        if (!isPure && ![str isEqualToString:@"."])
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:str withString:@""];
        }
    }
    
    if (textField.text.length>8)
    {
        textField.text = [textField.text substringToIndex:8];
    }
    
    [self updateMoney:textField.text];
    _lastStr = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [ZZUtils limitTextFieldWithTextField:textField range:range replacementString:string pure:NO];
}

//整形
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat width = (SCREEN_WIDTH - 15*2 - 25*2)/3.0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(width, 34);
        layout.sectionInset = UIEdgeInsetsMake(22, 15, 15, 15);
        layout.minimumLineSpacing = 20;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZWalletRechargeMoneyCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
