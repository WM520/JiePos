//
//  IBPopView.m
//  JiePos
//
//  Created by iBlocker on 2017/9/6.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBPopView.h"

@interface IBPopView () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableVIew;
    NSArray *_dataArray;
    NSArray *_arr1;
}
@end

@implementation IBPopView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _arr1 = @[@"全部已读"];
    _tableVIew = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    _tableVIew.scrollEnabled = NO;
    _tableVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableVIew];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.textLabel.font = [UIFont systemFontOfSize:JPRealValue(22)];
        cell.textLabel.textColor = JP_Content_Color;
    }
    cell.textLabel.text = _arr1[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.ib_clickBlock) {
        self.ib_clickBlock(indexPath.row);
    }
}

//重置本控制器的大小
- (CGSize)preferredContentSize {
    
    if (self.popoverPresentationController != nil) {
        CGSize tempSize ;
        tempSize.height = self.view.frame.size.height;
        tempSize.width  = 100;
        CGSize size = [_tableVIew sizeThatFits:tempSize];  //返回一个完美适应tableView的大小的 size
        return size;
    } else {
        return [super preferredContentSize];
    }
    
}

@end
