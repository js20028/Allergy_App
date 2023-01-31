//
//  LoadAllergyCollectionViewCell.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/26.
//

import UIKit

class LoadAllergyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var allergyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 7.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.backgroundColor = .yellow
    }

}
