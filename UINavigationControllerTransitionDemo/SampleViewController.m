//
//  SampleViewController.m
//  UINavigationControllerTransitionDemo
//
//  Created by Yoshiki Kurihara on 13/07/02.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import "SampleViewController.h"
#import "UINavigationController+Transform.h"

@interface SampleViewController ()

@property (assign, nonatomic) NSInteger depth;

@end

@implementation SampleViewController

- (id)initWithDepth:(NSInteger)depth {
    self = [super init];
    if (self) {
        _depth = depth;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Page %d", _depth];
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel *textLabel = [UILabel new];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.text = @"Blah blah blah";
    [textLabel sizeToFit];
    [self.view addSubview:textLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    imageView.frame = CGRectMake(0.0f,
                                 CGRectGetHeight(self.view.bounds) - CGRectGetHeight(imageView.frame),
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Pop"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(pop)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Push"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(push)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] <= 1) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)push {
    SampleViewController *vc = [[SampleViewController alloc] initWithDepth:_depth+1];
    [self.navigationController pushViewController:vc duration:0.3f preparations:^(CALayer *fromLayer, CALayer *toLayer) {
        toLayer.frame = CGRectOffset(toLayer.frame, toLayer.frame.size.width, 0.0f);
    } animations:^(CALayer *fromLayer, CALayer *toLayer) {
        fromLayer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0f);
        fromLayer.opacity = 0.0f;
        toLayer.frame = CGRectOffset(toLayer.frame, -toLayer.frame.size.width, 0.0f);
    } completions:^(CALayer *fromLayer, CALayer *toLayer) {
        //
    }];
}

- (void)pop {
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
}

@end
