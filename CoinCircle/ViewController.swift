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
		"Forward",
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
		//coinCircleView.forward = false
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
			v2.textAlignment = .center
			infoStacks[1].addArrangedSubview(v2)
		}
		infoView.layer.masksToBounds = true
		infoView.layer.cornerRadius = 8
		infoView.layer.borderColor = UIColor.blue.cgColor
		infoView.layer.borderWidth = 2
		
		updateInfoView()
		infoViewTopConstraint.constant = 0
		
		let t = UITapGestureRecognizer(target: self, action: #selector(self.infoViewTapped(_:)))
		infoView.addGestureRecognizer(t)
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
			coinCircleView.forward,
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
				label.text = obj == UIColor.clear ? "Clear" : " "
				print(obj == UIColor.clear)
			} else if let obj = v as? CGFloat {
				label.text = "\(obj)"
			} else if let obj = v as? Bool {
				label.text = obj == true ? "True" : "False"
			}
		}
		view.bringSubviewToFront(infoView)
	}
	
	@objc
	func infoViewTapped(_ g: UIGestureRecognizer) -> Void {
		//print(g.view)

		let touchLocation = g.location(in: nil)
		let matchingViews = descendants(of: UIApplication.shared.keyWindow!)
			.filter { $0.convert($0.bounds, to: nil).contains(touchLocation) }
			.filter { $0 is UILabel }
		//let labels = matchingViews.filter { $0 is UILabel }
		matchingViews.forEach {
			print($0)
		}
	
		//setPropByName("radius", val: 80)
		let propView = NumericView()
		view.addSubview(propView)
		NSLayoutConstraint.activate([
			propView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100.0),
			propView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
		propView.title = "Radius"
		propView.theValue = coinCircleView.radius
		propView.valueChanged = { v in
			self.coinCircleView.radius = v
		}
	}
	
	func descendants(of view: UIView) -> [UIView] {
		return view.subviews + view.subviews.flatMap(descendants(of:))
	}
	
}

extension ViewController {
	
	func setPropByName(_ prop:String, val: Any) -> Void {
		if prop == "radius" {
			if let t = val as? NSNumber {
				let v = CGFloat(t.floatValue)
				coinCircleView.radius = v
			}
		}
	}
	
	
}

class PropertiesView: UIView {
	
}

class ChangePropView: UIView {
	
	let propStack: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 8
		return v
	}()
	let titleLabel: UILabel = {
		let v = UILabel()
		v.text = "title"
		v.backgroundColor = .yellow
		return v
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		print(#function)
		backgroundColor = .red
		translatesAutoresizingMaskIntoConstraints = false
		propStack.translatesAutoresizingMaskIntoConstraints = false
		addSubview(propStack)
		NSLayoutConstraint.activate([
			propStack.widthAnchor.constraint(equalToConstant: 300.0 - 16.0),
			propStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
			propStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
			propStack.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
			propStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40.0),
		])
		let doneButton = UIButton(type: .system)
		doneButton.setTitle("Done", for: [])
		doneButton.setContentHuggingPriority(.required, for: .horizontal)
		let topRow = UIStackView()
		topRow.addArrangedSubview(titleLabel)
		topRow.addArrangedSubview(doneButton)
		propStack.addArrangedSubview(topRow)
		
		layer.masksToBounds = true
		layer.cornerRadius = 8
		layer.borderColor = UIColor.blue.cgColor
		layer.borderWidth = 2

	}
}
class NumericView: ChangePropView {
	
	var valueChanged: ((CGFloat) -> ())?
	
	var title: String = "" {
		didSet {
			titleLabel.text = title
		}
	}
	var theValue: CGFloat = 0 {
		didSet {
			stepper.value = Double(theValue)
			valueLabel.text = "\(theValue)"
		}
	}
	let valueLabel: UILabel = {
		let v = UILabel()
		v.textAlignment = .center
		return v
	}()
	let stepper: UIStepper = {
		let v = UIStepper()
		return v
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		myInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		myInit()
	}
	func myInit() {
		let stack = UIStackView()
		stack.addArrangedSubview(valueLabel)
		stack.addArrangedSubview(stepper)
		propStack.addArrangedSubview(stack)
		stepper.addTarget(self, action: #selector(self.stepperChanged(_:)), for: .valueChanged)
	}

	@objc func stepperChanged(_ s: UIStepper) -> Void {
		valueLabel.text = "\(s.value)"
		valueChanged?(CGFloat(s.value))
	}
}
