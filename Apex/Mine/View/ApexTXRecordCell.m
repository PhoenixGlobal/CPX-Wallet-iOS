//
//  ApexTXRecordCell.m
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTXRecordCell.h"

@implementation ApexTXRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(ApexTXRecorderModel *)model{
    _model = model;
    self.fromAddress.text = model.fromAddress;
    self.toAddress.text = model.toAddress;
    self.Value.text = model.value;
    self.txidL.text  = model.txid;
}
@end
