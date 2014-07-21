//
//  ViewController.m
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()
{
    NSString *requestTokenURLString;
    NSString *    accessTokenURLString;
    NSString *    userLoginURLString;
    NSString *    linkedInCallbackURL;
    
    NSURL *requestTokenURL;
    NSURL *    accessTokenURL;
    NSURL *    userLoginURL;
    

}
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController
#define apikey @"8pfycdymm7yq"
#define secretkey @"s7o1Qm7CXPe6wdDP"
#define redirect @"http://www.prosimity.com"
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewContainer.hidden=YES;


    
//    [[NXOAuth2AccountStore sharedStore] setClientID:apikey
//                                             secret:secretkey
//                                   authorizationURL:[NSURL URLWithString:@"https://www.linkedin.com/uas/oauth2/authorization"]
//                                           tokenURL:[NSURL URLWithString:@"https://api.linkedin.com/uas/oauth2/accessToken"]
//                                        redirectURL:[NSURL URLWithString:@"http://www.prosimity.com"]
//                                     forAccountType:@"linkedin"];
    
 
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSArray *arr =[NSArray arrayWithObjects:kMVPermissionBasicProfile,kMVPermissionDetailProfile,kMVPermissionEmail,kMVPermissionMessages, kMVPermissionGroups, kMVPermissionConnections, kMVPermissionContactInfo, nil];
    [[MVLinkedinClient linkedinClient]authorizeWithWebview:self.webView apiKey:apikey secret:secretkey state:@"DWMALKDFADJFALDJ" redirectUrl:redirect permissions:arr authDelegate:self];
    
    
//    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"linkedin"
//                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
//                                       // Open a web view or similar
//                                       NSURLRequest *request = [NSURLRequest requestWithURL:preparedURL];                                       
//                                       [self.webView loadRequest:request];
//                                       
//                                   }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)btnBasicProfileAction:(id)sender {
    [[MVLinkedinClient linkedinClient]getBasicProfile:self];
}

- (IBAction)btnDetailProfileAction:(id)sender {
    [[MVLinkedinClient linkedinClient]getDetailProfile:nil delegate:self];
}

- (IBAction)btnSendMessageAction:(id)sender {
}

- (IBAction)btnSendInvitationAction:(id)sender {
}

- (IBAction)btnProfilePicAction:(id)sender {
    [[MVLinkedinClient linkedinClient]getProfilePic:nil delegate:self];
}

#pragma mark - Authorization delegate

-(void)authorizationClientDidCancel{
    
}
-(void)authorizationClientDidReceiveAccessCode:(NSString *)accessCode{
    
}
-(void)authorizationClientDidReceiveAccessToken:(NSString*)accessToken
{
        [self.view bringSubviewToFront:self.viewContainer];
        self.viewContainer.hidden=NO;
   
}
-(void)authorizationClientDidFailWithError:(NSError*)error{
    
}

#pragma mark - Basic Profile Delegate

-(void)basicProfileFetchDidFinished:(NSDictionary*)profileInfo{
    
}
-(void)basicProfileFetchDidFail:(NSError*)error{
  
    
}

#pragma mark - Detail Profile Delegates

-(void)detailProfileFetchDidFinished:(NSDictionary*)profileInfo{
    
}
-(void)detailProfileFetchDidFail:(NSError*)error{
    
}

#pragma mark - Profile Pic Delegates

-(void)profilePicFetchDidFinished:(NSDictionary*)profilePicUrl{
    
}
-(void)profilePicFetchDidFailed:(NSError*)error{
    
}



@end
