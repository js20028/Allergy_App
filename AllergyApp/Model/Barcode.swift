//
//  Barcode.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/13.
//

import Foundation

struct Barcode: Codable {
    let C005: ProductInfo
}

struct ProductInfo: Codable {
    let row: [ProductDetail]
}

struct ProductDetail: Codable {
    let PRDLST_REPORT_NO: String
    let PRDLST_NM: String
    let BAR_CD: String
}
