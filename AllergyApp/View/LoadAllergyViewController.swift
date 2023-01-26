//
//  LoadAllergyViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoadAllergyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let allergyList = ["알러지1", "알러지2", "알러지3", "알러지4", "알러지5", "알러지6", "알러지1", "알러지2", "알러지3", "알러지4", "알러지5", "알러지6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.registerXib()
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "LoadAllergyCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "LoadAllergyCell")
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension LoadAllergyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allergyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LoadAllergyCell", for: indexPath) as? LoadAllergyCollectionViewCell else { return UICollectionViewCell() }
        cell.allergyName.text = self.allergyList[indexPath.row]
        
        return cell
    }
}

extension LoadAllergyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 150)
    }
}
