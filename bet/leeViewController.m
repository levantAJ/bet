//
//  leeViewController.m
//  bet
//
//  Created by AJ Lee on 8/19/13.
//  Copyright (c) 2013 AJ Lee. All rights reserved.
//

#import "leeViewController.h"
#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>

@interface leeViewController ()

@end

@implementation leeViewController

bool train = false;
bool helocopter = false;
bool taxi = false;
bool plane = false;
bool bike = false;

NSString *selected = @"🔰";
NSString *sign = @"🚧";
NSString *lost = @"😭";
NSString *won = @"😘";
NSString *vTrain = @"🚊";
NSString *vTaxi = @"🚕";
NSString *vHelicopter = @"🚁";
NSString *vBike = @"🚲";
NSString *vRocket = @"🚀";

NSTimer *timer;
NSUInteger maxValue = 1150;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIFont *font = [UIFont fontWithName:@"04b_19" size:29];
    [lblTitle setFont:font];
    [btnStart.titleLabel setFont:font];
    [self initBet];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)initBet
{
    NSUInteger height = 310;
    NSUInteger top = 245;
    int left = -110;
    int distance = 57.5;
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    //UISlider *slider= (UISlider *)[vView viewWithTag:1];
    for (int i=0; i<5; i++) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(left+(i*distance), top, height, 0)];
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
        slider.transform = trans;
        slider.value = 0;
        slider.maximumValue = maxValue;
        slider.minimumValue = 0;
        slider.tag = i+1;
        [vView addSubview:slider];
    }
}


- (IBAction)btnStartTouchUpInside:(id)sender {
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    for (int i=0; i<5; i++) {
        UISlider *slide = (UISlider *)[vView viewWithTag:(i+1)];
        [slide setValue:0];
    }
    if (train == false && taxi == false && helocopter == false && bike == false && plane == false){
        [self showMessage:@"Please bet on a vehicle!!!":false:@""];
    }
    else{
        UIButton *button= (UIButton *)sender;
        [button setEnabled:false];
        [self startTimer];
        SystemSoundID soundID;
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"racing" ofType:@"wav"];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

- (IBAction)btnTrainTouchUpInside:(id)sender {
    [self newGame];
    [self setSign:11];
    train = true;
    taxi = false;
    helocopter = false;
    bike = false;
    plane = false;
}

- (IBAction)btnTaxiTouchUpInside:(id)sender {
    [self newGame];
    [self setSign:12];
    train = false;
    taxi = true;
    helocopter = false;
    bike = false;
    plane = false;
}

- (IBAction)btnHelocopterTouchUpInside:(id)sender {
    [self newGame];
    [self setSign:13];
    train = false;
    taxi = false;
    helocopter = true;
    bike = false;
    plane = false;
}

- (IBAction)btnBikeTouchUpInside:(id)sender {
    [self newGame];
    [self setSign:14];
    train = false;
    taxi = false;
    helocopter = false;
    bike = true;
    plane = false;
}

- (IBAction)btnPlaneTouchUpInside:(id)sender {
    [self newGame];
    [self setSign:15];
    train = false;
    taxi = false;
    helocopter = false;
    bike = false;
    plane = true;
}

-(void) timeCounter:(NSTimer*)tmr{
    int rad;
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    for (int i=0; i<5; i++) {
        UISlider *slider = (UISlider *)[vView viewWithTag:(i+1)];
        if ([slider value] >= maxValue) {
            [self stopTimer];
            return;
        }
        else{
            rad = arc4random() % 57 + slider.value;
            [slider setValue:rad];
        }
    }
}

-(void)stopTimer{
    [timer invalidate];
    timer = nil;
    bool isWin = false;
    int win = 0;
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    for (int i=0; i<5; i++) {
        UISlider *slide = (UISlider *)[vView viewWithTag:(i+1)];
        if ([slide value] >= maxValue) {
            win = i;
            break;
        }
    }
    NSString *vehicle;
    switch (win) {
        case 0:
            vehicle = vTrain;
            if(train)
            {
                isWin= true;
            }
            break;
        case 1:
            vehicle = vTaxi;
            if(taxi)
            {
                isWin = true;
            }
            break;
        case 2:
            vehicle = vHelicopter;
            if(helocopter)
            {
                isWin = true;
            }
            break;
        case 3:
            vehicle = vBike;
            if(bike)
            {
                isWin = true;
            }
            break;
        case 4:
            vehicle  = vRocket;
            if(plane)
            {
                isWin = true;
            }
            break;
    }
    if(isWin){
        [self showMessage:[NSString stringWithFormat: @"%@ first!\nVictory!", vehicle]:true:won];
    }
    else{
        [self showMessage:[NSString stringWithFormat: @"%@ first!\nSorry, you lost!", vehicle]:true:lost];
    }
    
    UIButton *button= (UIButton *)[vView viewWithTag:16];
    [button setEnabled:true];
}

-(void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeCounter:) userInfo:nil repeats:YES];
}

-(void)showMessage:(NSString *)message:(BOOL)comfirm:(NSString *)icon
{
    if(comfirm){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ BET %@", icon, icon]
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Back"
                                                  otherButtonTitles:@"New game",nil];
        [alertView show];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"💰 BET 💰"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    }
    if (buttonIndex == 1) {
        [self newGame];
    }
}

-(void)newGame
{
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    for (int i=0; i<5; i++) {
        UISlider *slide = (UISlider *)[vView viewWithTag:(i+1)];
        [slide setValue:0];
        UILabel *label = (UILabel *)[vView viewWithTag:(i+11)];
        [label setText:sign];
    }
    train = false;
    taxi = false;
    helocopter = false;
    bike = false;
    plane = false;
}

-(void)setSign:(NSInteger)tag
{
    UIView *vView = (UIView *)[self.view viewWithTag:18];
    UILabel *label = (UILabel*)[vView viewWithTag:11];
    [label setText:sign];
    label = (UILabel*)[vView viewWithTag:12];
    [label setText:sign];
    label = (UILabel*)[vView viewWithTag:13];
    [label setText:sign];
    label = (UILabel*)[vView viewWithTag:14];
    [label setText:sign];
    label = (UILabel*)[vView viewWithTag:15];
    [label setText:sign];
    switch (tag) {
        case 11:
            label = (UILabel*)[vView viewWithTag:11];
            [label setText:selected];
            break;
        case 12:
            label = (UILabel*)[vView viewWithTag:12];
            [label setText:selected];
            break;
        case 13:
            label = (UILabel*)[vView viewWithTag:13];
            [label setText:selected];
            break;
        case 14:
            label = (UILabel*)[vView viewWithTag:14];
            [label setText:selected];
            break;
        case 15:
            label = (UILabel*)[vView viewWithTag:15];
            [label setText:selected];
            break;
    }
}

@end
