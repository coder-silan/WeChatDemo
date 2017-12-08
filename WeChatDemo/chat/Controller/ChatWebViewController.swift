//
//  ChatWebViewController.swift
//  WeChatDemo
//
//  Created by maomao on 2017/12/8.
//  Copyright © 2017年 maomao. All rights reserved.
//

import Foundation

import UIKit
import WebKit

private let kKVOContentSizekey: String = "contentSize"
private let kKVOTitlekey: String = "title"

class ChatWebViewController: UIViewController {
    var webView: WKWebView?
    var URLString: URL!
    var titleString: String?
    
    init(title: String? = nil, URLString: URL) {
        super.init(nibName: nil, bundle: nil)
        if let theTitle = title {
            self.title = theTitle
            self.titleString = theTitle
        }
        self.URLString = URLString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        guard let theWebView = self.webView else {
            return
        }
        
        theWebView.scrollView.bounces = true
        theWebView.scrollView.isScrollEnabled = true
        theWebView.navigationDelegate = self
        
        let urlRequest = URLRequest(url: URLString!)
        theWebView.load(urlRequest)
        self.view.addSubview(theWebView)
        
        theWebView.addObserver(self, forKeyPath:kKVOContentSizekey, options:.new, context:nil)
        theWebView.addObserver(self, forKeyPath:kKVOTitlekey, options:.new, context:nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case kKVOContentSizekey?:
            if let height = change![NSKeyValueChangeKey.newKey] as? Float {
                self.webView?.scrollView.contentSize.height = CGFloat(height)
            }
            break
        case kKVOTitlekey?:
            if self.titleString != nil {
                return
            }
            if let title = change![NSKeyValueChangeKey.newKey] as? String {
                self.title = title
            }
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath:kKVOContentSizekey)
        self.webView?.removeObserver(self, forKeyPath:kKVOTitlekey)
    }
}

// MARK: - @delegate WKNavigationDelegate
extension ChatWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: (@escaping (WKNavigationResponsePolicy) -> Void)){
        decisionHandler(.allow)
    }
}



