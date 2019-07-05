//
//  ShadowView.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
}
