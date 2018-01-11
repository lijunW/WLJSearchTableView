//
//  UITextField+WLJSearchTableview.m
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import "UITextField+WLJSearchTableview.h"
#import <objc/runtime.h>

static const void * NSObject_key_searchTableviewConfig = &NSObject_key_searchTableviewConfig;

@implementation UITextField (WLJSearchTableview)
@dynamic searchTableviewConfig;

- (WLJSearchTableviewConfig *)searchTableviewConfig{
    id object = objc_getAssociatedObject(self,NSObject_key_searchTableviewConfig);
    return object;
}
- (void)setSearchTableviewConfig:(WLJSearchTableviewConfig *)searchTableviewConfig{
    objc_setAssociatedObject(self, NSObject_key_searchTableviewConfig, searchTableviewConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)wlj_enableSeatchTableViewWithConfig:(WLJSearchTableviewConfig *)searchTableviewConfig{
    self.searchTableviewConfig = searchTableviewConfig;
    searchTableviewConfig.textField = self;//weak
}
@end
