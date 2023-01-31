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

    var disposeBag = DisposeBag()
    let viewModel = LoadAllergyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.registerXib()
        self.bindUI()
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "LoadAllergyCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "LoadAllergyCell")
    }
    
    private func configureCollectionView() {
        collectionView.rx.contentInset.onNext(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel.loadAllergyList
            .bind(to: self.collectionView.rx.items(cellIdentifier: "LoadAllergyCell", cellType: LoadAllergyCollectionViewCell.self)) { index, item, cell in
                cell.allergyName.text = item.productName
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let loadDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "LoadAllergyDetailViewController") as? LoadAllergyDetailViewController else { return }
                
                self?.navigationController?.pushViewController(loadDetailVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
}

extension LoadAllergyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 100)
    }
}
