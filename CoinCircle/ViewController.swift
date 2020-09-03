//
//  ViewController.swift
//  CoinCircle
//
//  Created by Don Mag on 9/1/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: Demo controller Stuff
	@IBOutlet var infoStacks: [UIStackView]!
	@IBOutlet var infoView: UIView!
	@IBOutlet var infoViewTopConstraint: NSLayoutConstraint!

	let frameView = DashedView()
	
	let upArrow = "▲"
	let downArrow = "▼"
	
	let infoLabels: [String] = [
		"Coin Size",
		"Radius",
		"Start Angle",
		"Order",
		"Clockwise",
		"Outline Width",
		"Outline Color",
		"View Border Width",
		"View Border Color",
		"Image Border Width",
		"Image Border Color",
		"Image Bkg Color",
		"Missing Image Color",
		"Allow Invalid Radius",
	]
	
	let coinSizeVals: [CGFloat] = [140, 140, 120, 120, 110, 100]
	let radiusVals: [CGFloat]    = [  0,  40,  63,  73,  80,  85]
	
	// MARK: Example usage
	let coinCircleView = DMCoinCircleView()
	var numPics: Int = 3
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		coinCircleView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(coinCircleView)
		
		// at least one to start
		numPics = max(numPics, 1)
		
		coinCircleView.coinSize = coinSizeVals[numPics - 1]
		coinCircleView.radius = radiusVals[numPics - 1]
		coinCircleView.outlineWidth = 4
		coinCircleView.outlineColor = .clear
		
		coinCircleView.startAngle = 0
		
		// additional options to try
		//coinCircleView.outlineColor = .green
		//coinCircleView.clockwise = false
		//coinCircleView.overlapOrder = .backward
		//coinCircleView.viewBorderColor = .blue
		//coinCircleView.viewBorderWidth = 1
		//coinCircleView.imageViewBorderColor = .blue
		//coinCircleView.imageViewBorderWidth = 1
		//coinCircleView.missingImageColor = .purple
		//coinCircleView.allowInvalidRadius = true
		
		// default is clear
		//coinCircleView.backgroundColor = .red
		
		// to use image names
		var a: [String] = []
		for i in 1...numPics {
			a.append("pro\(i)")
		}
		coinCircleView.setImagesByName(a)
		
		// or, to use images
		//var a: [UIImage] = []
		//for i in 1...numPics {
		//	if let img = UIImage(named: "pro\(i)") {
		//		a.append(img)
		//	}
		//}
		//coinCircleView.setImagesByImage(a)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			coinCircleView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			coinCircleView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
		// MARK: Demo Stuff
		
		frameView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(frameView)
		NSLayoutConstraint.activate([
			frameView.topAnchor.constraint(equalTo: coinCircleView.topAnchor, constant: -1),
			frameView.leadingAnchor.constraint(equalTo: coinCircleView.leadingAnchor, constant: -1),
			frameView.trailingAnchor.constraint(equalTo: coinCircleView.trailingAnchor, constant: 1),
			frameView.bottomAnchor.constraint(equalTo: coinCircleView.bottomAnchor, constant: 1),
		])
		
		view.sendSubviewToBack(frameView)
		frameView.isHidden = true
		
		let fnt = UIFont.systemFont(ofSize: 15, weight: .regular)
		infoLabels.forEach { s in
			let v1 = UILabel()
			v1.font = fnt
			v1.text = s
			infoStacks[0].addArrangedSubview(v1)
			let v2 = UILabel()
			v2.font = fnt
			v2.text = " "
			infoStacks[1].addArrangedSubview(v2)
		}
		infoView.layer.masksToBounds = true
		infoView.layer.cornerRadius = 8
		infoView.layer.borderColor = UIColor.blue.cgColor
		infoView.layer.borderWidth = 2
		
		updateInfoView()
		infoViewTopConstraint.constant = 0
	}
	
	// MARK: Demo Stuff
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let labels = infoStacks[0].arrangedSubviews
		let v = labels[1]
		let r = infoStacks[0].convert(v.frame, to: infoView)
		infoViewTopConstraint.constant = -(r.maxY) - infoStacks[0].spacing
	}
	
	@IBAction func showHideInfoViewTapped(_ sender: Any) {
		guard let b = sender as? UIButton, let c = b.currentTitle else {
			return
		}
		
		view.bringSubviewToFront(infoView)
		
		let labels = infoStacks[0].arrangedSubviews

		var v: UIView?
		if c == upArrow {
			v = labels.last
		} else {
			v = labels[1]
		}
		if let v = v {
			let r = infoStacks[0].convert(v.frame, to: infoView)
			infoViewTopConstraint.constant = -(r.maxY) - infoStacks[0].spacing
		}
		
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
		
		b.setTitle(c == downArrow ? upArrow : downArrow, for: [])
	}
	
	@IBAction func showHideFrameTapped(_ sender: Any) {
		frameView.isHidden.toggle()
	}
	
	@IBAction func addCoin(_ sender: Any?) -> Void {
		numPics += 1
		updateCoins()
	}
	@IBAction func removeCoin(_ sender: Any?) -> Void {
		if numPics > 1 {
			numPics -= 1
			updateCoins()
		}
	}
	
	func updateCoins() -> Void {
		
		// update coin size and radius from table (arrays)
		coinCircleView.radius = (numPics < radiusVals.count) ? radiusVals[numPics - 1] : radiusVals.last!
		coinCircleView.coinSize = (numPics < coinSizeVals.count) ? coinSizeVals[numPics - 1] : coinSizeVals.last!
		
		// to use image names
		var a: [String] = []
		for i in 1...numPics {
			a.append("pro\(i)")
		}
		coinCircleView.setImagesByName(a)
		
		updateInfoView()
	}
	
	func updateInfoView() -> Void {
		let labels = infoStacks[1].arrangedSubviews
		let vals: [Any] = [
			coinCircleView.coinSize,
			coinCircleView.radius,
			coinCircleView.startAngle,
			coinCircleView.overlapOrder,
			coinCircleView.clockwise,
			coinCircleView.outlineWidth,
			coinCircleView.outlineColor,
			coinCircleView.viewBorderWidth,
			coinCircleView.viewBorderColor,
			coinCircleView.imageViewBorderWidth,
			coinCircleView.imageViewBorderColor,
			coinCircleView.imageBackgroundColor,
			coinCircleView.missingImageColor,
			coinCircleView.allowInvalidRadius,
		]
		for (l, v) in zip(labels, vals) {
			guard let label = l as? UILabel else {
				continue
			}
			if let obj = v as? UIColor {
				label.backgroundColor = obj
				label.text = " "
			} else if let obj = v as? CGFloat {
				label.text = "\(obj)"
			} else if let obj = v as? Bool {
				label.text = obj == true ? "True" : "False"
			} else if let obj = v as? DMCoinCircleView.OverlapOrder {
				label.text = obj == .forward ? "Forward" : "Backward"
			}
		}
		view.bringSubviewToFront(infoView)
	}
	
}

