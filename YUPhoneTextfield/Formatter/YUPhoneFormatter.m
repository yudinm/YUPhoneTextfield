//
//  YUPhoneFormatter.m
//  YUPhoneTextfield
//
//  Created by michael on 01.07.14.
//  Copyright (c) 2014 ru.michael.yudin. All rights reserved.
//

#import "YUPhoneFormatter.h"

@interface YUPhoneFormatter ()

@end

@implementation YUPhoneFormatter

- (NSString *)stringForObjectValue:(id)aObject {
    //    NSString *strFromatExample = @"+_ (__) ___-__-__";
    NSString *strFromatExampleTrimmed = @"__________";

    if (![aObject isKindOfClass:[NSString class]]) return nil;
    if ([aObject length] < 1) return nil;

    NSMutableString *trimmedString = [[self trimNonDigit:aObject] mutableCopy];
    while (trimmedString.length<=strFromatExampleTrimmed.length) {
        [trimmedString appendFormat:@"_"];
    }

    // \+d{1}\(\d{3}\)\d{3}[-.]?\d{2}[-.]?\d{2}\b
    NSString *prefix1 = @"+";
    NSString *prefix11 = @" (";
    NSString *prefix2 = @") ";
    NSString *prefix3 = @"-";
    NSString *prefix4 = @"-";

    NSMutableString *oStrFormatted = [[NSMutableString alloc] init];
    //    NSString *prefixNum = [trimmedString substringFromIndex:1];
    if (trimmedString.length>0&&trimmedString.length<=1) {
        [oStrFormatted appendFormat:@"%@%@%@",prefix1,[trimmedString substringWithRange:NSMakeRange(0, trimmedString.length)],prefix11];
    }
    if (trimmedString.length>1&&trimmedString.length<=4) {
        [oStrFormatted appendFormat:@"%@%@%@",prefix1,[trimmedString substringWithRange:NSMakeRange(0, 1)],prefix11];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(1, trimmedString.length-1)],prefix2];
    }
    if (trimmedString.length>4&&trimmedString.length<=7) {
        [oStrFormatted appendFormat:@"%@%@%@",prefix1,[trimmedString substringWithRange:NSMakeRange(0, 1)],prefix11];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(1, 3)],prefix2];
        [oStrFormatted appendFormat:@"%@",[trimmedString substringWithRange:NSMakeRange(4, trimmedString.length-4)]];
    }
    if (trimmedString.length>7&&trimmedString.length<=9) {
        [oStrFormatted appendFormat:@"%@%@%@",prefix1,[trimmedString substringWithRange:NSMakeRange(0, 1)],prefix11];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(1, 3)],prefix2];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(4, 3)],prefix3];
        [oStrFormatted appendFormat:@"%@",[trimmedString substringWithRange:NSMakeRange(7, trimmedString.length-7)]];
    }
    if (trimmedString.length>9&&trimmedString.length<=11) {
        [oStrFormatted appendFormat:@"%@%@%@",prefix1,[trimmedString substringWithRange:NSMakeRange(0, 1)],prefix11];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(1, 3)],prefix2];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(4, 3)],prefix3];
        [oStrFormatted appendFormat:@"%@%@",[trimmedString substringWithRange:NSMakeRange(7, 2)],prefix4];
        [oStrFormatted appendFormat:@"%@",[trimmedString substringWithRange:NSMakeRange(9, trimmedString.length-9)]];
    }


    return oStrFormatted;
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString  **)error {
    *obj = (id)[self trimNonDigit:string];
    return YES;
}


- (NSString*)trimNonDigit:(NSString *)aString
{
    NSString *pattern = @"[^0-9]";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSString *trimmedString = [regexp stringByReplacingMatchesInString:aString options:0 range:NSMakeRange(0, [aString length]) withTemplate:@""];
    return trimmedString;
}

+ (NSString*)clearFromFormat:(NSString*)aString
{
    NSString *oString = [aString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    oString = [oString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    oString = [oString stringByReplacingOccurrencesOfString:@")" withString:@""];
    oString = [oString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    oString = [oString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return oString;
}

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    YUPhoneFormatter *pf = [[YUPhoneFormatter alloc] init];
    NSString *trimmedString = [pf trimNonDigit:string]; // Чищу от нецифр входную строку
    NSString *text = textField.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\+)|(\\()|(\\))|(-)|( )" options:0 error:nil];
    text = [text stringByReplacingCharactersInRange:range withString:trimmedString]; // Применяю изминения с клавиатуры к тексту имеющемуся уже в поле ввода

    NSString *newText = [regex stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) withTemplate:@""]; // Очищаю измененный номер от нашего формата чтобы получить только 10 или меньше цифр
    NSString *oldText = [regex stringByReplacingMatchesInString:textField.text options:NSMatchingReportProgress range:NSMakeRange(0, textField.text.length) withTemplate:@""]; // Очищаю НЕ измененный номер от нашего формата чтобы получить только 10 или меньше цифр
    if ([string isEqualToString:@""]) { // Обрабатываю более-менее приятное удаление
        if (newText.length<=4&&range.location<10) {
            newText = [newText substringToIndex:newText.length-1];
        }
        if (newText.length==oldText.length) { // Если изменения после ввода не повлияли на длину "чистого" номера, то пытались удалить формат, а значит ничего не делаем
            return NO;
        }
    }
    if ([pf trimNonDigit:newText].length>11) {
        return NO;
    }
    NSString *formattedString = [pf stringForObjectValue:newText]; // Форматирую измененный номер для вывода
    textField.text = formattedString; // Вывожу
    NSString *newTrimmedString = [pf trimNonDigit:newText];
    if (newTrimmedString.length) {
        NSInteger lastCharPos = [formattedString rangeOfString:[newTrimmedString substringFromIndex:newTrimmedString.length-1] options:NSBackwardsSearch].location;
        UITextPosition *selPos = [textField positionFromPosition:[textField beginningOfDocument] offset:lastCharPos+1];
        textField.selectedTextRange = [textField textRangeFromPosition:selPos toPosition:selPos];
    } else {
        UITextPosition *selPos = [textField positionFromPosition:[textField beginningOfDocument] offset:1];
        textField.selectedTextRange = [textField textRangeFromPosition:selPos toPosition:selPos];
    }
    //        self.currentUser.phone = newText; // Обновляю переменную, которую будем отсылать на сервер или передавать куда-то дальше
    //    _strPhoneNumber = formattedString;
    return NO;
}

@end