//
//  ActivityItem.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/27.
//

import UIKit

/// `activitySheet` modifier 를 통해 `ActivityView`를 띄울 때 사용하는 activity
struct ActivityItem {
    var items: [Any]
    var activities: [UIActivity]
    var excludedTypes: [UIActivity.ActivityType]
    
    /// - Parameters:
    ///   - items: `UIActivityViewController` 를 통해 공유할 아이템
    ///   - activities: 시트에 포함시키고자 하는 커스텀 `UIActivity`
    init(
        items: Any...,
        activities: [UIActivity] = [],
        excludedTypes: [UIActivity.ActivityType] = []
    ) {
        self.items = items
        self.activities = activities
        self.excludedTypes = excludedTypes
    }
}
