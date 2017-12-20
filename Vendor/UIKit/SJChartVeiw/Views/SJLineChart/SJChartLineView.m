//
//  SJChartLineView.m
//  SJChartViewDemo
//
//  Created by Jaesun on 16/9/9.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import "SJChartLineView.h"
#import "SJCircleView.h"

// Tag 基初值
#define BASE_TAG_COVERVIEW 100
#define BASE_TAG_CIRCLEVIEW 200
#define BASE_TAG_POPBTN 300

@interface SJChartLineView() {
    
    NSMutableArray *pointArray;
    NSInteger lastSelectedIndex;
    
    CGPoint touchViewPoint;
    UIView *movelineone;
    UILabel *movelineoneLable;
}
@end

@implementation SJChartLineView

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
}

- (void)setValueArray:(NSArray *)valueArray {
    _valueArray = valueArray;
}

- (void)setKeyArray:(NSArray *)keyArray {
    _keyArray = keyArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectedIndex = - 1;
        self.yAxis_L = frame.size.height;
        self.xAxis_L = frame.size.width;
        
    }
    return  self;
}

- (void)mapping {
    
    [super mapping];
    
    [self drawChartLine];
    [self drawGradient];
    
//    [self setupCircleViews];
    //  添加长按手势
    [self setupLongPressView];
}

- (void)reloadDatas {
    
    [self clearView];
    
    [self mapping];
}

#pragma mark 画折线图
- (void)drawChartLine {
    
    if (pointArray) {
        [pointArray removeAllObjects];
    }
    else {
        pointArray = @[].mutableCopy;
    }
    
    UIBezierPath *pAxisPath = [[UIBezierPath alloc] init];
    
    for (int i = 0; i < self.valueArray.count; i ++) {
        
        CGPoint last_point = CGPointZero;
        if (i > 0) {
            CGFloat last_point_X = self.xScaleMarkLEN * (self.xMarkTitles.count - 1) / (self.valueArray.count - 1) * (i - 1) + self.startPoint.x;
            
            id last_obj = self.valueArray[i - 1];
            if ([last_obj isEqual:[NSNull null]]) {
                return;
            }
            CGFloat last_value = [last_obj floatValue];
            CGFloat last_percent = last_value / self.maxValue;
            CGFloat last_point_Y = self.yAxis_L * (1 - last_percent) + self.startPoint.y;
            
            last_point = CGPointMake(last_point_X, last_point_Y);
        }
        
        
        CGFloat point_X = self.xScaleMarkLEN * (self.xMarkTitles.count - 1) / (self.valueArray.count - 1) * i + self.startPoint.x;
        
        id obj = self.valueArray[i];
        if ([obj isEqual:[NSNull null]]) {
            return;
        }
        CGFloat value = [obj floatValue];
        CGFloat percent = value / self.maxValue;
        CGFloat point_Y = self.yAxis_L * (1 - percent) + self.startPoint.y;
        
        CGPoint point = CGPointMake(point_X, point_Y);
        
        // 记录各点的坐标方便后边添加渐变阴影 和 点击层视图 等
        [pointArray addObject:[NSValue valueWithCGPoint:point]];
        
        if (i == 0) {
            [pAxisPath moveToPoint:point];
        } else {
            //  折线
//            [pAxisPath addLineToPoint:point];
            //  曲线
            [pAxisPath addCurveToPoint:point controlPoint1:CGPointMake((point.x - last_point.x) / 2 + last_point.x, last_point.y) controlPoint2:CGPointMake((point.x - last_point.x) / 2 + last_point.x, point.y)];
        }
    }
    CAShapeLayer *pAxisLayer = [CAShapeLayer layer];
    pAxisLayer.lineWidth = 3;
    pAxisLayer.strokeColor = JPBaseColor.CGColor;//[UIColor whiteColor].CGColor;
    pAxisLayer.fillColor = [UIColor clearColor].CGColor;
    pAxisLayer.path = pAxisPath.CGPath;
    [self.layer addSublayer:pAxisLayer];
}

#pragma mark 渐变阴影
- (void)drawGradient {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    gradientLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    gradientLayer.colors = @[(__bridge id)JPBaseColor.CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    
    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1);
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    [gradientPath moveToPoint:CGPointMake(self.startPoint.x, self.yAxis_L + self.startPoint.y)];
    
    for (int i = 0; i < pointArray.count; i ++) {
        [gradientPath addLineToPoint:[pointArray[i] CGPointValue]];
    }
    
    CGPoint endPoint = [[pointArray lastObject] CGPointValue];
    endPoint = CGPointMake(endPoint.x, self.yAxis_L + self.startPoint.y);
    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.layer addSublayer:gradientLayer];
    
}

#pragma mark 折线上的圆环
- (void)setupCircleViews {
    
    for (int i = 0; i < pointArray.count; i ++) {
        
        SJCircleView *circleView = [[SJCircleView alloc] initWithCenter:[pointArray[i] CGPointValue] radius:2];
        circleView.tag = i + BASE_TAG_CIRCLEVIEW;
        circleView.borderColor = [UIColor whiteColor];
        circleView.borderWidth = 1.0;
        [self addSubview:circleView];
    }
}

//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    
//    touchViewPoint = [touch locationInView:self];
//    
//    [movelineone removeFromSuperview];
//    [movelineoneLable removeFromSuperview];
//    movelineone = nil;
//    movelineoneLable = nil;
//}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    touchViewPoint = [touch locationInView:self];
//    [self setView];
//    [self isKPointWithPoint:touchViewPoint];
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    touchViewPoint = [touch locationInView:self];
//    [self isKPointWithPoint:touchViewPoint];
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//
//    touchViewPoint = [touch locationInView:self];
//
//    [movelineone removeFromSuperview];
//    [movelineoneLable removeFromSuperview];
//    movelineone = nil;
//    movelineoneLable = nil;
//}

#pragma mark - longPressView
- (void)setupLongPressView {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    
    touchViewPoint = [longPress locationInView:self];
    
    //  判断长按的点是否在视图内部
    if (touchViewPoint.x >= self.frame.origin.x && touchViewPoint.x <= self.frame.origin.x + self.frame.size.width && touchViewPoint.y >= self.frame.origin.y && touchViewPoint.y <= self.frame.origin.y + self.frame.size.height) {
        if(longPress.state == UIGestureRecognizerStateBegan) {
            
            [MobClick event:@"home_chartPress"];
            
            [self setView];
            [self isKPointWithPoint:touchViewPoint];
        } else if (longPress.state == UIGestureRecognizerStateChanged) {
            [self isKPointWithPoint:touchViewPoint];
        } else if (longPress.state == UIGestureRecognizerStateEnded) {
            [movelineone removeFromSuperview];
            [movelineoneLable removeFromSuperview];
            movelineone = nil;
            movelineoneLable = nil;
        }
    } else {
        [movelineone removeFromSuperview];
        [movelineoneLable removeFromSuperview];
        movelineone = nil;
        movelineoneLable = nil;
    }
}

- (void)setView {
    if (movelineone == Nil) {
        movelineone = [[UIView alloc] initWithFrame:CGRectMake(JPRealValue(100), 0, 0.5, self.frame.size.height - JPRealValue(60))];
        movelineone.backgroundColor = JPBaseColor;//[UIColor whiteColor];
        [self addSubview:movelineone];
    }
    if (movelineoneLable == Nil) {
        movelineoneLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JPRealValue(160), JPRealValue(60))];
        movelineoneLable.layer.cornerRadius = JPRealValue(6);
        movelineoneLable.layer.masksToBounds = YES;
        movelineoneLable.font = [UIFont systemFontOfSize:11];
        movelineoneLable.numberOfLines = 0;
        movelineoneLable.lineBreakMode = NSLineBreakByWordWrapping;
        movelineoneLable.layer.cornerRadius = JPRealValue(10);
        movelineoneLable.backgroundColor = JPBaseColor;//[UIColor whiteColor];
        movelineoneLable.textColor = [UIColor whiteColor];//JPBaseColor;
        movelineoneLable.textAlignment = NSTextAlignmentCenter;
        movelineoneLable.hidden = YES;
        [self addSubview:movelineoneLable];
    }
    movelineone.frame = CGRectMake(touchViewPoint.x, 0, 0.5, self.frame.size.height - JPRealValue(60));
    
    movelineone.hidden = YES;
    [self isKPointWithPoint:touchViewPoint];
}

#pragma mark 判断并在十字线上显示提示信息
- (void)isKPointWithPoint:(CGPoint)point {
    
    CGFloat itemPointX = 0;
    for (id obj in pointArray) {
        CGPoint myPoint = [obj CGPointValue];
        itemPointX = myPoint.x;
        NSInteger itemX = itemPointX;
        NSInteger pointX = point.x;
        
        if (itemX == pointX || fabs(point.x - itemX) <= 5) {
            movelineone.hidden = NO;
            movelineone.frame = CGRectMake(itemPointX, movelineone.frame.origin.y, 0.5, movelineone.frame.size.height + JPRealValue(60));
            
            [self layoutIfNeeded];
            NSInteger idx = [pointArray indexOfObject:obj];
            // 垂直提示日期控件
            movelineoneLable.text = [NSString stringWithFormat:@"%@元\n%@", self.valueArray[idx], self.keyArray[idx]]; // 日期
            movelineoneLable.hidden = NO;
            
            if (idx >= pointArray.count - 2) {
                movelineoneLable.center = CGPointMake(movelineone.frame.origin.x - JPRealValue(30), JPRealValue(60));
            } else {
                movelineoneLable.center = CGPointMake(movelineone.frame.origin.x, JPRealValue(60));
            }
            
            break;
        }
    }
}

#pragma mark- 清空视图
- (void)clearView {
    [self removeSubviews];
    [self removeSublayers];
//    [self.layer removeFromSuperlayer];
}

#pragma mark 移除 点击图层 、圆环 、数值标签
- (void)removeSubviews {
    
    NSArray *subViews = [NSArray arrayWithArray:self.subviews];
    
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    
}

#pragma mark 移除折线
- (void)removeSublayers {
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeFromSuperlayer];
    }
}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition
{
    return 0.f;
}
@end
