//
//  AppDelegate.m
//  MultiViewDeckExample
//
//  Created by Tom Adriaenssen on 06/05/12.
//  Copyright (c) 2012 Tom Adriaenssen. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "MYNavigationDelegate.h"
//#import "LeftViewController.h"
//#import "BottomViewController.h"
//#import "CenterViewController.h"
#import "ModalViewController.h"
@interface AppDelegate ()

@property (strong, nonatomic) MYNavigationDelegate *navigationDelegate;
@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	Class navigationClass = [UINavigationController class];
	UINavigationController *navigationVC = [[navigationClass alloc] initWithNavigationBarClass:[UINavigationBar class]
																				  toolbarClass:nil];
	self.navigationDelegate = [[MYNavigationDelegate alloc] init];
	navigationVC.delegate = self.navigationDelegate;

	IIViewDeckController *viewDeckController =  [[IIViewDeckController alloc] initWithCenterViewController:navigationVC];
	viewDeckController.sizeMode = IIViewDeckViewSizeMode;
	viewDeckController.delegate = self.navigationDelegate;
	viewDeckController.elastic = NO;

	viewDeckController.panningCancelsTouchesInView = YES;
	viewDeckController.panningMode = IIViewDeckDelegatePanning;
	viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
	self.window.rootViewController = viewDeckController;

    
    [self.window makeKeyAndVisible];

	[self presentInitialScreen];
    return YES;
}

- (void)presentInitialScreen {
	ModalViewController *initialVC = [[ModalViewController alloc] init];

	UINavigationController *navigationVC = (UINavigationController *)[(IIViewDeckController *)self.window.rootViewController centerController];
	[navigationVC setViewControllers:@[]];
	UINavigationController *navigationVCC = [((UINavigationController *)[UINavigationController alloc]) initWithRootViewController:initialVC];
	navigationVCC.navigationBarHidden = YES;
	navigationVCC.delegate = self.navigationDelegate;
	[navigationVC presentViewController:navigationVCC
							   animated:NO
							 completion:nil];
}




@end
