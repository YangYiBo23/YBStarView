//
//  YBStarView.h
//  CareWork
//
//  Created by 杨艺博 on 2020/4/2.
//  Copyright © 2020 阳阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YBStarViewDelegate <NSObject>

/// 点击回调(优先级低于block)
- (void)didSelectedScore:(CGFloat)score;

@end

IB_DESIGNABLE
@interface YBStarView : UIView

/// 星星个数(默认: 5个)
@property (nonatomic, assign) IBInspectable int startCount;

/// 单个星星进步值的百分比(取值范围: 0 < stepValue <= 1 默认: 0.5)
@property (nonatomic, assign) IBInspectable CGFloat stepValue;

/// 当前分数(默认: 0)
@property (nonatomic, assign) IBInspectable CGFloat score;

/// 是否允许拖动设置分数(默认: YES)
@property (nonatomic, assign) IBInspectable BOOL allowDragSelect;

/// 是否允许设置分数(默认: YES)
@property (nonatomic, assign) IBInspectable BOOL allowSelect;

/// 是否允许有小数(默认: YES)
@property (nonatomic, assign) IBInspectable BOOL allowDecimal;

/// 灰色星星
@property (nonatomic, strong, nullable) IBInspectable UIImage *normalImage;

/// 黄色星星
@property (nonatomic, strong, nullable) IBInspectable UIImage *highlightedImage;

/// 内边距(默认: UIEdgeInsetsZero)
@property (nonatomic, assign) UIEdgeInsets insets;

/// 这四个值用来适配通过xib设置时的实时渲染
@property (nonatomic, assign) IBInspectable CGFloat insets_top;
@property (nonatomic, assign) IBInspectable CGFloat insets_bottom;
@property (nonatomic, assign) IBInspectable CGFloat insets_left;
@property (nonatomic, assign) IBInspectable CGFloat insets_right;

/// 点击分数回调(优先于代理)
@property (nonatomic, copy) void(^completeBlock)(CGFloat score);

@property (nonatomic, weak) id<YBStarViewDelegate> delegate;

- (instancetype)init;

/// 自定义初始化方法
/// @param normalImage 正常星星图片
/// @param highlightedImage 高亮星星图片
- (instancetype)initWithNormalImage:(UIImage * _Nullable)normalImage highlightedImage:(UIImage * _Nullable)highlightedImage;

@end

NS_ASSUME_NONNULL_END
