//
//  MealReviewViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/13.
//

import UIKit
import Alamofire

class MealReviewViewController: UIViewController {
    
    var model: MealReviewModel?
    
    @IBOutlet weak var mealReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
    }
    
    func setting() {
        mealReviewTableView.delegate = self
        mealReviewTableView.dataSource = self
    }
    
    func apiCall() {
        let URL = "http://10.120.75.224:3000/review/check"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(MealReviewModel.self, from: data)
                } catch (let error) {
                    print(error.localizedDescription)
                }
                self.mealReviewTableView.reloadData()
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
        
        cell.updateConstraintsIfNeeded()
        print("1")
        
        return cell
    }
    
    
    
    
}
