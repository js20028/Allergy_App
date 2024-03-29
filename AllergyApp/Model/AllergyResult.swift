//
//  Allergy.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/25.
//

import Foundation

struct AllergyResult {
    let date: Date
    let productName: String
    let productIngredient: String
    let productAllergy: String
    let compareResult: String
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
