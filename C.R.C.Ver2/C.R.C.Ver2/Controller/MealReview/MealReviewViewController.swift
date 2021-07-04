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
        mealReviewTableView.tableFooterView = UIView()
    }
    
    func apiCall() {
        let URL = "http://192.168.43.203:3000/review/check"
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
        
        cell.updateConstraintsIfNeeded()
        
        cell.mealReviewNicname.text = model?.review_data[indexPath.row].nickname ?? ""
        cell.mealReviewDate.text = model?.review_data[indexPath.row].review_time ?? ""
        cell.mealReviewTime.text = model?.review_data[indexPath.row].review_when ?? ""
        cell.mealReviewContent.text = model?.review_data[indexPath.row].content ?? ""
        
        let star = model?.review_data[indexPath.row].review_star ?? 0
        
        switch star {
        case star:
            cell.mealReviewStar1.image = .init(systemName: "star.fill")
            print("1")
            if star > 1 { fallthrough } else { break }
        case 2:
            cell.mealReviewStar2.image = .init(systemName: "star.fill")
            print("2")
            if star > 2 { fallthrough } else { break }
        case 3:
            cell.mealReviewStar3.image = .init(systemName: "star.fill")
            print("3")
            if star > 3 { fallthrough } else { break }
        case 4:
            cell.mealReviewStar4.image = .init(systemName: "star.fill")
            print("4")
            if star > 4 { fallthrough } else { break }
        case 5:
            cell.mealReviewStar5.image = .init(systemName: "star.fill")
            print("5")
        default:
            break
        }
        
        
        
        return cell
    }
    
    
    
    
}
