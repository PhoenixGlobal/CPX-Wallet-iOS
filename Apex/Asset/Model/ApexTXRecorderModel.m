//
//  ApexTXRecorderModel.m
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTXRecorderModel.h"
/*
 @property (nonatomic, strong) NSString *txid;
 @property (nonatomic, strong) NSString *fromAddress;
 @property (nonatomic, strong) NSString *toAddress;
 @property (nonatomic, strong) NSString *value;
 @property (nonatomic, strong) NSString *data;
 */
@implementation ApexTXRecorderModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.txid = [aDecoder decodeObjectForKey:@"txid"];
        self.fromAddress = [aDecoder decodeObjectForKey:@"fromAddress"];
        self.toAddress = [aDecoder decodeObjectForKey:@"toAddress"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
        self.timeStamp = [aDecoder decodeObjectForKey:@"timeStamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.txid forKey:@"txid"];
    [aCoder encodeObject:self.fromAddress forKey:@"fromAddress"];
    [aCoder encodeObject:self.toAddress forKey:@"toAddress"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.timeStamp forKey:@"timeStamp"];
}
@end
