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
    
    let url = "http://openapi.foodsafetykorea.go.kr/api/sample/C005/json/1/5/BAR_CD=8801062521906"
    
    func fetchBarcode(completion: @escaping((Error?, [Barcode]?) -> Void)) {
        guard let barcodeURL = URL(string: url) else { return completion(NSError(domain: "what error", code: 404), nil) }
        
        AF.request(barcodeURL,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil)
        .responseDecodable(of: [Barcode].self) { response in
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
    
    func fetchBarcodeRx() -> Observable<[Barcode]> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchBarcode(completion: {(error, barcodeInfo) in
                
                if let error = error {
                    observer.onError(error)
                }
                
                //                if let barcodeInfo = barcodeInfo {
                //                    let memos = barcodeInfo.map { $0.toMemo() }
                //                    print(memos,"메모")
                //                    observer.onNext(memos)
                //                }
                
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}

