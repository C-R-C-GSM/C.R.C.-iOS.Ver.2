//
//  NoticeManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/09.
//

import Foundation

class NoticeManager {
    static var noticeTitle: String?
    static var noticeContent: String?
    static var noticeDate: String?
    
    
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
        guard let date = noticeDate else { return "" }
        return date
    }
    
    class func saveNoticeDate(date: String) {
        noticeDate = date
    }
    
    class func removeNoticeDate() {
        noticeDate = nil
    }
}
