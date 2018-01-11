//
//  WLJSearchTableviewConfig.m
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import "WLJSearchTableviewConfig.h"

@interface WLJSearchTableviewConfig ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSourceArray;
//『点击外部消失手势』,参考了IQkeyboardManager的点击外部，让键盘消失的思路
@property(nonatomic,strong)UITapGestureRecognizer * resignFirstResponderGesture;

@end
@implementation WLJSearchTableviewConfig
-(void)dealloc{
    NSLog(@"%s",__func__);
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.searchTableViewCellEstablishHeight = 35;
        self.maxShowNum = 4;
        
        _resignFirstResponderGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognized:)];
        _resignFirstResponderGesture.cancelsTouchesInView = NO;
        [_resignFirstResponderGesture setDelegate:self];
    }
    return self;
}

-(void)setTextField:(UITextField *)textField{
    _textField = textField;
    [self addUITextFieldNotifcation];
    [self setupTableview];
}

-(void)addUITextFieldNotifcation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

# pragma mark - UITextFieldNotifcation
-(void)UITextFieldTextDidBeginEditingNotification:(NSNotification *)notif{
    NSLog(@"UITextFieldTextDidBeginEditingNotification");
}
-(void)UITextFieldTextDidEndEditingNotification:(NSNotification *)notif{
    NSLog(@"UITextFieldTextDidEndEditingNotification");
    UITextField * textField = notif.object;
    if ([textField isKindOfClass:[UITextField class]]&&textField.text.length>0) {
        if (self.searchTime == SearchTimeWhileDidEndEditing) {
            if (self.searchKeywordsFunc) {
                self.searchKeywordsFunc(textField.text, ^(NSArray *searchResultArray) {
                    wlj_handSearchCompleteblock(self,searchResultArray);
                });
            }
        }
    }
}
-(void)UITextFieldTextDidChangeNotification:(NSNotification *)notif{
    NSLog(@"UITextFieldTextDidChangeNotification");
    UITextField * textField = notif.object;
    if ([textField isKindOfClass:[UITextField class]]&&textField.text.length>0) {
        [self dismiss];
        if (self.searchTime == SearchTimeWhileDidChange) {
            if (self.searchKeywordsFunc) {
                __weak typeof(self) weakSelf = self;
                self.searchKeywordsFunc(textField.text,^(NSArray *searchResultArray) {
                    wlj_handSearchCompleteblock(weakSelf,searchResultArray);
                });
            }
        }
    }
}

void (^wlj_handSearchCompleteblock)(WLJSearchTableviewConfig * config,NSArray * searchResultArray)  = ^(WLJSearchTableviewConfig * config,NSArray * searchResultArray){
    if(searchResultArray){
        config.dataSourceArray = searchResultArray;
        [config.tableView reloadData];
        [config performSelector:@selector(show)];
    }
};

#pragma mark - Action
-(void)show {
    [self.textField.window addGestureRecognizer:_resignFirstResponderGesture];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addAndSetDefaultTableViewFrame];
        
        CGRect defaultTableViewFrame = self.tableView.frame;
        
        CGFloat newTableViewHeight = self.maxShowNum * self.searchTableViewCellEstablishHeight;
        if (self.dataSourceArray.count < 4) {
            //搜索结果小于4个，重新计算高度
            newTableViewHeight = self.dataSourceArray.count * self.searchTableViewCellEstablishHeight;
        }
        if(self.searchTime == SearchTimeWhileDidEndEditing){
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.tableView.frame = CGRectMake(defaultTableViewFrame.origin.x, defaultTableViewFrame.origin.y, defaultTableViewFrame.size.width, newTableViewHeight);
            } completion:nil];
        }else{
            self.tableView.frame = CGRectMake(defaultTableViewFrame.origin.x, defaultTableViewFrame.origin.y, defaultTableViewFrame.size.width, newTableViewHeight);
        }
    });
}
-(void)dismiss {
    if (!self.tableView.superview) {
        return;
    }
    [self.textField.window removeGestureRecognizer:_resignFirstResponderGesture];
    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self addAndSetDefaultTableViewFrame];
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
    }];
}

-(void)setupTableview{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.estimatedRowHeight = self.searchTableViewCellEstablishHeight;
    
    //self.tableView.backgroundColor = [UIColor orangeColor];
}
-(void)addAndSetDefaultTableViewFrame{
    self.tableView.frame = CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y + self.textField.frame.size.height, self.textField.frame.size.width, 0);
    [self.textField.superview addSubview:self.tableView];
}

//固定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.searchTableViewCellEstablishHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (self.cellForRowAtIndexPath) {
        self.cellForRowAtIndexPath(cell, indexPath, self.dataSourceArray[indexPath.row]);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismiss];
    if (self.didSeletedRowAtIndexPath) {
        self.didSeletedRowAtIndexPath(indexPath, self.dataSourceArray[indexPath.row]);
    }
}


/** Resigning on tap gesture. */
- (void)tapRecognized:(UITapGestureRecognizer*)gesture  // (Enhancement ID: #14)
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        //Resigning currently responder textField.
        [self dismiss];
    }
}

/** Note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES. */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

/** To not detect touch events in a subclass of UIControl, these may have added their own selector for specific work */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)    (Bug ID: #145
    if (self.textField.isFirstResponder) {
        return NO;//textField键盘还在，则不处理 『点击外部消失手势』，先影藏键盘
    }
    if ([self.tableView pointInside:[touch locationInView:self.tableView] withEvent:nil]) {
        return NO;//点击的是搜索结果tableViiew，则不处理 『点击外部消失手势』
    }
    for (Class aClass in [NSSet setWithObjects:[UIControl class],[UINavigationBar class], nil])
    {
        if ([[touch view] isKindOfClass:aClass])
        {
            return NO;//点击的是一些操作控件，则不处理 『点击外部消失手势』
        }
    }
    return YES;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
@end
