//
//  MealSuggestionBoardCreateViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/06.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MealSuggestionBoardCreateViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    @IBOutlet weak var mealSuggestionNickname: UITextField!
    @IBOutlet weak var mealSuggestionTitle: UITextField!
    @IBOutlet weak var mealSuggestionContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        checkText() ? apiCall(title: mealSuggestionTitle.text ?? "", content: mealSuggestionContent.text ?? "", nickname: mealSuggestionNickname.text ?? "") : failAlert(messages: "빈칸을 모두 채워주세요.")
    }
    
    func setting() {
        mealSuggestionTitle.delegate = self
        mealSuggestionContent.delegate = self
        mealSuggestionNickname.delegate = self
        
        mealSuggestionTitle.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        mealSuggestionNickname.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요. ex) 정인교입큰이", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        mealSuggestionContent.layer.cornerRadius = 5
        mealSuggestionContent.layer.borderWidth = 0.5
        mealSuggestionContent.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
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
        
        let alert = UIAlertController(title: "건의 등록 성공", message: "건의 등록 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkText() -> Bool {
        if (mealSuggestionTitle.text == "") || (mealSuggestionContent.text == "내용을 입력하세요") || (mealSuggestionContent.text == "") || (mealSuggestionNickname.text == "") {
            return false
        }
        return true
    }
    
    func apiCall(title: String, content: String, nickname: String) {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-34-189-53.ap-northeast-2.compute.amazonaws.com:3000/suggest/register"
        let token = TokenManager.getToken()
        let PARAM: Parameters = [
            "title": title,
            "content": content,
            "nickname": nickname
        ]
        AF.request(URL, method: .post, parameters: PARAM, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dic = value as? NSDictionary, let code = dic["code"] as? Int else { return }
                switch code {
                case 0:
                    self.sucessAlert()
                default:
                    self.failAlert(messages: "건의를 등록할 수 없습니다.")
                }
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension MealSuggestionBoardCreateViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = UIColor.lightGray
        }
    }
}
