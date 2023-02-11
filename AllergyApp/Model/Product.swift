//
//  Product.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/11.
//

import Foundation


struct Response: Codable {
    let header: Header
    let body: Body
    
    struct Header: Codable {
        let resultCode: String
        let resultMessage: String
    }
    
    struct Body: Codable {
        let totalCount: String
        let pageNo: String
        let numOfRows: String
        let items: [Item]
        
        struct Item: Codable {
            let item: Product
            
            struct Product: Codable {
                let nutrient: String
                let rawmtrl: String
                let prdlstNm: String
                let imgurl2: String
                let barcode: String
                let imgurl1: String
                let productGb: String
                let seller: String
                let prdkindstate: String
                let rnum: String
                let manufacture: String
                let prdkind: String
                let prdlstReportNo: String
                let allergy: String
            }
        }
    }
}
