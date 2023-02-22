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
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var disposeBag = DisposeBag()
    let viewModel: LoadAllergyViewModel
    
    init(viewModel: LoadAllergyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = LoadAllergyViewModel()
        super.init(coder: coder)
    }
    
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
        collectionView.rx.contentInset.onNext(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel.loadAllergyList
            .bind(to: self.collectionView.rx.items(cellIdentifier: "LoadAllergyCell", cellType: LoadAllergyCollectionViewCell.self)) { index, item, cell in
                
                cell.productNameLabel.text = item.productName
                cell.createDateLabel.text = item.dateToString()
                cell.compareResultLabel.text = item.compareResult
                
                if item.compareResult == "알러지가 없습니다" {
                    cell.contentView.layer.borderColor = UIColor.primaryCGColor
                }
                
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(collectionView.rx.modelSelected(AllergyResult.self), collectionView.rx.itemSelected)
            .subscribe(onNext: { [weak self] (item, indexPath) in
                guard let loadDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "LoadAllergyDetailViewController") as? LoadAllergyDetailViewController else { return }
                let viewModel = LoadAllergyDetailViewModel(item)
                loadDetailVC.viewModel = viewModel
                
                viewModel.deleteButtonTapped
                    .subscribe(onNext: { [weak self] in
                        self?.viewModel.deleteIndex.onNext(indexPath)
                    })
                    .disposed(by: self!.disposeBag)
                
//                self?.navigationController?.pushViewController(loadDetailVC, animated: true)
                loadDetailVC.modalPresentationStyle = .fullScreen
                self?.present(loadDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension LoadAllergyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
}
