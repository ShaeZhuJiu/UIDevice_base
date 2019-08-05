//
//  ViewController.m
//  UIDevice_base
//
//  Created by 谢鑫 on 2019/8/5.
//  Copyright © 2019 Shae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self battery];
    //[self proximity];
    [self orientation];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self getDeviceInfo];
}

/*                                                   */
//获取设备的基本信息
-(void)getDeviceInfo{
    UIDevice *device=[UIDevice currentDevice];
    NSLog(@"name: %@",device.name);
    NSLog(@"model: %@",device.model);
    NSLog(@"localizedModel: %@",device.localizedModel);
    NSLog(@"systemVersion: %@",device.systemVersion);
    NSLog(@"systemVersion: %@",device.identifierForVendor.UUIDString);
}

/*                                                   */
//获取电池信息
-(void)battery{
    UIDevice *device=[UIDevice currentDevice];
    //开启电池检测
    device.batteryMonitoringEnabled=YES;
    //注册通知，当电池状态改变时调用batteryStateChange方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(batteryStateChange) name:UIDeviceBatteryStateDidChangeNotification object:nil];
}

- (void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)batteryStateChange{
    UIDevice *device=[UIDevice currentDevice];
    //获取当前电量
    float batteryVolume=device.batteryLevel *100;
    //计算电池电量百分比
    NSString *batteryVolumeString=[NSString stringWithFormat:@"当前电量：%.0f%%",batteryVolume];
    NSLog(@"%@",batteryVolumeString);
    //根据电池状态切换时，给出提醒
    switch (device.batteryState) {
        case UIDeviceBatteryStateUnplugged:{
            //提醒
            NSString *string=[NSString stringWithFormat:@"未充电，%@",batteryVolumeString];
            [self showAlert:string];
            break;}
            
        case UIDeviceBatteryStateCharging:{
            //提醒
            NSString *string=[NSString stringWithFormat:@"充电中，%@",batteryVolumeString];
            [self showAlert:string];
            break;}
            
        case UIDeviceBatteryStateFull:{
            //提醒
            NSString *string=[NSString stringWithFormat:@"已充电，%@",batteryVolumeString];
            [self showAlert:string];
            break;}
        case UIDeviceBatteryStateUnknown:{
            [self showAlert:@"未知状态"];
            break;
        }
            
        default:
            break;
    }
}
-(void)showAlert:(NSString *)string{
    //警告框
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"时间" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

/*                                                   */

//接近传感器
-(void)proximity{
    UIDevice *device=[UIDevice currentDevice];
    //开启接近传感器
    device.proximityMonitoringEnabled=YES;
    //接近传感器通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
}
-(void)proximityStateChange{
    UIDevice *device=[UIDevice currentDevice];
    if (device.proximityState==YES) {
        NSLog(@"物体靠近");
    }else{
        NSLog(@"物体离开");
    }
}

/*                                                   */
//方向传感器
-(void)orientation{
    UIDevice *device=[UIDevice currentDevice];
    //开启方向改变通知
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)orientationChange{
    UIDevice *device=[UIDevice currentDevice];
    NSString *string;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:{
            string= [NSString stringWithFormat:@"竖屏/正常"];
            break;}
        case UIDeviceOrientationPortraitUpsideDown:{
            string = [NSString stringWithFormat:@"竖屏/倒置"];
            break;}
        case UIDeviceOrientationLandscapeLeft:{
            string = [NSString stringWithFormat:@"横屏/左侧"];
            break;}
        case UIDeviceOrientationLandscapeRight:{
            string = [NSString stringWithFormat:@"横屏/右侧"];
            break;}
        case UIDeviceOrientationFaceUp:{
            string = [NSString stringWithFormat:@"正面朝上"];
            break;}
        case UIDeviceOrientationFaceDown:{
            string = [NSString stringWithFormat:@"正面朝下"];
            break;}
        default:{
            string = [NSString stringWithFormat:@"未知朝向"];
            break;}
    }
    NSLog(@"%@",string);
}
@end
