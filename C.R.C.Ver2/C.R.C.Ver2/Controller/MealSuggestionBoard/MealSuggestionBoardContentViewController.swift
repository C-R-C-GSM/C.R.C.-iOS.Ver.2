//
//  MealSuggestionBoardContentViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/11.
//

import UIKit
import Alamofire

class MealSuggestionBoardContentViewController: UIViewController {

    @IBOutlet weak var mealSuggestionTitle: UILabel!
    @IBOutlet weak var mealSuggestionDate: UILabel!
    @IBOutlet weak var mealSuggestionNickname: UILabel!
    @IBOutlet weak var mealSuggestionContent: UILabel!
    @IBOutlet weak var mealSuggestionAnswer: UILabel!
    
    @IBOutlet weak var mealSuggestionAnswerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        checkApiCall()
    }
    
    func setting() {
        mealSuggestionTitle.text = MealSuggestionBoardManager.getMealSuggestionTitle()
        mealSuggestionDate.text = MealSuggestionBoardManager.getMealSuggestionDate()
        mealSuggestionNickname.text = MealSuggestionBoardManager.getMealSuggestionNickname()
        mealSuggestionContent.text = MealSuggestionBoardManager.getMealSuggestionContent()
        mealSuggestionAnswer.text = MealSuggestionBoardManager.getMealSuggestionAnswer()
    }
    
    func checkApiCall() {
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/check/role"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary, let code = dic["code"] as? Int {
                    switch code {
                    case -600:
                        break
                    default:
                        self.mealSuggestionAnswerButton.isEnabled = true
                        self.mealSuggestionAnswerButton.tintColor = .init(named: "Primary Color")
                    }
                }
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
