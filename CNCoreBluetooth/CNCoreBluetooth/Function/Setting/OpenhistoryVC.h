//
//  OpenhistoryVC.h
//  CNCoreBluetooth
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OpenhistoryVC : BaseViewController

@property (nonatomic, copy) NSString *lockID;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
