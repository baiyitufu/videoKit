//
//  PlayviewConteoller.m
//  VideoDemo
//
//  Created by  tao on 14-6-10.
//  Copyright (c) 2014年 wang. All rights reserved.
//

#import "PlayviewConteoller.h"
#import "VideoPlayerKit.h"
#import "VideoPlayerSampleView.h"

@interface PlayviewConteoller ()

@property (nonatomic, strong) VideoPlayerKit *videoPlayerViewController;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) VideoPlayerSampleView *videoPlayerSampleView;
@end

@implementation PlayviewConteoller
- (id)init
{
    if ((self = [super init])) {
        
        // Optional Top View
        _topView = [[UIView alloc] init];
           self.topView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.bounds.size.width, 44);
        UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(180, 20, 200, 30)];
        label.textAlignment=NSTextAlignmentCenter;
      //  label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        label.text=@"测试标题";
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor purpleColor];
        [_topView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 20, 44, 44);
        [button addTarget:self
                   action:@selector(fullScreen)
         forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor blueColor]];
        [button setImage:[UIImage imageNamed:@"fhui"] forState:UIControlStateNormal];
        [_topView addSubview:button];
    }
    return self;
}
// Fullscreen / minimize without need for user's input
- (void)fullScreen
{
    
    if (!self.videoPlayerViewController.fullScreenModeToggled) {
        [self.videoPlayerViewController launchFullScreen];
    } else {
        [self.videoPlayerViewController minimizeVideo];
    }
}

- (void)loadView
{
    self.videoPlayerSampleView = [[VideoPlayerSampleView alloc] initWithTopView:nil videoPlayerView:nil];
    [self.videoPlayerSampleView.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self setView:self.videoPlayerSampleView];
}

- (void)playVideo
{
   NSURL *url = [NSURL URLWithString:@"http://ignhdvod-f.akamaihd.net/i/assets.ign.com/videos/zencoder/,416/d4ff0368b5e4a24aee0dab7703d4123a-110000,640/d4ff0368b5e4a24aee0dab7703d4123a-500000,640/d4ff0368b5e4a24aee0dab7703d4123a-1000000,960/d4ff0368b5e4a24aee0dab7703d4123a-2500000,1280/d4ff0368b5e4a24aee0dab7703d4123a-3000000,-1354660143-w.mp4.csmil/master.m3u8"];
    
//  http://rtmpcnr002.cnr.cn/live/jjzs/playlist.m3u8
   // NSURL *url = [NSURL URLWithString:@"http://h264.sctv.com/Features/test/shinyv/shinyv3.mp4"];
    
    if (!self.videoPlayerViewController) {
        self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingViewController:self optionalTopView:_topView hideTopViewWithControls:YES];
        // Need to set edge inset if top view is inserted
        [self.videoPlayerViewController setControlsEdgeInsets:UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0)];
        self.videoPlayerViewController.showStaticEndTime=YES;
        
        self.videoPlayerViewController.view.frame=CGRectMake(0, 20, 320, 200);
        self.videoPlayerViewController.delegate = self;
        self.videoPlayerViewController.allowPortraitFullscreen = NO;
    }
    
    [self.view addSubview:self.videoPlayerViewController.view];
    
    [self.videoPlayerViewController playVideoWithTitle:@"" URL:url videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
}
- (void)trackEvent:(NSString *)event videoID:(NSString *)videoID title:(NSString *)title{


    NSLog(@"%@",event);

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.bounds.size.width, 44);
}

@end
