//
//  TKFileManager.h
//  Thinking
//
//  Created by O*O on 17/2/10.
//  Copyright © 2017年 lane. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileName_FirstOpenApp       @"FileName_FirstOpenApp"
#define FileName_LoginUserModel     @"FileName_LoginUserModel"
#define FileName_UserModelHeadUrl   @"FileName_UserModelHeadUrl"
#define FileName_ChatMessage        @"FileName_ChatMessage"
#define FileName_DeviceToken        @"FileName_DeviceToken"
#define FileName_UserType           @"FileName_UserType"

@interface TKFileManager : NSObject

+ (void)saveData:(id)data withFileName:(NSString *)fileName;
+ (id)loadDataWithFileName:(NSString *)fileName;
+ (void)copyDefaultFileName:(NSString *)fileName;
+ (void)deleteFileName:(NSString *)fileName;
+ (void)saveValue:(id)value forKey:(NSString*)key;
+ (id)ValueWithKey:(NSString*)key;
+ (void)removeFileWithPath:(NSString*)path;
@end
