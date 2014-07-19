//
//  MVLinkedinClient.h
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVLinkedinPermission.h"
@protocol MVAuthorizationDelegate <NSObject>

-(void)authorizationClientDidCancel;
-(void)authorizationClientDidReceiveAccessCode:(NSString *)accessCode;
-(void)authorizationClientDidReceiveAccessToken:(NSString*)accessToken;
-(void)authorizationClientDidFailWithError:(NSError*)error;

@end


@protocol MVBasicProfileDelegate <NSObject>

-(void)basicProfileFetchDidFinished:(NSDictionary*)profileInfo;
-(void)basicProfileFetchDidFail:(NSError*)error;

@end

@interface MVLinkedinClient : NSObject
@property(strong,nonatomic)UIWebView            *webView;
@property(strong,nonatomic,readonly) NSString   *accessToken;

@property(nonatomic,strong)id <MVBasicProfileDelegate> basicProfileDelegate;
@property(nonatomic,strong)id <MVAuthorizationDelegate> authorizationDelegate;

+(id)linkedinClient;
-(void)authorizeWithWebview:(UIWebView *)webView
                     apiKey:(NSString *)apiKey
                     secret:(NSString *)secret
                      state:(NSString *)stateString
                redirectUrl:(NSString*)redirectUrl
                permissions:(NSArray*)permissions
               authDelegate:(id)delegate;

-(void)getBasicProfile:(id)delegate;

@end
