//
//  UINavigationController+Transform.h
//  UINavigationController+Transition
//
//  Created by Yoshiki Kurihara on 13/07/02.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (Transform)

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
              preparations:(void (^)(CALayer *fromLayer, CALayer *toLayer))preparations
                animations:(void (^)(CALayer *fromLayer, CALayer *toLayer))animations
               completions:(void (^)(CALayer *fromLayer, CALayer *toLayer))completions;

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                         preparations:(void (^)(CALayer *fromLayer, CALayer *toLayer))preparations
                           animations:(void (^)(CALayer *fromLayer, CALayer *toLayer))animations
                          completions:(void (^)(CALayer *fromLayer, CALayer *toLayer))completions;

@end
