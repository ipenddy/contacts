//
//  AppDelegate.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <UIKit/UIKit.h>
#import "ContactItem.h"
#import "ContactsStore.h"
#import "ContactTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    // 设置主界面中的两个Tab
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    

    ContactsTableViewController *contactsTableViewController = [[ContactsTableViewController alloc]init];
    UINavigationController *contactsNav = [[UINavigationController alloc]initWithRootViewController:contactsTableViewController];
    
    UITabBarItem * contactsTabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    contactsNav.tabBarItem = contactsTabBarItem;
    contactsTableViewController.navigationItem.title = @"通讯录";
    
    
    StaredContactsTableViewController *staredTableViewController = [[StaredContactsTableViewController alloc]init];
    UINavigationController *staredNav = [[UINavigationController alloc]initWithRootViewController:staredTableViewController];
    
    UITabBarItem * staredTabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    staredTableViewController.tabBarItem = staredTabBarItem;
    staredTableViewController.navigationItem.title = @"收藏";
    
    tabBarController.viewControllers = @[contactsNav,staredNav];
    
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    NSString *identify = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    for(ContactItem *item in [ContactsStore sharedStore].allContactsArray )
    {
        if(item.ldap == identify){
            NSLog(@"the contact %@ is found!",identify);
            UIViewController * currentVC = [ContactTools getCurrentVC];
            ContactDetailViewController *cdvc = [[ContactDetailViewController alloc]init];
            cdvc.item =item;
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:cdvc];

            // selector传递的参数，用来传递需要关闭的view
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:nc forKey:@"detailView"];
            cdvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf:)];
            

            [currentVC.view addSubview:nc.view];
            return YES;
        }
    }
    NSLog(@"the contact %@ is not found!",identify);

    return YES;
}
- (void)closeSelf:(id)sender{

    UIViewController * currentVC = [ContactTools getCurrentVC];
    [currentVC dismissViewControllerAnimated:YES completion:nil];


//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
