//
//  SearchViewController.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/06.
//

import SwiftUI
import Combine


class SearchViewController: UIHostingController<SearchView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: SearchView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


