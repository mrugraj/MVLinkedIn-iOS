//
//  ViewController.m
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
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
   
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSArray *arr =[NSArray arrayWithObjects:kMVPermissionBasicProfile,kMVPermissionDetailProfile,kMVPermissionEmail,kMVPermissionMessages, kMVPermissionGroups, kMVPermissionConnections, kMVPermissionContactInfo, nil];
    [[MVLinkedinClient linkedinClient]authorizeWithWebview:self.webView apiKey:apikey secret:secretkey state:@"DWMALKDFADJFALDJ" redirectUrl:redirect permissions:arr authDelegate:self];
    
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
}

- (IBAction)btnSendMessageAction:(id)sender {
}

- (IBAction)btnSendInvitationAction:(id)sender {
}

- (IBAction)btnProfilePicAction:(id)sender {
    
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


@end
