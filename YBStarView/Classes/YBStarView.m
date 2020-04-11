//
//  YBStarView.m
//  CareWork
//
//  Created by 杨艺博 on 2020/4/2.
//  Copyright © 2020 阳阳. All rights reserved.
//

#import "YBStarView.h"

@interface YBStarImage : UIView

/// 灰色星星
@property (nonatomic, strong) UIImage *normalImage;
/// 高亮星星
@property (nonatomic, strong) UIImage *highlightedImage;
/// 当前星星绘制的百分比
@property (nonatomic, assign) CGFloat highlightedPercent;

@end

@implementation YBStarImage

- (instancetype)initWithNormalImage:(UIImage * _Nullable)normalImage highlightedImage:(UIImage * _Nullable)highlightedImage {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        self.normalImage = normalImage;
        self.highlightedImage = highlightedImage;
    }
    return self;
}

- (void)setHighlightedPercent:(CGFloat)highlightedPercent {
    _highlightedPercent = highlightedPercent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_highlightedPercent == 1) {
        [self.highlightedImage drawInRect:rect];
        return;
    }
    if (_highlightedPercent == 0) {
        [self.normalImage drawInRect:rect];
        return;
    }
    CGFloat highlightedWidth = rect.size.width * _highlightedPercent;
    CGFloat normalWidth  = rect.size.width - highlightedWidth;
    UIImage *leftImg  = [self croppedImgWithImg:self.highlightedImage percent:_highlightedPercent fromLeft:YES];
    UIImage *rightImg = [self croppedImgWithImg:self.normalImage percent:(1 - _highlightedPercent) fromLeft:NO];
    [leftImg drawInRect:CGRectMake(0, 0, highlightedWidth, rect.size.height)];
    [rightImg drawInRect:CGRectMake(highlightedWidth, 0, normalWidth, rect.size.height)];
}

- (UIImage *)croppedImgWithImg:(UIImage *)img percent:(CGFloat)percent fromLeft:(BOOL)isfromLeft {
    CGSize imgSize = img.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgSize.width * percent, imgSize.height), NO, 0);
    if (isfromLeft) {
        [img drawAtPoint:CGPointMake(0, 0)];
    } else {
        [img drawAtPoint:CGPointMake(imgSize.width * percent - imgSize.width, 0)];
    }
    UIImage *croppedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImg;
}

@end

@interface YBStarView ()

@property (nonatomic, strong) NSMutableArray<YBStarImage *> *starViews;

@end

@implementation YBStarView

- (instancetype)initWithNormalImage:(UIImage * _Nullable)normalImage highlightedImage:(UIImage * _Nullable)highlightedImage {
    if (self = [super init]) {
        self.normalImage = normalImage;
        self.highlightedImage = highlightedImage;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.allowDragSelect = YES;
    self.allowSelect = YES;
    self.allowDecimal = YES;
    self.stepValue = 0.5;
    self.score = 3.0;
    self.startCount = 5;
}

- (void)setStartCount:(int)startCount {
    _startCount = startCount;
    for (YBStarImage *star in self.starViews) {
        [star removeFromSuperview];
    }
    [self.starViews removeAllObjects];
    for (int i = 0; i < startCount; i ++) {
        YBStarImage *starImage = [[YBStarImage alloc] initWithNormalImage:self.normalImage highlightedImage:self.highlightedImage];
        [self.starViews addObject:starImage];
        [self addSubview:starImage];
    }
}

- (void)setScore:(CGFloat)score {
    _score = score;
    if (score > self.startCount) {
        score = self.startCount;
    } else if (score < 0) {
        score = 0;
    } else;
    
    int integerStarCount = floor(score);
    for (int i = 0; i < self.starViews.count; i ++) {
        YBStarImage *starView = self.starViews[i];
        if (i < integerStarCount) {
            starView.highlightedPercent = 1.0;
        } else if (i > integerStarCount) {
            starView.highlightedPercent = 0.0;
        } else {
            starView.highlightedPercent = score - integerStarCount;
        }
    }
}

- (void)setStepValue:(CGFloat)stepValue {
    if (stepValue > 1) {
        _stepValue = 1;
    } else if (stepValue < 0) {
        _stepValue = 0.5;
    } else {
        _stepValue = stepValue;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (0 == self.starViews.count) {
        return;
    }
    CGFloat star_w = (self.frame.size.width - self.insets.left - self.insets.right) / (CGFloat)self.starViews.count;
    CGFloat star_h = self.frame.size.height - self.insets.top - self.insets.bottom;
    CGFloat starSize = MIN(star_w, star_h);
    if (starSize <= 0) {
        return;
    }
    if (1 == self.starViews.count) {
        self.starViews.firstObject.frame = CGRectMake((self.frame.size.width - starSize) / 2.0, (self.frame.size.height - starSize) / 2.0, starSize, starSize);
    } else {
        CGFloat margin = (self.frame.size.width - self.insets.left - self.insets.right - (starSize * self.starViews.count)) / (CGFloat)(self.starViews.count - 1);
        for (int i = 0; i < self.starViews.count; i ++) {
            YBStarImage *starView = self.starViews[i];
            starView.frame = CGRectMake(self.insets.left + i * starSize + margin * i, self.insets.top + (self.frame.size.height - self.insets.top - self.insets.bottom - starSize) / 2.0, starSize, starSize);
        }
    }
}

- (NSMutableArray<YBStarImage *> *)starViews {
    if (!_starViews) {
        _starViews = [NSMutableArray array];
    }
    return _starViews;
}

- (UIImage *)normalImage {
    if (!_normalImage) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"YBStarView" ofType:@"bundle"]];
        _normalImage = [UIImage imageNamed:@"icon_yb_star_gray" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return _normalImage;
}

- (UIImage *)highlightedImage {
    if (!_highlightedImage) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"YBStarView" ofType:@"bundle"]];
        _highlightedImage = [UIImage imageNamed:@"icon_yb_star_yellow" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return _highlightedImage;
}

- (void)setInsets_top:(CGFloat)insets_top {
    UIEdgeInsets insets = self.insets;
    insets.top = insets_top;
    self.insets = insets;
    [self setNeedsLayout];
}

- (void)setInsets_bottom:(CGFloat)insets_bottom {
    UIEdgeInsets insets = self.insets;
    insets.bottom = insets_bottom;
    self.insets = insets;
    [self setNeedsLayout];
}

- (void)setInsets_left:(CGFloat)insets_left {
    UIEdgeInsets insets = self.insets;
    insets.left = insets_left;
    self.insets = insets;
    [self setNeedsLayout];
}

- (void)setInsets_right:(CGFloat)insets_right {
    UIEdgeInsets insets = self.insets;
    insets.right = insets_right;
    self.insets = insets;
    [self setNeedsLayout];
}

#pragma mark - 处理点击滑动事件
- (void)handleTouches:(NSSet *)touchs {
    if (!_allowSelect) {
        return;
    }
    UITouch *touch = [touchs anyObject];
    CGPoint locatedPoint = [touch locationInView:self];
    NSInteger lastTapStarViewIndex = self.starViews.count - 1;
    for (NSInteger i = self.starViews.count - 1; i >= 0; i --) {
        if (locatedPoint.x > CGRectGetMinX(self.starViews[i].frame)) {
            lastTapStarViewIndex = i;
            break;
        }
    }
    _score = 0.0;
    for (int i = 0; i < self.starViews.count; i ++ ) {
        YBStarImage *star = self.starViews[i];
        if (i < lastTapStarViewIndex) {
            star.highlightedPercent = 1.0;
            _score += 1.0;
        } else if (i > lastTapStarViewIndex) {
            star.highlightedPercent = 0.0;
        } else {
            if (self.allowDecimal) {
                CGFloat highlightedPercent = (locatedPoint.x - star.frame.origin.x) / star.frame.size.width;
                highlightedPercent = highlightedPercent > 1 ? 1 : highlightedPercent;
                highlightedPercent = round(highlightedPercent / self.stepValue) * self.stepValue;
                _score += highlightedPercent;
                star.highlightedPercent = highlightedPercent;
            } else {
                _score += 1.0;
                star.highlightedPercent = 1.0;
            }
        }
    }
    _score = [NSString stringWithFormat:@"%.2f", _score].floatValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (NO == self.allowDragSelect) {
        return;
    }
    [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.completeBlock) {
        self.completeBlock(self.score);
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedScore:)]) {
            [_delegate didSelectedScore:self.score];
        }
    }
}


@end
