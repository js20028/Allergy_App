//
//  ShowAllergyTableViewCell.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift

class ShowAllergyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var allergyTitleLabel: UILabel!
    @IBOutlet weak var checkAllergyImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // checkAllergtImageView 설정
        checkAllergyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        checkAllergyImageView.heightAnchor.constraint(equalToConstant: self.allergyTitleLabel.frame.height).isActive = true
        checkAllergyImageView.widthAnchor.constraint(equalTo: checkAllergyImageView.heightAnchor).isActive = true
        
        
    }
}
