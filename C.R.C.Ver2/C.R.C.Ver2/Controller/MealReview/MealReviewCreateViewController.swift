//
//  MealReviewCreateViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/02.
//

import UIKit
import DropDown
import Alamofire
import NVActivityIndicatorView

class MealReviewCreateViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    let dropDown = DropDown()
    
    var mealReviewStarCount = 0
    
    @IBOutlet weak var mealReviewNickname: UITextField!
    @IBOutlet weak var mealReviewContent: UITextView!
    @IBOutlet weak var mealReviewTime: UIButton!
    @IBOutlet weak var mealReviewDate: UIDatePicker!
    
    @IBOutlet weak var mealReviewStar1: UIButton!
    @IBOutlet weak var mealReviewStar2: UIButton!
    @IBOutlet weak var mealReviewStar3: UIButton!
    @IBOutlet weak var mealReviewStar4: UIButton!
    @IBOutlet weak var mealReviewStar5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd "
        let mealReviewDateData = formatter.string(from: mealReviewDate.date)
        
        checkText() ? apiCall(review_star: mealReviewStarCount, content: mealReviewContent.text ?? "", nickname: mealReviewNickname.text ?? "", when: mealReviewTime.titleLabel?.text ?? "", day: mealReviewDateData) : failAlert(messages: "빈칸을 모두 채우세요.")
    }
    
    @IBAction func mealReviewTimeButton(_ sender: UIButton) {
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            self.mealReviewTime.setTitle(item, for: .normal)
        }
    }
    
    func setting() {
        mealReviewNickname.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요. ex) 정인교입큰이", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        mealReviewNickname.delegate = self
        mealReviewContent.delegate = self
        mealReviewContent.layer.cornerRadius = 5
        mealReviewContent.layer.borderWidth = 0.5
        mealReviewContent.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        mealReviewStar1.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar2.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar3.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar4.addTarget(self, action: #selector(star), for: .touchUpInside)
        mealReviewStar5.addTarget(self, action: #selector(star), for: .touchUpInside)
        
        mealReviewTime.layer.cornerRadius = 5
        
        mealReviewDate.minimumDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        mealReviewDate.maximumDate = Date()
        
        dropDown.dataSource = ["아침", "점심","저녁"]
        dropDown.anchorView = mealReviewTime
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
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
        
        let alert = UIAlertController(title: "리뷰 등록 성공", message: "리뷰 등록 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkText() -> Bool {
        if (mealReviewNickname.text == "") || (mealReviewContent.text == "내용을 입력하세요.") || (mealReviewContent.text == "") || (mealReviewTime.titleLabel?.text == "") {
            return false
        }
        return true
    }
    
    @objc func star(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            sender.tintColor = .systemYellow
            mealReviewStarCount += 1
        } else {
            sender.isSelected = false
            sender.tintColor = .lightGray
            mealReviewStarCount -= 1
        }
    }
    
    func apiCall(review_star: Int, content: String, nickname: String, when: String, day: String) {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-34-189-53.ap-northeast-2.compute.amazonaws.com:3000/review/register"
        let token = TokenManager.getToken()
        let PARAM: Parameters = [
            "review_star":review_star,
            "content": content,
            "nickname": nickname,
            "when": when,
            "day": day
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
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension MealReviewCreateViewController: UITextViewDelegate, UITextFieldDelegate {
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
