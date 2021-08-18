//
//  MealReviewAnswerViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/11.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MealReviewAnswerViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)

    @IBOutlet weak var mealReviewAnswerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        checkText() ? apiCall(answer: mealReviewAnswerTextView.text) : failAlert(messages: "빈칸을 모두 채우세요.")
    }
    
    func setting() {
        mealReviewAnswerTextView.delegate = self
        mealReviewAnswerTextView.layer.cornerRadius = 5
        mealReviewAnswerTextView.layer.borderWidth = 0.5
        mealReviewAnswerTextView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func failAlert(messages: String) {
        indicator.stopAnimating()
        
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sucessAlert() {
        indicator.stopAnimating()
        
        let alert = UIAlertController(title: "답변 달기 성공", message: "답변 달기 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkText() -> Bool {
        if (mealReviewAnswerTextView.text == "답글을 입력하세요.") || (mealReviewAnswerTextView.text == "") {
            return false
        }
        return true
    }
    
    func apiCall(answer: String) {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/review/reply"
        let token = TokenManager.getToken()
        let reviewid = MealReviewManager.getMealReviewId()
        let PARAM: Parameters = [
            "reviewid": reviewid,
            "reply": answer
        ]
        AF.request(URL, method: .post, parameters: PARAM, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dic = value as? NSDictionary, let code = dic["code"] as? Int else { return }
                switch code {
                case 0:
                    self.sucessAlert()
                default:
                    self.failAlert(messages: "답변을 등록할 수 없습니다.")
                }
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension MealReviewAnswerViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "답글을 입력하세요." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "답글을 입력하세요."
            textView.textColor = UIColor.lightGray
        }
    }
}
