//
//  NoticeModel.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/07.
//

import Foundation

struct NoticeModel: Codable {
    let code: Int
    let notice_list: [Notice_List]
}

struct Notice_List: Codable {
    let noticeid: Int
    let notice_title: String
    let notice_content: String
    let notice_time: String
}
