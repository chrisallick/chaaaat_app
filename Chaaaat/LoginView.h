//
//  LoginView.h
//  Morbid Baest
//
//  Created by Chris Allick on 2/11/15.
//  Copyright (c) 2015 Chris Allick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImage+animatedGIF.h"

@protocol LoginViewDelegate
    @required
        -(void) didFinishRegistration;
@end

@interface LoginView : UIView <UITextFieldDelegate> {
    UIImageView *logo;
    UITextField *emailTextField;
    UIButton *loginButton;

    __weak id <LoginViewDelegate> loginViewDelegate;
}

@property (nonatomic, weak) id <LoginViewDelegate> loginViewDelegate;

-(void) initLogo;

@end
