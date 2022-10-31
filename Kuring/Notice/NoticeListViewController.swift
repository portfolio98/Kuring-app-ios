//
//  NoticeListViewController.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/29.
//

import SwiftUI


class NoticeListViewController: UIHostingController<HomeView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: HomeView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

