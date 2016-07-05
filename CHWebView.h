//
//  CHWebView.h
//  AviationNews
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

typedef NS_ENUM(NSInteger, CHWebViewNavigationType) {
    CHWebViewNavigationTypeLinkClicked,
    CHWebViewNavigationTypeFormSubmitted,
    CHWebViewNavigationTypeBackForward,
    CHWebViewNavigationTypeReload,
    CHWebViewNavigationTypeFormResubmitted,
    CHWebViewNavigationTypeOther
};

typedef NS_ENUM(NSInteger, CHWebViewType) {
    CHWebViewType_UIWebView,
    CHWebViewType_WKWebView,
    CHWebViewType_AUTO
};

@class CHWebView;

typedef void(^webViewJSCompleteHandler)(id result, NSError *error);

@protocol CHWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(CHWebView *)webView shouldStartRequest:(NSURLRequest *)request navigationType:(CHWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(CHWebView *)webView;
- (void)webViewDidFinishLoad:(CHWebView *)webView;
- (void)webView:(CHWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface CHWebView : UIView

@property (nonatomic, weak) id<CHWebViewDelegate> web_delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(CHWebViewType)type;

- (BOOL)canGoBack;
- (void)goBack;
- (void)reload;
- (UIScrollView *)getScrollView;
- (CHWebViewType)getWebType;
- (void)stopLoading;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL;

- (NSString *)getAbsoluteString;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(webViewJSCompleteHandler)completionHandler;

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;

@end
