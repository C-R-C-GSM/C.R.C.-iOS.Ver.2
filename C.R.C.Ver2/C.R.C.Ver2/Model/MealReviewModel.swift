//
//  MealReviewModel.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/01.
//

import Foundation

struct MealReviewModel: Codable {
    let code: Int
    let review_data: [Review_Data]
}

struct Review_Data: Codable {
    let reviewid: Int
    let nickname: String
    let review_star: Float
    let content: String
    let empathy: Int
    let review_time: String
    let review_when: String
    let reply: String
}
