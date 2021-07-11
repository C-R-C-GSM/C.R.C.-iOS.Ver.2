//
//  MealReviewManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/11.
//

import Foundation

class MealReviewManager {
    static var mealReviewId: Int?
    
    // 급식 리뷰 Id
    class func getMealReviewId() -> Int {
        guard let id = mealReviewId else { return 0 }
        return id
    }
    
    class func saveMealReviewId(id: Int) {
        mealReviewId = id
    }
    
    class func removeMealReviewId() {
        mealReviewId = nil
    }
}
