#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
char pinyinFirstLetter(unsigned short hanzi);

@end