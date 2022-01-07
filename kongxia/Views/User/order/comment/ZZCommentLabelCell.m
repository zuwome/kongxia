//
//  ZZCommentLabelCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZCommentLabelCell.h"

#import "ZZCollectionConstantSpaceLayout.h"

@interface ZZCommentLabelInputCell : UICollectionViewCell

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZZCommentLabelInputCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _textField = [[UITextField alloc] init];
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"编辑标签";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.tintColor = kYellowColor;
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

@end

@interface ZZCommentLabelContentCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZCommentLabelContentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 2;
        _bgView.layer.borderColor = kGrayContentColor.CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kGrayContentColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
        }];
    }
    
    return self;
}

@end

@interface ZZCommentLabelCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *editCollectionView;
@property (nonatomic, strong) UICollectionView *labelCollectionView;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSString *selectLabel;

@end

@implementation ZZCommentLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.editCollectionView.hidden = NO;
        self.labelCollectionView.hidden = NO;
    }
    
    return self;
}

- (void)setLabelArray:(NSMutableArray *)labelArray
{
    _labelArray = labelArray;
    
    [self.labelCollectionView reloadData];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.editCollectionView) {
        return _selectLabel ? 2:1;
    } else {
        return _labelArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.editCollectionView) {
        if (_selectLabel && indexPath.row == 0) {
            ZZCommentLabelContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"labelcell" forIndexPath:indexPath];
            cell.bgView.backgroundColor = kYellowColor;
            cell.bgView.layer.borderWidth = 0;
            cell.titleLabel.text = _selectLabel;
            cell.titleLabel.textColor = kBlackTextColor;
            return cell;
        } else {
            ZZCommentLabelInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inputcell" forIndexPath:indexPath];
            cell.textField.delegate = self;
            [cell.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }
    } else {
        ZZCommentLabelContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = _labelArray[indexPath.row];
        if (_selectIndexPath == indexPath) {
            cell.bgView.backgroundColor = kYellowColor;
            cell.bgView.layer.borderWidth = 0;
            cell.titleLabel.textColor = kBlackTextColor;
        } else {
            cell.bgView.backgroundColor = [UIColor whiteColor];
            cell.bgView.layer.borderWidth = 0.5;
            cell.titleLabel.textColor = kGrayContentColor;
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.editCollectionView) {
        if (_selectLabel && indexPath.row == 0) {
            CGFloat width = [ZZUtils widthForCellWithText:_selectLabel fontSize:14] + 16;
            return CGSizeMake(width, 26);
        } else {
            return CGSizeMake(80, 26);
        }
    } else {
        NSString *string = _labelArray[indexPath.row];
        CGFloat width = [ZZUtils widthForCellWithText:string fontSize:14];
        return CGSizeMake(width+16, 26);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.labelCollectionView) {
        _selectIndexPath = indexPath;
        [self.labelCollectionView reloadData];
        
        [self updateEditCollectionView:_labelArray[indexPath.row]];
    }
}

- (void)updateEditCollectionView:(NSString *)label
{
    BOOL contain = _selectLabel;
    _selectLabel = label;
    if (_chooseLabel) {
        _chooseLabel(label);
    }
    [_editCollectionView performBatchUpdates:^{
        if (!isNullString(label)) {
            if (contain) {
                [_editCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
            } else {
                [_editCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
            }
        } else if (contain) {
            [_editCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

#pragma mark - UITextFieldMethod

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!isNullString(text)) {
        [self updateEditCollectionView:text];
        textField.text = nil;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = nil;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && range.location == 0) {
        [self updateEditCollectionView:nil];
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField
{
    NSString *toString = textField.text;
    NSString *language = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([language isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toString.length > 12) {
                textField.text = [toString substringToIndex:12];
            }
        }
    } else { // 非中文输入法
        if (toString.length > 12) {
            textField.text = [toString substringToIndex:12];
        }
    }
}

#pragma mark - lazyload

- (UICollectionView *)editCollectionView
{
    if (!_editCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 14;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _editCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(35, 45, SCREEN_WIDTH - 35 - 15, 35) collectionViewLayout:layout];
        _editCollectionView.backgroundColor = [UIColor whiteColor];
        [_editCollectionView registerClass:[ZZCommentLabelContentCell class] forCellWithReuseIdentifier:@"labelcell"];
        [_editCollectionView registerClass:[ZZCommentLabelInputCell class] forCellWithReuseIdentifier:@"inputcell"];
        _editCollectionView.delegate = self;
        _editCollectionView.dataSource = self;
        [self.contentView addSubview:_editCollectionView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"印象标签";
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        }];
        
        UIImageView *editImgView = [[UIImageView alloc] init];
        editImgView.image = [UIImage imageNamed:@"icon_user_edit"];
        [self addSubview:editImgView];
        
        [editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(_editCollectionView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 16));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(_editCollectionView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return _editCollectionView;
}

- (UICollectionView *)labelCollectionView
{
    if (!_labelCollectionView) {
        ZZCollectionConstantSpaceLayout *layout = [[ZZCollectionConstantSpaceLayout alloc] init];
        layout.minimumInteritemSpacing = 14;
        layout.minimumLineSpacing = 14;
        
        _labelCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _labelCollectionView.backgroundColor = [UIColor whiteColor];
        [_labelCollectionView registerClass:[ZZCommentLabelContentCell class] forCellWithReuseIdentifier:@"cell"];
        _labelCollectionView.delegate = self;
        _labelCollectionView.dataSource = self;
        [self addSubview:_labelCollectionView];
        
        [_labelCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
            make.top.mas_equalTo(self.mas_top).offset(80+10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-24);
        }];
    }
    return _labelCollectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
