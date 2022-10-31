//
//  UIViewController.Kuring.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK
import SwiftUI

extension UIViewController {
    func showOnboardingViewController() {
        guard Kuring.categoryStrings.isEmpty else { return }
        guard Kuring.isFirstRun || Kuring.appVersion == nil else { return }
        
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.isModalInPresentation = true
        self.present(onboardingVC, animated: true)
    }
    
    func showNoticeWebViewController(notice: Notice) {
        let noticeWebView = NoticeWebView(notice: notice)
        let vc = UIHostingController(rootView: noticeWebView)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
