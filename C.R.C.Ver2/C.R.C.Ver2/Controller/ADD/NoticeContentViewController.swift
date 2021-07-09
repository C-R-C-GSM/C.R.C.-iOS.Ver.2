//
//  NoticeContentViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/09.
//

import UIKit

class NoticeContentViewController: UIViewController {

    @IBOutlet weak var noticeContentTitle: UILabel!
    @IBOutlet weak var noticeContentDate: UILabel!
    @IBOutlet weak var noticeContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    func setting() {
        noticeContentTitle.text = NoticeManager.getNoticeTitle()
        noticeContentDate.text = NoticeManager.getNoticeDate()
        noticeContent.text = NoticeManager.getNoticeContent()
    }
    
}
