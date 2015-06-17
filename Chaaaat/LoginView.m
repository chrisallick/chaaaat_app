//
//  LoginView.m
//  Morbid Baest
//
//  Created by Chris Allick on 2/11/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize loginViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"datgif" withExtension:@"gif"];
        UIImage *logoAnimatedImage = [UIImage animatedImageWithAnimatedGIFURL:filePath];
        logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-logoAnimatedImage.size.width/4.0, self.frame.size.height/2.0-logoAnimatedImage.size.height/4.0, logoAnimatedImage.size.width/2.0, logoAnimatedImage.size.height/2.0)];
        [logo setImage:logoAnimatedImage];
        [self addSubview:logo];
        
        UIImage *registerbuttonImage = [UIImage imageNamed:@"register_button.png"];
        
        emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-registerbuttonImage.size.width/4.0, 320.0, registerbuttonImage.size.width/2.0, 40.0)];
        [emailTextField setReturnKeyType:UIReturnKeyDone];
        [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [emailTextField setBackgroundColor:[UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1]];
        [emailTextField setTextColor:[UIColor colorWithRed:0.047 green:0.000 blue:0.000 alpha:1]];
        [emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [emailTextField setTextAlignment:NSTextAlignmentCenter];
        [emailTextField setFont:[UIFont fontWithName:@"Futura-Medium" size:15.0]];
        [emailTextField setDelegate:self];
        [emailTextField setAlpha:0.0];
        [self addSubview:emailTextField];

        NSAttributedString *attributedString =
        [[NSAttributedString alloc]
         initWithString:@"Enter your email"
         attributes:
         @{
           NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:15.0],
           NSKernAttributeName : @(1.4)
           }];
        
        [emailTextField setAttributedPlaceholder:attributedString];

        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(self.frame.size.width/2.0-registerbuttonImage.size.width/4.0, 390.0, registerbuttonImage.size.width/2.0, registerbuttonImage.size.height/2.0)];
        [loginButton setBackgroundImage:registerbuttonImage forState:UIControlStateNormal];
        [loginButton setAdjustsImageWhenHighlighted:NO];
        [loginButton setUserInteractionEnabled:YES];
        [loginButton setTag:1];
        [loginButton setAlpha:0.0];
        [loginButton addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [loginButton addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        [loginButton addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchDragExit];
        [self addSubview:loginButton];


    }
    return self;
}

-(void) initLogo {
    [UIView animateWithDuration: 0.300
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [logo setFrame:CGRectMake(logo.frame.origin.x, logo.frame.origin.y-120, logo.frame.size.width, logo.frame.size.height)];
                         if( !IS_IPHONE_5 ) {
                             [logo setFrame:CGRectMake(logo.frame.origin.x, logo.frame.origin.y-50, logo.frame.size.width, logo.frame.size.height)];
                         }
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration: 0.300
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [emailTextField setAlpha:1.0];
                                              [loginButton setAlpha:1.0];
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

// reformat text with attributed string.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [emailTextField setTypingAttributes:@{           NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:15.0],
                                            NSKernAttributeName : @(1.4),
                                            NSForegroundColorAttributeName : [UIColor colorWithRed:0.047 green:0.000 blue:0.000 alpha:1]}];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setPlaceholder:nil];
    
    if( IS_IPHONE_5 ) {
        [UIView beginAnimations:@"animationOn" context:NULL];
        [UIView setAnimationDuration:.150];
        [logo setFrame:CGRectMake(logo.frame.origin.x, logo.frame.origin.y-20, logo.frame.size.width, logo.frame.size.height)];
        [emailTextField setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y-20.0, textField.frame.size.width, textField.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if( IS_IPHONE_5 ) {
        [UIView beginAnimations:@"animationOn" context:NULL];
        [UIView setAnimationDuration:.150];
        [logo setFrame:CGRectMake(logo.frame.origin.x, logo.frame.origin.y+20, logo.frame.size.width, logo.frame.size.height)];
        [emailTextField setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y+20.0, textField.frame.size.width, textField.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( [textField.text length] ) {
        [textField resignFirstResponder];
        
        return YES;
    } else {
        return NO;
    }
}

-(void) registerUser {
    NSDictionary *params = @{ @"email":emailTextField.text };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/users/user/new/", HOST] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *response = [responseObject objectForKey:@"result"];
        if ([response isEqualToString:@"success"]) {
            NSLog(@"successfully registered");
            
            NSDictionary *user_details = [responseObject objectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registered"];
            [[NSUserDefaults standardUserDefaults] setValue:[user_details objectForKey:@"email"] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setValue:[user_details objectForKey:@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setValue:[user_details objectForKey:@"uid"] forKey:@"uid"];
            
            NSArray *words = [[user_details objectForKey:@"name"] componentsSeparatedByString:@" "];
            NSMutableArray *newWords = [NSMutableArray array];
            for (NSString *word in words) {
                if (word.length > 0) {
                    [newWords addObject:[[word substringToIndex:1] uppercaseString]];
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:[newWords componentsJoinedByString:@""] forKey:@"initials"];

            [loginViewDelegate didFinishRegistration];
        } else if ([response isEqualToString:@"error"]) {
            NSLog(@"error");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        //[loginViewDelegate didFinishRegistration];
    }];
}

-(void)onTouchUp:(UIButton *)sender {
    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [sender setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

-(void)onTouchDown:(UIButton *)sender {
    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [sender setTransform:CGAffineTransformMakeScale(0.85, 0.85)];
    [UIView commitAnimations];
}

-(void)onTap:(UIButton *)sender {
    [UIView animateWithDuration: 0.150
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [sender setTransform:CGAffineTransformIdentity];
                     }
                     completion:^(BOOL finished) {
                         if( [sender tag] == 1 ) {
                             [self registerUser];
                         }
                     }];
}

@end
