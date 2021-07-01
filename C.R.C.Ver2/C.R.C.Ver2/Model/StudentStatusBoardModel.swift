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
    let data: [Data]
}

struct Data: Codable {
    let student_data: Int
    let student_name: String
    let student_check: Int
}
