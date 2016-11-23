//
//  NSData+Base64AES128CBC.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);
char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);
@interface NSData (Base64)
+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;
- (NSData *)AES128EncryptWithKey:(NSString *)key;

- (NSData *)AES128DecryptWithKey:(NSString *)key;
@end

