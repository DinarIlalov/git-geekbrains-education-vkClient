//
//  UIVeiw.swift
//  VKClient
//
//  Created by Константин Зонин on 05.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

extension UIView {
    
    func round() {
        self.cornerRadius(self.frame.height/2)
    }
    
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}
