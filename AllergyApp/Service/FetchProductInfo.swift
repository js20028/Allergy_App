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
    
    let urlString = "http://apis.data.go.kr/B553748/CertImgListService/getCertImgListService?pageNo=1&numOfRows=10&returnType=json&prdlstReportNo=1978061400972&serviceKey=uH8nZxYXbYR18xBZzXcmcbEavFYjx5wSCOjPjyxAZp0S3qY6Y5f63gTjGzknfSB3W%2Fx%2BcQinV0lwlqfChKhHjQ%3D%3D"
    
    func downloadPost(completion: @escaping((Error?, Response?) -> Void)) {
        
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
                print("성공")
//                print("success \(randomPosts)")
                return completion(nil, randomPosts)
            }
  
        }
    }
    

    func fetchNews() -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            
            self.downloadPost(completion: {(error, randomPosts) in
                
                if let error = error {
                    print(error,"실패")
                    observer.onError(error)
                }
                
                if let randomPosts = randomPosts {
                    
                    let nutrient = randomPosts.body.items[0].item.nutrient
                    let allergy = randomPosts.body.items[0].item.allergy
                    print(nutrient,"zzzzzzz")
                    print(allergy,"zzzz")
                    observer.onNext(allergy)
                    
                }
                
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
}
