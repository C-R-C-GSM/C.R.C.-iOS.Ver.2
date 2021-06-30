//
//  TotalStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/11.
//

import UIKit
import Alamofire

class TotalStatusBoardViewController: UIViewController {

    var model: TotalStudentModel?
    
    @IBOutlet weak var comeStudentCount: UILabel!
    @IBOutlet weak var notComeStudentCount: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
    }
    
    func setting() {
        comeStudentCount.text = "\(model?.total_num ?? 0)"
        notComeStudentCount.text = "\(230 - (model?.total_num ?? 0))"
    }
    
    func apiCall() {
        let URL = "http://10.120.75.224:3000/check/total"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let data = response.data else { return }
                self.model = try? JSONDecoder().decode(TotalStudentModel.self, from: data)
                self.setting()
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        apiCall()
    }
    
}
