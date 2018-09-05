//
//  ApexRequestMoenyController.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexRequestMoenyController.h"

@interface ApexRequestMoenyController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRImageV;
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UITextField *requestNumTF;
@property (nonatomic, strong) UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, strong) UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLable0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstrant;

@end

@implementation ApexRequestMoenyController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNav];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ------private------
- (void)setNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleLable;
    
    [self.navigationController lt_setBackgroundColor:[UIColor whiteColor]];
}

- (void)setUI{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.addressL.text = self.walletAddress;
    self.walletNameL.text = self.walletName;
    self.QRImageV.image = [self scanCodeGenerator:[NSString stringWithFormat:@"%@",self.walletAddress]];
    
    [self.requestNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    [ApexUIHelper addLineInView:self.requestNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.btn.layer.cornerRadius = 5;
    
    _tipLable0.text = SOLocalizedStringFromTable(@"YourWallet", nil);
    [self.btn setTitle:SOLocalizedStringFromTable(@"Copy Wallet address", nil) forState:UIControlStateNormal];
}

- (void)textFieldDidChange{
    if (self.requestNumTF.text.length == 0) {
        self.QRImageV.image = [self scanCodeGenerator:[NSString stringWithFormat:@"%@/0",self.walletAddress]];
    }else{
        self.QRImageV.image = [self scanCodeGenerator:[NSString stringWithFormat:@"%@/%@",self.walletAddress, self.requestNumTF.text]];
    }
}

- (UIImage*)scanCodeGenerator:(NSString*)info{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *Str = info;
    NSData *data = [Str dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.QRImageV.size.width];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (IBAction)copyAddress:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.walletAddress;
    [self showMessage:SOLocalizedStringFromTable(@"CopySuccess", nil)];
    
    [_btn setTitle:SOLocalizedStringFromTable(@"Copied", nil) forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.btn setTitle:SOLocalizedStringFromTable(@"Copy Wallet address", nil) forState:UIControlStateNormal];
        
    });
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ------getter & setter------
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = SOLocalizedStringFromTable(@"Receipt", nil);
    }
    return _titleLable;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 20, 30)];
        [_backBtn setImage:[UIImage imageNamed:@"back-4"] forState:UIControlStateNormal];
        _backBtn.imageView.contentMode = UIViewContentModeLeft;
    }
    return _backBtn;
}
@end
