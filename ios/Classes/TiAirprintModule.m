/**
 * Ti.Airprint Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAirprintModule.h"
#import "TiBase.h"
#import "TiApp.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiAirprintModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"ebd45fea-93b5-4ab7-bb03-b6d462aab32f";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.airprint";
}


#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

- (BOOL)canPrint:(id)args
{
    return [UIPrintInteractionController isPrintingAvailable];
}

- (void)print:(id)args
{
	ENSURE_UI_THREAD(print,args);
	ENSURE_SINGLE_ARG(args,NSDictionary);

    NSURL* url = [TiUtils toURL:[args objectForKey:@"url"] proxy:self];
    if (url==nil) {
        NSLog(@"[ERROR] Print called without passing in a url property!");
        return;
    }

    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if (!controller) {
        NSLog(@"[ERROR] Unable to create a print interaction controller.");
        return;
    }

    controller.showsPageRange = [TiUtils boolValue:[args objectForKey:@"showsPageRange"] def:YES];
    controller.printingItem = url;

    BOOL* isMarkup = [TiUtils boolValue:[args objectForKey:@"isHtml"]];
    if (isMarkup) {
        NSLog(@"[INFO] Printing html string.");
        NSString* html = [args objectForKey:@"html"];
        controller.printingItem = nil;
        UIPrintFormatter *formatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:html];
        controller.printFormatter = formatter;
    }

    NSLog(@"[INFO] Printing out %@", url);

    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"[ERROR] Printing failed due to error in domain %@ with error code %u", error.domain, error.code);
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    };

    TiApp* tiApp = [TiApp app];
	if ([TiUtils isIPad]==NO)
	{
		[controller presentAnimated:YES completionHandler:completionHandler];
	}
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
	else
	{
		UIView* poView = [tiApp controller].view;
		TiViewProxy* popoverViewProxy = [args objectForKey:@"view"];
		if (popoverViewProxy!=nil)
		{
			poView = [popoverViewProxy view];
		}

        [controller presentFromRect:poView.bounds inView:poView animated:YES completionHandler:completionHandler];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePopover:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
	}
    #endif
}

-(void)updatePopover:(NSNotification *)notification;
{
	[[UIPrintInteractionController sharedPrintController] performSelector:@selector(dismissAnimated:)
                                                               withObject:NO
                                                               afterDelay:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]
                                                                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

@end
