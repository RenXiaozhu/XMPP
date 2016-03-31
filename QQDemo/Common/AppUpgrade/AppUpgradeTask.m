//
// Created by fengshuai on 16/2/27.
// Copyright (c) 2016 yundongsports.com. All rights reserved.
//

#import "AppUpgradeTask.h"
#import "YUD301Service.h"
#import "AppContext.h"

@interface  AppUpgradeTask()<UIAlertViewDelegate>

@property(nonatomic, strong) YUD301Service *service;
@end

@implementation AppUpgradeTask
{
    AppUpgradeInfo *_appUpgradeInfo;
}

- (void)checkUpdate
{
    self.service= [[YUD301Service alloc] init];

    @weakify(self);
    [self.service startGetWithBlock:^(YUD301ServiceResponse *result, NSError *error) {

        @strongify(self);

        if (error==nil)
        {
            if ([AppContext isNewVersion:result.appupgradeinfo.version])
            {
                self->_appUpgradeInfo=result.appupgradeinfo;
                UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"发现新版本" message:result.appupgradeinfo.tips  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级",nil];

                alertView.tag=2016022722;

//                [alertView show];

            }
        }



    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2016022722&&buttonIndex==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appUpgradeInfo.fileurl]];

    }
}


@end