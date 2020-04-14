//
//  UIViewController+Loading.m
//  Opener
//
//  Created by Tim Johnsen on 4/12/15.
//  Copyright (c) 2015 tijo. All rights reserved.
//

#import "UIViewController+Loading.h"

static const NSInteger kLoadingIndicatorTag = 92463;

@implementation UIViewController (Loading)

- (void)showLoadingIndicatorAfterDelayIfNotCancelled:(const NSTimeInterval)delay
{
    [self performSelector:@selector(_tryShowLoadingIndicator) withObject:nil afterDelay:delay];
}

- (void)setLoadingIndicatorVisible:(BOOL)visible
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_tryShowLoadingIndicator) object:nil];
    if (visible) {
        [self _tryShowLoadingIndicator];
    } else {
        [self _hideLoadingIndicator];
    }
}

- (void)_tryShowLoadingIndicator
{
    if (![self.view viewWithTag:kLoadingIndicatorTag]) {
        static const CGFloat kLoadingViewSideLength = 125.0;
        static const CGFloat kLoadingViewCornerRadius = 12.0;
        
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kLoadingViewSideLength, kLoadingViewSideLength)];
        loadingView.layer.cornerRadius = kLoadingViewCornerRadius;
        loadingView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        loadingView.tag = kLoadingIndicatorTag;
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:loadingView];
        
        static const CGFloat kLoadViewLightInterfaceBackgroundAlpha = 0.8;
        
        UIActivityIndicatorViewStyle style;
        if (@available(iOS 13.0, *)) {
            style = UIActivityIndicatorViewStyleLarge;
            loadingView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                    return [UIColor colorWithWhite:0.0 alpha:kLoadViewLightInterfaceBackgroundAlpha];
                } else {
                    return [UIColor tertiarySystemBackgroundColor];
                }
            }];
            loadingView.layer.cornerCurve = kCACornerCurveContinuous;
        } else {
            style = UIActivityIndicatorViewStyleWhiteLarge;
            loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kLoadViewLightInterfaceBackgroundAlpha];
        }
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        activityIndicator.color = [UIColor whiteColor];
        [activityIndicator sizeToFit];
        activityIndicator.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [activityIndicator startAnimating];
        [loadingView addSubview:activityIndicator];
        
        _setActivityIndicatorViewHidden(loadingView, YES);
        [UIView animateWithDuration:0.25
                              delay:0.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            _setActivityIndicatorViewHidden(loadingView, NO);
        }
                         completion:nil];
    }
}

- (void)_hideLoadingIndicator
{
    UIView *const view = [self.view viewWithTag:kLoadingIndicatorTag];
    [UIView animateWithDuration:0.2
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        _setActivityIndicatorViewHidden(view, YES);
    }
                     completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

static void _setActivityIndicatorViewHidden(UIView *const view, const BOOL hidden) {
    if (hidden) {
        view.transform = CGAffineTransformMakeScale(0.3, 0.3);
        view.alpha = 0.0;
    } else {
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }
}

@end
