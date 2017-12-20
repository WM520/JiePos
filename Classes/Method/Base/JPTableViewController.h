//
//  JPTableViewController.h
//  JiePos
//
//  Created by iBlocker on 2017/8/24.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger sections;
@property (nonatomic, assign) NSInteger rows;
- (UITableViewCell *)ib_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ib_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
