//
//  ChatView.h
//  Morbid Baest
//
//  Created by Chris Allick on 2/15/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "NSTimer+Blocks.h"

@interface ChatView : UIView <UITextViewDelegate> {
    UIScrollView *csv;
    int chat_items;
    float next_y;
    
    UITextView *entry;
    UIButton *send;
    
    float keyboard_height;
    
    NSMutableArray *chatmessages;
}

-(void) getChat;

@end
