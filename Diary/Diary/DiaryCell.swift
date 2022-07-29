//
//  DiaryCell.swift
//  Diary
//
//  Created by 이준혁 on 2022/07/26.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    // 이 생성자를 통해 객체가 생성된다
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor 
    }
}
