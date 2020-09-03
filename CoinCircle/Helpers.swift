//
//  Helpers.swift
//  CoinCircle
//
//  Created by Don Mag on 9/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class DashedView: UIView {
	
	override class var layerClass: AnyClass { return CAShapeLayer.self }
	
	private var dashBorder: CAShapeLayer {
		return self.layer as! CAShapeLayer
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		dashBorder.lineWidth = 1
		dashBorder.lineDashPattern = [10, 10]
		dashBorder.strokeColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0).cgColor
		dashBorder.fillColor = UIColor.clear.cgColor
		dashBorder.path = UIBezierPath(rect: bounds).cgPath
	}
}
