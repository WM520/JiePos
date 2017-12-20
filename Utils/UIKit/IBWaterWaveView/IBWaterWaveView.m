//
//  IBWaterWaveView.m
//  JiePos
//
//  Created by iBlocker on 2017/8/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBWaterWaveView.h"

@interface IBWaterWaveView ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondeWaveLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer1;
@property (nonatomic, strong) CAGradientLayer *gradientLayer2;
@end
@implementation IBWaterWaveView
{
    CGFloat _waveAmplitude;      //!< 振幅
    CGFloat _waveCycle;          //!< 周期
    CGFloat _waveSpeed;          //!< 速度
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveOffsetX;        //!< 波浪x位移
    UIColor *_waveColor;         //!< 波浪颜色
    
    CGFloat _waveSpeed2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xedf0f4" alpha:0.1];
        self.layer.masksToBounds = YES;
        
        [self ConfigParams];
        
        [self startWave];
    }
    return self;
}

#pragma mark 配置参数
- (void)ConfigParams {
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = JPRealValue(20);
    //  背景色
    _waveColor = JP_viewBackgroundColor;
    _waveSpeed = 2.5f;
    _waveOffsetX = 0;
    _wavePointY = JPRealValue(456 - 40);
    _waveAmplitude = JPRealValue(20);
    _waveCycle =  1.29 * M_PI / _waterWaveWidth;
}

#pragma mark 加载layer ，绑定runloop 帧刷新
- (void)startWave {
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondeWaveLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark 帧刷新事件
- (void)getCurrentWave {
    _waveOffsetX += _waveSpeed;
    
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    
    [self.layer addSublayer:self.gradientLayer1];
    self.gradientLayer1.mask = _firstWaveLayer;
    
    [self.layer addSublayer:self.gradientLayer2];
    self.gradientLayer2.mask = _secondeWaveLayer;
}

#pragma mark 三个shapeLayer动画
- (void)setFirstWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = _waveAmplitude * 1.6 * sin((250 / _waterWaveWidth) * (x * M_PI / 180) - _waveOffsetX * M_PI / 270) + _wavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)setSecondWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        
        y = _waveAmplitude * 1.6 * sin((260 / _waterWaveWidth) * (x * M_PI / 180) - _waveOffsetX * M_PI / 180) + _wavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    _secondeWaveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark Get
- (CAGradientLayer *)gradientLayer1 {
    if (!_gradientLayer1) {
        _gradientLayer1 = [CAGradientLayer layer];
        _gradientLayer1.frame = self.bounds;
        _gradientLayer1.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
        _gradientLayer1.locations = @[@0, @1.0];
        _gradientLayer1.startPoint = CGPointMake(0, 0);
        _gradientLayer1.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer1;
}

- (CAGradientLayer *)gradientLayer2 {
    if (!_gradientLayer2) {
        _gradientLayer2 = [CAGradientLayer layer];
        _gradientLayer2.frame = self.bounds;
        _gradientLayer2.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
        _gradientLayer2.locations = @[@0, @1.0];
        _gradientLayer2.startPoint = CGPointMake(0, 0);
        _gradientLayer2.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer2;
}


- (CAShapeLayer *)firstWaveLayer {
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        //        _firstWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondeWaveLayer {
    if (!_secondeWaveLayer) {
        _secondeWaveLayer = [CAShapeLayer layer];
        //        _secondeWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondeWaveLayer;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
}
@end
