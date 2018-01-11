//
//  WLJSearchTableviewConfig.h
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SearchTimeWhileDidEndEditing = 0,//结束编辑（键盘下去时）
    SearchTimeWhileDidChange,//输入改变时
    SearchTimeWhileOther,
} WLJ_SearchTime;

typedef void (^SearchCompleteblock)(NSArray * searchResultArray);

@interface WLJSearchTableviewConfig : NSObject
//要处理的输入框，weak防止循环引用，（textField已经强引用了self）
@property(nonatomic,weak)UITextField * textField;
//最多显示几条搜索结果，默认4条
@property(nonatomic,assign)NSInteger maxShowNum;
//cell行高，默认 35
@property(nonatomic,assign)CGFloat searchTableViewCellEstablishHeight;
//什么时候开始发起搜索
@property(nonatomic,assign)WLJ_SearchTime searchTime;
//cell显示设置，data对应该条数据
@property(nonatomic,copy)void (^cellForRowAtIndexPath)(UITableViewCell * cell,NSIndexPath * indexPath,id data);
//调用外部搜索接口，并返回搜索结果
@property(nonatomic,copy)void (^searchKeywordsFunc)(NSString * keyWords,SearchCompleteblock searchCompleteblock);
//选中某条搜索结果，data对应该条数据
@property(nonatomic,copy)void (^didSeletedRowAtIndexPath)(NSIndexPath* indexPath ,id data);
@end
