//
//  ZZPostTaskContentCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskContentCell.h"
#import "ZZPostTaskViewModel.h"

@interface ZZPostTaskContentCell () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UILabel *countsLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) NSInteger maxCounts;

@end

@implementation ZZPostTaskContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _maxCounts = 200;
        _limitHeight = 53;
        [self addNotification];
        [self layout];
        
    }
    return self;
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)configureData {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titleLabel.text = _cellModel.title;
}

- (CGSize)boundsWithMaxSize:(CGSize)size font:(UIFont *)font lineSpace:(CGFloat)lineSpace str:(NSString *)str {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:str]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}

- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (void)configureHeight:(NSString *)str isDefault:(BOOL)isDefault {
    
    CGFloat height = [NSString findHeightForText:str havingWidth:_contentTextView.width - _contentTextView.textContainerInset.left - _contentTextView.textContainerInset.right andFont:_contentTextView.font];
    NSInteger textHeight = height + 1;
    
    CGFloat textViewHeight = textHeight + _contentTextView.textContainerInset.top + _contentTextView.textContainerInset.bottom + 10;
    
    if (isDefault) {
        _limitHeight = textViewHeight;
        [UIView animateWithDuration:0.2 animations:^{
            _contentTextView.height = textViewHeight;
            _countsLabel.frame = CGRectMake(15.0, _contentTextView.bottom + 10.0, SCREEN_WIDTH - 30.0, _countsLabel.font.lineHeight + 5.0);
            _line.frame = CGRectMake(15.0, _countsLabel.bottom + 15.0, SCREEN_WIDTH - 30.0, 1);
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:cellHeight:)]) {
            [self.delegate cell:self cellHeight:_line.bottom];
        }
    }
    else {
        if (textViewHeight > _limitHeight) {
            [UIView animateWithDuration:0.2 animations:^{
                _contentTextView.height = textViewHeight;
                _countsLabel.frame = CGRectMake(15.0, _contentTextView.bottom + 10.0, SCREEN_WIDTH - 30.0, _countsLabel.font.lineHeight + 5.0);
                _line.frame = CGRectMake(15.0, _countsLabel.bottom + 15.0, SCREEN_WIDTH - 30.0, 1);
            }];
            CGFloat cellHeight = _line.bottom;
            if (fabs(cellHeight - _cellModel.cellHeight) > 0.01) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cell:cellHeight:)]) {
                       [self.delegate cell:self cellHeight:_line.bottom];
                   }
            }
        }
    }
}

#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange:(NSNotification *)notification {
    UITextRange *selectedRange = [_contentTextView markedTextRange];
    // 获取高亮选择部分
    UITextPosition *position = [_contentTextView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
    if (!position) {
        if (_contentTextView.text.length > _maxCounts) {
            // 截取子串
            _contentTextView.text = [_contentTextView.text substringToIndex:_maxCounts];
        }
    }
    _countsLabel.text = [NSString stringWithFormat:@"%ld/%ld", _contentTextView.text.length, _maxCounts];
    
    [self configureHeight:_contentTextView.text isDefault:NO];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didInputContent:)]) {
        [self.delegate cell:self didInputContent:textView.text];
    }
}

#pragma mark - Layout
- (void)layout {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.countsLabel];
    [self.contentView addSubview:self.line];
    
    _titleLabel.frame = CGRectMake(15.0, 15, SCREEN_WIDTH - 15 - 15, _titleLabel.font.lineHeight);
    
    _contentTextView.frame = CGRectMake(15.0, _titleLabel.bottom + 5, SCREEN_WIDTH - 30.0, 53);
    
    _countsLabel.frame = CGRectMake(15.0, _contentTextView.bottom + 15.0, SCREEN_WIDTH - 30.0, _countsLabel.font.lineHeight);
    
    _line.frame = CGRectMake(15.0, _countsLabel.bottom + 15.0, SCREEN_WIDTH - 30.0, 1);
}

#pragma mark - getters and setters
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
    }
    return _titleLabel;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.placeholder = @"热情有礼貌的人会更受欢迎哦！描述一下你的活动细节如：活动的具体时间、要做什么；或对参与用户的具体要求、需要几人、具备哪些技能等";
        _contentTextView.textColor = RGBCOLOR(102, 102, 102);
        _contentTextView.font = [UIFont systemFontOfSize:13.0];//[UIFont fontWithName:@"PingFangSC-Medium" size:13.0];
        _contentTextView.backgroundColor = UIColor.whiteColor;
        _contentTextView.delegate = self;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(5.0, 0.0, 5.0, 10.0);
        _contentTextView.textContainer.lineFragmentPadding = 0;
        _contentTextView.layoutManager.allowsNonContiguousLayout = NO;
        _contentTextView.userInteractionEnabled = YES;
    }
    return _contentTextView;
}

- (UILabel *)countsLabel {
    if (!_countsLabel) {
        _countsLabel = [[UILabel alloc] init];
        _countsLabel.text = [NSString stringWithFormat:@"0/%ld", _maxCounts];
        _countsLabel.textColor = RGBCOLOR(102, 102, 102);
        _countsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.0];
        _countsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countsLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}

@end
