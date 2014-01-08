//
//  playGameViewController.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "playGameViewController.h"
#import "UserInfo.h"
#import "levelData.h"



@implementation playGameViewController

@synthesize levelImgview;
@synthesize selectView;
@synthesize nextLevelBt;
@synthesize doubleImg, singleImg;

@synthesize bigLevel, smallLevel, allSmallLevel;

@synthesize timeCount;
@synthesize emptyTagsArr;

@synthesize gameOver, isPlaying;

@synthesize gameFinished;
@synthesize overNum;

@synthesize appDelegate;
@synthesize soundIsOpen, helpIsOpen;

@synthesize hourImgview01, hourImgview02;
@synthesize minuteImgview01, minuteImgview02;
@synthesize secondImgview01, secondImgview02;

@synthesize infoView;
@synthesize infoImgview;

@synthesize gameOverView;



const int squareLine = 31;

int hours;
int minutes;
int seconds;

int btIndex;
int btNum;	// 当前空位中填的数字

int infoNum;

NSString *DateString;

//extern int *allLevel1[100];




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		emptyTagsArr = [[NSMutableArray alloc]init];	// 初始化空位数组 
		gameOver = NO;	// 默认游戏未结束
		overNum= 0;	// 默认当前小关游戏通关次数为0
		
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSLog(@"当前关卡为:%d...<%d, %d>", smallLevel, bigLevel, allSmallLevel);
	
	userInfo = [NSUserDefaults standardUserDefaults];
	
	appDelegate = [[UIApplication sharedApplication]delegate];
	soundIsOpen = appDelegate.soundIsOpen;	// 音效
	helpIsOpen = appDelegate.showHelp;		// 提示
	
	selectView.hidden = YES;	// 可选的填充数字栏隐藏
	
	// 如果当前小关数等于小关激活数,则下一关bt不可点击
	if (smallLevel == allSmallLevel) {
		nextLevelBt.userInteractionEnabled = NO;
		nextLevelBt.alpha = 0.5;
	}
	
	
	[infoView setFrame:CGRectMake(-320, 0, 320, 640)];
	[self.view addSubview:infoView];
	[infoImgview setFrame:CGRectMake(23, 129, 273, 257)];
	
	[gameOverView setFrame:CGRectMake(320, 0, 320, 640)];
	[self.view addSubview:gameOverView];
	
	
	// 只在首次进行游戏时调用...重新开始游戏时不调用此方法...
	[self initSomeProperty];	// 错...重新开始时也可调用此方法...!!!
	
	[self initBigLevelImg];
	
	[self initSmallLevelNum];
	
	[self initGameNumberLayout];
	
	[self initGameNumberBt];
	
	[self fixCoordinate];
	
	
}



// 视图出现时,开始计时...
- (void)viewDidAppear:(BOOL)animated {

	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];	
	
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




// 初始化一些相关的属性...
// 主要是判断当前小关是否已通关...
- (void)initSomeProperty {

	// 1#Level_1_time1
	NSString *timeFirstStr = [NSString stringWithFormat:@"%d#Level_%d_time1", bigLevel, smallLevel];
	
	if ([userInfo objectForKey:timeFirstStr] == nil) {	// 不存在第1记录,说明当前小关未通关
		
		gameFinished = NO;
		overNum = 0;
		NSLog(@"当前小关未通关...");
		
	}else {												// 存在第1记录,说明当前小关之前已通关
	
		gameFinished = YES;
		overNum = 2;
		NSLog(@"当前小关已通关...");
		
	}
	
	infoNum = 0;
	
}



// 初始化当前棋局的难度图片...
- (void)initBigLevelImg {

	switch (bigLevel) {
		case 1:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_1.png"]];
			
			break;
		case 2:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_2.png"]];
			
			break;
		case 3:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_3.png"]];
			
			break;
		case 4:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_4.png"]];
			
			break;
		case 5:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_5.png"]];
			
			break;
		case 6:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_6.png"]];
			
			break;
		default:
			break;
	}
	
	
}




// 初始化小关索引...
- (void)initSmallLevelNum {

	int doubleNum;
	int singleNum;
	
	doubleNum = smallLevel / 10;
	singleNum = smallLevel % 10;
	
	NSString *doubleStr = [NSString stringWithFormat:@"%d.png", doubleNum];
	NSString *singleStr = [NSString stringWithFormat:@"%d.png", singleNum];
	
	[doubleImg setImage:[UIImage imageNamed:doubleStr]];
	[singleImg setImage:[UIImage imageNamed:singleStr]];
	
}




// 初始化当前棋局中的数字布局
- (void)initGameNumberLayout {

	// isPlaying  1#Level_1_playing
	
	NSString *playingStr = [NSString stringWithFormat:@"%d#Level_%d_playing", bigLevel, smallLevel];
	//NSString *numDataStr = [NSString stringWithFormat:@"%d#Level_%d_saveData", bigLevel, smallLevel];
	//NSString *timeCountStr = [NSString stringWithFormat:@"%d#Level_%d_timePassed", bigLevel, smallLevel]; 
	//NSLog(@"当前小关是否已开始...<%@>...<%@>...<%@>...key", playingStr, numDataStr, timeCountStr);
	
	// 获取当前小关游戏状态...
	if ([userInfo objectForKey:playingStr] == nil) {
	
		// 若是第1次进入当前关,则默认未开始...
		
		isPlaying = NO;
		[userInfo setBool:NO forKey:playingStr];
		
	}else {
		
		isPlaying = [userInfo integerForKey:playingStr];
		
	}

		
	if (isPlaying == NO) {
		
		// 当前棋局未开始...
		
		// 获取初始数组...
		// 1. 棋局未开始时,用来传给最终的布局数组
		// 2. 棋局已开始时,用来读取空位布局数组
		[self getDefaultNum];
		/************ 最最原始的布局 ***********/
		
		// 计时置为0
		timeCount = 0;
		
		// 若是重新开局,则直接读取初始布局信息即可...
		[self fillCurrentNumArr:origin_numLayout];
		
		//[self getRandomNum];
		
		//[self changeLayoutByRandomNum];
		
	}else {
		
		// 当前棋局已开始...

		// 若棋局已开始,则计时必大于0...
		NSString *timeCountStr = [NSString stringWithFormat:@"%d#Level_%d_timePassed", bigLevel, smallLevel];		
		timeCount = [userInfo integerForKey:timeCountStr];
		
		// 当前棋局已开始...
		[self getNumForLayout];
		
	}
	
	
}




// 获取当前小关的默认布局信息...
// 只获取最最原始的布局信息...因为新的布局会随机变动...
- (void)getDefaultNum {

	//extern int *allLevel1[100];
	
	int *tempNum;
	
	switch (bigLevel) {
		case 1:
			
			tempNum = allLevel1[smallLevel - 1];
			
			break;
		case 2:
			
			tempNum = allLevel2[smallLevel - 1];
			
			break;
		case 3:
			
			tempNum = allLevel3[smallLevel - 1];
			
			break;
		case 4:
			
			tempNum = allLevel4[smallLevel - 1];
			
			break;
		case 5:
			
			tempNum = allLevel1[smallLevel - 1];
			
			break;
		default:
			break;
	}

	//int *tempNum = allLevel1[smallLevel - 1];
	int n = 0;
	
	for ( int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n = i*9 + j;
			
			// 在继续游戏模式中,原始数组与最终数组无关...!!!
			origin_numLayout[i][j] = *(tempNum + n);
			//NSLog(@"<默认>当前布局:%d...<<<<<<<<<<<<<<",numLayout[i][j]);
			
		}
		
	}
	
}





// 获取1~9的随机数
- (void)getRandomNum {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
        
		isRepeated = NO;
		
        srand(time(0));							// 设置随机数种子
		int num_random = arc4random()%9 + 1;	// 获取1~9间的随机数...需不需要生成随机数种子...???
        
		if (i == 0) {	// 对于第一个随机数,直接赋值
            
			randomNum[0] = num_random;
            
		}else {			// 对于后面的随机数,需判断与之前的是否重复...若重复则需要重新取
            
			for (int j = 0; j < i; j++) {
				
				if (randomNum[j] == num_random) {
					
					i--;
					isRepeated = YES;
					break;		// 跳出当前小for
					
				}
				
			}
			
			if (isRepeated == NO) {
				
				randomNum[i] = num_random;
				
			}
            
		}
        
	}
	
	/*
	for (int i = 0; i < 9; i++) {
		
		NSLog(@"...<已取随机数>...randomNum=%d...", randomNum[i]);
		
	}
	*/
	
}




// 若是重新开始,则每次都要进行随机布局...!!!
- (void)changeLayoutByRandomNum {

	
	for (int n = 0; n < 10; n++) {	// 遍历10轮
		
		
		for (int i = 0; i < 9; i++) {
			
			for (int j = 0; j < 9; j++) {
				
				
				if (n == 0) {	// 第一轮
					
					if (numLayout[i][j] == randomNum[n]) {
						
						numLayout[i][j] = 10;	// 棋局中等于第1个随机数的数字替换为10
					}
					
				}else if (n == 9) {
					
					if (numLayout[i][j] == 10) {
						
						numLayout[i][j] = randomNum[n-1];
					}
					
				}else {
					
					if (numLayout[i][j] == randomNum[n]) {
						
						numLayout[i][j] = randomNum[n-1];
					}
					
				}
				
				
			}	// 9列
			
		}	// 9行
		
		
	}	// 10
	
	
	
	// 需要对原始的布局进行重新赋值...
	// 因为在提示功能中,要用到原始布局...
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
		
			origin_numLayout[i][j] = numLayout[i][j];
			
		}
		
	}
	/****************** 重要 *******************/
	
}





// 从保存的数据中读取布局信息
- (void)getNumForLayout {

	// 读取最终的布局
	NSString *numDataStr = [NSString stringWithFormat:@"%d#Level_%d_saveData", bigLevel, smallLevel];
	NSMutableArray *saveDataArr = (NSMutableArray *)[userInfo objectForKey:numDataStr];
	
	// 读取原始布局
	NSString *originalStr = [NSString stringWithFormat:@"%d#Level_%d_default", bigLevel, smallLevel];
	NSMutableArray *defaultLayoutArr = (NSMutableArray *)[userInfo objectForKey:originalStr];
	
	
	int tempNum[9][9];
	int n = 0;
	
	for ( int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
			tempNum[i][j] = [[saveDataArr objectAtIndex: n-1] intValue];
			//NSLog(@"<读取>当前布局:%d...<<<<<<<<<<<<<<",tempNum[i][j]);
			
			origin_numLayout[i][j] = [[defaultLayoutArr objectAtIndex: n-1] intValue];
			
		}
		
	}
	
	// 将读取到的布局信息传给最终布局数组...
	[self fillCurrentNumArr:tempNum];
	
}



// 给当前(最终)数组赋布局信息
- (void)fillCurrentNumArr:(int [9][9])tempArr {

	for ( int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			// 数组的复制...
			// int型c数组的复制是深复制...???...即复制的是副本
			numLayout[i][j] = tempArr[i][j];
			
		}
		
	}
	
}




// 初始化81个棋子bt
- (void)initGameNumberBt {

	int n = 0;
	//int emptyNum = 0;
	int cardNum = 0;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
	
			cardNum = numLayout[i][j];
			
			NSString *numStr = [NSString stringWithFormat:@"bt%d_1.png", cardNum];
			
			UIButton *numBt = [UIButton buttonWithType:UIButtonTypeCustom];
			[numBt setFrame:CGRectMake(8 + squareLine*j + 3.2*j, 108 + squareLine*i + 3.2*i, squareLine, squareLine)];
			//UIButton *numBt = [[UIButton alloc]initWithFrame:CGRectMake(8 + squareLine*j + 3.2*j, 108 + squareLine*i + 3.2*i, squareLine, squareLine)];
			numBt.tag = n;
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			
			// 判断空位...
			if (cardNum == 0) {
				
				//emptyNum++;
				//emptyTags[emptyNum-1] = n;	// 保存空位的tag...!!!
				
				// 只要当前bt为空位,则将其tag保存在空位数组中...
				NSNumber *emptyNum = [NSNumber numberWithInt:n];
				[emptyTagsArr addObject:emptyNum];
				
				[numBt addTarget:self action:@selector(fillTheNumber:) forControlEvents:UIControlStateHighlighted];
				
			}else {
				
				//numBt.userInteractionEnabled = NO;
				
				if (origin_numLayout[i][j] == 0) {	// 为已填充数字的空位...
					
					// 只针对继续游戏棋式...
					// 因为若是重新开始棋式,则必不为0...
					
					// 重新设置数字Bt图片...
					NSString *newNumStr = [NSString stringWithFormat:@"bt%d.png", cardNum];
					[numBt setImage:[UIImage imageNamed:newNumStr] forState:UIControlStateNormal];
					
					// 只要当前bt为空位,则将其tag保存在空位数组中...
					NSNumber *emptyNum = [NSNumber numberWithInt:n];
					[emptyTagsArr addObject:emptyNum];
					
					[numBt addTarget:self action:@selector(fillTheNumber:) forControlEvents:UIControlStateHighlighted];
					
					
				}else {								// 不为空位...
				
					numBt.userInteractionEnabled = NO;
				
				}
				
			}
			
			[self.view addSubview:numBt];
			//[numBt release];
			
			allNumberBtArr[i][j] = numBt;
			
		}
		
	}
	
	NSLog(@"当前游戏界面上空位数为:%d...<若是继续游戏棋式,则还包括之前已填充过数字的空位>", emptyTagsArr.count);
	
	
}



// 开始计时...
- (void)startGameCount {

	//timeCount++;
	hours = timeCount / 3600;
	minutes = timeCount / 60;
	seconds = timeCount % 60;
    
	//[self updateTimeLabel];
	
	[self showChangedTimePic];
	
	timeCount++;
	
}




/*
// 更新计时...
- (void)updateTimeLabel {

	if (hours >= 10 && minutes >= 10 && seconds >= 10) {
		[timeLb setText:[NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds]];
	}else if (hours >= 10 && minutes >= 10 && seconds < 10) {
		[timeLb setText:[NSString stringWithFormat:@"%d:%d:0%d",hours,minutes,seconds]];
	}else if (hours >= 10 && minutes < 10 && seconds < 10) {
		[timeLb setText:[NSString stringWithFormat:@"%d:0%d:0%d",hours,minutes,seconds]];
	}else if (hours >= 10 && minutes < 10 && seconds >= 10) {
		[timeLb setText:[NSString stringWithFormat:@"%d:0%d:%d",hours,minutes,seconds]];
	}else if (hours < 10 && minutes >= 10 && seconds >= 10) {
		[timeLb setText:[NSString stringWithFormat:@"0%d:%d:%d",hours,minutes,seconds]];
	}else if (hours < 10 && minutes >= 10 && seconds < 10) {
		[timeLb setText:[NSString stringWithFormat:@"0%d:%d:0%d",hours,minutes,seconds]];
	}else if (hours < 10 && minutes < 10 && seconds >= 10) {
		[timeLb setText:[NSString stringWithFormat:@"0%d:0%d:%d",hours,minutes,seconds]];
	}else if (hours < 10 && minutes < 10 && seconds < 10) {
		[timeLb setText:[NSString stringWithFormat:@"0%d:0%d:0%d",hours,minutes,seconds]];
	}
	
}
*/




// 显示计时图片
- (void)showChangedTimePic {
	
	
	if (hours == 0) {	// 不满一小时
		
		[hourImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[hourImgview02 setImage:[UIImage imageNamed:@"0.png"]];
		
	}else {				// 满了一小时
		
		int h_num1 = hours / 10;
		int h_num2 = hours % 10;
		
		NSString *num1_h_str = [NSString stringWithFormat:@"%d.png", h_num1];
		NSString *num2_h_str = [NSString stringWithFormat:@"%d.png", h_num2];
		
		[hourImgview01 setImage:[UIImage imageNamed:num1_h_str]];
		[hourImgview02 setImage:[UIImage imageNamed:num2_h_str]];
		
	}
	
	/****************************************/
	
	if (minutes == 0) {	// 不满一分钟
		
		[minuteImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[minuteImgview02 setImage:[UIImage imageNamed:@"0.png"]];
		
	}else {					// 满了一分钟
		
		int m_num1 = minutes / 10;
		int m_num2 = minutes % 10;
		
		NSString *num1_m_str = [NSString stringWithFormat:@"%d.png", m_num1];
		NSString *num2_m_str = [NSString stringWithFormat:@"%d.png", m_num2];
		
		[minuteImgview01 setImage:[UIImage imageNamed:num1_m_str]];
		[minuteImgview02 setImage:[UIImage imageNamed:num2_m_str]];
		
	}
	
	/****************************************/
	
	if (seconds >= 10) {	// 满了10秒...
		
		int s_num1 = seconds / 10;	// 十位
		int s_num2 = seconds % 10;	// 个位
		
		NSString *num1_str = [NSString stringWithFormat:@"%d.png", s_num1];
		NSString *num2_str = [NSString stringWithFormat:@"%d.png", s_num2];
		
		[secondImgview01 setImage:[UIImage imageNamed:num1_str]];
		[secondImgview02 setImage:[UIImage imageNamed:num2_str]];
		
	}else {					// 不足10秒...
		
		NSString *num_str = [NSString stringWithFormat:@"%d.png", seconds];
		[secondImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[secondImgview02 setImage:[UIImage imageNamed:num_str]];
		
	}
	
	
}




// 对坐标进行微调
- (void)fixCoordinate {

	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			UIButton *currentBt = (UIButton *)allNumberBtArr[i][j];
						
			CGRect currentRect;
			currentRect = currentBt.frame;
			
			if (i == 5 || i == 8) {
				currentRect.origin.y -= 1;
			}
			
			if (j == 5 || j == 8) {
				currentRect.origin.x -= 1;
			}
			
			currentBt.frame = currentRect;
			
		}
		
	}
	
}



// 点击空位来选数字...
- (void)fillTheNumber:(id)sender {

	UIButton *fillBt = (UIButton *)sender;
	btIndex = fillBt.tag;
	//NSLog(@"用户点击的bt之tag为:%d", btIndex);
		
	int i = (btIndex-1) / 9;
	int j = (btIndex-1) % 9;
	int currentNum = numLayout[i][j];
	
	btNum = currentNum;	// 获取当前空位的数字...若未填,则为0
	
	// 首先更改当前选中的空位图片...
	// 反应快速
	if (currentNum == 0) { 
		[fillBt setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
	}else {
		NSString *numStr = [NSString stringWithFormat:@"bt%d_2.png", currentNum];
		[fillBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
	}
	
	
	// 去掉选中效果...对所有空位进行刷新...!!!
	[self removeAllSelectedImg];
	
	
	//[UIView beginAnimations:nil context:nil];
	//[UIView setAnimationDelay:0.8];
	//[UIView setAnimationDelegate:self];
	selectView.hidden = NO;
	//[UIView commitAnimations];
	
	if (helpIsOpen) {	// 若提示打开,则显示提示功能...
		
		[self showHelpInfo];
		
	}
	

}




// 去掉选中状态...
- (void)removeAllSelectedImg {

	// 去掉所有空位(包括已填数字的空位)的选中状态
	for (NSNumber *myNum in emptyTagsArr) {
		
		int realNum = [myNum intValue];		// 获得空位的tag
		
		if (realNum == btIndex) {
			continue;
		}
		
		int m = (realNum-1) / 9;
		int n = (realNum-1) % 9;
		//NSLog(@"所有的空位索引为: <%d, %d>, tag=%d", m, n, realNum);
		NSString *realStr = [NSString stringWithFormat:@"bt%d.png", numLayout[m][n]];
		UIButton *realBt = allNumberBtArr[m][n];
		[realBt setImage:[UIImage imageNamed:realStr] forState:UIControlStateNormal];
		
	}
	
}





// 增加提示信息...
- (void)showHelpInfo {
		
	for (int i = 0; i < 9; i++) {	// 清空提示数组
		
		originalHelp[i] = NO;
		updatedHelp[i] = NO;
		
	}
	
	[self analyseOriginalNumLayout];	// 填充
	
	[self analyseUpdatedNumLayout];		// 填充
	
	[self settingHelpAction];
	
}




// 对原始数字布局进行分析
- (void)analyseOriginalNumLayout {
	
	int row_empty = (btIndex - 1) / 9;							// 当前空位的行
	int column_empty = (btIndex - 1) % 9;							// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;		// 当前空位所在的九宫的索引
	
	[self analyseLineForOriginal:row_empty];
	
	[self analyseColumnForOriginal:column_empty];
	
	[self analyseSquareForOriginal:square_empty];
	
	
}



- (void)analyseLineForOriginal:(int)row {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[row][i] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[row][i] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[row][i] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[row][i] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[row][i] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[row][i] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[row][i] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[row][i] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[row][i] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}	// 遍历当前行的9个棋格...
	
	
}



- (void)analyseColumnForOriginal:(int)column {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[i][column] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[i][column] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[i][column] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[i][column] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[i][column] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[i][column] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[i][column] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[i][column] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[i][column] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}	// 遍历当前列的9个棋格...
	
	
}



- (void)analyseSquareForOriginal:(int)square {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}
	
	
}



// 对更新后的数字布局进行分析
- (void)analyseUpdatedNumLayout {
	
	// 默认当前空位bt没有 非空且重复 的情况
	BOOL notEmptyAndRepeated = NO;
	
	int row_empty = (btIndex - 1) / 9;							// 当前空位的行
	int column_empty = (btIndex - 1) % 9;							// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;		// 当前空位所在的九宫的索引
	
	
	if (btNum != 0) {		// 若当前空位已填数字,则需要判断当前所填数字是否有重复
		
		int repeatNum = 0;	// 初始重复个数为0
		
		int num1 = [self checkRepeatedInLine:row_empty];
		int num2 = [self checkRepeatedInColumn:column_empty];
		int num3 = [self checkRepeatedInSquare:square_empty];
		
		repeatNum = num1 + num2 + num3;
		
		if (repeatNum > 3) {	// 大于3,说明必有重复...等于3说明不重复...
			
			NSLog(@"有重复...<前提是空位上有数字>");
			
			// 若有重复,则此空位上的数字当作未填...
			// 不作进一步处理...
			
		}else if (repeatNum == 3) {
			
			NSLog(@"没有重复...<前提是空位上有数字>");
			
			// 若没有重复,则在bool型的布局中将当前空位设置为no...
			// 然后再作分析...
			
			notEmptyAndRepeated = YES;
			
		}
		
		
	}	// 当前空位中已填数字...
	
	
	[self analyseLineForUpdated:row_empty];
	
	[self analyseColumnForUpdated:column_empty];
	
	[self analyseSquareForUpdated:square_empty];
	
	
	if (notEmptyAndRepeated == YES) {
		
		updatedHelp[btNum - 1] = NO;	// 满足情况时,假设当前空位没有填数字...
		
	}
	
}



// 获得当前数字在行中的个数...检查重复用...
- (int)checkRepeatedInLine:(int)row {
	
	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == btNum) {
			
			num++;
			
		}
		
	}
	
	return num;
	
}

- (int)checkRepeatedInColumn:(int)column {
	
	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == btNum) {
			
			num++;
			
		}
		
	}
	
	return num;
	
	
}

- (int)checkRepeatedInSquare:(int)square {
	
	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == btNum) {
			
			num++;
			
		}
		
	}
	
	return num;
	
}




- (void)analyseLineForUpdated:(int)row {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[row][i] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[row][i] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[row][i] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[row][i] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[row][i] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[row][i] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[row][i] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[row][i] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}	// 遍历当前行的9个棋格...
	
	
}



- (void)analyseColumnForUpdated:(int)column {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[i][column] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[i][column] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[i][column] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[i][column] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[i][column] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[i][column] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[i][column] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[i][column] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}	// 遍历当前列的9个棋格...
	
	
}



- (void)analyseSquareForUpdated:(int)square {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}
	
	
}




// 对可选数字bt的逻辑处理
- (void)settingHelpAction {
	
	
	BOOL hasPlayer = NO;	// 默认没有填数字...
	
	// 判断是否在原始布局的基础上已经填了数字...
	// 即更新后的布局与原始布局是否相同
	for (int i = 0; i < 9; i++) {
		
		if (originalHelp[i] != updatedHelp[i]) {
			
			hasPlayer = YES;
			break;
		}
		
	}
	
	
	// 对原始布局进行分析
	for (int i = 0; i < 9; i++) {	// 对9个bt设置图片
		
		int myTag = 101 + i;
		UIButton *numBt = (UIButton *)[self.view viewWithTag:myTag];
		
		if (originalHelp[i] == NO) {	// 可选
			
			NSString *numStr = [NSString stringWithFormat:@"num%d_1.png", i+1];
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			numBt.userInteractionEnabled = YES;
			
		}else {							// 不可选
			
			NSString *numStr = [NSString stringWithFormat:@"num%d.png", i+1];
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			numBt.userInteractionEnabled = NO;
			
		}
		
	}
	
	
	// 对更新后的布局进行分析
	if (hasPlayer == YES) {
		
		for (int i = 0; i < 9; i++) {	// 对9个bt设置图片
			
			int myTag = 101 + i;
			UIButton *numBt = (UIButton *)[self.view viewWithTag:myTag];
			
			if (updatedHelp[i] == NO) {
				
				NSString *numStr = [NSString stringWithFormat:@"num%d_2.png", i+1];
				[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
				//numBt.userInteractionEnabled = YES;
				
			}
			
		}
		
	}
	
	
}




// 选好数字后对空位进行填充...
- (IBAction)selectTheNumber:(id)sender {

	UIButton *numBt = (UIButton *)sender;
	//NSLog(@"tag=%d", numBt.tag);
	
	int realTag;
	realTag = numBt.tag % 100;
	//NSLog(@"realNum=%d", realTag);
	
	/*
	// 需对当前点击的数字进行判断...若有重复则不可选...!!!
	if (helpIsOpen) {	// 前提是提示已开启...
		
		BOOL isRepeated;
		isRepeated = [self checkCurrentNumberIsRepeatedOrNot:realTag];
		
		if (isRepeated == YES) {	// 返回yes表示有重复...
			//NSLog(@"有重复,请重新选择数字...!!!");
			return;
		}
		
	}
	*/
	
	//[UIView beginAnimations:nil context:nil];
	//[UIView setAnimationDelay:0.8];
	//[UIView setAnimationDelegate:self];
	selectView.hidden = YES;
	//[UIView commitAnimations];
	
	
	NSString *imgStr = [NSString stringWithFormat:@"bt%d_2.png", realTag];
	
	int i = (btIndex-1) / 9;
	int j = (btIndex-1) % 9;
	
	UIButton *currentBt = allNumberBtArr[i][j];
	[currentBt setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
	
	// 在当前空位上保存所选的数字
	numLayout[i][j] = realTag;
	
	
	[self checkGameOverOrNot];
	
	
}



// 检查当前数字是否重复...
- (BOOL)checkCurrentNumberIsRepeatedOrNot:(int)numSelected {
	
	BOOL repeat_h;
	BOOL repeat_v;
	BOOL repeat_s;
	
	int row_empty = (btIndex-1) / 9;							// 当前空位的行
	int column_empty = (btIndex-1) % 9;							// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;	// 当前空位所在的九宫的索引
	
	//NSLog(@"当前空位的索引信息: <%d, %d>...%d", row_empty, column_empty, square_empty);
	
	repeat_h = [self checkCurrentHorizontalLine:row_empty forCurrentNum:numSelected];
	repeat_v = [self checkCurrentVerticalLine:column_empty forCurrentNum:numSelected];
	repeat_s = [self checkCurrentSquare:square_empty forCurrentNum:numSelected];
	
	if (repeat_h == YES || repeat_v == YES || repeat_s == YES) {
		
		return YES;	// 有重复
		
	}else {
		
		return NO;	// 无重复
		
	}
	
}




// 检查当前行中是否有相同的数字
- (BOOL)checkCurrentHorizontalLine:(int)row forCurrentNum:(int)numSelected {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == numSelected) {
			
			isRepeated = YES;
			break;
			
		}
		
	}
	
	return isRepeated;
	
}




// 检查当前列中是否有相同的数字
- (BOOL)checkCurrentVerticalLine:(int)column forCurrentNum:(int)numSelected {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == numSelected) {
			
			isRepeated = YES;
			break;
			
		}
		
	}
	
	return isRepeated;
	
}




// 检查当前九宫中是否有相同的数字
- (BOOL)checkCurrentSquare:(int)sIndex forCurrentNum:(int)numSelected {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(sIndex/3)*3 + i/3][(sIndex%3)*3 + i%3] == numSelected) {
			
			isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
			break;
			
		}
		
	}
	
	return isRepeated;
	
}




// 检查游戏是否结束...
- (void)checkGameOverOrNot {
	
	// 若所有数字均已填完,则需进行胜负判断...
	if ([self allNumberFilled] == YES) {
		
		if ([self gameIsOver] == YES) {
			
			NSLog(@">>>>>>>>>>>...胜利...<<<<<<<<<<<");
			gameOver = YES;
			overNum++;	// 若当前小关之前已通关,则必大于1
			[self showGameOverInfo];
			
		}
		
	}else {
		
		//NSLog(@"游戏未结束,还有空位没有填完...");
		
	}
	
}




// 所有的数字是否已填充完
- (BOOL)allNumberFilled {

	BOOL fillOver = YES;
	
	for (NSNumber *myNum in emptyTagsArr) {
		
		int realNum = [myNum intValue];		// 获得空位的tag
		int m = (realNum-1) / 9;
		int n = (realNum-1) % 9;
		
		if (numLayout[m][n] == 0) {		// 只要找到没有填的空位,则返回no...
			
			fillOver = NO;
			break;
			
		}
		
	}
	
	
	return fillOver;
	
}




// 游戏是否结束...
- (BOOL)gameIsOver {
	
	// 开始默认游戏结束...
	BOOL isOver = YES;	
	
	// 依次遍历9个行、列、宫...
	for (int i = 0; i < 9; i++) {
		
		BOOL h = [self checkEveryHorizontalLine:i];
		BOOL v = [self checkEveryVerticalLine:i];
		BOOL s = [self checkEverySquare:i];
		
		if (h == YES || v == YES || s == YES) {		// 返回yes说明有重复...不符...!!!
			
			isOver = NO;	// 只要找到一个不符合条件的,则直接返回no, 并退出for...
			break;
		}
		
	}
	
	return isOver;
	
}




// 看每一行是否有重复...前提是所有空位均已填完
// 返回no表示无重复...
- (BOOL)checkEveryHorizontalLine:(int)row {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			if (numLayout[row][i] == numLayout[row][j]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 看每一列是否有重复...前提是所有空位均已填完
- (BOOL)checkEveryVerticalLine:(int)column {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			if (numLayout[i][column] == numLayout[j][column]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 看每一九宫是否有重复...前提是所有空位均已填完
- (BOOL)checkEverySquare:(int)sIndex {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			//int m = (sIndex/3)*3 + i/3;
			//int n = (sIndex%3)*3 + i%3;
			//NSLog(@"......<%d, %d>......", m, n);
			
			if (numLayout[(sIndex/3)*3 + i/3][(sIndex%3)*3 + i%3] == numLayout[(sIndex/3)*3 + j/3][(sIndex%3)*3 + j%3]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 显示胜利提示...
- (void)showGameOverInfo {

	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	// 每次游戏结果时,均要重新取得(更新)当前时间...
	[self getCurrentDate];
	
	// 读取当前小关的过关时间记录,进行比较...
	[self checkAndSaveGameRecord];
	
	// 启动新的关卡
	[self refreshNewSmallLevel];
	
	/*********************** 删除 ********************/
	// 当前小关的游戏状态设置为no...
	NSString *playingStr = [NSString stringWithFormat:@"%d#Level_%d_playing", bigLevel, smallLevel];
	//[userInfo setBool:NO forKey:playingStr];
	[userInfo removeObjectForKey:playingStr];
	
	NSString *smallSaveStr = [NSString stringWithFormat:@"%d#Level_%d_saveData", bigLevel, smallLevel];
	[userInfo removeObjectForKey:smallSaveStr];
	
	NSString *timeStr = [NSString stringWithFormat:@"%d#Level_%d_timePassed", bigLevel, smallLevel];
	[userInfo removeObjectForKey:timeStr];
	
	NSString *defaultStr = [NSString stringWithFormat:@"%d#Level_%d_default", bigLevel, smallLevel];
	[userInfo removeObjectForKey:defaultStr];
	/*********************** 删除 ********************/
	
	
	// 空位不可再点击
	for (NSNumber *myNum in emptyTagsArr) {
		
		int realNum = [myNum intValue];		// 获得空位的tag
		int i = (realNum-1) / 9;
		int j = (realNum-1) % 9;
		
		UIButton *gameBt = allNumberBtArr[i][j];
		gameBt.userInteractionEnabled = NO;
		
	}
	
	
	//UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"游戏结束" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	//[infoAlert show];
	//[infoAlert release];
	
	[self.view bringSubviewToFront:gameOverView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[gameOverView setFrame:CGRectMake(0, 0, 320, 640)];
	[UIView commitAnimations];
	
}




//获取系统日期
- (void)getCurrentDate {
    
	NSDate *currentDate = [NSDate date];
	NSCalendar *currentCalender = [NSCalendar currentCalendar];
	NSUInteger uniteFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
	NSDateComponents *currentComponent = [currentCalender components:uniteFlags fromDate:currentDate];
	NSInteger currentYear = [currentComponent year];
	NSInteger currentMonth = [currentComponent month];
	NSInteger currentDay = [currentComponent day];
	
	if (currentMonth < 10 || currentDay < 10) {
		
		if (currentMonth < 10 && currentDay < 10) {
			
			DateString = [NSString stringWithFormat:@"%d-0%d-0%d", currentYear, currentMonth, currentDay];
			
		}else if (currentMonth < 10 && currentDay >= 10) {
			
			DateString = [NSString stringWithFormat:@"%d-0%d-%d", currentYear, currentMonth, currentDay];
			
		}else {
			
			DateString = [NSString stringWithFormat:@"%d-%d-0%d", currentYear, currentMonth, currentDay];
			
		}
				
	}else {
	
		DateString = [NSString stringWithFormat:@"%d-%d-%d", currentYear, currentMonth, currentDay];
		
	}
	
	//DateString = [NSString stringWithFormat:@"%4d-%2d-%2d", currentYear, currentMonth, currentDay];
    
}




// 游戏结束后,比较并保存相关记录...
- (void)checkAndSaveGameRecord {

	
	NSString *firstTimeKey = [NSString stringWithFormat:@"%d#Level_%d_time1", bigLevel, smallLevel];
	NSString *secondTimeKey = [NSString stringWithFormat:@"%d#Level_%d_time2", bigLevel, smallLevel];
	NSString *thirdTimeKey = [NSString stringWithFormat:@"%d#Level_%d_time3", bigLevel, smallLevel];
	
	NSString *firstDateKey = [NSString stringWithFormat:@"%d#Level_%d_date1", bigLevel, smallLevel];
	NSString *secondDateKey = [NSString stringWithFormat:@"%d#Level_%d_date2", bigLevel, smallLevel];
	NSString *thirdDateKey = [NSString stringWithFormat:@"%d#Level_%d_date3", bigLevel, smallLevel];
	
	
	if ([userInfo objectForKey:firstTimeKey] == nil) {	// 无第一记录...
		
		[userInfo setInteger:timeCount forKey:firstTimeKey];
		[userInfo setObject:DateString forKey:firstDateKey];
		
	}else {											// 有第一记录...
		
		
		int firstT = [userInfo integerForKey:firstTimeKey];	// 原始的第1记录
		NSString *firstD = (NSString *)[userInfo objectForKey:firstDateKey];
		
		if (timeCount < firstT) {	// 新记录比第1记录小...则把新记录设置为第1记录,原始的第1记录往下移...
			
			// 存新记录...
			[userInfo setInteger:timeCount forKey:firstTimeKey];
			[userInfo setObject:DateString forKey:firstDateKey];
						
			if ([userInfo objectForKey:secondTimeKey] == nil) {	// 如果第2记录为空,则用原先的第1记录覆盖... 
				
				[userInfo setInteger:firstT forKey:secondTimeKey];
				[userInfo setObject:firstD forKey:secondDateKey];
				
			}else {												// 如果第2记录不为空,则第2记录往下移到第3记录...!!!
				
				int secondT = [userInfo integerForKey:secondTimeKey];	// 先取第2记录的原值
				NSString *secondD = (NSString *)[userInfo objectForKey:secondDateKey];
				
				[userInfo setInteger:firstT forKey:secondTimeKey];		// 再用第1记录覆熏第2记录
				[userInfo setObject:firstD forKey:secondDateKey];				
				
				// 此时不管第3记录是否为空,直接用第2记录覆盖
				[userInfo setInteger:secondT forKey:thirdTimeKey];
				[userInfo setObject:secondD forKey:thirdDateKey];
				
				
			}

			
		}else {						// 新记录比第1记录大...则要继续往下判断
			
			
			if ([userInfo objectForKey:secondTimeKey] == nil) {	// 若第2记录为空,则直接将新计时存入第2记录
				
				[userInfo setInteger:timeCount forKey:secondTimeKey];
				[userInfo setObject:DateString forKey:secondDateKey];
				
			}else {												// 若第2记录不为空,则需要与第2记录进行比较
				
				
				int secondT = [userInfo integerForKey:secondTimeKey];	// 原始的第2记录
				NSString *secondD = (NSString *)[userInfo objectForKey:secondDateKey];
				
				if (timeCount < secondT) {	// 若新计时小于第2记录,则用新计时覆盖第2记录,且第2记录往下移
					
					[userInfo setInteger:timeCount forKey:secondTimeKey];
					[userInfo setObject:DateString forKey:secondDateKey];
					
					[userInfo setInteger:secondT forKey:thirdTimeKey];
					[userInfo setObject:secondD forKey:thirdDateKey];
					
				}else {						// 若新记录大于第2记录,则还需要与第3记录进行比较...
					
					if ([userInfo objectForKey:thirdTimeKey] == nil) {	// 若第3记录为空,则直接用新计时覆盖
						
						[userInfo setInteger:timeCount forKey:thirdTimeKey];
						[userInfo setObject:DateString forKey:thirdDateKey];
						
					}else {												// 若第3记录不为空,则需进行比较...
						
						int thirdT = [userInfo integerForKey:thirdTimeKey];
						
						if (timeCount < thirdT) {	// 若新计时小于第3记录
							
							[userInfo setInteger:timeCount forKey:thirdTimeKey];
							[userInfo setObject:DateString forKey:thirdDateKey];
							
						}else {						// 若新计时大于第3记录,则丢弃,不保存...
							
							// 不保存......
							
						}

					}
					
				}

				
			}	// 存在第2记录...
			
			
		}	// 新记录比第1记录大...

		
	}	// 存在第1记录...
	
	
}




// 对小关的激活数进行刷新...
// 前提是当前关游戏结束
- (void)refreshNewSmallLevel {

	if (overNum == 1) {
		
		NSLog(@"当前小关是第一次通关...故需要激活后面的一个小关");
		
		if (allSmallLevel == 99) {
			return;		// 若当前大关的所有小关均已激活,则不再继续增加...!!!
		}
		
		NSString *levelNumKey = [NSString stringWithFormat:@"%d#Level_openNum", bigLevel];
		[userInfo setInteger:(allSmallLevel + 1) forKey:levelNumKey];
		
		// 对当前大关下的小关激活数进行刷新...
		allSmallLevel = [userInfo integerForKey:levelNumKey];
		
		if (smallLevel == allSmallLevel) {
			
			nextLevelBt.userInteractionEnabled = NO;
			nextLevelBt.alpha = 0.5;
			
		}else {
			
			nextLevelBt.userInteractionEnabled = YES;
			nextLevelBt.alpha = 1;
			
		}		
		
	}else {
		
		// 当前小关在之前已通关,故再次通关时不再激活后面的小关...!!!
		NSLog(@"当前小关在之前已通关,故再次通关时不再激活后面的小关");
		
	}
	
}



// 返回并保存数据
- (IBAction)backHome {
    
	infoNum = 1;	// 1表示返回...
	
    if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
    if (gameOver == NO) {	// 游戏未结束...
				
		[self.infoImgview setImage:[UIImage imageNamed:@"ts1.png"]];
		
		[self.view bringSubviewToFront:infoView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[infoView setFrame:CGRectMake(0, 0, 320, 640)];
		[UIView commitAnimations];
				
	}else {					// 游戏已结束...
		
		// 游戏已结束则直接返回...
		
		[self dismissModalViewControllerAnimated:YES];
		
	}
	
    
}



// 在游戏未结束时保存信息...
- (void)saveDataBeforeBackhome {

	
	// 将当前小关状态重置为正在游戏...
	NSString *playingStr = [NSString stringWithFormat:@"%d#Level_%d_playing", bigLevel, smallLevel];
	[userInfo setBool:YES forKey:playingStr];
	
	// 保存当前小关游戏中已花费的时间...
	NSString *timeStr = [NSString stringWithFormat:@"%d#Level_%d_timePassed", bigLevel, smallLevel];
	[userInfo setInteger:timeCount forKey:timeStr];
	
	// 保存当前数字布局...
	NSMutableArray *saveLayoutArr = [[NSMutableArray alloc]init];
	for (int i = 0; i < 9; i++) {
		for (int j = 0; j < 9; j++) {
			[saveLayoutArr addObject:[NSNumber numberWithInt:numLayout[i][j]]];
		}
	}
	NSString *saveStr = [NSString stringWithFormat:@"%d#Level_%d_saveData", bigLevel, smallLevel];
	[userInfo setObject:saveLayoutArr forKey:saveStr];
	[saveLayoutArr release];
	
	// 保存当前原始布局...
	NSMutableArray *originalLayoutArr = [[NSMutableArray alloc]init];
	for (int i = 0; i < 9; i++) {
		for (int j = 0; j < 9; j++) {
			[originalLayoutArr addObject:[NSNumber numberWithInt:origin_numLayout[i][j]]];
		}
	}
	NSString *originalStr = [NSString stringWithFormat:@"%d#Level_%d_default", bigLevel, smallLevel];
	[userInfo setObject:originalLayoutArr forKey:originalStr];
	[originalLayoutArr release];
	
}



// 重新开始当前关
- (IBAction)restart {

	infoNum = 2;	// 2表示重新开始...
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	if (gameOver == NO) {	// 游戏未结束...
		
		[self.infoImgview setImage:[UIImage imageNamed:@"ts2.png"]];
		
		[self.view bringSubviewToFront:infoView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[infoView setFrame:CGRectMake(0, 0, 320, 640)];
		[UIView commitAnimations];
			
	}else {					// 游戏已结束...
		
		[self restartCurrentLevel];
		
	}
	
}



// 重新开始时的一些相关设置...
- (void)restartCurrentLevel {

	
	[emptyTagsArr removeAllObjects];
	gameOver = NO;
	timeCount = 0;
	
	selectView.hidden = YES;	// 可选的填充数字栏隐藏
	
	// 重新获取当前大关下的小关激活数...
	NSString *smallNumStr = [NSString stringWithFormat:@"%d#Level_openNum", bigLevel];
	allSmallLevel = [userInfo integerForKey:smallNumStr];
	NSLog(@"重新开始后,当前大关下所有的小关激活数=%d, 当前正在游戏中的小关为=%d", allSmallLevel, smallLevel);
	
	if (smallLevel == allSmallLevel) {
		nextLevelBt.userInteractionEnabled = NO;
		nextLevelBt.alpha = 0.5;
	}else {
		nextLevelBt.userInteractionEnabled = YES;
		nextLevelBt.alpha = 1;
	}
	
	// 有未完成的布局记录,则删除...
	NSString *smallSaveStr = [NSString stringWithFormat:@"%d#Level_%d_saveData", bigLevel, smallLevel];
	[userInfo removeObjectForKey:smallSaveStr];
	
	NSString *playingStr = [NSString stringWithFormat:@"%d#Level_%d_playing", bigLevel, smallLevel];
	[userInfo setBool:NO forKey:playingStr];
	
	NSString *timeStr = [NSString stringWithFormat:@"%d#Level_%d_timePassed", bigLevel, smallLevel];
	[userInfo removeObjectForKey:timeStr];
	
	NSString *defaultStr = [NSString stringWithFormat:@"%d#Level_%d_default", bigLevel, smallLevel];
	[userInfo removeObjectForKey:defaultStr];
	
	
	// 清空数组...
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			numLayout[i][j] = 0;
			
			UIButton *numBt = allNumberBtArr[i][j];
			[numBt removeFromSuperview];
			numBt = nil;
			//[numBt release];
			//numBt = nil;
			
		}
		
	}
	
		
	//[self initBigLevelImg];
	
	//[self initSmallLevelNum];
	
	// 当前关重新开始,不需要再获取当前关的通关与否信息
	
	[self initGameNumberLayout];
	
	[self initGameNumberBt];
	
	[self fixCoordinate];
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	// 重新计时...
	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];
	
	
}




// 下一关游戏...
- (IBAction)goToNextLevel {

	infoNum = 3;	// 3表示下一关...
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	if (gameOver == NO) {	// 游戏未结束...
		
		// 提示,并保存当前关的数据信息
		//[self saveDataBeforeBackhome];
		//[self nextLevelAction];
		
		[self.infoImgview setImage:[UIImage imageNamed:@"ts3.png"]];
				
		[self.view bringSubviewToFront:infoView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[infoView setFrame:CGRectMake(0, 0, 320, 640)];
		[UIView commitAnimations];
		
	}else {					// 游戏已结束...
		
		// 如果当前关的游戏已结束,则直接进入下一步...
		[self nextLevelAction];
		
	}
	
}




// 进入下一步前保存相关信息...
- (void)nextLevelAction {

	
	// 切换到下一关...获取下一关的相关数据
	smallLevel++;
	
	[emptyTagsArr removeAllObjects];
	gameOver = NO;
	timeCount = 0;
	
	selectView.hidden = YES;	// 可选的填充数字栏隐藏
	
	// 若当前关(下一关)与小关激活数相等,则下一关bt不可用...
	if (smallLevel == allSmallLevel) {
		nextLevelBt.userInteractionEnabled = NO;
		nextLevelBt.alpha = 0.5;
	}else {
		nextLevelBt.userInteractionEnabled = YES;
		nextLevelBt.alpha = 1;
	}
	
	// 清空数组...
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			numLayout[i][j] = 0;
			
			UIButton *numBt = allNumberBtArr[i][j];
			[numBt removeFromSuperview];
			numBt = nil;
			//[numBt release];
			//numBt = nil;
			
		}
		
	}
	
	
	// 获取下一关是否已通关...
	[self initSomeProperty];	
	
	[self initSmallLevelNum];
	
	[self initGameNumberLayout];
	
	[self initGameNumberBt];
	
	[self fixCoordinate];
	
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	// 重新计时...
	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];
	
		
}




// 前提是游戏未结束...
- (IBAction)ensureBackhome {
		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(afterAnimation)];
	[infoView setFrame:CGRectMake(-320, 0, 320, 640)];
	[UIView commitAnimations];
	
}




- (IBAction)cancelBackhome {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[infoView setFrame:CGRectMake(-320, 0, 320, 640)];
	[UIView commitAnimations];
	
	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];
	
}





- (void)afterAnimation {

	switch (infoNum) {
		case 1:
			
			// 返回
			[self saveDataBeforeBackhome];
			
			[self dismissModalViewControllerAnimated:YES];
			
			break;
		case 2:
			
			// 重新开始
			[self restartCurrentLevel];
			
			break;
		case 3:
			
			// 下一关
			[self saveDataBeforeBackhome];
			
			[self nextLevelAction];
			
			break;
		default:
			break;
	}
	
}





- (IBAction)gameOverAction {

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[gameOverView setFrame:CGRectMake(320, 0, 320, 640)];
	[UIView commitAnimations];
	
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

	[levelImgview release];
	levelImgview = nil;
	
	[selectView release];
	selectView = nil;
	
	[nextLevelBt release];
	nextLevelBt = nil;
	
	[doubleImg release];
	doubleImg = nil;
	
	[singleImg release];
	singleImg = nil;
	
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			UIButton *numBt = allNumberBtArr[i][j];
			[numBt removeFromSuperview];
			numBt = nil;
			
		}
		
	}
	
	[emptyTagsArr release];
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	[hourImgview01 release];
	hourImgview01 = nil;
	
	[hourImgview02 release];
	hourImgview02 = nil;
	
	[minuteImgview01 release];
	minuteImgview01 = nil;
	
	[minuteImgview02 release];
	minuteImgview02 = nil;
	
	[secondImgview01 release];
	secondImgview01 = nil;
	
	[secondImgview02 release];
	secondImgview02 = nil;
	
	[infoView release];
	infoView = nil;
	
	[infoImgview release];
	infoImgview = nil;
	
	[gameOverView release];
	gameOverView = nil;
	
	[super dealloc];
	
}




@end



