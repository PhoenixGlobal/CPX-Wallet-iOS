//
//  ApexTXDetailController.m
//  Apex
//
//  Created by chinapex on 2018/6/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTXDetailController.h"
#import "ApexTransferModel.h"

@interface ApexTXDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UILabel *toAddressL;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *txic;
@property (weak, nonatomic) IBOutlet UILabel *valueL;

@end

@implementation ApexTXDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI{
    _fromAddressL.text = self.model.from;
    _toAddressL.text = self.model.to;
    _timeStamp.text = self.model.time;
    _txic.text = self.model.txid;
    _valueL.text = self.model.value;
}

@end
