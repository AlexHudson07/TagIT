//
//  AppDelegate.m
//  TagIt
//
//  Created by Steven Sickler on 8/25/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"LGoKQau3KAIoHY3aH201WncmAp4uOoNhe7nyCkqx"clientKey:@"iEJmwbIor8EqyCvZ4Jqsyu6VWv0gNpUN0t1xcODV"];



    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
    {

        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            //save the installation
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
            // here we add a column to the installation table and store the current user’s ID
            // this way we can target specific users later

            // while we’re at it, this is a good place to reset our app’s badge count
            // you have to do this locally as well as on the parse server by updating
            // the PFInstallation object
            if (currentInstallation.badge != 0) {
                currentInstallation.badge = 0;
                [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        // Handle error here with an alert…
                    }
                    else {
                        // only update locally if the remote update succeeded so they always match
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                        NSLog(@"updated badge");
                    }
                }];
            }
        } else {
            
            [PFUser logOut];
            // show the signup screen here....
        }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)automaticLogin
{
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData:newDeviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@""];

}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Did fail to register for push, %@", error);
}
@end
