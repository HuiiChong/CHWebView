//
//  CHWebView.m
//  AviationNews
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 庄春辉. All rights reserved.
//

#import "CHWebView.h"
#import <WebKit/WebKit.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface CHWebView ()<UIWebViewDelegate,WKNavigationDelegate>
{
    UIWebView                       *_webView;
    WKWebView                       *_webView_wk;
    
    WKWebViewJavascriptBridge       *_bridge_wk;
    WebViewJavascriptBridge         *_bridge;
}

@end

@implementation CHWebView

#pragma mark life cycle

- (instancetype)initWithFrame:(CGRect)frame type:(CHWebViewType)type
{
    self = [super initWithFrame:frame];
    if(self){
        __weak typeof(self) _weakSelf = self;
        
        if(type==CHWebViewType_UIWebView){
            //初始化uiwebview
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _webView.delegate = _weakSelf;
            _webView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_webView];
            
            _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
            [_bridge setWebViewDelegate:_weakSelf];
        }else if(type==CHWebViewType_WKWebView){
            //初始化wkwebview
            WKWebViewConfiguration *_webConfig = [[WKWebViewConfiguration alloc] init];
            _webConfig.preferences = [[WKPreferences alloc] init];
            _webConfig.preferences.javaScriptEnabled = YES;
            
            _webView_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:_webConfig];
            _webView_wk.navigationDelegate = _weakSelf;
            _webView_wk.backgroundColor = [UIColor whiteColor];
            [self addSubview:_webView_wk];
            
            _bridge_wk = [WKWebViewJavascriptBridge bridgeForWebView:_webView_wk];
            [_bridge_wk setWebViewDelegate:_weakSelf];
        }else {
            Class wkWebViewClass = NSClassFromString(@"WKWebView");
            if(wkWebViewClass) {
                //初始化wkwebview
                WKWebViewConfiguration *_webConfig = [[WKWebViewConfiguration alloc] init];
                _webConfig.preferences = [[WKPreferences alloc] init];
                _webConfig.preferences.javaScriptEnabled = YES;
                
                _webView_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:_webConfig];
                _webView_wk.navigationDelegate = _weakSelf;
                _webView_wk.backgroundColor = [UIColor whiteColor];
                [self addSubview:_webView_wk];
                
                _bridge_wk = [WKWebViewJavascriptBridge bridgeForWebView:_webView_wk];
                [_bridge_wk setWebViewDelegate:_weakSelf];
            }else {
                //初始化uiwebview
                _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                _webView.delegate = _weakSelf;
                _webView.backgroundColor = [UIColor whiteColor];
                [self addSubview:_webView];
                
                _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
                [_bridge setWebViewDelegate:_weakSelf];
            }
        }
    }
    return self;
}

#pragma mark public method

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if(_webView) {
        [_webView setBackgroundColor:backgroundColor];
    }else if(_webView_wk){
        [_webView_wk setBackgroundColor:backgroundColor];
    }
}

- (void)setHidden:(BOOL)hidden
{
    if(_webView) {
        _webView.hidden = hidden;
    }else if(_webView_wk){
        _webView_wk.hidden = hidden;
    }
}

- (BOOL)canGoBack
{
    if(_webView) {
        return [_webView canGoBack];
    }else if(_webView_wk){
        return [_webView_wk canGoBack];
    }
    return NO;
}

- (void)goBack
{
    if(_webView) {
        [_webView goBack];
    }else if(_webView_wk){
        [_webView_wk goBack];
    }
}

- (void)reload
{
    if(_webView){
        [_webView reload];
    }else if(_webView_wk){
        [_webView_wk reload];
    }
}

- (UIScrollView *)getScrollView
{
    if(_webView){
        return _webView.scrollView;
    }else {
        return _webView_wk.scrollView;
    }
}

- (CHWebViewType)getWebType
{
    if(_webView){
        return CHWebViewType_UIWebView;
    }else{
        return CHWebViewType_WKWebView;
    }
}

- (void)stopLoading
{
    if(_webView){
        [_webView stopLoading];
    }else if(_webView_wk){
        [_webView_wk stopLoading];
    }
}

- (void)loadRequest:(NSURLRequest *)request
{
    if(_webView) {
        [_webView loadRequest:request];
    }else if(_webView_wk){
        [_webView_wk loadRequest:request];
    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if(_webView) {
        [_webView loadHTMLString:string baseURL:baseURL];
    }else if(_webView_wk){
        [_webView_wk loadHTMLString:string baseURL:baseURL];
    }
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL
{
    if(_webView_wk){
        [_webView_wk loadFileURL:URL allowingReadAccessToURL:readAccessURL];
    }
}

- (NSString *)getAbsoluteString
{
    if(_webView) {
        return _webView.request.URL.absoluteString;
    }else if(_webView_wk){
        return _webView_wk.URL.absoluteString;
    }
    return @"";
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(webViewJSCompleteHandler)completionHandler
{
    if(_webView) {
        if(completionHandler){
            completionHandler([_webView stringByEvaluatingJavaScriptFromString:javaScriptString],nil);
        }else{
            [_webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        }
    }else if(_webView_wk) {
        [_webView_wk evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if(completionHandler){
                completionHandler(result, error);
            }
        }];
    }
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler
{
    if(_bridge){
        [_bridge registerHandler:handlerName handler:handler];
    }else if(_bridge_wk){
        [_bridge_wk registerHandler:handlerName handler:handler];
    }
}

#pragma mark uiwebview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    __weak typeof(self) _weakSelf = self;
    return [self.web_delegate webView:_weakSelf shouldStartRequest:request navigationType:(CHWebViewNavigationType)navigationType];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webViewDidStartLoad:_weakSelf];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webViewDidFinishLoad:_weakSelf];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webView:_weakSelf didFailLoadWithError:error];
}

#pragma mark wkwebview delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    __weak typeof(self) _weakSelf = self;
    if([self.web_delegate webView:_weakSelf shouldStartRequest:navigationAction.request navigationType:(CHWebViewNavigationType)navigationAction.navigationType]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webViewDidStartLoad:_weakSelf];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webViewDidFinishLoad:_weakSelf];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    __weak typeof(self) _weakSelf = self;
    [self.web_delegate webView:_weakSelf didFailLoadWithError:error];
}

@end
