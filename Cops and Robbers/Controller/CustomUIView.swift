//
//  LayoutExtension.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-11.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class CustomUIView: UIView {
    
    func drawSemiCircle(){
        
        let radiusRate = self.frame.size.width/7
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height), radius: self.frame.size.width - radiusRate, startAngle: 180 * CGFloat(M_PI)/180, endAngle: 0 * CGFloat(M_PI)/180, clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        self.layer.mask = circleShape
    }
}
