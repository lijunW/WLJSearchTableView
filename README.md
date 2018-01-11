# WLJSearchTableView
快速添加输入框下拉显示关联搜索关键词

## GIF animation
[![WLJSearchTableView](http://ovn0zb2g7.bkt.clouddn.com/WLJSearchTableView1.gif)](http://ovn0zb2g7.bkt.clouddn.com/WLJSearchTableViewVideo.mov)

## Video
<a href="http://ovn0zb2g7.bkt.clouddn.com/WLJSearchTableViewVideo.mov" target="_blank"><img src="http://ovn0zb2g7.bkt.clouddn.com/Simulator%20Screen%20Shot%20-%20iPhone%206s%20Plus%20-%202018-01-11%20at%2015.57.49.png"
alt="WLJSearchTableView Demo Video" width="320" height="480" border="10" /></a>


GetStart
==========================
#### 1.导入WLJSearchTableview文件夹进工程
#### 2.导入#import "UITextField+WLJSearchTableview.h"

```objective-c
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
  UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"点击 了%@",currentData[@"name"]] preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
  [weakSelf presentViewController:alert animated:YES completion:nil];
};
[textField wlj_enableSeatchTableViewWithConfig:searchTableviewConfig];
```


LICENSE
---
Distributed under the MIT License.

Author
---
If you wish to contact me, email at: 18055352658@189.cn

