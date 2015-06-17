//
//  ViewController.h
//  Chaaaat
//
//  Created by Chris Allick on 6/17/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginView.h"
#import "ChatView.h"

@interface ViewController : UIViewController <LoginViewDelegate> {
    LoginView *lv;
    ChatView *cv;
    UIImageView *logo;
}


@end

