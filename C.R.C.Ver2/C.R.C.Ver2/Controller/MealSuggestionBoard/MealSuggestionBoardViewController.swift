//
//  MealSuggestionBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/03.
//

import UIKit
import Alamofire

class MealSuggestionBoardViewController: UIViewController {

    var model: MealSuggestionBoardModel?
    
    @IBOutlet weak var mealSuggestionBoardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
        apiCall()
    }
    
    func setting() {
        mealSuggestionBoardTableView.delegate = self
        mealSuggestionBoardTableView.dataSource = self
        mealSuggestionBoardTableView.tableFooterView = UIView()
    }
    
    func apiCall() {
        let URL = "http://10.120.75.224:3000/suggest/check"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(MealSuggestionBoardModel.self, from: data)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                self.mealSuggestionBoardTableView.reloadData()
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MealSuggestionBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.suggest_data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealSuggestionBoardTableViewCell", for: indexPath) as! MealSuggestionBoardTableViewCell
        
        cell.mealSuggestionTitle.text = model?.suggest_data[indexPath.row].title ?? ""
        cell.mealSuggestionDate.text = model?.suggest_data[indexPath.row].suggest_time ?? ""
        
        return cell
    }
}
