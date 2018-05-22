//
//  HYFAppInfo.h
//  ZJbirdWorker
//
//  Created by 黄驿峰 on 2017/7/12.
//  Copyright © 2017年 黄驿峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSInteger isLogin = 0;
@interface HYFAppInfo : NSObject

//appBundle信息 e.g com.zjn.zjbird.worker
+ (NSString *)appBundle;
//app 显示名称  e.g 住建鸟工友
+ (NSString *)appName;
//app版本   e.g 1.0.0
+ (NSString *)appVersion;
//appBuild版本  e.g   1
+ (NSString *)appBuild;
//app渠道信息  e.g 未设置
+ (NSString *)appChannelID;
/// Whether this app is pirated (not install from appstore).
+ (BOOL)isPirated;
/// 是不是开发者模式.
+ (BOOL)isDebug;

# pragma mark - Device Info

//每次都不一样，需要自己保存  e.g E966312B-6CAE-4236-BF81-3601865CF41C
+ (NSString *)uuid;
//ip地址 e.g  192.168.10.121
+ (NSString *)localIPAddress;
//基站IP e.g  10.104.57.6
+ (NSString *)cellIPAddress;
//系统版本 e.g  10.3.2
+ (NSString *)iosVersion;
//设备类型 e.g  iPhone
+ (NSString *)iosModel;
//电池状态
+ (UIDeviceBatteryState)batteryState;
//设备大小 e.g 30507 30G
+ (NSString *)totalDiskspace;
//剩余空间 e.g 4499
+ (NSString *)freeDiskspace;
//具体设备 e.g iPhone9,1
+ (NSString *)machineType;

///是不是模拟器
+ (BOOL)isSimulator;
/// Whether the device is jailbroken.
+ (BOOL)isJailbroken;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModelName;

@end
