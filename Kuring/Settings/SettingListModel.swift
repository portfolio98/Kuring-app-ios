//
//  SettingViewModel.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/05.
//

import SwiftUI
import KuringSDK
import KuringCommons

enum URLLink: String {
    case whatsNew = "https://kuring.notion.site/iOS-eef51c986b7f4320b97424df3f4a5e3c"
    case privacy = "https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c"
    case terms = "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9"
    case team = "https://bit.ly/3v2c5eg"
    case instagram = "https://bit.ly/3I30uiG"
    case kakaotalk = "https://bit.ly/3p5LZTI"
    
    func openURL() {
        if let url = URL(string: self.rawValue) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

class SettingListModel: ObservableObject {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @Published var showsSubscription: Bool = false
    @Published var showsFeedback: Bool = false
    @Published var showsOpensource: Bool = false

    @Published var isOnSwitch: Bool = Kuring.isCustomNotificationEnabled {
        didSet {
            Kuring.isCustomNotificationEnabled = isOnSwitch
            Logger.debug("didSwitchCustomNotification: \(Kuring.isCustomNotificationEnabled)")
        }
    }
    
}
