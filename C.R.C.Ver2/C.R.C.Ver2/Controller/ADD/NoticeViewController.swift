//
//  NoticeViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/07.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class NoticeViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    var model: NoticeModel?

    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var noticeCreateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkApiCall()
        setting()
        indicatorAutolayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
    }
    
    func setting() {
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.tableFooterView = UIView()
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
                        self.noticeCreateButton.isEnabled = true
                        self.noticeCreateButton.tintColor = .init(named: "Primary Color")
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
        
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/notice/check"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(NoticeModel.self, from: data)
                } catch(let error) {
                    self.failAlert(messages: error.localizedDescription)
                    print(error.localizedDescription)
                }
                self.indicator.stopAnimating()
                self.noticeTableView.reloadData()
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error)
            }
        }
    }
    
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model?.notice_list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as! NoticeTableViewCell
        
        cell.noticeTitle.text = model?.notice_list[indexPath.row].notice_title ?? ""
        cell.noticeDate.text = model?.notice_list[indexPath.row].notice_time ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NoticeManager.saveNoticeTitle(title: model?.notice_list[indexPath.row].notice_title ?? "")
        NoticeManager.saveNoticeContent(content: model?.notice_list[indexPath.row].notice_content ?? "")
        NoticeManager.saveNoticeDate(date: model?.notice_list[indexPath.row].notice_time ?? "")
    }
    
}
