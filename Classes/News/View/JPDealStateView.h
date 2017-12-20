//
//  JPDealStateView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JP_DealType) {
    JP_DealTypeCollection = 0,  //  收款
    JP_DealTypeRefund,          //  退款
};

@interface JPDealStateView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *ammount;
@property (nonatomic, assign) JP_DealType type;
@end

