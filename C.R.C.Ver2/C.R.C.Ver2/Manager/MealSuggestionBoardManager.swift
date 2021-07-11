//
//  MealSuggestionBoardManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/11.
//

import Foundation

class MealSuggestionBoardManager {
    static var mealSuggestionId: Int?
    static var mealSuggestionTitle: String?
    static var mealSuggestionContent: String?
    static var mealSuggestionDate: String?
    static var mealSuggestionNickname: String?
    
    // 급식 건의 Id
    class func getMealSuggestionId() -> Int {
        guard let id = mealSuggestionId else { return 0 }
        return id
    }
    
    class func saveMealSuggestionId(id: Int) {
        mealSuggestionId = id
    }
    
    class func removeMealSuggestionId() {
        mealSuggestionId = nil
    }
    
    
    // 급식 건의 제목
    class func getMealSuggestionTitle() -> String {
        guard let title = mealSuggestionTitle else { return "" }
        return title
    }
    
    class func saveMealSuggestionTitle(title: String) {
        mealSuggestionTitle = title
    }
    
    class func removeMealSuggestionTitle() {
        mealSuggestionTitle = nil
    }
    
    
    // 급식 건의 내용
    class func getMealSuggestionContent() -> String {
        guard let content = mealSuggestionContent else { return "" }
        return content
    }
    
    class func saveMealSuggestionContent(content: String) {
        mealSuggestionContent = content
    }
    
    class func removeMealSuggestionContent() {
        mealSuggestionContent = nil
    }
    
    // 급식 건의 작성 날짜
    class func getMealSuggestionDate() -> String {
        guard let date = mealSuggestionDate else { return "" }
        return date
    }
    
    class func saveMealSuggestionDate(date: String) {
        mealSuggestionDate = date
    }
    
    class func removeMealSuggestionDate() {
        mealSuggestionDate = nil
    }
    
    
    // 급식 건의 닉네임
    class func getMealSuggestionNickname() -> String {
        guard let nickname = mealSuggestionNickname else { return "" }
        return nickname
    }
    
    class func saveMealSuggestionNickname(nickname: String) {
        mealSuggestionNickname = nickname
    }
    
    class func removeMealSuggestionNickname() {
        mealSuggestionNickname = nil
    }
}
