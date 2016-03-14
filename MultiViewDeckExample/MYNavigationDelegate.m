#import "MYNavigationDelegate.h"

@implementation MYNavigationDelegate

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
	if (navigationController.viewControllers.count > 1) {
		viewController.navigationItem.hidesBackButton = NO;
		UIBarButtonItem *backBarButtonItem = [self configureBarButtonItemWithImageName:@"ic_navbar_btn_back"
																				target:navigationController
																				action:@selector(popViewControllerAnimated:)];
		viewController.navigationItem.leftBarButtonItem = backBarButtonItem;
	} else {
		viewController.navigationItem.hidesBackButton = YES;
		UIBarButtonItem *menuBarButtonItem = [self configureBarButtonItemWithImageName: @"ic_navbar_btn_menu"
																				target:viewController.viewDeckController
																				action:@selector(toggleLeftViewAnimated:)];
		viewController.navigationItem.leftBarButtonItem = menuBarButtonItem;
	}
}

#pragma mark - IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController *)viewDeckController
			   applyShadow:(CALayer *)shadowLayer
				withBounds:(CGRect)rect {
	shadowLayer.masksToBounds = NO;
	shadowLayer.shadowRadius = 5;
	shadowLayer.shadowOpacity = 0.5;
	shadowLayer.shadowColor = [[UIColor blackColor] CGColor];
	shadowLayer.shadowOffset = CGSizeZero;
	shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController
		  willOpenViewSide:(IIViewDeckSide)viewDeckSide
				  animated:(BOOL)animated {
	if (viewDeckSide == IIViewDeckLeftSide) {
		[viewDeckController.leftController.view setHidden:NO];
	} else if (viewDeckSide == IIViewDeckRightSide) {
		[viewDeckController.rightController.view setHidden:NO];
	}
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController
		  didCloseViewSide:(IIViewDeckSide)viewDeckSide
				  animated:(BOOL)animated {
	if (viewDeckSide == IIViewDeckLeftSide) {
		[viewDeckController.leftController.view setHidden:YES];
	} else if (viewDeckSide == IIViewDeckRightSide) {
		[viewDeckController.rightController.view setHidden:YES];
	}
}

- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController
		shouldOpenViewSide:(IIViewDeckSide)viewDeckSide {
	return viewDeckSide == IIViewDeckLeftSide;
}

- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController
				 shouldPan:(UIPanGestureRecognizer *)panGestureRecognizer {
	BOOL showLeft = ([panGestureRecognizer velocityInView:viewDeckController.centerController.view].x > 0);

	if ([viewDeckController isSideOpen:IIViewDeckRightSide] || ![viewDeckController isAnySideOpen]) {
		return showLeft;
	}
	return YES;
}

#pragma mark - Helper methods

- (UIBarButtonItem *)configureBarButtonItemWithImageName:(NSString *)imageName
												  target:(id)target
												  action:(SEL)action {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[button setContentMode:UIViewContentModeCenter];
	[button sizeToFit];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
