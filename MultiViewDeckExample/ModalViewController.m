//
//  ModalViewController.m
//  MultiViewDeckExample
//
//  Created by Tom Adriaenssen on 10/05/12.
//  Copyright (c) 2012 Tom Adriaenssen. All rights reserved.
//

#import "ModalViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"

#import "LeftViewController.h"
#import "CenterViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	double delayInSeconds = 0.1;// self.isReloginAttempt ? 0.0 : 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
		[self navigateToViewController];
	});

}

// Just internal convenience method.
+ (IIViewDeckController *)rootViewDeckController {
	return (IIViewDeckController *)[((AppDelegate *)[[UIApplication sharedApplication] delegate]) window].rootViewController;
}

- (void)navigateToViewController {
	[self pushInitialController:[self centerController]];
	[ModalViewController rootViewDeckController].leftController = [self leftController];
	[ModalViewController rootViewDeckController].leftSize = 320.f;
	[self refreshLeftMenu];
}

- (void)pushInitialController:(UIViewController *)controller {
	UINavigationController *navigationVC = (UINavigationController *)[[ModalViewController rootViewDeckController] centerController];
	[navigationVC setViewControllers:@[controller]];
	[[ModalViewController rootViewDeckController] closeLeftViewAnimated:NO];
	[[ModalViewController rootViewDeckController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshLeftMenu {
	[[ModalViewController rootViewDeckController] openLeftViewAnimated:NO completion:^(IIViewDeckController *controller, BOOL success) {
		[controller closeLeftViewAnimated:NO];
	}];
}

- (UIViewController *)leftController {
	return [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
}

- (UIViewController *)centerController {
	return [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
}

@end
