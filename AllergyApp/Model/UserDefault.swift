//
//  UserDefault.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/03/01.
//

import Foundation

class UserDefault {
    let userDefault = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func setUserDefault(check: showLabel) {
        let descriptionEncoder = try? encoder.encode(check)
        userDefault.set(descriptionEncoder, forKey: "description")
    }
    
    func loadUserDefault() -> showLabel {
        guard let loadDescription = userDefault.object(forKey: "description") else { return .show }
        guard let loadDescriptionDecoder = try? decoder.decode(showLabel.self, from: loadDescription as! Data) else { return .show }
        
        return loadDescriptionDecoder
    }
}


