/* Copyright (C) 2012 IGN Entertainment, Inc. */

#import "VideoPlayerView.h"

#define PLAYER_CONTROL_BAR_HEIGHT 60
#define BUTTON_PADDING 8
#define CURRENT_POSITION_WIDTH 56
#define TIME_LEFT_WIDTH 59
#define ALIGNMENT_FUZZ 2
#define ROUTE_BUTTON_ALIGNMENT_FUZZ 8

@interface VideoPlayerView ()

@property (readwrite, strong) UILabel *titleLabel;
@property (readwrite, strong) UIView *playerControlBar;
@property (readwrite, strong) AirplayActiveView *airplayIsActiveView;
@property (readwrite, strong) UIButton *airplayButton;
@property (readwrite, strong) MPVolumeView *volumeView;
@property (readwrite, strong) UIButton *fullScreenButton;
@property (readwrite, strong) UIButton *playPauseButton;
@property (readwrite, strong) UISlider *videoScrubber;
@property (readwrite, strong) UILabel *currentPositionLabel;
@property (readwrite, strong) UILabel *timeLeftLabel;
@property (readwrite, strong) UIProgressView *progressView;
@property (readwrite, strong) UIActivityIndicatorView *activityIndicator;
@property (readwrite, strong) UIButton *shareButton;
@end

@implementation VideoPlayerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _airplayIsActiveView = [[AirplayActiveView alloc] initWithFrame:CGRectZero];
        [_airplayIsActiveView setHidden:YES];
        [self addSubview:_airplayIsActiveView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont fontWithName:@"Forza-Medium" size:16.0f]];
        [_titleLabel setTextColor:[UIColor orangeColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setNumberOfLines:2];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_titleLabel];
        
        _playerControlBar = [[UIView alloc] init];
        [_playerControlBar setOpaque:NO];
        [_playerControlBar setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.8]];
      
        {
         
            _actionView= [[UIView alloc] initWithFrame:CGRectZero];
            [_actionView setOpaque:NO];
            [_actionView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.8]];
            
            _collectBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            _downLoadBtn =[[UIButton alloc]initWithFrame:CGRectMake(50, 0, 40, 40)];
            _shareBtn =[[UIButton alloc]initWithFrame:CGRectMake(100,0, 40, 40)];
            
            [_collectBtn setImage:[UIImage imageNamed:@"collectBlack"] forState:UIControlStateNormal];
            [_downLoadBtn setImage:[UIImage imageNamed:@"downLoadBlack"] forState:UIControlStateNormal];
            [_shareBtn setImage:[UIImage imageNamed:@"shareBtnBlack"] forState:UIControlStateNormal];
            
            [_actionView addSubview:_collectBtn];
            [_actionView addSubview:_downLoadBtn];
            [_actionView addSubview:_shareBtn];
            [_playerControlBar addSubview:_actionView];
        
        }

        
        
        
        _playPauseButton = [[UIButton alloc] init];
        [_playPauseButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
        [_playPauseButton setShowsTouchWhenHighlighted:YES];
        [_playerControlBar addSubview:_playPauseButton];
        
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setImage:[UIImage imageNamed:@"fullscreen-button"] forState:UIControlStateNormal];
        [_fullScreenButton setShowsTouchWhenHighlighted:YES];
        [_playerControlBar addSubview:_fullScreenButton];
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
        _progressView.trackTintColor = [UIColor darkGrayColor];
        [_playerControlBar addSubview:_progressView];
        
        _videoScrubber = [[UISlider alloc] init];
        [_videoScrubber setThumbImage:[UIImage imageNamed:@"3_4播放器_r12_c11"] forState:UIControlStateNormal];
        [_videoScrubber setMinimumTrackTintColor:[UIColor redColor]];
        [_videoScrubber setMaximumTrackImage:[UIImage imageNamed:@"transparentBar"] forState:UIControlStateNormal];
        [_videoScrubber setThumbTintColor:[UIColor whiteColor]];
        [_playerControlBar addSubview:_videoScrubber];
        
        _volumeView = [[MPVolumeView alloc] init];
        [_volumeView setShowsRouteButton:YES];
        [_volumeView setShowsVolumeSlider:NO];
        [_playerControlBar addSubview:_volumeView];
        
        // Listen to alpha changes to know when other routes are available
        for (UIButton *button in [_volumeView subviews]) {
            if (![button isKindOfClass:[UIButton class]]) {
                continue;
            }
            
            [button addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
            [self setAirplayButton:button];
        }
        
        _currentPositionLabel = [[UILabel alloc] init];
        [_currentPositionLabel setBackgroundColor:[UIColor clearColor]];
        [_currentPositionLabel setTextColor:[UIColor whiteColor]];
        [_currentPositionLabel setFont:[UIFont fontWithName:@"DINRoundCompPro" size:14.0f]];
        [_currentPositionLabel setTextAlignment:NSTextAlignmentCenter];
        [_playerControlBar addSubview:_currentPositionLabel];
        
        _timeLeftLabel = [[UILabel alloc] init];
        [_timeLeftLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLeftLabel setTextColor:[UIColor yellowColor]];
        [_timeLeftLabel setFont:[UIFont fontWithName:@"DINRoundCompPro" size:14.0f]];
        [_timeLeftLabel setTextAlignment:NSTextAlignmentCenter];
        [_playerControlBar addSubview:_timeLeftLabel];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityIndicator];

        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"share-button"] forState:UIControlStateNormal];
        [_shareButton setShowsTouchWhenHighlighted:YES];
        
        [self addSubview:_shareButton];
        self.controlsEdgeInsets = UIEdgeInsetsZero;
        
        
        self.backgroundColor=[UIColor blackColor];
        
        _playPreButton = [[UIButton alloc] init];
        [_playPreButton setTintColor:[UIColor whiteColor]];
        [_playPreButton setTitle:@"上一集" forState:UIControlStateNormal];
        
        [_playPreButton setShowsTouchWhenHighlighted:YES];
     
        [self addSubview:_playPreButton];
        
        
        _playNextButton = [[UIButton alloc] init];
        [_playNextButton setTintColor:[UIColor whiteColor]];

        [_playNextButton setTitle:@"下一集" forState:UIControlStateNormal];
         [_playNextButton setShowsTouchWhenHighlighted:YES];
     
        [self addSubview:_playNextButton];
        
        
        
        
    }
    return self;
}


- (void)dealloc
{
    [_airplayButton removeObserver:self forKeyPath:@"alpha"];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];

    CGRect insetBounds = CGRectInset(UIEdgeInsetsInsetRect(bounds, self.controlsEdgeInsets), _padding, _padding);
    
    
    
    CGSize titleLabelSize = [[_titleLabel text] sizeWithFont:[_titleLabel font]
                                           constrainedToSize:CGSizeMake(insetBounds.size.width, CGFLOAT_MAX)
                                               lineBreakMode:NSLineBreakByCharWrapping];
    
    UIImage *shareImage = [UIImage imageNamed:@"share-button"];
    
    if (!_fullscreen) {
        CGSize twoLineSize = [@"M\nM" sizeWithFont:[_titleLabel font]
                                 constrainedToSize:CGSizeMake(insetBounds.size.width, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        
        self.autoresizingMask = UIViewAutoresizingNone;
        
        [_titleLabel setFrame:CGRectMake(insetBounds.origin.x + self.padding,
                                         insetBounds.origin.y,
                                         insetBounds.size.width,
                                         titleLabelSize.height)];
        
        CGRect playerFrame = CGRectMake(0,
                                        0,
                                        bounds.size.width,
                                        bounds.size.height - twoLineSize.height - _padding - _padding);
        [_airplayIsActiveView setFrame:playerFrame];

        [_shareButton setFrame:CGRectMake(insetBounds.size.width - shareImage.size.width, insetBounds.origin.y, shareImage.size.width, shareImage.size.height)];
        
        
        
//        _playNextButton.hidden=YES;
//          _playPreButton.hidden=YES;
        
    } else {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [_titleLabel setFrame:CGRectMake(insetBounds.origin.x + self.padding,
                                         insetBounds.origin.y,
                                         insetBounds.size.width,
                                         titleLabelSize.height)];
        
        [_airplayIsActiveView setFrame:bounds];
        
        [_shareButton setFrame:CGRectMake(insetBounds.size.width - shareImage.size.width, insetBounds.origin.y+100, shareImage.size.width, shareImage.size.height)];
        
//        _playPreButton.hidden=NO;
//        _playNextButton.hidden=NO;
        
        
        [_playPreButton setFrame:CGRectMake(insetBounds.size.width - ButtonNextOrPre_width*2-30, 20, ButtonNextOrPre_width, ButtonNextOrPre_height)];
        
        [_playNextButton setFrame:CGRectMake(insetBounds.size.width- ButtonNextOrPre_width-10, 20, ButtonNextOrPre_width, ButtonNextOrPre_height)];

        _playPreButton.backgroundColor=[UIColor redColor];
        
    }
    
    [_playerControlBar setFrame:CGRectMake(bounds.origin.x,
                                           bounds.size.height - PLAYER_CONTROL_BAR_HEIGHT,
                                           bounds.size.width,
                                           PLAYER_CONTROL_BAR_HEIGHT)];
    
    [_activityIndicator setFrame:CGRectMake((bounds.size.width - _activityIndicator.frame.size.width)/2.0,
                                            (bounds.size.height - _activityIndicator.frame.size.width)/2.0,
                                            _activityIndicator.frame.size.width,
                                            _activityIndicator.frame.size.height)];
    
    [_playPauseButton setFrame:CGRectMake(10,
                                          20,
                                          PLAYER_CONTROL_BAR_HEIGHT-20,
                                          PLAYER_CONTROL_BAR_HEIGHT-20)];
    
    CGRect fullScreenButtonFrame = CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT+20,
                                              20,
                                              PLAYER_CONTROL_BAR_HEIGHT-20,
                                              PLAYER_CONTROL_BAR_HEIGHT-20);
    [_fullScreenButton setFrame:fullScreenButtonFrame];
    
    if (!_fullscreen) {
    [_actionView setFrame:CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT-80, 20, 100,40)];
        _shareBtn.hidden=YES;
    }else {
        _shareBtn.hidden=NO;
       [_actionView setFrame:CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT-140, 20, 150,40)];
    
    }
 
    CGRect routeButtonRect = CGRectZero;
    if ([_airplayButton alpha] > 0) {
        if ([_volumeView respondsToSelector:@selector(routeButtonRectForBounds:)]) {
            routeButtonRect = [_volumeView routeButtonRectForBounds:bounds];
        } else {
            routeButtonRect = CGRectMake(0, 0, 24, 18);
        }
        [_volumeView setFrame:CGRectMake(CGRectGetMinX(fullScreenButtonFrame) - routeButtonRect.size.width
                                         - ROUTE_BUTTON_ALIGNMENT_FUZZ,
                                         PLAYER_CONTROL_BAR_HEIGHT / 2 - routeButtonRect.size.height / 2,
                                         routeButtonRect.size.width,
                                         routeButtonRect.size.height)];
    }
    
    [_currentPositionLabel setFrame:CGRectMake(PLAYER_CONTROL_BAR_HEIGHT,
                                               ALIGNMENT_FUZZ+10,
                                               CURRENT_POSITION_WIDTH,
                                               PLAYER_CONTROL_BAR_HEIGHT)];
    [_timeLeftLabel setFrame:CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT - TIME_LEFT_WIDTH
                                        - routeButtonRect.size.width,
                                        ALIGNMENT_FUZZ,
                                        TIME_LEFT_WIDTH,
                                        PLAYER_CONTROL_BAR_HEIGHT)];
    [_timeLeftLabel setFrame:CGRectMake(_currentPositionLabel.frame.origin.x+TIME_LEFT_WIDTH+10,
                                        ALIGNMENT_FUZZ+10,
                                        TIME_LEFT_WIDTH,
                                        PLAYER_CONTROL_BAR_HEIGHT)];
//    CGRect scrubberRect = CGRectMake(PLAYER_CONTROL_BAR_HEIGHT + CURRENT_POSITION_WIDTH,
//                                     0,
//                                     bounds.size.width - (PLAYER_CONTROL_BAR_HEIGHT * 2) - TIME_LEFT_WIDTH -
//                                     CURRENT_POSITION_WIDTH - (TIME_LEFT_WIDTH - CURRENT_POSITION_WIDTH)
//                                     - routeButtonRect.size.width,
//                                     PLAYER_CONTROL_BAR_HEIGHT);
//    
    CGRect scrubberRect = CGRectMake(10,
                                     0,
                                     bounds.size.width - 20 ,
                                     20);

    
    [_videoScrubber setFrame:scrubberRect];
    [_progressView setFrame:[_videoScrubber trackRectForBounds:scrubberRect]];
}

- (void)setTitle:(NSString *)title
{
    [_titleLabel setText:title];
    [self setNeedsLayout];
}

- (void)setFullscreen:(BOOL)fullscreen
{
    if (_fullscreen == fullscreen) {
        return;
    }
    
    _fullscreen = fullscreen;
    
    [self setNeedsLayout];
}

- (CGFloat)heightForWidth:(CGFloat)width
{
    CGSize titleLabelSize = [@"M\nM" sizeWithFont:[_titleLabel font]
                                constrainedToSize:CGSizeMake(width - _padding - _padding, CGFLOAT_MAX)];
    return (width / 16 * 9) + titleLabelSize.height;
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)self.layer setPlayer:player];
    [_airplayIsActiveView setHidden:YES];
    [self addSubview:self.playerControlBar];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _airplayButton && [keyPath isEqualToString:@"alpha"]) {
        [self setNeedsLayout];
    }
}

@end
