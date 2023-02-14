//
//  MainViewModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    let disposeBag = DisposeBag()
    
    let fetchBarcodeInfo: FetchBarcodeInfo
    let fetchProductInfo: FetchProductInfo
    
    let barcodeSubject = PublishSubject<String>()
    let productSubject = PublishSubject<String>()
    
    var testString: String = ""
    var barcode = ""
    
    let checkResultButtonTapped = PublishSubject<Void>()
    let scanButtonTapped = PublishSubject<Void>()
    
    init(fetchBarcodeInfo: FetchBarcodeInfo, fetchProductInfo: FetchProductInfo) {
        self.fetchBarcodeInfo = fetchBarcodeInfo
        self.fetchProductInfo = fetchProductInfo
        
        // 팝업창 확인하기 클릭시 결과 확인
        checkResultButtonTapped.subscribe(onNext: { _ in
            fetchBarcodeInfo.fetchBarcodeRx(barcode: self.barcode)
                .subscribe(onNext: { [weak self] barcode in
                    print(barcode.C005.row[0].PRDLST_REPORT_NO, "바코드 성공")
                    self?.productSubject.onNext(barcode.C005.row[0].PRDLST_REPORT_NO)
                }, onError: { error in
                    print(error, "fetchBarcodeRx 실패")
                })
                .disposed(by: self.disposeBag)
        })
        
        
        
        // 바코드 스캔하기 버튼 클릭시 바코드 인식
        barcodeSubject.bind(onNext: { code in
            self.barcode = code
        }).disposed(by: disposeBag)
        
        
        
        
        productSubject
            .subscribe(onNext: { productNum in
                fetchProductInfo.fetchNews(productNum: productNum)
                    .subscribe(onNext: { [weak self] product in
                        self?.testString = product
                        print(product, "완성")
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
