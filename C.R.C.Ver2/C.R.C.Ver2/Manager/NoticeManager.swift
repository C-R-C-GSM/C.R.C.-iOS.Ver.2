//
//  NoticeManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/09.
//

import Foundation

class NoticeManager {
    static var noticeId: Int?
    static var noticeTitle: String?
    static var noticeContent: String?
    static var noticeData: String?
    
    
    // 공지사항 아이디
    class func getNoticeId() -> Int {
        guard let id = noticeId else { return 0 }
        return id
    }
    
    class func saveNoticeId(id: Int) {
        noticeId = id
    }
    
    class func removeNoticeId() {
        noticeId = nil
    }
    
    
    // 공지사항 제목
    class func getNoticeTitle() -> String {
        guard let title = noticeTitle else { return "" }
        return title
    }
    
    class func saveNoticeTitle(title: String) {
        noticeTitle = title
    }
    
    class func removeNoticeTitle() {
        noticeTitle = nil
    }
    
    
    // 공지사항 내용
    class func getNoticeContent() -> String {
        guard let content = noticeContent else { return "" }
        return content
    }
    
    class func saveNoticeContent(content: String) {
        noticeContent = content
    }
    
    class func removeNoticeContent() {
        noticeContent = nil
    }
    
    // 공지사항 작성 날짜
    class func getNoticeDate() -> String {
        guard let date = noticeData else { return "" }
        return date
    }
    
    class func saveNoticeDate(date: String) {
        noticeData = date
    }
    
    class func removeNoticeDate() {
        noticeData = nil
    }
}
