//
//  MealSuggestionBoardModel.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/05.
//

import Foundation

struct MealSuggestionBoardModel: Codable {
    let code: Int
    let suggest_data: [Suggest_Data]
}

struct Suggest_Data: Codable {
    let suggestid: Int
    let title: String
    let content: String
    let suggest_time: String
    let nickname: String
    let reply: String
}
