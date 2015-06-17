//
//  ChatView.m
//  Morbid Baest
//
//  Created by Chris Allick on 2/15/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import "ChatView.h"

@implementation ChatView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        csv = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 45.0, self.frame.size.width, self.frame.size.height-216.0-35.0-45.0+2.0)];
        [self addSubview:csv];
        
        entry = [[UITextView alloc] initWithFrame:CGRectMake(0.0, csv.frame.origin.y+csv.frame.size.height-2.0, self.frame.size.width-60.0, 35.0)];
        [entry.layer setBorderColor:[UIColor blackColor].CGColor];
        [entry.layer setBorderWidth:2.0];
        [entry setDelegate:self];
        [entry setTextContainerInset:UIEdgeInsetsMake(10.0, 3.0, 0.0, 0.0)];
        [entry setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self addSubview:entry];
        
        send = [UIButton buttonWithType:UIButtonTypeCustom];
        [send setFrame:CGRectMake(self.frame.size.width-60.0, csv.frame.origin.y+csv.frame.size.height-2.0, 60.0, 35.0)];
        [send setBackgroundColor:[UIColor blackColor]];
        [send setTag:1];
        [send addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [send addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        [send addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
        [send addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchDragExit];
        [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        NSAttributedString *attributedString =
        [[NSAttributedString alloc]
         initWithString:@"send"
         attributes:
         @{
           NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:15.0],
           NSKernAttributeName : @(1.4),
           NSForegroundColorAttributeName: [UIColor whiteColor]
           }];
        
        [send setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        
        [self addSubview:send];
        
        chat_items = 0;
        next_y = 5.0;
        chatmessages = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        keyboard_height = 0.0;
        
        
    }
    return self;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboard_height = keyboardSize.height;
}

// reformat text with attributed string.
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [entry setTypingAttributes:@{           NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:17.0],
                                            NSKernAttributeName : @(1.4)}];
    return YES;
}

-(void) addChats:(NSArray *)chats {
    int i = 0;
    for( NSDictionary *chatitem in chats ) {
        if( i >= chat_items ) {
            [self addChatItem:[chatitem objectForKey:@"msg"] withInits:[chatitem objectForKey:@"inits"]];
        }
        i++;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 block:^ {
        [self getChat];
    } repeats:NO];
}

-(void) getChat {
    NSDictionary *params = @{@"email":@"chrisallick@gmail.com",@"index":@1};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/chat/new/", HOST] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *response = [responseObject objectForKey:@"result"];
        if ([response isEqualToString:@"success"]) {
            NSLog(@"successfully retreived chats");
            [self addChats:[responseObject objectForKey:@"chats"]];
        } else if ([response isEqualToString:@"error"]) {
            NSLog(@"error");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [entry becomeFirstResponder];
}

-(void) postChat:(NSDictionary *)new_msg {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/chat/new/", HOST] parameters:new_msg success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *response = [responseObject objectForKey:@"result"];
        if ([response isEqualToString:@"success"]) {
            NSLog(@"successfully posted chat");
        } else if ([response isEqualToString:@"error"]) {
            NSLog(@"error");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) addChatItem:(NSString *)_msg withInits:(NSString *)_inits {
    UIView *chat = [[UIView alloc] initWithFrame:CGRectMake(0.0, next_y, self.frame.size.width, 30.0)];
    
    UIImageView *chatIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 0.0, 32.0, 32.0)];
    [chatIcon setImage:[UIImage imageNamed:@"face_circle.png"]];
    [chat addSubview:chatIcon];
    
    UILabel *chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 1.0, 30.0, 30.0)];
    [chatLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSAttributedString *attributedString =
    [[NSAttributedString alloc]
     initWithString:_inits
     attributes:
     @{
       NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:10.0],
       NSKernAttributeName : @(1.6)
       }];
    
    [chatLabel setAttributedText:attributedString];
    
    
    [chat addSubview:chatLabel];
    
    // set the y on this to move text down.
    UILabel *chatText = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 0.0, self.frame.size.width-40.0, 20)];

    attributedString =
    [[NSAttributedString alloc]
     initWithString:_msg
     attributes:
     @{
       NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:15.0],
       NSKernAttributeName : @(1.4)
       }];
    
    [chatText setAttributedText:attributedString];
    
    [chatText setNumberOfLines:0];
    [chatText sizeToFit];
    [chat addSubview:chatText];
    [chat sizeToFit];
    [csv addSubview:chat];
    
    float offset = chatText.frame.size.height - 30.0;
    if( offset < 0 ) {
        offset = 0.0;
    }
    
    next_y = next_y + offset + 30.0 + 5.0;
    
    [csv setContentSize:CGSizeMake(self.frame.size.width, next_y)];

    CGPoint bottomOffset = CGPointMake(0, csv.contentSize.height - csv.bounds.size.height);
    if( bottomOffset.y > 0 ) {
        [csv setContentOffset:bottomOffset animated:YES];
    }

    chat_items++;
}

-(void) openMenu {
    [entry resignFirstResponder];
    
    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [self setFrame:CGRectMake(100.0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
}

-(void) closeMenu {
    [entry resignFirstResponder];

    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [self setFrame:CGRectMake(0.0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
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
                             if( [[entry text] length] > 0 ) {
                                 [self addChatItem:[entry text] withInits:[[NSUserDefaults standardUserDefaults] objectForKey:@"initials"]];
                                 
                                 NSDictionary *new_msg = @{
                                                           @"email":[[NSUserDefaults standardUserDefaults] objectForKey:@"email"],
                                                           @"msg":[entry text],
                                                           @"inits":[[NSUserDefaults standardUserDefaults] objectForKey:@"initials"]
                                                           };
                                 [chatmessages addObject:new_msg];
                                 [self postChat:new_msg];
                                 
                                 [entry setText:@""];
                             }
                         }
                     }];
}

@end
