//
//  GoogleAdsMobView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/26.
//

import GoogleMobileAds
import SwiftUI
import UIKit
import KuringSDK
import KuringCommons
import AppTrackingTransparency

struct BannerView: UIViewControllerRepresentable  {
    
    let size = CGSize(width: UIScreen.main.bounds.width - 35, height: 52)
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeFromCGSize(size))
        let viewController = UIViewController()
        view.adUnitID = Kuring.adUnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: size)
        
        ATTrackingManager.requestTrackingAuthorization { status in
            let gadRequest = GADRequest()
            DispatchQueue.main.async {
                gadRequest.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            }
            view.load(gadRequest)
        }
        
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            bannerView.isHidden = false
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            Logger.error("\(#function) \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            Logger.debug("bannerViewDidRecordImpression")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            Logger.debug("bannerViewWillPresentScreen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            Logger.debug("bannerViewWillDIsmissScreen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            Logger.debug("bannerViewDidDismissScreen")
        }
    }
}
