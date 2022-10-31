//
//  SettingListViewController.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/05.
//

import SwiftUI
import Combine

class SettingListViewController: UIHostingController<SettingList> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: SettingList())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
