//
//  NoticeListModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/29.
//

import SwiftUI
import KuringSDK
import KuringCommons

class NoticeListModel: ObservableObject {
    // TODO: (FIXME) TEST
    @Published var error: String = ""
    
    @Published var currentType: NoticeType = .학사 {
        didSet {
            if noticeList[currentType] == nil { load() }
            currentNotices = noticeList[currentType] ?? []
        }
    }
    
    @Published var currentNotices: [Notice] = []
    @Published var readNoticeIDs: Set<String> = Kuring.readNoticeIDs
    @Published var bookmarkNotices: [Notice] = Kuring.noticeBookmark
    
    /// 각 타입별로 가져온 공지사항을 저장
    var noticeList: [NoticeType: [Notice]] = [:] {
        didSet {
            currentNotices = noticeList[currentType] ?? []
        }
    }
    
    @Published var isLoading = false
    
    var query: NoticeListQuery?
    
    // MARK: State
    /// 각 타입별로 어느 오프셋부터 공지사항을 가져오면 되는지 기록
    var offsetList: [NoticeType: Int] = [:]
    /// 각 타입별로 불러올 수 있는 공지사항이 더 존재하는지 여부 기록
    var hasNextList: [NoticeType: Bool] = [:]
    /// 한번 요청 시 가져올 수 있는 공지 사항 개수 최댓값
    let loadLimit = 20
    
    func refresh() {
        isLoading = true
        // 오프셋0부터 데이터 가져오기
        let params = NoticeListQuery.Params(
            type: currentType,
            offset: 0,
            max: UInt(loadLimit)
        )
        query = Kuring.createNoticeListQuery(with: params)
        query?.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notices):
                let noticeType = notices.first?.category ?? self.currentType
                var newNotices: [Notice] = []
                for notice in notices {
                    if notice.id == self.noticeList[noticeType]?.first?.id { return }
                    newNotices.append(notice)
                }
                guard !newNotices.isEmpty else { return }
                
                // 가져온 데이터 수 만큼 오프셋 값 추가
                self.offsetList[noticeType, default: 0] += newNotices.count
                
                // 가져온 데이터 array 가장 앞에 삽입
                // Update notices
                self.noticeList[noticeType, default: []].insert(contentsOf: newNotices, at: 0)
            case .failure(let error):
                Logger.error(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    func load() {
        if hasNextList[currentType] == false { return }
        isLoading = true
        let currentOffset = offsetList[currentType] ?? 0
        let params = NoticeListQuery.Params(
            type: currentType,
            offset: UInt(currentOffset),
            max: UInt(loadLimit)
        )
        query = Kuring.createNoticeListQuery(with: params)
        query?.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notices):
                // Update hasNext
                let noticeType = notices.first?.category ?? self.currentType
                let hasNext = notices.count >= self.loadLimit
                self.hasNextList.updateValue(hasNext, forKey: noticeType)
                
                // Update offset
                let prevOffset = self.offsetList[noticeType] ?? 0
                let currentOffset = prevOffset + notices.count
                self.offsetList.updateValue(currentOffset, forKey: noticeType)
                
                // Update notices
                var currentNotices = self.noticeList[noticeType] ?? []
                notices.forEach { currentNotices.append($0) }
                self.noticeList.updateValue(currentNotices, forKey: noticeType)
            case .failure(let error):
                Logger.error(error.localizedDescription)
                self.error = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func read(notice: Notice) {
        self.readNoticeIDs.insert(notice.id)
        Kuring.readNotice(notice)
    }
    
    func bookmark(notice: Notice) {
        if bookmarkNotices.contains(notice) {
            self.bookmarkNotices.removeAll { notice == $0 }
        } else {
            self.bookmarkNotices.append(notice)
        }
        Kuring.noticeBookmark = self.bookmarkNotices
    }
}
