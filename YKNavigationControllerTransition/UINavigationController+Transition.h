//
//  UINavigationController+Transition.h
//  YKNavigationControllerTansition
//
//  Created by Yoshiki Kurihara on 13/07/02.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    YKNavigationControllerTransitionStyleIdentity = 0,
    YKNavigationControllerTransitionStyleFadeInBack,
    YKNavigationControllerTransitionStyleFadeInFront,
    YKNavigationControllerTransitionStyleFadeOutBack,
    YKNavigationControllerTransitionStyleFadeOutFront,
    YKNavigationControllerTransitionStyleSlideOutRight,
    YKNavigationControllerTransitionStyleSlideOutLeft,
    YKNavigationControllerTransitionStyleSlideOutTop,
    YKNavigationControllerTransitionStyleSlideOutBottom,
    YKNavigationControllerTransitionStyleSlideInRight,
    YKNavigationControllerTransitionStyleSlideInLeft,
    YKNavigationControllerTransitionStyleSlideInTop,
    YKNavigationControllerTransitionStyleSlideInBottom,
    YKNavigationControllerTransitionStyleRotateOutLeft,
    YKNavigationControllerTransitionStyleRotateOutRight,
    YKNavigationControllerTransitionStyleRotateInLeft,
    YKNavigationControllerTransitionStyleRotateInRight,
} YKNavigationControllerTransitionStyle;

typedef void(^YKNavigationControllerTransitionBlock)(CALayer *fromLayer, CALayer *toLayer);

@interface UINavigationController (Transition)

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
              preparations:(YKNavigationControllerTransitionBlock)preparations
                animations:(YKNavigationControllerTransitionBlock)animations
               completions:(YKNavigationControllerTransitionBlock)completions;

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                         preparations:(YKNavigationControllerTransitionBlock)preparations
                           animations:(YKNavigationControllerTransitionBlock)animations
                          completions:(YKNavigationControllerTransitionBlock)completions;

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
       fromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
         toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle;

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                  fromTransitionStyle:(YKNavigationControllerTransitionStyle)fromTransitionStyle
                    toTransitionStyle:(YKNavigationControllerTransitionStyle)toTransitionStyle;

@end
