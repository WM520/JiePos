//
//  JPSearchDealCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPSearchHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) void (^jp_searchMerchantBlock)(UILabel *merchantName);
@property (nonatomic, copy) NSString *merchantName;
@end

@interface JPSearchDealCell : UITableViewCell
@property (nonatomic, copy) NSString *oneTitle;
@property (nonatomic, copy) NSString *oneValue;
@property (nonatomic, copy) NSString *twoTitle;
@property (nonatomic, copy) NSString *twoValue;
@property (nonatomic, copy) void (^jp_oneRowClick)(JPSearchDealCell *cell);
@property (nonatomic, copy) void (^jp_twoRowClick)(JPSearchDealCell *cell);
@end

@interface JPSearchFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) void (^jp_searchDealBlock)();
@property (nonatomic, strong) UIButton *searchDealButton;
@end
