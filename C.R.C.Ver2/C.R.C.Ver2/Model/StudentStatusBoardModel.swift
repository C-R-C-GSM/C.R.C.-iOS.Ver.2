//
//  StudentStatusBoardModel.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/30.
//

import Foundation

struct StudentStatusBoardModel: Codable {
    let success: Bool
    let code: Int
    let oneData: [OneData]
}

struct OneData: Codable {
    let student_data1: Int
    let student_name1: String
    let check1: Int
}
