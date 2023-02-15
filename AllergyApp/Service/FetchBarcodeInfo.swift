//
//  FetchBarcodeInfo.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/10.
//

import Foundation
import Alamofire
import RxSwift

class FetchBarcodeInfo {
    
    
    
    func fetchBarcode(barcode: String, completion: @escaping((Error?, Barcode?) -> Void)) {
        
        let url = "http://openapi.foodsafetykorea.go.kr/api/e400aebdccb64dddbb17/C005/json/1/5/BAR_CD=\(barcode)"
        
        guard let barcodeURL = URL(string: url) else { return completion(NSError(domain: "what error", code: 404), nil) }
        
        AF.request(barcodeURL,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil)
        .responseDecodable(of: Barcode.self) { response in
            if let error = response.error {
                print(error)
                return completion(error, nil)
            }
            
            if let barcodeInfo = response.value {
                print("success fetch BarcodeInfo")
                return completion(nil, barcodeInfo)
            }
        }
        
    }
    
    func fetchBarcodeRx(barcode: String) -> Observable<Barcode> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchBarcode(barcode: barcode, completion: {(error, barcodeInfo) in
                
                if let error = error {
                    observer.onError(error)
                }
                
                if let barcodeInfo = barcodeInfo {
                    print(barcodeInfo, "바코드 인포")
                    observer.onNext(barcodeInfo)
                }
                
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}

