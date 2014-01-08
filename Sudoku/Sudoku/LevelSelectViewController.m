//
//  LevelSelectViewController.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "helpViewController.h"
#import "UserInfo.h"
#import "playGameViewController.h"


@implementation LevelSelectViewController


@synthesize levelScrollView;
//@synthesize allButtonArr;

@synthesize bigLevel;
@synthesize veryEasyBt, easyBt, normalBt, hardBt, veryHardBt, whatBt;
@synthesize hideLevelShow;
@synthesize smallOpenNum;

@synthesize pageController;
@synthesize waitAlert;


const int hideLevelNum = 27;	// 设置隐藏大关的小关个数...






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
				
		NSLog(@"........................initWithNibName");
		
		
		hideLevelShow = NO;
		
		// 显示等待标记
		waitAlert = [[UIAlertView alloc] initWithTitle:@"数据加载中,请等待..." 
											   message:nil 
											  delegate:self 
									 cancelButtonTitle:nil 
									 otherButtonTitles:nil];
		[waitAlert show];
		
		UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]
												  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicatorView.center = CGPointMake(waitAlert.bounds.size.width/2, waitAlert.bounds.size.height/2 + 8);
		[indicatorView startAnimating];
		
		[waitAlert addSubview:indicatorView];
		[indicatorView release];
		
		
    }
    return self;
	
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
	NSLog(@"didReceiveMemoryWarning...");
	
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad");
	
	
	userInfo = [NSUserDefaults standardUserDefaults];
	
	// 获取主要的信息:当前大关与大关下的小关开启个数...!!!
	
	// 获取大关...
	if ([userInfo objectForKey:@"bigLevel"] == nil) {
		
		bigLevel = 1;
		[userInfo setInteger:1 forKey:@"bigLevel"];
		
	}else {
		
		bigLevel = [userInfo integerForKey:@"bigLevel"];
		
	}
	
	if (bigLevel != 6) {
	
		pageController.numberOfPages = 11;
		
	}else {
		
		pageController.numberOfPages = 3;
		
	}
	
	
	/************************************/
	
	
	// 获取隐藏关是否开启...
	// 若未开启,则不可点击...!!!
	if ([userInfo objectForKey:@"hideLevel"] == nil) {
		
		// 隐藏关暂时设置为开......!!!
		hideLevelShow = NO;
		[userInfo setBool:NO forKey:@"hideLevel"];
		
	}else {
		
		hideLevelShow = [userInfo boolForKey:@"hideLevel"];
		
	}

	if (hideLevelShow == NO) {	// 隐藏关未开启...点击bt无效
		
		whatBt.userInteractionEnabled = NO;
		
	}else {						// 隐藏关已开启...点击bt有效
		
		whatBt.userInteractionEnabled = YES;
		
	}
	
	
	
	// 根据大关索引来设置当前大关下的所有小关信息...
	// 首先获得当前大关的前缀...1#Level
	// 然后获得当前大关下的小关开启个数...1#Level_openNum
	NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", bigLevel];
	//NSLog(@"当前大关下所有小关的开启个数的key:%@", smallNumStr);
	
	if ([userInfo objectForKey:smallNumStr] == nil) {
		
		//smallOpenNum = 3;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
		//[userInfo setInteger:3 forKey:smallNumStr];
		
		// 读取相应大关的小关数
		switch (bigLevel) {
			case 1:
				
				smallOpenNum = 99;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:99 forKey:smallNumStr];
				
				break;
			case 2:
				
				smallOpenNum = 6;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:6 forKey:smallNumStr];
				
				break;
			case 3:
				
				smallOpenNum = 3;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:3 forKey:smallNumStr];
				
				break;
			case 4:
				
				smallOpenNum = 2;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:2 forKey:smallNumStr];
				
				break;
			case 5:
				
				smallOpenNum = 1;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:1 forKey:smallNumStr];
				
				break;
			case 6:
				
				smallOpenNum = 9;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:9 forKey:smallNumStr];
				
				break;
			default:
				break;
		}
		
		
	}else {
		
		// 若已设置,则直接读取
		smallOpenNum = [userInfo integerForKey:smallNumStr];
		
	}
	
	
	[self checkAllBigLevelStatus];	// 每次均要判断是否可激活隐藏关 or 五大关...
	
	
	// 获取大关索引与小关个数over...
	
	
    // 只在第一次进入选择界面时才初始化所有的bt,从游戏界面返回时不再重新初始化...
    firstCome = YES;
    
	levelScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(6, 105, 306, 306)];
	[levelScrollView setContentSize:CGSizeMake(306*11, 306)];
	levelScrollView.delegate = self;
	levelScrollView.scrollEnabled = YES;
	levelScrollView.pagingEnabled = YES;
	levelScrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:levelScrollView];
		
	
	if (bigLevel == 6) {	// 若是一开始便进入隐藏关,则...
		[levelScrollView setContentSize:CGSizeMake(306*3, 306)];
	}
	
}



// 暂不用...
- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"viewWillAppear");
	
	
}



// 主要方法...
- (void)viewDidAppear:(BOOL)animated {
	
	NSLog(@"viewDidAppear");
	
	
	if (firstCome == YES) {
		
		NSLog(@"程序首次进入此界面时的初始化>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		
		
		// 初始化...!!!
		[self setBigLevelImg];	// 初始化各大关bt
		
		[self initLevelBt];		// 初始化各小关bt及显示信息
		
	}
	
	
	// 关键方法...!!!	
	[self setEverySmallLevel];	// 获取各小关信息
		
	// 隐藏提示...
	[waitAlert dismissWithClickedButtonIndex:0 animated:YES];
	//waitAlert = nil;
    
	firstCome = NO;
	
}



// 检查所有大关状态...开启的小关数
// 若有两个大关中所有的小关均已经通关,则6个大关全部开启...
- (void)checkAllBigLevelStatus {

	int bigCount = 0;
	
	for (int i = 1; i < 6; i++) {	// 遍历五大关...
		
		NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", i];
		
		if ([userInfo objectForKey:smallNumStr]) {	// 必须已设置...
			
			int levelCount = [userInfo integerForKey:smallNumStr];
			
			if (levelCount == 99) {
				
				bigCount++;
				//NSLog(@"第%d大关已全部打通<<<<<<<<<<<<<", i);
				
			}
			
		}
		
	}
	
	if (bigCount == 1) {		// 启动隐藏关
		
		[userInfo setBool:YES forKey:@"hideLevel"];
		
		hideLevelShow = YES;
		
		whatBt.userInteractionEnabled = YES;
		
	}else if (bigCount == 2) {	// 激活所有关...
		
		for (int i = 1; i < 6; i++) {	// 遍历五大关...所有关开启...!!!
			
			NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", i];
			
			[userInfo setInteger:99 forKey:smallNumStr];
			
		}
		
	}
	
	
}



// 根据大关索引设置对应的bt图片
- (void)setBigLevelImg {

	switch (bigLevel) {
			
		case 1:	
			
			// 极易
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
			
			break;
		case 2:
			
			// 容易
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2_1.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
			
			break;

		case 3:
			
			// 普通
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3_1.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
			
			break;

		case 4:
			
			// 困难
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4_1.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
			
			break;

		case 5:
			
			// 极难
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5_1.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
			break;
			
		case 6:
			
			// what
			[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
			[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
			[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
			[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
			[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
			[whatBt setImage:[UIImage imageNamed:@"gk_6_1.png"] forState:UIControlStateNormal];
			break;
			
		default:
			break;
			
	}
	
}



// 界面第一次加载时初始化各bt
- (void)initLevelBt {

	int n = 0;
	
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
			
			// 初始化bt
			UIButton *levelBt = [[UIButton alloc]initWithFrame:CGRectMake(2+306*i+(j%3)*101, 2+101*(j/3), 100, 100)];
			levelBt.tag = n;
			//[levelBt setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
			[levelBt addTarget:self action:@selector(selectLevelAction:) forControlEvents:UIControlEventTouchUpInside];
			//NSLog(@"button retainCount: %d...<1>", [levelBt retainCount]);		// retainCount = 1
			[levelScrollView addSubview:levelBt];
            //[levelBt release];
			//NSLog(@"button retainCount: %d...<2>", [levelBt retainCount]);		// retainCount = 2
			allButtonArr[i][j] = levelBt;
			//NSLog(@"button retainCount: %d...<3>", [levelBt retainCount]);		// retainCount = 2
			[levelBt release];
			//NSLog(@"button retainCount: %d...<4>", [levelBt retainCount]);		// retainCount = 1
			
			
			// 初始化小关编号
			UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, 38, 21)];
			
			//numLabel.text = tagNum;
			[numLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
			[numLabel setBackgroundColor:[UIColor clearColor]];
			[numLabel setTextColor:[UIColor whiteColor]];
			
			[levelBt addSubview:numLabel];
            //[numLabel release];
			allLabelNumArr[i][j] = numLabel;
			[numLabel release];
			
			
			// 初始化小关提示
			UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 2, 52, 21)];
			
			//showLabel.text = @"游戏中...";
			[showLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
			[showLabel setBackgroundColor:[UIColor clearColor]];
			//[showLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:showLabel];
            //[showLabel release];
			allLabel_PlayingArr[i][j] = showLabel;
			[showLabel release];
			
			
			// 初始化小关计时
			UILabel *passTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 20, 92, 18)];
			
			//passTimeLabel.text = @"已用时: 00.02.58";
			[passTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
			[passTimeLabel setBackgroundColor:[UIColor clearColor]];
			//[passTimeLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:passTimeLabel];
            //[passTimeLabel release];
			allLabel_TimeArr[i][j] = passTimeLabel;
			[passTimeLabel release];
			
			
			// 初始化最佳时长提示
			UILabel *bestTimeInfo = [[UILabel alloc]initWithFrame:CGRectMake(1, 38, 62, 18)];
			[bestTimeInfo setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[bestTimeInfo setBackgroundColor:[UIColor clearColor]];
			[levelBt addSubview:bestTimeInfo];
			allBestTimeInfoArr[i][j] = bestTimeInfo;
			[bestTimeInfo release];
			
			
			// 初始化小关第一高分:时间
			//UILabel *firstTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 44, 44, 18)];
			UILabel *firstTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 52, 44, 18)];
			
			//firstTimeLabel.text = @"00.05.28";
			[firstTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[firstTimeLabel setBackgroundColor:[UIColor clearColor]];
			//[passTimeLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:firstTimeLabel];
            //[firstTimeLabel release];
			allLabel_firstTime[i][j] = firstTimeLabel;
			[firstTimeLabel release];
			
			
			// 初始化小关第一高分:日期
			//UILabel *firstDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 44, 59, 18)];
			UILabel *firstDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 52, 59, 18)];
			
			//firstDateLabel.text = @"2012-02-16";
			[firstDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
			[firstDateLabel setBackgroundColor:[UIColor clearColor]];
			//[passTimeLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:firstDateLabel];
            //[firstDateLabel release];
			allLabel_firstDate[i][j] = firstDateLabel;
			[firstDateLabel release];
			
			
			// 初始化小关第二高分:时间
			//UILabel *secondTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 62, 44, 18)];
			UILabel *secondTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 66, 44, 18)];
			
			//secondTimeLabel.text = @"00.06.48";
			[secondTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[secondTimeLabel setBackgroundColor:[UIColor clearColor]];
			//[secondTimeLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:secondTimeLabel];
            //[secondTimeLabel release];
			allLabel_secondTime[i][j] = secondTimeLabel;
			[secondTimeLabel release];
			
			
			// 初始化小关第二高分:日期
			//UILabel *secondDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 62, 59, 18)];
			UILabel *secondDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 66, 59, 18)];
			
			//secondDateLabel.text = @"2012-02-14";
			[secondDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[secondDateLabel setBackgroundColor:[UIColor clearColor]];
			//[secondDateLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:secondDateLabel];
            //[secondDateLabel release];
			allLabel_secondDate[i][j] = secondDateLabel;
			[secondDateLabel release];
			
			
			// 初始化小关第三高分:时间
			//UILabel *thirdTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 80, 44, 18)];
			UILabel *thirdTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 80, 44, 18)];
			
			//thirdTimeLabel.text = @"00.08.25";
			[thirdTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[thirdTimeLabel setBackgroundColor:[UIColor clearColor]];
			//[thirdTimeLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:thirdTimeLabel];
            //[thirdTimeLabel release];
			allLabel_thirdTime[i][j] = thirdTimeLabel;
			[thirdTimeLabel release];
			
			
			// 初始化小关第三高分:日期
			//UILabel *thirdDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 80, 59, 18)];
			UILabel *thirdDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 80, 59, 18)];
			
			//thirdDateLabel.text = @"2012-02-12";
			[thirdDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
			[thirdDateLabel setBackgroundColor:[UIColor clearColor]];
			//[thirdDateLabel setTextColor:[UIColor whiteColor]];
			[levelBt addSubview:thirdDateLabel];
            //[thirdDateLabel release];
			allLabel_thirdDate[i][j] = thirdDateLabel;
			[thirdDateLabel release];
			
		}
		
	}
	
		
}




- (IBAction)setGameVeryEasy {

	if (bigLevel == 1) {
		return;
	}
	
	// 极易
	[veryEasyBt setImage:[UIImage imageNamed:@"gk_1_1.png"] forState:UIControlStateNormal];
	[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
	[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
	[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
	[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
	[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
	
	
	if (bigLevel == 6) {
		
		NSLog(@"从隐藏关返回到五大关......@@@");
		[self resettingLevelBtForAllFiveLevel];
		
	}
	
	
	// 设置大关...
	[userInfo setInteger:1 forKey:@"bigLevel"];
	bigLevel = 1;	
		
	[self setEverySmallLevel];
	
	// scrollView 直接滑动到当前大关下的最后开启的小关...
	int currentPageIndex = (smallOpenNum-1) / 9;
	CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}


- (IBAction)setGameEasy {

	if (bigLevel == 2) {
		return;
	}
	
	// 容易
	[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
	[easyBt setImage:[UIImage imageNamed:@"gk_2_1.png"] forState:UIControlStateNormal];
	[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
	[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
	[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
	[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
	
	
	if (bigLevel == 6) {
		
		NSLog(@"从隐藏关返回到五大关......@@@");
		[self resettingLevelBtForAllFiveLevel];
		
	}
	
	
	// 设置大关...
	[userInfo setInteger:2 forKey:@"bigLevel"];
	bigLevel = 2;

	[self setEverySmallLevel];
	
	// scrollView 直接滑动到当前大关下的最后开启的小关...
	int currentPageIndex = (smallOpenNum-1) / 9;
	CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}


- (IBAction)setGameNormal {

	if (bigLevel == 3) {
		return;
	}
	
	// 普通
	[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
	[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
	[normalBt setImage:[UIImage imageNamed:@"gk_3_1.png"] forState:UIControlStateNormal];
	[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
	[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
	[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
	
	
	if (bigLevel == 6) {
		
		NSLog(@"从隐藏关返回到五大关......@@@");
		[self resettingLevelBtForAllFiveLevel];
		
	}	
	
	// 设置大关...
	[userInfo setInteger:3 forKey:@"bigLevel"];
	bigLevel = 3;
	
	[self setEverySmallLevel];
	
	// scrollView 直接滑动到当前大关下的最后开启的小关...
	int currentPageIndex = (smallOpenNum-1) / 9;
	CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}


- (IBAction)setGameHard {

	if (bigLevel == 4) {
		return;
	}
	
	// 困难
	[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
	[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
	[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
	[hardBt setImage:[UIImage imageNamed:@"gk_4_1.png"] forState:UIControlStateNormal];
	[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
	[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
	
	
	if (bigLevel == 6) {
		
		NSLog(@"从隐藏关返回到五大关......@@@");
		[self resettingLevelBtForAllFiveLevel];
		
	}
	
	
	// 设置大关...
	[userInfo setInteger:4 forKey:@"bigLevel"];
	bigLevel = 4;
	
	[self setEverySmallLevel];
	
	// scrollView 直接滑动到当前大关下的最后开启的小关...
	int currentPageIndex = (smallOpenNum-1) / 9;
	CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}


- (IBAction)setGameVeryHard {

	if (bigLevel == 5) {
		return;
	}
	
	// 极难
	[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
	[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
	[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
	[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
	[veryHardBt setImage:[UIImage imageNamed:@"gk_5_1.png"] forState:UIControlStateNormal];
	[whatBt setImage:[UIImage imageNamed:@"gk_6.png"] forState:UIControlStateNormal];
	
	if (bigLevel == 6) {
		
		NSLog(@"从隐藏关返回到五大关......@@@");
		[self resettingLevelBtForAllFiveLevel];
		
	}
	
	// 设置大关...
	[userInfo setInteger:5 forKey:@"bigLevel"];
	bigLevel = 5;
	
	[self setEverySmallLevel];
	
	// scrollView 直接滑动到当前大关下的最后开启的小关...
	int currentPageIndex = (smallOpenNum-1) / 9;
	CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}


// 隐藏关...
- (IBAction)setGameWhat {

	NSLog(@"点击隐藏关...!!!");
	
	if (hideLevelShow == YES) {
		
		if (bigLevel == 6) {
			return;
		}
		
		// what
		[veryEasyBt setImage:[UIImage imageNamed:@"gk_1.png"] forState:UIControlStateNormal];
		[easyBt setImage:[UIImage imageNamed:@"gk_2.png"] forState:UIControlStateNormal];
		[normalBt setImage:[UIImage imageNamed:@"gk_3.png"] forState:UIControlStateNormal];
		[hardBt setImage:[UIImage imageNamed:@"gk_4.png"] forState:UIControlStateNormal];
		[veryHardBt setImage:[UIImage imageNamed:@"gk_5.png"] forState:UIControlStateNormal];
		[whatBt setImage:[UIImage imageNamed:@"gk_6_1.png"] forState:UIControlStateNormal];

		// 设置大关...
		[userInfo setInteger:6 forKey:@"bigLevel"];
		bigLevel = 6;
		
		// 当前大关为隐藏关时,scrollview减短
		[levelScrollView setContentSize:CGSizeMake(306*3, 306)];
		pageController.numberOfPages = 3;
		
		// 设置对应的小关...
		NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", bigLevel];
		if ([userInfo objectForKey:smallNumStr] == nil) {
			
			smallOpenNum = 9;
			[userInfo setInteger:9 forKey:smallNumStr];
			
		}else {
			
			smallOpenNum = [userInfo integerForKey:smallNumStr];
			
		}
		
		//NSLog(@"当前大关索引＝%d, 开启的小关数＝%d", bigLevel, smallOpenNum);
		
		
		// scrollView 直接滑动到当前大关下的最后开启的小关...
		int currentPageIndex = (smallOpenNum-1) / 9;
		CGRect currentRect;
		currentRect = levelScrollView.frame;
		currentRect.origin.x = currentRect.origin.x + currentPageIndex * currentRect.size.width - 6;
		[levelScrollView scrollRectToVisible:currentRect animated:YES];
		
		[self selectHideLevel];		// 设置bt...!!!
		
	}else {
		
		// 若隐藏关未开启,则点击无效...
		
	}
	
}




// 删除当前所有小关bt,并重新初始化...
- (void)resettingLevelBtForAllFiveLevel {

	
	for (int i = 1; i <= 99; i++) {
		
		UIButton *levelBt = (UIButton *)[self.view viewWithTag:i];
		[levelBt removeFromSuperview];
		levelBt = nil;
		
	}
	
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			allLabelNumArr[i][j] = nil;
			
			allLabel_PlayingArr[i][j] = nil;
			
			allLabel_TimeArr[i][j] = nil;
			
			allBestTimeInfoArr[i][j] = nil;
			
			allLabel_firstTime[i][j] = nil;
			
			allLabel_firstDate[i][j] = nil;
			
			allLabel_secondTime[i][j] = nil;
			
			allLabel_secondDate[i][j] = nil;
			
			allLabel_thirdTime[i][j] = nil;
			
			allLabel_thirdDate[i][j] = nil;
			
			allButtonArr[i][j] = nil;
			
		}
		
	}
	
	// 当前大关不为隐藏关时,scrollview的内容长度要恢复
	[levelScrollView setContentSize:CGSizeMake(306*11, 306)];
	pageController.numberOfPages = 11;
	
	[self initLevelBt];		// 初始化各小关bt及显示信息
	
	
}




// 根据当前大关索引,以及当前大关下的小关开启数,设置各小关信息ui
- (void)setEverySmallLevel {

	
	// 若是隐藏关,则直接退出,返回到隐藏关的方法...
	if (bigLevel == 6) {
		
		[self selectHideLevel];
		return;
		
	}
	
	
	// 以下方法适用于前五大关...
		
	
	// 设置对应的小关...
	NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", bigLevel];
	if ([userInfo objectForKey:smallNumStr] == nil) {
		
		//smallOpenNum = 3;
		//[userInfo setInteger:3 forKey:smallNumStr];
		
		// 读取相应大关的小关数
		switch (bigLevel) {
			case 1:
				
				smallOpenNum = 99;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:99 forKey:smallNumStr];
				
				break;
			case 2:
				
				smallOpenNum = 6;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:6 forKey:smallNumStr];
				
				break;
			case 3:
				
				smallOpenNum = 3;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:3 forKey:smallNumStr];
				
				break;
			case 4:
				
				smallOpenNum = 2;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:2 forKey:smallNumStr];
				
				break;
			case 5:
				
				smallOpenNum = 1;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:1 forKey:smallNumStr];
				
				break;
			case 6:
				
				smallOpenNum = 9;	// 若是首先进入 or 没有通过一次关, 则启用默认设置, 只开放3关, 并保存设置
				[userInfo setInteger:9 forKey:smallNumStr];
				
				break;
			default:
				break;
		}
		
		
	}else {
		
		smallOpenNum = [userInfo integerForKey:smallNumStr];
		
	}
	
	//NSLog(@"当前大关索引＝%d, 开启的小关数＝%d", bigLevel, smallOpenNum);
	
	
	NSString *bigPrefix = [NSString stringWithFormat:@"%d#Level", bigLevel];
	
	int n = 0;
	
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
			
			NSString *tagNum;	// 当前遍历到的编号
			if (n < 10) {
				tagNum = [NSString stringWithFormat:@"%d-00%d", bigLevel, n];
			}else {
				tagNum = [NSString stringWithFormat:@"%d-0%d", bigLevel, n];
			}
			
			if (n <= smallOpenNum) {	// 只开前 smallOpenNum 关
				
				// 所有打开的关卡均要显示相关信息
				
				// 1.
				UIButton *currentBt = allButtonArr[i][j];
				
				//NSLog(@"<1....................>当前bt的引用计数为:%d.......", [currentBt retainCount]);
				//while ([currentBt retainCount] > 1) {
				//	[currentBt release];
				//}
				//NSLog(@"<2....................>当前bt的引用计数为:%d.......", [currentBt retainCount]);
				
				// Program received signal:  “EXC_BAD_ACCESS”..........
				[currentBt setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
				[currentBt setImage:[UIImage imageNamed:@"unlock_1.png"] forState:UIControlStateHighlighted];
				currentBt.userInteractionEnabled = YES;
				
				// 2. 直接显示
				UILabel *numLb = allLabelNumArr[i][j];
				numLb.text = tagNum;
				numLb.font = [UIFont boldSystemFontOfSize:12];
				
				// 3. 需读取数据...
				UILabel *showLb = allLabel_PlayingArr[i][j];
				showLb.font = [UIFont boldSystemFontOfSize:11];
				
				UILabel *passTimeLb = allLabel_TimeArr[i][j];
				passTimeLb.font = [UIFont boldSystemFontOfSize:11];
				
				NSString *statusStr = [NSString stringWithFormat:@"%@_%d_playing", bigPrefix, n];
				//NSLog(@"当前小关游戏状态key:%@", statusStr);
				
				if ([userInfo objectForKey:statusStr] == nil) {			// 没有设置
					
					
					showLb.text = @"";					
					passTimeLb.text = @"";
					
					[userInfo setBool:NO forKey:statusStr];
					
				}else {													// 已设置
					
					if ([userInfo boolForKey:statusStr] == NO) {			// 没有开始游戏
						
						showLb.text = @"";
						passTimeLb.text = @"";
						
					}else {													// 游戏进行中...
						
						showLb.text = @"游戏中...";
						
						NSString *passTimeStr = [NSString stringWithFormat:@"%@_%d_timePassed", bigPrefix, n];
						//NSLog(@"当前小关游戏已用时key:%@", passTimeStr);
						
						if ([userInfo objectForKey:passTimeStr] == nil) {
							
							passTimeLb.text = @"";
							
						}else {
							
							int timeCount = (int)[userInfo integerForKey:passTimeStr];
							//NSLog(@"总的用时为<%d>秒...", timeCount);
							NSString *timeStr = [NSString stringWithString:@"已用时:  "];
							[self showTimeCountInfo:timeCount forTimeString:&timeStr];
							passTimeLb.text = timeStr;
							//NSLog(@">>>>>>>>>>>>>>>当前关已用时:%@", timeStr);
							
						}

					}

				}	// 游戏正在进行中...

				
				// 4.
				
				UILabel *bestTimeInfoLb = allBestTimeInfoArr[i][j];
				bestTimeInfoLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *firstTimeLb = allLabel_firstTime[i][j];
				firstTimeLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *firstDateLb = allLabel_firstDate[i][j];
				firstDateLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *secondTimeLb = allLabel_secondTime[i][j];
				secondTimeLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *secondDateLb = allLabel_secondDate[i][j];
				secondDateLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *thirdTimeLb = allLabel_thirdTime[i][j];
				thirdTimeLb.font = [UIFont boldSystemFontOfSize:10];
				
				UILabel *thirdDateLb = allLabel_thirdDate[i][j];
				thirdDateLb.font = [UIFont boldSystemFontOfSize:10];
				
				
				NSString *firstTime = [NSString stringWithFormat:@"%@_%d_time1", bigPrefix, n];
				//NSLog(@"当前小关游戏第1时间:%@", firstTime);
				
				if ([userInfo objectForKey:firstTime] == nil) {	// 没有第1记录...
					
					// 如果第1时间没有设置,则其它均不用显示...
					
					bestTimeInfoLb.text = @"";
					firstTimeLb.text = @"";
					firstDateLb.text = @"";
					secondTimeLb.text = @"";
					secondDateLb.text = @"";
					thirdTimeLb.text = @"";
					thirdDateLb.text = @"";
					
				}else {											// 有第1记录...
					
					// 已设置
					
					bestTimeInfoLb.text = @"最佳时长:";
					
					NSString *firstDate = [NSString stringWithFormat:@"%@_%d_date1", bigPrefix, n];					
					firstDateLb.text = (NSString *)[userInfo stringForKey:firstDate];
					
					int firstT = [userInfo integerForKey:firstTime];
					NSString *firstStr = [NSString stringWithString:@""];
					[self showTimeCountInfo:firstT forTimeString:&firstStr];
					firstTimeLb.text = firstStr;
					
					/***********************************************/
					
					NSString *secondTime = [NSString stringWithFormat:@"%@_%d_time2", bigPrefix, n];
					NSString *secondDate = [NSString stringWithFormat:@"%@_%d_date2", bigPrefix, n];
					
					if ([userInfo objectForKey:secondTime] == nil) {	// 第2记录为空
						
						// 若第2时间未设置,则后面两个记录为空
						
						secondTimeLb.text = @"";
						secondDateLb.text = @"";
						thirdTimeLb.text = @"";
						thirdDateLb.text = @"";
						
					}else {												// 第2记录不为空 
						
						secondDateLb.text = (NSString *)[userInfo stringForKey:secondDate];
						
						int secondT = [userInfo integerForKey:secondTime];
						NSString *secondStr = [NSString stringWithString:@""];
						[self showTimeCountInfo:secondT forTimeString:&secondStr];
						secondTimeLb.text = secondStr;
						
						/**********************************************/
						
						NSString *thirdTime = [NSString stringWithFormat:@"%@_%d_time3", bigPrefix, n];
						NSString *thirdDate = [NSString stringWithFormat:@"%@_%d_date3", bigPrefix, n];
						
						if ([userInfo objectForKey:thirdTime] == nil) {	// 第3记录为空
							
							thirdTimeLb.text = @"";
							thirdDateLb.text = @"";
							
						}else {											// 第3记录不为空
							
							thirdDateLb.text = (NSString *)[userInfo stringForKey:thirdDate];
							
							int thirdT = [userInfo integerForKey:thirdTime];
							NSString *thirdStr = [NSString stringWithString:@""];
							[self showTimeCountInfo:thirdT forTimeString:&thirdStr];
							thirdTimeLb.text = thirdStr;
							
							
						}	// 第3时间存在...

						
					}	// 第2时间存在...

					
				}	// 第1时间存在...

				
			}else {						// 后面的关卡不开
				
				// 所有未打开的关卡均不显示信息
				
				UIButton *currentBt = allButtonArr[i][j];
				[currentBt setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
				currentBt.userInteractionEnabled = NO;
				
				UILabel *numLb = allLabelNumArr[i][j];
				numLb.text = tagNum;
				
				UILabel *showLb = allLabel_PlayingArr[i][j];
				showLb.text = @"";
				
				UILabel *passTimeLb = allLabel_TimeArr[i][j];
				passTimeLb.text = @"";
				
				UILabel *bestTimeInfoLb = allBestTimeInfoArr[i][j];
				bestTimeInfoLb.text = @"";
				
				UILabel *firstTimeLb = allLabel_firstTime[i][j];
				firstTimeLb.text = @"";
				
				UILabel *firstDateLb = allLabel_firstDate[i][j];
				firstDateLb.text = @"";
				
				UILabel *secondTimeLb = allLabel_secondTime[i][j];
				secondTimeLb.text = @"";
				
				UILabel *secondDateLb = allLabel_secondDate[i][j];
				secondDateLb.text = @"";
				
				UILabel *thirdTimeLb = allLabel_thirdTime[i][j];
				thirdTimeLb.text = @"";
				
				UILabel *thirdDateLb = allLabel_thirdDate[i][j];
				thirdDateLb.text = @"";
				
			}	// 后面的关卡未打开...
			
			
		}	// for
		
	}	// for
	
	
	// 循环完成后...
	
	
}




// 产生计时字段...
- (void)showTimeCountInfo:(int)currentCount forTimeString:(NSString **)timeStr{

	
	int hours = currentCount / 3600;
	int minutes = currentCount / 60;
	int seconds = currentCount % 60;
	
	//NSLog(@"<%d,%d,%d>", hours, minutes, seconds);
	
	if (hours >= 10 && minutes >= 10 && seconds >= 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"%d:%d:%d",hours,minutes,seconds];
		
	}else if (hours >= 10 && minutes >= 10 && seconds < 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"%d:%d:0%d",hours,minutes,seconds];
		
	}else if (hours >= 10 && minutes < 10 && seconds < 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"%d:0%d:0%d",hours,minutes,seconds];
		
	}else if (hours >= 10 && minutes < 10 && seconds >= 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"%d:0%d:%d",hours,minutes,seconds];
		
	}else if (hours < 10 && minutes >= 10 && seconds >= 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"0%d:%d:%d",hours,minutes,seconds];
		
	}else if (hours < 10 && minutes >= 10 && seconds < 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"0%d:%d:0%d",hours,minutes,seconds];
		
	}else if (hours < 10 && minutes < 10 && seconds >= 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"0%d:0%d:%d",hours,minutes,seconds];
		
	}else if (hours < 10 && minutes < 10 && seconds < 10) {
		
		*timeStr = [(*timeStr) stringByAppendingFormat:@"0%d:0%d:0%d",hours,minutes,seconds];
		
	}
	
	
}




// 隐藏关bt点击后的处理
// 前掉是隐藏关已解锁...
- (void)selectHideLevel {
	
	
	NSString *bigPrefix = [NSString stringWithFormat:@"%d#Level", bigLevel];
	
	int n = 0;

	
	// 修改bt上的相关信息显示...
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
			
			NSString *tagNum;	// 当前遍历到的编号
			if (n < 10) {
				tagNum = [NSString stringWithFormat:@"%d-00%d", bigLevel, n];
			}else {
				tagNum = [NSString stringWithFormat:@"%d-0%d", bigLevel, n];
			}
			
			if (n <= hideLevelNum) {	// 隐藏关小于99...只显示有的隐藏关...27关...!!!
				
				if (n <= smallOpenNum) {	// 隐藏关已开启
					
					// 显示已开启的隐藏关信息...
					
					// 1. 关卡bt
					UIButton *currentBt = allButtonArr[i][j];
					[currentBt setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
					currentBt.userInteractionEnabled = YES;
					
					// 2. 直接显示编号
					UILabel *numLb = allLabelNumArr[i][j];
					numLb.text = tagNum;
					numLb.font = [UIFont boldSystemFontOfSize:12];
					
					// 3. 需读取数据
					UILabel *showLb = allLabel_PlayingArr[i][j];
					showLb.font = [UIFont boldSystemFontOfSize:11];
					
					UILabel *passTimeLb = allLabel_TimeArr[i][j];
					passTimeLb.font = [UIFont boldSystemFontOfSize:11];
					
					NSString *statusStr = [NSString stringWithFormat:@"%@_%d_playing", bigPrefix, n];
					//NSLog(@"当前小关游戏状态key:%@", statusStr);
					
					if ([userInfo objectForKey:statusStr] == nil) {			// 没有设置
						
						
						showLb.text = @"";					
						passTimeLb.text = @"";
						
						[userInfo setBool:NO forKey:statusStr];
						
					}else {													// 已设置
						
						if ([userInfo boolForKey:statusStr] == NO) {			// 没有开始游戏
							
							showLb.text = @"";
							passTimeLb.text = @"";
							
						}else {													// 游戏进行中...
							
							showLb.text = @"游戏中...";
							
							NSString *passTimeStr = [NSString stringWithFormat:@"%@_%d_timePassed", bigPrefix, n];
							//NSLog(@"当前小关游戏已用时key:%@", passTimeStr);
							
							if ([userInfo objectForKey:passTimeStr] == nil) {
								
								passTimeLb.text = @"";
								
							}else {
								
								//passTimeLb.text = (NSString *)[userInfo stringForKey:passTimeStr];
								
								int timeCount = (int)[userInfo integerForKey:passTimeStr];
								//NSLog(@"总的用时为<%d>秒...", timeCount);
								NSString *timeStr = [NSString stringWithString:@"已用时:  "];
								[self showTimeCountInfo:timeCount forTimeString:&timeStr];
								passTimeLb.text = timeStr;
								
							}
							
						}
						
					}
					
					
					// 4.
					
					UILabel *bestTimeInfoLb = allBestTimeInfoArr[i][j];
					bestTimeInfoLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *firstTimeLb = allLabel_firstTime[i][j];
					firstTimeLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *firstDateLb = allLabel_firstDate[i][j];
					firstDateLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *secondTimeLb = allLabel_secondTime[i][j];
					secondTimeLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *secondDateLb = allLabel_secondDate[i][j];
					secondDateLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *thirdTimeLb = allLabel_thirdTime[i][j];
					thirdTimeLb.font = [UIFont boldSystemFontOfSize:10];
					
					UILabel *thirdDateLb = allLabel_thirdDate[i][j];
					thirdDateLb.font = [UIFont boldSystemFontOfSize:10];
					
					
					NSString *firstTime = [NSString stringWithFormat:@"%@_%d_time1", bigPrefix, n];
					//NSLog(@"当前小关游戏第1时间:%@", firstTime);
					
					if ([userInfo objectForKey:firstTime] == nil) {
						
						// 如果第1时间没有设置,则其它均不用显示...
						
						bestTimeInfoLb.text = @"";
						firstTimeLb.text = @"";
						firstDateLb.text = @"";
						secondTimeLb.text = @"";
						secondDateLb.text = @"";
						thirdTimeLb.text = @"";
						thirdDateLb.text = @"";
						
					}else {
						
						// 已设置
						
						bestTimeInfoLb.text = @"最佳时长:";
						
						NSString *firstDate = [NSString stringWithFormat:@"%@_%d_date1", bigPrefix, n];
						
						//firstTimeLb.text = (NSString *)[userInfo stringForKey:firstTime];
						firstDateLb.text = (NSString *)[userInfo stringForKey:firstDate];
						
						int firstT = [userInfo integerForKey:firstTime];
						NSString *firstStr = [NSString stringWithString:@""];
						[self showTimeCountInfo:firstT forTimeString:&firstStr];
						firstTimeLb.text = firstStr;
						
						/***********************************************/
						
						NSString *secondTime = [NSString stringWithFormat:@"%@_%d_time2", bigPrefix, n];
						NSString *secondDate = [NSString stringWithFormat:@"%@_%d_date2", bigPrefix, n];
						
						if ([userInfo objectForKey:secondTime] == nil) {	
							
							// 若第2时间未设置,则后面两个记录为空
							
							secondTimeLb.text = @"";
							secondDateLb.text = @"";
							thirdTimeLb.text = @"";
							thirdDateLb.text = @"";
							
						}else {
							
							//secondTimeLb.text = (NSString *)[userInfo stringForKey:secondTime];
							secondDateLb.text = (NSString *)[userInfo stringForKey:secondDate];
							
							int secondT = [userInfo integerForKey:secondTime];
							NSString *secondStr = [NSString stringWithString:@""];
							[self showTimeCountInfo:secondT forTimeString:&secondStr];
							secondTimeLb.text = secondStr;
							
							/**********************************************/
							
							NSString *thirdTime = [NSString stringWithFormat:@"%@_%d_time3", bigPrefix, n];
							NSString *thirdDate = [NSString stringWithFormat:@"%@_%d_date3", bigPrefix, n];
							
							if ([userInfo objectForKey:thirdTime] == nil) {
								
								thirdTimeLb.text = @"";
								thirdDateLb.text = @"";
								
							}else {
								
								//thirdTimeLb.text = (NSString *)[userInfo stringForKey:thirdTime];
								thirdDateLb.text = (NSString *)[userInfo stringForKey:thirdDate];
								
								int thirdT = [userInfo integerForKey:thirdTime];
								NSString *thirdStr = [NSString stringWithString:@""];
								[self showTimeCountInfo:thirdT forTimeString:&thirdStr];
								thirdTimeLb.text = thirdStr;
								
							}	// 第3时间存在...
							
							
						}	// 第2时间存在...
						
						
					}	// 第1时间存在...
					
					
				}else {						// 隐藏关未开启
					
					// 所有未打开的关卡均不显示信息
					
					UIButton *currentBt = allButtonArr[i][j];
					[currentBt setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
					currentBt.userInteractionEnabled = NO;
					
					UILabel *numLb = allLabelNumArr[i][j];
					numLb.text = tagNum;
					
					UILabel *showLb = allLabel_PlayingArr[i][j];
					showLb.text = @"";
					
					UILabel *passTimeLb = allLabel_TimeArr[i][j];
					passTimeLb.text = @"";
					
					UILabel *bestTimeInfoLb = allBestTimeInfoArr[i][j];
					bestTimeInfoLb.text = @"";
					
					UILabel *firstTimeLb = allLabel_firstTime[i][j];
					firstTimeLb.text = @"";
					
					UILabel *firstDateLb = allLabel_firstDate[i][j];
					firstDateLb.text = @"";
					
					UILabel *secondTimeLb = allLabel_secondTime[i][j];
					secondTimeLb.text = @"";
					
					UILabel *secondDateLb = allLabel_secondDate[i][j];
					secondDateLb.text = @"";
					
					UILabel *thirdTimeLb = allLabel_thirdTime[i][j];
					thirdTimeLb.text = @"";
					
					UILabel *thirdDateLb = allLabel_thirdDate[i][j];
					thirdDateLb.text = @"";
					
				}
				
			}else {
				
				UIButton *currentBt = allButtonArr[i][j];
				currentBt.userInteractionEnabled = NO;
				currentBt.hidden = YES;
				
				// 后面的bt隐藏...但scrollview要变短,且页数要减
				
				
			}
			
		}
		
	}	// for... 
	
	
}




// 点击小关后的回调方法...
- (void)selectLevelAction:sender {

	UIButton *selectBt = (UIButton *)sender;
	//NSLog(@"选择小关:%d", selectBt.tag);
    
	playGameViewController *playGame = [[playGameViewController alloc]initWithNibName:@"playGameViewController" bundle:nil];
	playGame.bigLevel = bigLevel;			// 当前大关索引
	playGame.smallLevel = selectBt.tag;		// 选中的小关索引
	playGame.allSmallLevel = smallOpenNum;	// 小关激活总数
	//NSLog(@"当前玩家选择的关卡为:<%d, %d>", playGame.bigLevel, playGame.smallLevel);
	[self presentModalViewController:playGame animated:YES];
	[playGame release];
	
}





// 翻页停止后,重新设置pageControll的当前页数
// 已改进...
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
	CGFloat pageWidth = levelScrollView.frame.size.width;
	//int page = floor((levelScrollView.contentOffset.x - pageWidth) / pageWidth) + 1;
	//pageController.currentPage = page;
    
    //int currentPage = (int)(levelScrollView.contentOffset.x / pageWidth);
    int currentPage = pageController.currentPage;
    float realOffset = (float)(levelScrollView.contentOffset.x / pageWidth);
    float resultNum = fabs(realOffset - currentPage);
    
    if (resultNum > 0.5) {
        
        //NSLog(@"截断后的整数=%d, 实际小数=%f", currentPage, realOffset);
        //NSLog(@"差值=%f", resultNum);
        pageController.currentPage = (int)(floor((levelScrollView.contentOffset.x - pageWidth) / pageWidth) + 1);
        
    }
    
}




// pageControll的回调方法,重新设置scrollview
- (IBAction)changePage {
    
    // pageControll 控制有问题...待改进...!!!
    
    int page = pageController.currentPage;
    CGRect currentRect;
    currentRect = levelScrollView.frame;
    currentRect.origin.x = currentRect.origin.x + page * currentRect.size.width;
    [levelScrollView scrollRectToVisible:currentRect animated:YES];
	
}



/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];
    CGPoint beginTouch;
	beginTouch = [touch locationInView: self.pageController];
	
    NSLog(@">>>>>>>>>>>>>>>beginTouch.x=%f, beginTouch.y=%f", beginTouch.x, beginTouch.y);
    
	if (beginTouch.x > 0 && beginTouch.x < 258) {
		
		beginPoint.x = beginTouch.x;		// 在小棋盘上的x坐标
		beginPoint.y = beginTouch.y;		// 在小棋盘上的y坐标
		//NSLog(@">>>>>>>>>>>>>>>beginTouch.x=%f, beginTouch.y=%f", beginTouch.x, beginTouch.y);
		
	}
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint endTouch;
	endTouch = [touch locationInView: self.pageController];
    
    NSLog(@">>>>>>>>>>>>>>>endTouch.x=%f, endTouch.y=%f", endTouch.x, endTouch.y);
    
    if (endTouch.x > 0 && endTouch.x < 258) {
		
		endPoint.x = endTouch.x;		// 在小棋盘上的x坐标
		endPoint.y = endTouch.y;		// 在小棋盘上的y坐标
		//NSLog(@">>>>>>>>>>>>>>>endTouch.x=%f, endTouch.y=%f", endTouch.x, endTouch.y);
		
        resultValue = endPoint.x - beginPoint.x;
        
	}else {
    
        resultValue = 0;
        
    }
    
}
*/



- (IBAction)backHome {
    
    [self dismissModalViewControllerAnimated:YES];
    
}



- (IBAction)HelpView {

    helpViewController *help = [[helpViewController alloc]initWithNibName:@"helpViewController" bundle:nil];
    
	[help setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentModalViewController:help animated:YES];
    
    [help release];
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	// 系统每调用一次此方法 viewDidUnload, 则需要重新加载一次 viewDidLoad
	
	// It is called during low-memory conditions 
	// when the view controller needs to release its view and any objects associated with that view to free up memory.
	NSLog(@"viewDidUnload......< Release any retained subviews of the main view >");
	
}



- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"viewWillDisappear");
	
}


- (void)viewDidDisappear:(BOOL)animated {
	
	NSLog(@"viewDidDisappear");
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }else {
        return  NO;
    }
    
}



- (void)dealloc {
    
	
	/*
	// 释放所有代码生成的控件...
	// 去掉此方法后再测内存使用情况...!!!
	
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			// 释放所有bt、lb...
			
			UILabel *numLb = (UILabel *)allLabelNumArr[i][j];
            numLb = nil;
            [numLb release];
			
			UILabel *playingLb = (UILabel *)allLabel_PlayingArr[i][j];
            playingLb = nil;
            [playingLb release];
			
			UILabel *passTimeLb = (UILabel *)allLabel_TimeArr[i][j];
            passTimeLb = nil;
			[passTimeLb release];
            
			UILabel *firstTime = (UILabel *)allLabel_firstTime[i][j];
            firstTime = nil;
			[firstTime release];
            
			UILabel *firstDate = (UILabel *)allLabel_firstDate[i][j];
            firstDate = nil;
			[firstDate release];
            
			UILabel *secondTime = (UILabel *)allLabel_secondTime[i][j];
            secondTime = nil;
			[secondTime release];
            
			UILabel *secondDate = (UILabel *)allLabel_secondDate[i][j];
            secondDate = nil;
			[secondDate release];
            
			UILabel *thirdTime = (UILabel *)allLabel_thirdTime[i][j];
            thirdTime = nil;
			[thirdTime release];
            
			UILabel *thirdDate = (UILabel *)allLabel_thirdDate[i][j];
            thirdDate = nil;
			[thirdDate release];
			
			
			UIButton *myButton = (UIButton *)allButtonArr[i][j];
			//NSLog(@"<1>当前bt的引用计数为:%d", [myButton retainCount]);
			myButton = nil;
			[myButton release];
			//NSLog(@"<2>当前bt的引用计数为:%d", [myButton retainCount]);
            
		}
		
	}
    */
	
   
	for (int i = 1; i < 100; i++) {
		
		UIButton *levelBt = (UIButton *)[self.view viewWithTag:i];
		[levelBt removeFromSuperview];
		levelBt = nil;
		
	}
    	
	for (int i = 0; i < 11; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			allButtonArr[i][j] = nil;
			allLabelNumArr[i][j] = nil;
			allLabel_PlayingArr[i][j] = nil;
			allLabel_TimeArr[i][j] = nil;
			allBestTimeInfoArr[i][j] = nil;
			allLabel_firstTime[i][j] = nil;
			allLabel_firstDate[i][j] = nil;
			allLabel_secondTime[i][j] = nil;
			allLabel_secondDate[i][j] = nil;
			allLabel_thirdTime[i][j] = nil;
			allLabel_thirdDate[i][j] = nil;
			
		}
		
	}
	
	
	[veryEasyBt release];
	veryEasyBt = nil;
	
	[easyBt release];
	easyBt = nil;
	
	[normalBt release];
	normalBt = nil;
	
	[hardBt release];
	hardBt = nil;
	
	[veryHardBt release];
	veryHardBt = nil;
	
	[whatBt release];
	whatBt = nil;
	
	[pageController release];
    pageController = nil;
	
	[waitAlert release];
	waitAlert = nil;
    
	[levelScrollView release];
	levelScrollView = nil;
	
	[super dealloc];
	
	NSLog(@"dealloc");
	
}



@end
