//
//  SetDetailViewController.m
//  CNCoreBluetooth
//
//  Created by apple on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SetDetailViewController.h"
#import "SetDetailCell.h"
#import "SetLockMethod.h"
#import "ModifyPwdVC.h"
#import "OpenhistoryVC.h"
#import "UIView+KGViewExtend.h"
#import "DeleteUnpairAlert.h"
#import "SaveSettingAlert.h"
#import "CNPeripheralModel.h"
#import "CNDataBase.h"
#import "CNBlueCommunication.h"
#import "CNBlueManager.h"
#import "EnterPwdAlert.h"
#import "UserControlVC.h"

static NSString *setDetailCell = @"SetDetailCell";

static NSString *setLockMethod = @"SetLockMethod";

@interface SetDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *bgView;
    NSArray *dataArray;
    DeleteUnpairAlert *alert;
    SaveSettingAlert *saveAlert;
    BOOL isShowIncorrectPwd;
    CNPeripheralModel *tempModel;
}

@end

@implementation SetDetailViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self setBackBtnHiden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBtnHiden:NO];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)rotate{
    if ([CommonData deviceIsIpad]) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        if (SCREENWIDTH>SCREENHEIGHT) {
            leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, edgeDistancePage*2/3.0+5, 0, 0);
        }else{
            leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, edgeDistancePage*2/3.0, 0, 0);
        }
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([CommonData deviceIsIpad]) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        if (SCREENWIDTH>SCREENHEIGHT) {
            leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, edgeDistancePage*2/3.0+5, 0, 0);
        }else{
            leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, edgeDistancePage*2/3.0, 0, 0);
        }
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    tempModel = [[CNDataBase sharedDataBase] searchPeripheralInfo:_lockModel.periID];
    _lockModel.isAdmin = tempModel.isAdmin;
    
    if (_lockModel.isAdmin) {
        dataArray = @[@"Name",@"Password",@"Open History",@"User Control",@"Unlock Mode",@"Enable TouchSafe Sensor",@"Unpair Device"];
    }else{
        dataArray = @[@"Name",@"Unlock Mode",@"Enable TouchSafe Sensor",@"Unpair Device"];
    }
    
    [_myTableView registerNib:[UINib nibWithNibName:@"SetDetailCell" bundle:nil] forCellReuseIdentifier:setDetailCell];
    [_myTableView registerNib:[UINib nibWithNibName:@"SetLockMethod" bundle:nil] forCellReuseIdentifier:setLockMethod];
    _myTableView.tableFooterView = [[UIView alloc] init];
    
    bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    bgView.hidden = YES;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_myTableView);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyDidHide) name:UIKeyboardDidHideNotification object:nil];

    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:19+FontSizeAdjust];
    _saveBtn.layer.cornerRadius = _saveBtn.height/2.0;
    //lyh debug 50*6
    float footViewheight = SCREENHEIGHT - 64-iPhoneXTopPara-49-iPhoneXBottomPara-125-50*(dataArray.count-1);
    if (footViewheight<90) {
        footViewheight = 90;
    }
    _footView.frame = CGRectMake(0, 0, SCREENWIDTH, footViewheight);
    _myTableView.tableFooterView = _footView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)keyWillShow{
    bgView.hidden = NO;
}


- (void)keyWillHide{
    bgView.hidden = YES;
}

- (void)keyDidHide{
//    if (isShowIncorrectPwd) {
//        [CNPromptView showStatusWithString:@"Incorrect Password"];
//        isShowIncorrectPwd = NO;
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    tempModel.periname = textField.text;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakself = self;
    if (_lockModel.isAdmin) {
        if (indexPath.row == 1) {
            ModifyPwdVC *pwdVC = [[ModifyPwdVC alloc] init];
            pwdVC.periModel = _lockModel;
            pwdVC.lockname = _lockModel.periname;
            pwdVC.pwd = _lockModel.periPwd;
            [self.navigationController pushViewController:pwdVC animated:YES];
        }else if (indexPath.row == 2){
            OpenhistoryVC *history = [[OpenhistoryVC alloc] init];
            history.lockID = _lockModel.periID;
            [self.navigationController pushViewController:history animated:YES];
        }else if (indexPath.row == 3){
            UserControlVC *user = [[UserControlVC alloc] init];
            user.model = _lockModel;
            [self.navigationController pushViewController:user animated:YES];
        }else if (indexPath.row == 6){
            alert = [[NSBundle mainBundle] loadNibNamed:@"DeleteUnpairAlert" owner:self options:nil][0];
            alert.unpairedBlock = ^{
                [weakself unPaired];
            };
            alert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }else{
        if (indexPath.row == 3){
            alert = [[NSBundle mainBundle] loadNibNamed:@"DeleteUnpairAlert" owner:self options:nil][0];
            alert.unpairedBlock = ^{
                [weakself unPaired];
            };
            alert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_lockModel.isAdmin) {
        if (indexPath.row == 4) {
            return 125;
        }
    }else{
        if (indexPath.row == 1) {
            return 125;
        }
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int temp = 3;
    if (_lockModel.isAdmin) {
        temp = 0;
    }
    if (indexPath.row == 4-temp) {
        SetLockMethod *detailCell2 = [tableView dequeueReusableCellWithIdentifier:setLockMethod forIndexPath:indexPath];
        detailCell2.openBlock = ^(OpenLockMethod openMethod) {
            tempModel.openMethod = openMethod;
        };
        detailCell2.nameLab.text = dataArray[4-temp];
        [detailCell2 selectMethod:tempModel.openMethod];
        return detailCell2;
    }
    SetDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:setDetailCell forIndexPath:indexPath];
    detailCell.imageV.hidden = YES;
    detailCell.mySwitch.hidden = YES;
    detailCell.textF.hidden = YES;
    detailCell.swichBlock = ^(BOOL isTouch) {
        tempModel.isTouchUnlock = isTouch;
    };
    detailCell.nameBlock = ^(NSString *name) {
        tempModel.periname = name;
    };
    if (_lockModel.isAdmin) {
        switch (indexPath.row) {
            case 0:{
                detailCell.textF.text = _lockModel.periname;
                detailCell.textF.hidden = NO;
                break;
            }
            case 1:{
                detailCell.textF.hidden = NO;
                detailCell.textF.secureTextEntry = YES;
                detailCell.textF.enabled = NO;
                detailCell.textF.text = _lockModel.periPwd;
                detailCell.imageV.hidden = NO;
                detailCell.imageV.image = [UIImage imageNamed:@"chevron"];
                break;
            }
            case 2:{
                
                detailCell.imageV.hidden = NO;
                detailCell.imageV.image = [UIImage imageNamed:@"chevron"];
                break;
            }
            case 3:{
                detailCell.imageV.hidden = NO;
                detailCell.imageV.image = [UIImage imageNamed:@"chevron"];
                break;
            }
            case 5:{
                if (_lockModel.isTouchUnlock) {
                    detailCell.mySwitch.on = YES;
                }else{
                    detailCell.mySwitch.on = NO;
                }
                detailCell.mySwitch.hidden = NO;
                break;
            }
            case 6:{
                detailCell.imageV.hidden = NO;
                detailCell.imageV.image = [UIImage imageNamed:@"delete"];
                break;
            }
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                detailCell.textF.enabled = NO;
                detailCell.textF.text = _lockModel.periname;
                detailCell.textF.hidden = NO;
                break;
            }
            case 2:{
                if (_lockModel.isTouchUnlock) {
                    detailCell.mySwitch.on = YES;
                }else{
                    detailCell.mySwitch.on = NO;
                }
                detailCell.mySwitch.hidden = NO;
                break;
            }
            case 3:{
                detailCell.imageV.hidden = NO;
                detailCell.imageV.image = [UIImage imageNamed:@"delete"];
                break;
            }
                
            default:
                break;
        }
    }
   
    detailCell.nameLab.text = dataArray[indexPath.row];
    return detailCell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    NSData *nameData = [tempModel.periname dataUsingEncoding:NSUTF8StringEncoding];
    if (nameData.length > 18) {
        [CNPromptView showStatusWithString:@"Name is too long" withadjustBottomSpace:50];
        return;
    }
    //弹出输入密码框
    EnterPwdAlert *enterAlert = [[NSBundle mainBundle] loadNibNamed:@"EnterPwdAlert" owner:self options:nil][0];
    enterAlert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    __weak typeof(self) weakself = self;
    __weak EnterPwdAlert *weakAlert = enterAlert;
    enterAlert.returnPasswordStringBlock = ^(NSString *pwd) {
        if ([pwd isEqualToString:_lockModel.periPwd]) {
            weakAlert.hidden = YES;
            [weakAlert.assistTF resignFirstResponder];//隐藏键盘
            
            [weakself updateSetInfo];
        }else{
            weakAlert.assistTF.text = @"";
            weakAlert.pwd1.text = @"";
            weakAlert.pwd2.text = @"";
            weakAlert.pwd3.text = @"";
            weakAlert.pwd4.text = @"";
            weakAlert.pwd5.text = @"";
            weakAlert.pwd6.text = @"";
            //密码输错提示
            //isShowIncorrectPwd = YES;
            [CNPromptView showStatusWithString:@"Incorrect Password"  withadjustBottomSpace:50];
            
        }
    };
    [enterAlert showWithName:_lockModel.periname];
    
//    saveAlert = [[NSBundle mainBundle] loadNibNamed:@"SaveSettingAlert" owner:self options:nil][0];
//    __weak typeof(self) weakself = self;
//    saveAlert.saveBlock = ^{
//        [weakself updateNameAndPwd:YES];
//    };
//    saveAlert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    [[UIApplication sharedApplication].keyWindow addSubview:saveAlert];
}
//保存锁具名称和密码
- (void)updateSetInfo{
    CNPeripheralModel *originalModel = [[CNDataBase sharedDataBase] searchPeripheralInfo:_lockModel.periID];
    if (![originalModel.periname isEqualToString:tempModel.periname]) {
        //如果密码在别的地方已修改，这里传最新的密码
        tempModel.periPwd = _lockModel.periPwd;
        __block BOOL isFinish = false;
        for (CBPeripheral *peri in [CNBlueManager sharedBlueManager].connectedPeripheralArray) {
            if ([peri.identifier.UUIDString isEqualToString:_lockModel.periID]) {
                isFinish = YES;
                [CNBlueCommunication cbSendInstruction:ENChangeNameAndPwd toPeripheral:peri otherParameter:tempModel finish:^(RespondModel *model) {
                    if ([model.state intValue] == 1) {
                        [CNPromptView showStatusWithString:@"Setting Saved"];
                        //更新数据
                        _lockModel.periname = tempModel.periname;
                        _lockModel.isTouchUnlock = tempModel.isTouchUnlock;
                        _lockModel.openMethod = tempModel.openMethod;
                        _lockModel.actionType = ENUpdate;
                        //不传_lockModel也可以
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReload object:_lockModel];
                        [[CNDataBase sharedDataBase] updatePeripheralInfo:_lockModel];
                        [self.navigationController popViewControllerAnimated:YES];
                        self.tabBarController.selectedIndex = 0;

                    }else{
                        //lyh debug
                        [CNPromptView showStatusWithString:@"Failed" withadjustBottomSpace:50];
                    }
                }];
                break;
            }
        }
        if(isFinish == NO){
            [CNPromptView showStatusWithString:@"Failed" withadjustBottomSpace:50];
        }
    }else{
        [CNPromptView showStatusWithString:@"Setting Saved"];
        //更新数据
        _lockModel.openMethod = tempModel.openMethod;
        _lockModel.actionType = ENUpdate;
        BOOL isTouchUnlock_old = _lockModel.isTouchUnlock;
        _lockModel.isTouchUnlock = tempModel.isTouchUnlock;
        //不传_lockModel也可以
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReload object:_lockModel];
        [[CNDataBase sharedDataBase] updatePeripheralInfo:_lockModel];
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
        if (isTouchUnlock_old != tempModel.isTouchUnlock) {
            for (CBPeripheral *peri in [CNBlueManager sharedBlueManager].connectedPeripheralArray) {
                if ([peri.identifier.UUIDString isEqualToString:_lockModel.periID]) {
                    [CNBlueCommunication cbSendInstruction:ENAutoLogin toPeripheral:peri otherParameter:nil finish:nil];
                }
            }
        }
    }

    
}

- (void)unPaired{
    [[CNDataBase sharedDataBase] deletePairedWithIdentifier:_lockModel.periID];
    _lockModel.actionType = ENDelete;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReload object:_lockModel];
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
    return;
    
    //弹出输入密码框
    EnterPwdAlert *enterAlert = [[NSBundle mainBundle] loadNibNamed:@"EnterPwdAlert" owner:self options:nil][0];
    __weak EnterPwdAlert *weakAlert = enterAlert;
    enterAlert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    enterAlert.returnPasswordStringBlock = ^(NSString *pwd) {
        if ([pwd isEqualToString:_lockModel.periPwd]) {
            weakAlert.hidden = YES;
            [weakAlert.assistTF resignFirstResponder];//隐藏键盘
            
            //解除配对（不是管理员踢人操作）
//            for (CBPeripheral *peri in [CNBlueManager sharedBlueManager].connectedPeripheralArray) {
//                if ([peri.identifier.UUIDString isEqualToString:_lockModel.periID]) {
//                    [[CNDataBase sharedDataBase] deletePairedWithIdentifier:peri.identifier.UUIDString];
//                    _lockModel.actionType = ENDelete;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReload object:_lockModel];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    self.tabBarController.selectedIndex = 0;
//                    break;
//                }
//            }
            
            [[CNDataBase sharedDataBase] deletePairedWithIdentifier:_lockModel.periID];
            _lockModel.actionType = ENDelete;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReload object:_lockModel];
            [self.navigationController popViewControllerAnimated:YES];
            self.tabBarController.selectedIndex = 0;
            
        }else{
            weakAlert.assistTF.text = @"";
            weakAlert.pwd1.text = @"";
            weakAlert.pwd2.text = @"";
            weakAlert.pwd3.text = @"";
            weakAlert.pwd4.text = @"";
            weakAlert.pwd5.text = @"";
            weakAlert.pwd6.text = @"";
            
            //密码输错提示
            //isShowIncorrectPwd = YES;
            [CNPromptView showStatusWithString:@"Incorrect Password"   withadjustBottomSpace:50];
        }
    };
    [enterAlert showWithName:_lockModel.periname];
}

@end
