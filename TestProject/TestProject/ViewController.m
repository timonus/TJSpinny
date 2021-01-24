//
//  ViewController.m
//  TestProject
//
//  Created by Tim Johnsen on 1/8/21.
//

#import "ViewController.h"
#import "UIViewController+Loading.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL showing;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20.0, self.view.bounds.size.height - self.view.safeAreaInsets.bottom - 80.0, self.view.bounds.size.width - 40.0, 60.0)];
    button.layer.cornerRadius = 8.0;
    button.layer.borderColor = [[UIColor systemBlueColor] CGColor];
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor systemBlueColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Spinny" forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:button];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"Light", @"Dark"]];
    control.selectedSegmentIndex = (self.view.window.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
    [control sizeToFit];
    control.frame = CGRectMake(20.0, button.frame.origin.y - 20.0 - control.bounds.size.height, self.view.bounds.size.width - 40.0, control.bounds.size.height);
    [control addTarget:self action:@selector(controlChanged:) forControlEvents:UIControlEventValueChanged];
    control.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:control];
}

- (void)buttonTapped:(UIButton *)button
{
    self.showing = !self.showing;
    [self setLoadingIndicatorVisible:self.showing];
    if (self.showing) {
        [button setTitle:@"Hide Spinny" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"Show Spinny" forState:UIControlStateNormal];
    }
}

- (void)controlChanged:(UISegmentedControl *)control
{
    self.view.overrideUserInterfaceStyle = control.selectedSegmentIndex == 0 ? UIUserInterfaceStyleLight : UIUserInterfaceStyleDark;
}

@end
