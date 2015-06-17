//
//  ViewController.m
//  Chaaaat
//
//  Created by Chris Allick on 6/17/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logoAnimatedImage = [UIImage imageNamed:@"logo_smallest.png"];
    logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-logoAnimatedImage.size.width/4.0, self.view.frame.size.height/2.0-logoAnimatedImage.size.height/4.0, logoAnimatedImage.size.width/2.0, logoAnimatedImage.size.height/2.0)];
    [logo setImage:logoAnimatedImage];
    [self.view addSubview:logo];

    if( !lv ) {
        lv = [[LoginView alloc] initWithFrame:self.view.frame];
        [lv setLoginViewDelegate:self];
        [self.view addSubview:lv];
    }

    if( !cv ) {
        cv = [[ChatView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:cv];
    }
    
    [cv setHidden:YES];
    [lv setHidden:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        if( [[NSUserDefaults standardUserDefaults] boolForKey:@"registered"] ) {
            NSLog(@"registered");
            [self startUp];
        } else {
            NSLog(@"not registered.");
            [logo setHidden:YES];
            [lv setHidden:NO];
            [lv initLogo];
        }
    } repeats:NO];
}

-(void) openChat {
    NSLog(@"opening chat");
    
    [cv getChat];
    [cv setHidden:NO];
}

-(void) startUp {
    [self openChat];
}

-(void) didFinishRegistration {
    [UIView animateWithDuration: 0.300
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [lv setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration: 0.300
                                               delay: 0.200
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                          }
                                          completion:^(BOOL finished) {
                                              [lv setHidden:YES];
                                              
                                              [self startUp];
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
