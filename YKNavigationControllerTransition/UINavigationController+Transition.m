//
//  UINavigationController+Transition.m
//  YKNavigationControllerTansition
//
//  Created by Yoshiki Kurihara on 13/07/02.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import <QuartzCore/QuartzCore.h>

@interface YKTransitionView : UIView

@property (assign, nonatomic) NSInteger index;

@end

@implementation YKTransitionView

@end

static YKTransitionView *_fromTransitionView;
static YKTransitionView *_toTransitionView;

@implementation UINavigationController (Transition)

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
              preparations:(YKNavigationControllerTransitionBlock)preparations
                animations:(YKNavigationControllerTransitionBlock)animations
               completions:(YKNavigationControllerTransitionBlock)completions {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f / 1000.0f;
    self.view.superview.layer.sublayerTransform = transform;

    [self.view.superview insertSubview:self.toTransitionView atIndex:self.toTransitionView.index];
    
    CALayer *fromLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    [self.toTransitionView.layer addSublayer:fromLayer];
    
    [self pushViewController:viewController animated:NO];

    if (preparations)
        preparations(self.toTransitionView.layer, self.view.layer);
    
    [UIView animateWithDuration:duration animations:^{
        if (animations)
            animations(self.toTransitionView.layer, self.view.layer);
    } completion:^(BOOL finished) {
        if (completions)
            completions(self.toTransitionView.layer, self.view.layer);
        [self removeToTransitionView];
    }];
}

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                         preparations:(YKNavigationControllerTransitionBlock)preparations
                           animations:(YKNavigationControllerTransitionBlock)animations
                          completions:(YKNavigationControllerTransitionBlock)completions {
    
    CALayer *fromLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    [self.fromTransitionView.layer addSublayer:fromLayer];
    [self.view.superview insertSubview:self.fromTransitionView atIndex:0];

    [self popViewControllerAnimated:NO];

    if (preparations)
        preparations(self.fromTransitionView.layer, self.view.layer);
    
    [UIView animateWithDuration:duration animations:^{
        if (animations)
            animations(self.fromTransitionView.layer, self.view.layer);
    } completion:^(BOOL finished) {
        if (completions)
            completions(self.fromTransitionView.layer, self.view.layer);
        [self removeFromTransitionView];
    }];
}

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
       fromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
         toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle {

    switch (fromTransitionStyle) {
        case YKNavigationControllerTransitionStyleFadeOutFront:
            self.toTransitionView.index = 100;
            break;
        default:
            break;
    }

    YKNavigationControllerTransitionBlock preparations = [self preparationsWithFromTransitionStyle:fromTransitionStyle
                                                                                 toTransitionStyle:toTransitionStyle];
    YKNavigationControllerTransitionBlock animations = [self animationsWithFromTransitionStyle:fromTransitionStyle
                                                                             toTransitionStyle:toTransitionStyle];
    YKNavigationControllerTransitionBlock completions = [self completionsWithFromTransitionStyle:fromTransitionStyle
                                                                               toTransitionStyle:toTransitionStyle];

    [self pushViewController:viewController
                    duration:duration
                preparations:preparations
                  animations:animations
                 completions:completions];
}

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                  fromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
                    toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle {
    
    switch (toTransitionStyle) {
        case YKNavigationControllerTransitionStyleFadeInFront:
            self.fromTransitionView.index = 0;
            break;
        default:
            break;
    }

    YKNavigationControllerTransitionBlock preparations = [self preparationsWithFromTransitionStyle:fromTransitionStyle
                                                                                 toTransitionStyle:toTransitionStyle];
    YKNavigationControllerTransitionBlock animations = [self animationsWithFromTransitionStyle:fromTransitionStyle
                                                                             toTransitionStyle:toTransitionStyle];
    YKNavigationControllerTransitionBlock completions = [self completionsWithFromTransitionStyle:fromTransitionStyle
                                                                               toTransitionStyle:toTransitionStyle];

    [self popViewControllerWithDuration:duration
                           preparations:preparations
                             animations:animations
                            completions:completions];
}

- (YKNavigationControllerTransitionBlock)preparationsWithFromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
                                                           toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle {

    return ^void(CALayer *fromLayer, CALayer *toLayer) {
        switch (fromTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            case YKNavigationControllerTransitionStyleRotateOutLeft: {
                CGRect fromLayerFrame = fromLayer.frame;
                fromLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
                fromLayer.frame = fromLayerFrame;
                break;
            }
            case YKNavigationControllerTransitionStyleRotateOutRight: {
                CGRect fromLayerFrame = fromLayer.frame;
                fromLayer.anchorPoint = CGPointMake(1.0f, 0.5f);
                fromLayer.frame = fromLayerFrame;
                break;
            }
            default:
                break;
        }
        switch (toTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            case YKNavigationControllerTransitionStyleSlideInRight:
                toLayer.frame = CGRectOffset(toLayer.frame, toLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideInLeft:
                toLayer.frame = CGRectOffset(toLayer.frame, -toLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideInTop:
                toLayer.frame = CGRectOffset(toLayer.frame, 0.0f, -toLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleSlideInBottom:
                toLayer.frame = CGRectOffset(toLayer.frame, 0.0f, toLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleFadeInBack:
                toLayer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0f);
                toLayer.opacity = 0.0f;
                break;
            case YKNavigationControllerTransitionStyleFadeInFront:
                toLayer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0f);
                toLayer.opacity = 0.0f;
                break;
            case YKNavigationControllerTransitionStyleRotateInLeft: {
                CGRect toLayerFrame = toLayer.frame;
                toLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
                toLayer.frame = toLayerFrame;
                toLayer.transform = CATransform3DMakeRotation((100.0f * M_PI / 180.0f), 0.0f, 1.0f, 0.0f);
                break;
            }
            case YKNavigationControllerTransitionStyleRotateInRight: {
                CGRect toLayerFrame = toLayer.frame;
                toLayer.anchorPoint = CGPointMake(1.0f, 0.5f);
                toLayer.frame = toLayerFrame;
                toLayer.transform = CATransform3DMakeRotation((-100.0f * M_PI / 180.0f), 0.0f, 1.0f, 0.0f);
                break;
            }
            default:
                break;
        }
    };
}

- (YKNavigationControllerTransitionBlock)animationsWithFromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
                                                         toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle {
    
    return ^void(CALayer *fromLayer, CALayer *toLayer) {
        switch (fromTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            case YKNavigationControllerTransitionStyleFadeOutBack:
                fromLayer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0f);
                fromLayer.opacity = 0.0f;
                break;
            case YKNavigationControllerTransitionStyleFadeOutFront:
                fromLayer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0f);
                fromLayer.opacity = 0.0f;
                break;
            case YKNavigationControllerTransitionStyleSlideOutRight:
                fromLayer.frame = CGRectOffset(fromLayer.frame, fromLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideOutLeft:
                fromLayer.frame = CGRectOffset(fromLayer.frame, -fromLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideOutTop:
                fromLayer.frame = CGRectOffset(fromLayer.frame, 0.0f, -fromLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleSlideOutBottom:
                fromLayer.frame = CGRectOffset(fromLayer.frame, 0.0f, fromLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleRotateOutLeft:
                fromLayer.transform = CATransform3DMakeRotation((100.0f * M_PI / 180.0f), 0.0f, 1.0f, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleRotateOutRight:
                fromLayer.transform = CATransform3DMakeRotation((-100.0f * M_PI / 180.0f), 0.0f, 1.0f, 0.0f);
                break;
            default:
                break;
        }
        switch (toTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            case YKNavigationControllerTransitionStyleSlideInRight:
                toLayer.frame = CGRectOffset(toLayer.frame, -toLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideInLeft:
                toLayer.frame = CGRectOffset(toLayer.frame, toLayer.frame.size.width, 0.0f);
                break;
            case YKNavigationControllerTransitionStyleSlideInTop:
                toLayer.frame = CGRectOffset(toLayer.frame, 0.0f, toLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleSlideInBottom:
                toLayer.frame = CGRectOffset(toLayer.frame, 0.0f, -toLayer.frame.size.height);
                break;
            case YKNavigationControllerTransitionStyleFadeInBack:
                toLayer.transform = CATransform3DIdentity;
                toLayer.opacity = 1.0f;
                break;
            case YKNavigationControllerTransitionStyleFadeInFront:
                toLayer.transform = CATransform3DIdentity;
                toLayer.opacity = 1.0f;
                break;
            case YKNavigationControllerTransitionStyleRotateInLeft:
                toLayer.transform = CATransform3DIdentity;
                break;
            case YKNavigationControllerTransitionStyleRotateInRight:
                toLayer.transform = CATransform3DIdentity;
                break;
            default:
                break;
        }
    };
}

- (YKNavigationControllerTransitionBlock)completionsWithFromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
                                                          toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle {
    
    return ^void(CALayer *fromLayer, CALayer *toLayer) {
        switch (fromTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            default:
                break;
        }
        switch (toTransitionStyle) {
            case YKNavigationControllerTransitionStyleIdentity:
                break;
            default:
                break;
        }
    };
}

- (YKTransitionView *)fromTransitionView {
    if (_fromTransitionView == nil) {
        _fromTransitionView = [[YKTransitionView alloc] initWithFrame:self.view.bounds];
        _fromTransitionView.index = 100;
    }
    return _fromTransitionView;
}

- (void)removeFromTransitionView {
    [_fromTransitionView removeFromSuperview];
    _fromTransitionView = nil;
}

- (YKTransitionView *)toTransitionView {
    if (_toTransitionView == nil) {
        _toTransitionView = [[YKTransitionView alloc] initWithFrame:self.view.bounds];
        _toTransitionView.index = 0;
    }
    return _toTransitionView;
}

- (void)removeToTransitionView {
    [_toTransitionView removeFromSuperview];
    _toTransitionView = nil;
}

- (CALayer *)_layerSnapshotWithTransform:(CATransform3D)transform {
	if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
	else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    CALayer *snapshotLayer = [CALayer layer];
	snapshotLayer.transform = transform;
    snapshotLayer.frame = self.view.bounds;
	snapshotLayer.contents = (id)snapshot.CGImage;
    return snapshotLayer;
}

@end
