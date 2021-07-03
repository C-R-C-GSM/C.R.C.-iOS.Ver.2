//
//  MealReviewCreateViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/02.
//

import UIKit
import iOSDropDown
import Alamofire

class MealReviewCreateViewController: UIViewController {

    @IBOutlet weak var mealReviewNickname: UITextField!
    @IBOutlet weak var mealReviewContent: UITextView!
    @IBOutlet weak var mealReviewTime: DropDown!
    
    @IBOutlet weak var mealReviewStar1: UIButton!
    @IBOutlet weak var mealReviewStar2: UIButton!
    @IBOutlet weak var mealReviewStar3: UIButton!
    @IBOutlet weak var mealReviewStar4: UIButton!
    @IBOutlet weak var mealReviewStar5: UIButton!
    
    var mealReviewStarCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        
        mealReviewNickname.delegate = self
        mealReviewContent.delegate = self
        
        mealReviewStar1.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar2.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar3.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar4.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar5.addTarget(self, action: #selector(star), for: .touchUpInside)
        
        mealReviewTime.optionArray = ["아침", "점심", "저녁"]
        mealReviewTime.selectedRowColor = .init(named: "Primary Color") ?? UIColor.black
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        checkText() ? apiCall(review_star: mealReviewStarCount, content: mealReviewContent.text ?? "", nickname: mealReviewNickname.text ?? "", when: mealReviewTime.text ?? "") : failAlert(messages: "빈칸을 모두 채우세요.")
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "리뷰 등록 성공", message: "리뷰 등록 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkText() -> Bool {
        if (mealReviewNickname.text == "") || (mealReviewContent.text == "") || (mealReviewTime.text == "") {
            return false
        }
        return true
    }
    
    @objc func star(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            sender.setImage(.init(systemName: "star.fill"), for: .normal)
            mealReviewStarCount += 1
        } else {
            sender.isSelected = false
            sender.setImage(.init(systemName: "star"), for: .normal)
            mealReviewStarCount -= 1
        }
        print(mealReviewStarCount)
    }
    
    func apiCall(review_star: Int, content: String, nickname: String, when: String) {
        let URL = "http://192.168.219.126:3000/review/register"
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
                guard let dic = value as? NSDictionary, let code = dic["code"] as? Int else { return }
                switch code {
                case 0:
                    self.sucessAlert()
                default:
                    self.failAlert(messages: "리뷰를 등록할 수 없습니다.")
                }
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension MealReviewCreateViewController: UITextViewDelegate, UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
