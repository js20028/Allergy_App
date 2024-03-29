//
//  FetchProductInfo.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/11.
//

import Foundation
import Alamofire
import RxSwift

class FetchProductInfo {
    
//    var productNum = ""
    
    func fetchProduct(productNum: String, completion: @escaping((Error?, Response?) -> Void)) {
        
        let urlString = "http://apis.data.go.kr/B553748/CertImgListService/getCertImgListService?returnType=json&prdlstReportNo=\(productNum)&serviceKey=uH8nZxYXbYR18xBZzXcmcbEavFYjx5wSCOjPjyxAZp0S3qY6Y5f63gTjGzknfSB3W%2Fx%2BcQinV0lwlqfChKhHjQ%3D%3D"
        
        // url을 URL을 이용해서 알맞게 변환 실패시 completion error함수 호출
        guard let url = URL(string: urlString) else { return completion(NSError(domain: "why", code: 404), nil) }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil)
            .responseDecodable(of: Response.self) { response in
            
            if let error = response.error {
                print("에러")
                print(error)
                return completion(error, nil)
            }
            
            if let randomPosts = response.value {
                print("성공", productNum)
                
//                print("success \(randomPosts)")
                return completion(nil, randomPosts)
            }
        }
    }
    

    func fetchProductRx(productNum: String) -> Observable<Response> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchProduct(productNum: productNum, completion: {(error, product) in
                
                if let error = error {
                    print(error,"실패")
                    observer.onError(error)
                }
                
                if let product = product {
                    print(product, "프로덕트")
                    
                    if product.body.items.isEmpty {
                        print("에러났다")
                        observer.onError(NSError(domain: "why", code: 404))
                    } else {
                        print("보내졌다")
                        observer.onNext(product)
                    }
                    
                }
                
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
}
