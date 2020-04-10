//
//  UIViewController+Loading.h
//  Opener
//
//  Created by Tim Johnsen on 4/12/15.
//  Copyright (c) 2015 tijo. All rights reserved.
//

@import UIKit;

@interface UIViewController (Loading)

- (void)showLoadingIndicatorAfterDelayIfNotCancelled:(const NSTimeInterval)delay;
- (void)setLoadingIndicatorVisible:(BOOL)visible;

@end
