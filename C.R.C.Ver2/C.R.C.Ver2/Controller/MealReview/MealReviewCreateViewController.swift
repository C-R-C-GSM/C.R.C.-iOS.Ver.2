//
//  MealReviewCreateViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/02.
//

import UIKit
import Alamofire

class MealReviewCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func apiCall(review_star: Int, content: String, nickname: String, when: String) {
        let URL = "http://192.168.35.159:3000/register"
        let token = TokenManager.getToken()
        let PARAM: Parameters = [
            "review_star":review_star,
            "content": content,
            "nickname": nickname,
            "when": when
        ]
        AF.request(URL, method: .post, parameters: PARAM, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
