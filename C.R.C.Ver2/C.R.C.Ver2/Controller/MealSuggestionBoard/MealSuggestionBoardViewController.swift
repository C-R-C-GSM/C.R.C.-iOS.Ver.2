//
//  MealSuggestionBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/03.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MealSuggestionBoardViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    var model: MealSuggestionBoardModel?
    
    @IBOutlet weak var mealSuggestionBoardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
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
        
        mealSuggestionBoardCollectionView.delegate = self
        mealSuggestionBoardCollectionView.dataSource = self
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
    
    func apiCall() {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-34-189-53.ap-northeast-2.compute.amazonaws.com:3000/suggest/check"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(MealSuggestionBoardModel.self, from: data)
                } catch(let error) {
                    self.failAlert(messages: error.localizedDescription)
                    print(error.localizedDescription)
                }
                self.indicator.stopAnimating()
                self.mealSuggestionBoardCollectionView.reloadData()
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension MealSuggestionBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.suggest_data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealSuggestionBoardCollectionViewCell", for: indexPath) as! MealSuggestionBoardCollectionViewCell
    
        cell.contentView.backgroundColor = .white
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 4)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        
        
        cell.mealSuggestionTitle.text = model?.suggest_data[indexPath.row].title ?? ""
        cell.mealSuggestionDate.text = model?.suggest_data[indexPath.row].suggest_time ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MealSuggestionBoardManager.saveMealSuggestionId(id: model?.suggest_data[indexPath.row].suggestid ?? 0)
        MealSuggestionBoardManager.saveMealSuggestionTitle(title: model?.suggest_data[indexPath.row].title ?? "")
        MealSuggestionBoardManager.saveMealSuggestionDate(date: model?.suggest_data[indexPath.row].suggest_time ?? "")
        MealSuggestionBoardManager.saveMealSuggestionContent(content: model?.suggest_data[indexPath.row].content ?? "")
        MealSuggestionBoardManager.saveMealSuggestionNickname(nickname: model?.suggest_data[indexPath.row].nickname ?? "")
        MealSuggestionBoardManager.saveMealSuggestionAnswer(answer: model?.suggest_data[indexPath.row].reply ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 60, height: 60)
    }
}
