//
//  UINavigationController+Transform.m
//  UINavigationController+Transition
//
//  Created by Yoshiki Kurihara on 13/07/02.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import "UINavigationController+Transform.h"
#import <QuartzCore/QuartzCore.h>

#define kUINavigationControllerTransformViewTag 164136

@implementation UINavigationController (Transform)

- (void)pushViewController:(UIViewController *)viewController
                  duration:(NSTimeInterval)duration
              preparations:(void (^)(CALayer *, CALayer *))preparations
                animations:(void (^)(CALayer *, CALayer *))animations
               completions:(void (^)(CALayer *, CALayer *))completions {

    UIView *transformView = [[UIView alloc] initWithFrame:self.view.bounds];
    transformView.tag = kUINavigationControllerTransformViewTag;
    [self.view.superview insertSubview:transformView atIndex:0];
    
    CALayer *fromLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    [transformView.layer addSublayer:fromLayer];
    
    [self pushViewController:viewController animated:NO];

    if (preparations)
        preparations(transformView.layer, self.view.layer);
    
    [UIView animateWithDuration:duration animations:^{
        if (animations)
            animations(transformView.layer, self.view.layer);
    } completion:^(BOOL finished) {
        if (completions)
            completions(transformView.layer, self.view.layer);
        //transformView.layer.transform = CATransform3DIdentity;
        [transformView removeFromSuperview];
    }];
}

- (void)popViewControllerWithDuration:(NSTimeInterval)duration
                         preparations:(void (^)(CALayer *, CALayer *))preparations
                           animations:(void (^)(CALayer *, CALayer *))animations
                          completions:(void (^)(CALayer *, CALayer *))completions {
    
    UIView *fromView = [[UIView alloc] initWithFrame:self.view.bounds];
    CALayer *fromLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    [fromView.layer addSublayer:fromLayer];
    [self.view.superview addSubview:fromView];

    [self popViewControllerAnimated:NO];

    if (preparations)
        preparations(fromView.layer, self.view.layer);
    
    [UIView animateWithDuration:duration animations:^{
        if (animations)
            animations(fromView.layer, self.view.layer);
    } completion:^(BOOL finished) {
        if (completions)
            completions(fromView.layer, self.view.layer);
        [fromView removeFromSuperview];
    }];
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
