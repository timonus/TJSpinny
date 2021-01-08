//
//  UIViewController+Loading.m
//  Opener
//
//  Created by Tim Johnsen on 4/12/15.
//  Copyright (c) 2015 tijo. All rights reserved.
//

#import "UIViewController+Loading.h"
#import <objc/runtime.h>

static char *const kLoadingIndicatorKey = "kLIK";

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
    UIView *const view = self.viewIfLoaded;
    if (self.isViewLoaded && !objc_getAssociatedObject(self, kLoadingIndicatorKey)) {
        static const CGFloat kLoadingViewSideLength = 125.0;
        static const CGFloat kLoadingViewCornerRadius = 12.0;
        
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kLoadingViewSideLength, kLoadingViewSideLength)];
        loadingView.layer.cornerRadius = kLoadingViewCornerRadius;
        loadingView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
        objc_setAssociatedObject(self, kLoadingIndicatorKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [view addSubview:loadingView];
        
        static const CGFloat kLoadViewLightInterfaceBackgroundAlpha = 0.8;
        
        UIActivityIndicatorViewStyle style;
        
#if !defined(__IPHONE_13_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_13_0
        if (@available(iOS 13.0, *)) {
#endif
            style = UIActivityIndicatorViewStyleLarge;
            loadingView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                    return [UIColor colorWithWhite:0.0 alpha:kLoadViewLightInterfaceBackgroundAlpha];
                } else {
                    return [UIColor tertiarySystemBackgroundColor];
                }
            }];
            loadingView.layer.cornerCurve = kCACornerCurveContinuous;
#if !defined(__IPHONE_13_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_13_0
        } else {
            style = UIActivityIndicatorViewStyleWhiteLarge;
            loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kLoadViewLightInterfaceBackgroundAlpha];
        }
#endif
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
             usingSpringWithDamping:UIAccessibilityIsReduceMotionEnabled() ? 1.0 : 0.6
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
    UIView *const view = objc_getAssociatedObject(self, kLoadingIndicatorKey);
    if (view) {
        objc_setAssociatedObject(self, kLoadingIndicatorKey, nil, OBJC_ASSOCIATION_ASSIGN);
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
}

static void _setActivityIndicatorViewHidden(UIView *const view, const BOOL hidden) {
    if (hidden) {
        const CGFloat scale = UIAccessibilityIsReduceMotionEnabled() ? 0.85 : 0.3;
        view.transform = CGAffineTransformMakeScale(scale, scale);
        view.alpha = 0.0;
    } else {
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }
}

@end
