
#import <Foundation/Foundation.h>


@interface NSString (Extensions)

/**
 * return yes if the str is nil or empty or contains only whitespace.
 */
+ (BOOL)isBlank:(NSString *)str;

/**
 * return no if the str is nil or empty or contains only whitespace.
 */
+ (BOOL)isNotBlank:(NSString *)str;

/**
 * return yes if the str is numeric ,otherwise no.
 */
+ (BOOL)isNumeric:(NSString *)str;

/**
 *  返回两个字符串比较，支持 nil 比较
 */
+ (BOOL)isEqualToStringOrblank:(NSString *)str1 compareString:(NSString *)str2;

/**
 * return string by base64.
 */
+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;

- (BOOL)isContain:(NSString*)asubstr;

- (BOOL)isPhoneNumber;

- (BOOL)isNumber;

- (BOOL)isEmail;

- (BOOL)isPhoneNumberOrEmail;

- (void)detectAllEmailWithBlock:(void (^)(NSString *email, NSRange range))emailBlock;

- (void)detectAllPhoneNumberWithBlock:(void (^)(NSString *phone, NSRange range))phoneBlock;

- (void)detectAllURLWithBlock:(void (^)(NSString *URL, NSRange range))URLBlock;

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 * @deprecated Use StringWithAnyText() instead. Updating your use of
 * this method is non-trivial. See the note below.
 *
 * Notes for updating your use of isEmptyOrWhitespace:
 *
 * if (!textField.text.isEmptyOrWhitespace) {
 *
 * becomes
 *
 * if (StringWithAnyText(textField.text) && !textField.text.isWhitespaceAndNewlines) {
 *
 * and
 *
 * if (textField.text.isEmptyOrWhitespace) {
 *
 * becomes
 *
 * if (0 == textField.text.length || textField.text.isWhitespaceAndNewlines) {
 */
- (BOOL)isEmptyOrWhitespace;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
- (NSString *)md5Hash;

- (NSString *)trim;
- (NSString *)trimBegin:(NSString *)strBegin;
- (NSString *)trimEnd:(NSString *)strEnd;
- (NSString *)trim:(NSString *)strTrim;

- (NSString *)replaceCRWithNewLine;

- (NSString *)replaceOldString:(NSString *)strOld WithNewString:(NSString *)strNew;

- (NSString *)UTIForPathExtension;

- (NSString *)MIMETypeForPathExtension;

- (NSString *)numberUppercaseString;

////md5(md5(password) & Right(md5(password),8))
//- (NSString *)multiMD5:(NSString *)str offset:(NSUInteger)offSet;

@end

