//
//  MealReviewViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/13.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MealReviewViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    var model: MealReviewModel?
    
    @IBOutlet weak var mealReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
        checkApiCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
    }
    
    func setting() {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 0.9)
        
        mealReviewTableView.delegate = self
        mealReviewTableView.dataSource = self
        mealReviewTableView.tableFooterView = UIView()
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
                        self.mealReviewTableView.allowsSelection = true
                    }
                }
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func apiCall() {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/review/check"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(MealReviewModel.self, from: data)
                } catch (let error) {
                    self.failAlert(messages: "오류가 발생했습니다.")
                    print(error.localizedDescription)
                }
                self.indicator.stopAnimating()
                self.mealReviewTableView.reloadData()
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension MealReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.review_data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealReviewTableViewCell", for: indexPath) as! MealReviewTableViewCell
        
        
        
        cell.mealReviewNicname.text = model?.review_data[indexPath.row].nickname ?? ""
        cell.mealReviewDate.text = model?.review_data[indexPath.row].review_time ?? ""
        cell.mealReviewTime.text = model?.review_data[indexPath.row].review_when ?? ""
        cell.mealReviewContent.text = model?.review_data[indexPath.row].content ?? ""
        cell.mealReviewAnswer.text = model?.review_data[indexPath.row].reply ?? ""
        
        let star = model?.review_data[indexPath.row].review_star ?? 0
        
        switch star {
        case 0:
            cell.mealReviewStar1.tintColor = UIColor.lightGray
            cell.mealReviewStar2.tintColor = UIColor.lightGray
            cell.mealReviewStar3.tintColor = UIColor.lightGray
            cell.mealReviewStar4.tintColor = UIColor.lightGray
            cell.mealReviewStar5.tintColor = UIColor.lightGray
        case 1:
            print("1")
            cell.mealReviewStar1.tintColor = UIColor.systemYellow
            cell.mealReviewStar2.tintColor = UIColor.lightGray
            cell.mealReviewStar3.tintColor = UIColor.lightGray
            cell.mealReviewStar4.tintColor = UIColor.lightGray
            cell.mealReviewStar5.tintColor = UIColor.lightGray
        case 2:
            print("2")
            cell.mealReviewStar1.tintColor = UIColor.systemYellow
            cell.mealReviewStar2.tintColor = UIColor.systemYellow
            cell.mealReviewStar3.tintColor = UIColor.lightGray
            cell.mealReviewStar4.tintColor = UIColor.lightGray
            cell.mealReviewStar5.tintColor = UIColor.lightGray
        case 3:
            print("3")
            cell.mealReviewStar1.tintColor = UIColor.systemYellow
            cell.mealReviewStar2.tintColor = UIColor.systemYellow
            cell.mealReviewStar3.tintColor = UIColor.systemYellow
            cell.mealReviewStar4.tintColor = UIColor.lightGray
            cell.mealReviewStar5.tintColor = UIColor.lightGray
        case 4:
            print("4")
            cell.mealReviewStar1.tintColor = UIColor.systemYellow
            cell.mealReviewStar2.tintColor = UIColor.systemYellow
            cell.mealReviewStar3.tintColor = UIColor.systemYellow
            cell.mealReviewStar4.tintColor = UIColor.systemYellow
            cell.mealReviewStar5.tintColor = UIColor.lightGray
        case 5:
            print("5")
            cell.mealReviewStar1.tintColor = UIColor.systemYellow
            cell.mealReviewStar2.tintColor = UIColor.systemYellow
            cell.mealReviewStar3.tintColor = UIColor.systemYellow
            cell.mealReviewStar4.tintColor = UIColor.systemYellow
            cell.mealReviewStar5.tintColor = UIColor.systemYellow
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MealReviewManager.saveMealReviewId(id: model?.review_data[indexPath.row].reviewid ?? 0)
    }
}
