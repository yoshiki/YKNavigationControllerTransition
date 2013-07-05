YKNavigationControllerTransition
==========

![Movie](movie.gif)

# Features #

- Customization push/pop transition of UINavigationController.

# Requirements #

- iOS4.3 or later

# ARC #

YKNavigationControllerTransition uses ARC.

# Instration #

- Copy YKNavigationControllerTransition/ directory to your project.
- Import "YKNavigationControllerTransition.h" wherever you need it.

# Usage #

- Push view controller

``` objective-c
    [self.navigationController pushViewController:viewController duration:0.3f preparations:^(CALayer *fromLayer, CALayer *toLayer) {
        toLayer.frame = CGRectOffset(toLayer.frame, toLayer.frame.size.width, 0.0f);
    } animations:^(CALayer *fromLayer, CALayer *toLayer) {
        fromLayer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0f);
        fromLayer.opacity = 0.0f;
        toLayer.frame = CGRectOffset(toLayer.frame, -toLayer.frame.size.width, 0.0f);
    } completions:^(CALayer *fromLayer, CALayer *toLayer) {
        //
    }];
```

or

``` objective-c
    [self.navigationController pushViewController:vc
                                         duration:0.3f
                              fromTransitionStyle:YKNavigationControllerTransitionStyleSlideOutLeft
                                toTransitionStyle:YKNavigationControllerTransitionStyleSlideInRight];
```

- Pop view controller

``` objective-c
    [self.navigationController popViewControllerWithDuration:0.3f preparations:^(CALayer *fromLayer, CALayer *toLayer) {
        toLayer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0f);
        toLayer.opacity = 0.0f;
    } animations:^(CALayer *fromLayer, CALayer *toLayer) {
        fromLayer.frame = CGRectOffset(fromLayer.frame, fromLayer.frame.size.width, 0.0f);
        toLayer.transform = CATransform3DIdentity;
        toLayer.opacity = 1.0f;
    } completions:^(CALayer *fromLayer, CALayer *toLayer) {
        //
    }];
```
or

``` objective-c
    [self.navigationController popViewControllerWithDuration:0.3f
                                         fromTransitionStyle:YKNavigationControllerTransitionStyleSlideOutRight
                                           toTransitionStyle:YKNavigationControllerTransitionStyleSlideInLeft];
```

# Transition styles #

- YKNavigationControllerTransitionStyleIdentity
- YKNavigationControllerTransitionStyleFadeInBack
- YKNavigationControllerTransitionStyleFadeInFront
- YKNavigationControllerTransitionStyleFadeOutBack
- YKNavigationControllerTransitionStyleFadeOutFront
- YKNavigationControllerTransitionStyleSlideOutRight
- YKNavigationControllerTransitionStyleSlideOutLeft
- YKNavigationControllerTransitionStyleSlideOutTop
- YKNavigationControllerTransitionStyleSlideOutBottom
- YKNavigationControllerTransitionStyleSlideInRight
- YKNavigationControllerTransitionStyleSlideInLeft
- YKNavigationControllerTransitionStyleSlideInTop
- YKNavigationControllerTransitionStyleSlideInBottom
- YKNavigationControllerTransitionStyleRotateOutLeft
- YKNavigationControllerTransitionStyleRotateOutRight
- YKNavigationControllerTransitionStyleRotateInLeft
- YKNavigationControllerTransitionStyleRotateInRight

# License #

UINavigationController+Transition is available under the MIT License.

Copyright (c) 2013 Yoshiki Kurihara

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
