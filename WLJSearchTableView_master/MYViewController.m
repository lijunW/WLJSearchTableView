//
//  MYViewController.m
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import "MYViewController.h"

#import "UITextField+WLJSearchTableview.h"

@interface MYViewController ()

@end

@implementation MYViewController

-(void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView * tableVIew = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableVIew];
    
    UITextField * textFieldOther = [[UITextField alloc]initWithFrame:CGRectMake(40, 360, 320, 40)];
    textFieldOther.placeholder = @"其他输入框";
    textFieldOther.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textFieldOther];
    
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(40, 160, 220, 40)];
    textField.placeholder = @"请输入关键字搜索";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    /*使用说明：
     导入WLJSearchTableview文件夹进工程
     导入#import "UITextField+WLJSearchTableview.h"
     使用代码如下
     */
    /******************************************************************************************/
    __weak typeof(self) weakSelf = self;
    WLJSearchTableviewConfig * searchTableviewConfig  = [[WLJSearchTableviewConfig alloc]init];
    //searchTableviewConfig.searchTime = SearchTimeWhileDidEndEditing;//输入结束时开始搜索
    searchTableviewConfig.searchTime = SearchTimeWhileDidChange;//输入变化时开始搜索
    searchTableviewConfig.searchTableViewCellEstablishHeight = 30;//行高
    searchTableviewConfig.maxShowNum = 3;//最大显示行数
    //调用搜索接口，并返回搜索结果
    searchTableviewConfig.searchKeywordsFunc = ^(NSString *keyWords, SearchCompleteblock searchCompleteblock) {
        [weakSelf searchWithKeyWords:keyWords complete:searchCompleteblock];
    };
    //设置cell显示
    searchTableviewConfig.cellForRowAtIndexPath = ^(UITableViewCell *cell, NSIndexPath *indexPath,id data) {
        NSDictionary * currentData = (NSDictionary *) data;
        cell.textLabel.text = currentData[@"name"];
    };
    //点击了搜索结果
    searchTableviewConfig.didSeletedRowAtIndexPath = ^(NSIndexPath *indexPath, id data) {
        NSDictionary * currentData = (NSDictionary *) data;
        //do your code ... eg.:
        UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"点击了%@",currentData[@"name"]] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [textField wlj_enableSeatchTableViewWithConfig:searchTableviewConfig];
    /******************************************************************************************/
}


//模拟调用网络搜索接口
-(void)searchWithKeyWords:(NSString * )keyWords complete:(SearchCompleteblock)searchCompleteblock{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray * searchResultArray = [[NSMutableArray alloc]init];;
        //模拟数据
        NSInteger x = arc4random()%30;
        for (int i = 0; i< x ; i++) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            dict[@"name"] = [NSString stringWithFormat:@"%@%d",keyWords,i];
            dict[@"path"] = [NSString stringWithFormat:@"Document/%d.txt",i];
            [searchResultArray addObject:dict];
        }
        NSLog(@"%@",searchResultArray);
        if (searchCompleteblock) {
            searchCompleteblock(searchResultArray);
        }
    });
}
@end
