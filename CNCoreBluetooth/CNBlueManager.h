//
//  CNBlueMannager.h
//  CNCoreBluetooth
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^scanFinishBlock)(CBPeripheral *per);
typedef void(^periConnectedStateBlock)(CBPeripheral *peripherial,BOOL isConnect);

@interface CNBlueManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

+ (CNBlueManager *)sharedBlueManager;
- (void)cus_beginScanPeriPheralFinish:(scanFinishBlock)finish;
- (void)cus_stopScan;
- (void)cus_connectPeripheral:(CBPeripheral *)peri;
-(void)cus_cancelConnectPeripheral:(CBPeripheral *)peri;
/**
 向peripheral发送数据
 */
- (void)senddata:(NSString *)str toPeripheral:(CBPeripheral *)peri;

//蓝牙锁被连接，或者失去连接
@property (nonatomic,copy)periConnectedStateBlock periConnectedState;
//存放已扫到的外设
@property (nonatomic,strong) NSMutableArray *peripheralArray;
@property (nonatomic,strong) NSMutableArray *connectedPeripheralArray;

@end
