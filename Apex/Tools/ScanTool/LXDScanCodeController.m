//
//  LXDScanCodeController.m
//  LXDScanQRCode
//
//  Created by 林欣达 on 15/10/14.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#import "LXDScanCodeController.h"
#import "LXDScanView.h"

@interface LXDScanCodeController ()<LXDScanViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) LXDScanView * scanView;
@property (nonatomic, strong) UIButton *gallaryBtn;

@end

@implementation LXDScanCodeController


#pragma mark - initial
+ (instancetype)scanCodeController
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.scanView = [LXDScanView scanViewShowInController: self];
    }
    return self;
}


#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫描";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.gallaryBtn];
    [self.view addSubview: self.scanView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.scanView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.scanView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.scanView stop];
}

- (UIButton *)gallaryBtn
{
    if (!_gallaryBtn) {
        _gallaryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_gallaryBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_gallaryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_gallaryBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self choicePhoto];
        }];
        _gallaryBtn.hidden = YES;
    }
    return _gallaryBtn;
}

- (void)choicePhoto{
    //调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   __block NSString *content = @"" ;
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (feature.count == 0) {
            
            return;
        }
        else
        {
            //取出探测到的数据
            for (CIQRCodeFeature *result in feature) {
                content = result.messageString;
            }
            
            [self scanView:self.scanView codeInfo:content];
        }
    }];
}

#pragma mark - LXDScanCodeController
/**
 *  扫描成功时回调
 */
- (void)scanView:(LXDScanView *)scanView codeInfo:(NSString *)codeInfo
{
    if ([_scanDelegate respondsToSelector: @selector(scanCodeController:codeInfo:)]) {
        [self.navigationController popViewControllerAnimated:NO];
        [_scanDelegate scanCodeController: self codeInfo: codeInfo];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: LXDSuccessScanQRCodeNotification object: self userInfo: @{ LXDScanQRCodeMessageKey: codeInfo }];
    }
}


@end
