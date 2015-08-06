//
//  SudokuAppDelegate.h
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UserInfo.h"


@class SudokuViewController;

@interface SudokuAppDelegate : NSObject <UIApplicationDelegate> {

    BOOL musicIsOpen;   // 音乐
	BOOL soundIsOpen;   // 音效
    int bigLevel;		// 大关索引
	
    BOOL showHelp;      // 提示
    int quickLevel;     // <快速游戏时的>等级
    int timeCount;      // <快速游戏时的>游戏时长
    int quickNum;       // <快速游戏时的>关卡数
    
	//int timeInt;	  //快速游戏选择时间的坐标
	//BOOL disBack;	  //游戏中，点击帮助时，时间要停止
    
    AVAudioPlayer *musicPlayer;
    
    // 游戏重启时需保存当前状态...!!!
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SudokuViewController *viewController;

@property BOOL musicIsOpen, soundIsOpen, showHelp;
@property int bigLevel, quickLevel, timeCount, quickNum;
@property (nonatomic, retain) AVAudioPlayer *musicPlayer;

- (void)initSetting;        // 读取设置
- (void)initBackgoundMusic; // 初始化背景音乐
- (void)playMusic;          //音乐播放
- (void)stopMusic;          //音乐停止

@end
