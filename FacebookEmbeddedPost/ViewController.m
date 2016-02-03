//
//  ViewController.m
//  FacebookEmbeddedPost
//
//  Created by Singh, Manoj on 3/02/2016.
//  Copyright © 2016 Singh, Manoj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    _webView = [[UIWebView alloc] init];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityIndicatorView.color = [UIColor blueColor];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];

    // Add constraints for webview
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0];

    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];

    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0];

    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20.0];

    [self.view addConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];

    // Add constraints for activity Indiacator.
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];

    [self.view addConstraints:@[centerXConstraint, centerYConstraint]];


    // Hi Facebook team, We are taking here 3 approchs to load HTML file to webview.

    // First approach:
    // Get content for FacebookPost.html file and load the html string to webview.    // This is our requirment.

    NSError *error = nil;
    NSString *facebookPostFilePath = [[NSBundle mainBundle] pathForResource:@"FacebookPost" ofType:@".html"];
    NSString *facebookPost = [NSString stringWithContentsOfFile:facebookPostFilePath encoding:NSUTF8StringEncoding error:&error];

    /*
    if (error == nil) {
        if (facebookPost) {
            [_webView loadHTMLString:facebookPost baseURL:nil];              //First Approach  [Not Working]
        }
    }
    else {
        NSLog(@"File Error : %@", error.userInfo);
    }
    return;

     */


    // Second Approach:  load html file from NSBundle.
    NSURL *facebookFileUrl = [NSURL fileURLWithPath:facebookPostFilePath];

    // Third Approach:  load html file from web server. Same html file we are hosting insdie webserver.
    // Webserver path in Mac: /Library/WebServer/Documents
    NSURL *facebookWebServerUrl = [NSURL URLWithString:@"http://10.65.77.160/FacebookPost.html"];  // IP Address of my mac to load the file in my mobile.

//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:facebookFileUrl];             // Second Approach     [Not Working]
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:facebookWebServerUrl];          // Third Approach      [Working]

    [_webView loadRequest:urlRequest];

}


#pragma mark UIWebViewDelegate methods.

- (void)webViewDidStartLoad:(UIWebView *)webView {

    [_activityIndicatorView startAnimating];
    NSLog(@"WebView Start Loading...");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [_activityIndicatorView stopAnimating];
    NSLog(@"WebView Failed To Load With Error: %@", error.userInfo);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [_activityIndicatorView stopAnimating];
    NSLog(@"WebView Loaded...");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
