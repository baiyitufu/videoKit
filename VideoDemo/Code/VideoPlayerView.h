/* Copyright (C) 2012 IGN Entertainment, Inc. */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AirplayActiveView.h"


#define ButtonNextOrPre_width 70
#define ButtonNextOrPre_height 44
@interface VideoPlayerView : UIView {
    BOOL _fullscreen;
}

@property (readwrite) CGFloat padding;
@property (readonly, strong) UILabel *titleLabel;
@property (readonly, strong) AirplayActiveView *airplayIsActiveView;
@property (readonly, strong) UIView *playerControlBar;

@property (readonly, strong) UIView *actionView;
@property (readonly, strong) UIButton *collectBtn;
@property (readonly, strong) UIButton *downLoadBtn;
@property (readonly, strong) UIButton *shareBtn;


@property (readonly, strong) UIButton *playPauseButton;
@property (readonly, strong) UIButton *fullScreenButton;
@property (readonly, strong) UISlider *videoScrubber;
@property (readonly, strong) UILabel *currentPositionLabel;
@property (readonly, strong) UILabel *timeLeftLabel;
@property (readonly, strong) UIProgressView *progressView;
@property (readonly, strong) UIButton *shareButton;
@property (readonly, strong) UIButton *playPreButton;
@property (readonly, strong) UIButton *playNextButton;
@property (readwrite) UIEdgeInsets controlsEdgeInsets;
@property (nonatomic, readwrite, getter=isFullscreen) BOOL fullscreen;

@property (readonly, strong) UIActivityIndicatorView *activityIndicator;

- (void)setTitle:(NSString *)title;
- (CGFloat)heightForWidth:(CGFloat)width;
- (void)setPlayer:(AVPlayer *)player;

@end
