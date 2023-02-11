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
    
    let urlString = "https://apis.data.go.kr/B553748/CertImgListService/getCertImgListService?serviceKey=ZtojqVhPokrJTTkuSpyHP2XWQCF22ta%2B6C49kxFFjVXOIOzaBQjEEDid1bNvWCzYNTIOQDZxhDHtZpkJxhXa9g%3D%3D&prdlstReportNo=1978061400972&returnType=json"
    
    func downloadPost(completion: @escaping((Error?, [Response]?) -> Void)) {
        
        // url을 URL을 이용해서 알맞게 변환 실패시 completion error함수 호출
        guard let url = URL(string: urlString) else { return completion(NSError(domain: "why", code: 404), nil) }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil)
            .responseDecodable(of: [Response].self) { response in
            
            if let error = response.error {
                print(error)
                return completion(error, nil)
            }
            
            if let randomPosts = response.value {
                print("success \(randomPosts)")
                return completion(nil, randomPosts)
            }
  
        }
    }
    
    @discardableResult
    func fetchNews() -> Observable<[Response]> {
        return Observable.create { (observer) -> Disposable in
            
            self.downloadPost(completion: {(error, randomPosts) in
                
                if let error = error {
                    print(error)
                    observer.onError(error)
                }
                
                if let randomPosts = randomPosts {
                    print(randomPosts)
                    observer.onNext(randomPosts)
                }
                
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
}
