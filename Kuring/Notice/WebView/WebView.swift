//
//  WebView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/27.
//

import SwiftUI
import WebKit
import KuringSDK
import KuringCommons
import Lottie

struct WebView: UIViewRepresentable {
    
    @Binding var isLoading: Bool
    @Binding var isScrolling: Bool
    
    // MARK: - Properties
    let urlString: String
    let noticeID: String
    
    private var webView = WKWebView()
    
    init(
        isLoading: Binding<Bool>,
        isScrolling:  Binding<Bool>,
        urlString: String,
        noticeID: String
        
    ) {
        _isLoading = isLoading
        _isScrolling = isScrolling
        self.urlString = urlString
        self.noticeID = noticeID
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        
        loadWebView()
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func loadWebView() {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        Logger.debug("✅ 공지화면을 열었습니다: \(url)")
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebView {
    class Coordinator: NSObject, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate, WKUIDelegate
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            Logger.debug("webViewdidCommit", action: nil)
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Logger.debug("webViewdidFinish", action: nil)
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            Logger.debug("webViewdidFail", action: nil)

            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            Logger.error(error)
        }
        
        
        // MARK: - UIScrollViewDelegate
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isScrolling = true
            Logger.debug("\(#function)", action: nil)
        }
        
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                parent.isScrolling = false
            }
            
            Logger.debug("\(#function)", action: nil)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            withAnimation {
                parent.isScrolling = false
            }
            
            Logger.debug("\(#function)", action: nil)
        }
        
    }
}
