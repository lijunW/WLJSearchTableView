//
//  UITextField+WLJSearchTableview.h
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLJSearchTableviewConfig.h"
@interface UITextField (WLJSearchTableview)
@property(nonatomic,retain)WLJSearchTableviewConfig * searchTableviewConfig;
-(void)wlj_enableSeatchTableViewWithConfig:(WLJSearchTableviewConfig *)searchTableviewConfig;
@end
