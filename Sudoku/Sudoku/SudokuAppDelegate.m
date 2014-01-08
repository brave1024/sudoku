//
//  SudokuAppDelegate.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "SudokuViewController.h"

@implementation SudokuAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize musicIsOpen, soundIsOpen, showHelp;
@synthesize bigLevel, quickLevel, timeCount, quickNum;
@synthesize musicPlayer;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // 读取设置并做数据持久化
    [self initSetting];
    
    //[self initBackgoundMusic];
    
    return YES;
    
}



// 读取设置
- (void)initSetting {

    userInfo = [NSUserDefaults standardUserDefaults];
    
    // 读取音乐状态
    if ([userInfo objectForKey:@"music"] == nil) {  // 判断是否是第一次运行游戏...!!!
        musicIsOpen = YES;
        [userInfo setBool:YES forKey:@"music"];
        //NSLog(@"第一次运行,没有设置音乐...初次进入时默认设置音乐为开状态");
    }else {
        musicIsOpen = [userInfo boolForKey:@"music"];
        //NSLog(@"已设置音乐...");
    }
    
    // 读取音效状态
    if ([userInfo objectForKey:@"sound"] == nil) {
        soundIsOpen = YES;
        [userInfo setBool:YES forKey:@"sound"];
        //NSLog(@"第一次运行,没有设置音效...初次进入时默认设置音效为开状态");
    }else {
        soundIsOpen = [userInfo boolForKey:@"sound"];
        //NSLog(@"已设置音效...");
    }
    
	// 读取大关索引
    if ([userInfo objectForKey:@"bigLevel"] == nil) {
        bigLevel = 1;
        [userInfo setInteger:1 forKey:@"bigLevel"];
        //NSLog(@"第一次运行,没有设置大关号...初次进入时默认设置大关为1");
    }else {
        bigLevel = [userInfo integerForKey:@"bigLevel"];
        //NSLog(@"已设置大关索引...");
    }
	
	
    /*************************************************/
    
	
    // 读取提示状态
    if ([userInfo objectForKey:@"showHelp"] == nil) {
        showHelp = YES;
        [userInfo setBool:YES forKey:@"showHelp"];
        //NSLog(@"第一次运行,没有设置提示...初次进入时默认设置提示为关状态");
    }else {
        showHelp = [userInfo boolForKey:@"showHelp"];
        //NSLog(@"已设置提示...");
    }
    
    // 读取快速游戏时的游戏等级
    if ([userInfo objectForKey:@"quickLevel"] == nil) {
        quickLevel = 1;
        [userInfo setInteger:1 forKey:@"quickLevel"];
        //NSLog(@"第一次运行,没有设置等级...初次进入时默认设置游戏等级为2");
    }else {
        quickLevel = [userInfo integerForKey:@"quickLevel"];
        //NSLog(@"已设置等级...");
    }
    
    // 读取快速游戏时的时长
    if ([userInfo objectForKey:@"timeCount"] == nil) {
        timeCount = 10;
        [userInfo setInteger:10 forKey:@"timeCount"];
        //NSLog(@"第一次运行,没有设置游戏时长...初次进入时默认设置时长为10分钟");
    }else {
        timeCount = [userInfo integerForKey:@"timeCount"];
        //NSLog(@"已设置时长...");
    }
    
    // 读取快速游戏时的关卡个数
    if ([userInfo objectForKey:@"quickNum"] == nil) {
        quickNum = 2;
        [userInfo setInteger:2 forKey:@"quickNum"];
        //NSLog(@"第一次运行,没有设置关卡数...初次进入时默认设置关卡数为1");
    }else {
        quickNum = [userInfo integerForKey:@"quickNum"];
        //NSLog(@"已设置关卡数...");
    }
    
}


// 初始化背景音乐
- (void)initBackgoundMusic {
    
    NSString *paths = [[NSBundle mainBundle]resourcePath];
	NSString *audioFile = [paths stringByAppendingPathComponent:@"背景音乐.mp3"];
	NSURL *audioURL = [NSURL fileURLWithPath:audioFile];
	NSError *error;
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    
	if (!musicPlayer) {
        
		NSLog(@"no tickPlayer: %@", [error localizedDescription]);	
        
	}else {
    
        [musicPlayer prepareToPlay];
        [musicPlayer setNumberOfLoops:-1];
        
        if (musicIsOpen == YES) {
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(playMusic) userInfo:nil repeats:NO];
        }
        
    }
        
}


// 播放
- (void)playMusic {

    [musicPlayer play];
    
}

// 停止
- (void)stopMusic {
    
    [musicPlayer stop];

}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    // 保存数据...???
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    // 保存数据...!!!
    
    
    
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [musicPlayer release];
	musicPlayer = nil;
    [super dealloc];
}


@end



