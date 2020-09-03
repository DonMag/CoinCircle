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
	
	let coinSizeVals: [CGFloat] = [140, 140, 120, 120, 110, 100]
	let radiusVals: [CGFloat]    = [  0,  40,  63,  73,  80,  85]
	
	// MARK: Example usage
	let coinCircleView = DMCoinCircleView()
	var numPics: Int = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		coinCircleView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(coinCircleView)
		
		coinCircleView.coinSize = coinSizeVals[0]
		coinCircleView.radius = radiusVals[0]
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
		
		// to use image names
		var a: [String] = []
		for i in 1...numPics {
			a.append("pro\(i)")
		}
		coinCircleView.coinPicNames = a
		
		// or, to use images
		/*
		var a: [UIImage] = []
		for i in 1...numPics {
		if let img = UIImage(named: "pro\(i)") {
		a.append(img)
		}
		}
		coinCircleView.coinPicImages = a
		*/
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			coinCircleView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			coinCircleView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
		coinCircleView.backgroundColor = .clear
		
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
		
		infoView.layer.masksToBounds = true
		infoView.layer.cornerRadius = 8
		infoView.layer.borderColor = UIColor.blue.cgColor
		infoView.layer.borderWidth = 2
		
		updateInfoView()
		infoViewTopConstraint.constant = 0
	}
	
	// MARK: Demo Stuff
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if infoViewTopConstraint.constant == 0 {
			let labels = infoStacks[0].arrangedSubviews
			let v = labels[1]
			let r = infoStacks[0].convert(v.frame, to: infoView)
			infoViewTopConstraint.constant = -(r.maxY) - infoStacks[0].spacing
		}
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

		coinCircleView.outlineColor = .yellow
		coinCircleView.outlineWidth = 12
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
		
		// manually adjust coin size and radius
		coinCircleView.radius = (numPics < radiusVals.count) ? radiusVals[numPics - 1] : radiusVals.last!
		coinCircleView.coinSize = (numPics < coinSizeVals.count) ? coinSizeVals[numPics - 1] : coinSizeVals.last!
		
		// to use image names
		var a: [String] = []
		for i in 1...numPics {
			a.append("pro\(i)")
		}
		coinCircleView.coinPicNames = a
		
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

class DMCoinCircleView: UIView {
	
	// Overlap Order
	//	forward == 2 overlaps 1, 3 overlaps 2, etc
	//		i.e. you lay down 1, lay down 2 on top of 1, lay down 3 on top of 2, etc
	//	backward == 1 overlaps 2, 2 overlaps 3, etc
	//		i.e. you lay down 1, put 2 under 1, put 3 under 2, etc
	enum OverlapOrder {
		case forward, backward
	}
	
	// default order is .forward
	public var overlapOrder: OverlapOrder = .forward
	
	// Layout Direction
	// default is TRUE
	public var clockwise: Bool = true
	
	// Start Angle (in degrees)
	//	  0 == 12 o'clock
	//	 90 == 3 o'clock
	//	180 == 6 o'clock
	//	270 == 9 o'clock
	//	or any angle in between, such as with 4 images
	//		start at 0 degrees for a "diamond" layout
	//		start at 45 degrees for a "square" layout
	public var startAngle: CGFloat = 0
	
	// width & height of the individual images (1:1 ratio)
	public var coinSize: CGFloat = 66.0
	
	// distance of center of each image from center of circle
	public var radius: CGFloat = 60
	
	// false prevents radius from being too small
	public var allowInvalidRadius: Bool = false
	
	// width of "outline"
	public var outlineWidth: CGFloat = 6 {
		didSet {
			setNeedsLayout()
		}
	}
	
	// outline color (can be set to .clear)
	public var outlineColor: UIColor = .lightGray {
		didSet {
			setNeedsLayout()
		}
	}
	
	// round view border
	public var viewBorderWidth: CGFloat = 0.0 {
		didSet {
			setNeedsLayout()
		}
	}

	public var viewBorderColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	
	// round image view border
	public var imageViewBorderWidth: CGFloat = 0.0 {
		didSet {
			setNeedsLayout()
		}
	}

	public var imageViewBorderColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	
	// image color if named image cannot be loaded
	public var missingImageColor: UIColor = .red {
		didSet {
			setNeedsLayout()
		}
	}
	
	// this becomes true or false
	//	based on setting coinPicNames or coinPicImages
	private var useImageNames: Bool = true
	
	// array of image names
	public var coinPicNames: [String] = [] {
		didSet {
			useImageNames = true
			updateView()
		}
	}
	
	// array of images
	public var coinPicImages: [UIImage] = [] {
		didSet {
			useImageNames = false
			updateView()
		}
	}
	
	private var coinPicViews: [DMCoinImageView] = []
	private var myIntrinsicSize: CGSize = .zero
	
	func updateView() {
		// clear out previous objects if they exists
		self.coinPicViews = []
		self.subviews.forEach {
			$0.removeFromSuperview()
		}
		// create image views
		if useImageNames {
			self.coinPicViews = coinPicNames.map({ (coinPic) -> DMCoinImageView in
				let coinView = DMCoinImageView()
				if let img = UIImage(named: coinPic) {
					coinView.img = img
				} else {
					coinView.img = nil
				}
				return coinView
			})
		} else {
			self.coinPicViews = coinPicImages.map({ (coinPicImg) -> DMCoinImageView in
				let coinView = DMCoinImageView()
				coinView.img = coinPicImg
				return coinView
			})
		}
		
		// add MyOverlapImageViews to self
		//	and set width / height constraints
		self.coinPicViews.forEach { (imageView) in
			self.addSubview(imageView)
			imageView.frame = CGRect(origin: .zero, size: CGSize(width: coinSize, height: coinSize))
		}
		
		var contentRect: CGRect = coinPicViews.first?.frame ?? .zero
		
		// if there is only one image, we don't have to do anything else
		if coinPicViews.count > 1 {
			// start at "12 o'clock"
			var curAngle = (startAngle - 90) * .pi / 180
			
			// angle increment
			var incAngle: CGFloat = ( 360.0 / CGFloat(self.coinPicViews.count) ) * .pi / 180.0
			
			if !clockwise {
				incAngle = -incAngle
			}
			
			// if number of images is > 2, minimum radius is ceil 1/2 of coinSize
			var validRadius = radius
			if coinPicViews.count > 2 && !allowInvalidRadius {
				validRadius = max(radius, ceil(coinSize * 0.5))
			}
			
			// calculate position for each image view
			//	set center constraints
			self.coinPicViews.forEach { imgView in
				let xPos = cos(curAngle) * validRadius
				let yPos = sin(curAngle) * validRadius
				imgView.center = CGPoint(x: xPos, y: yPos)
				curAngle += incAngle
			}
			
			// "normalize" bounding box and image positions
			contentRect = subviews.reduce(into: .zero) { rect, view in
				rect = rect.union(view.frame)
			}
			self.coinPicViews.forEach { imgView in
				imgView.frame.origin.x += CGFloat(abs(contentRect.origin.x))
				imgView.frame.origin.y += CGFloat(abs(contentRect.origin.y))
			}
			
			// set "overlapView" property for each image view
			let n = self.coinPicViews.count
			
			if overlapOrder == .forward {
				for i in (0..<n) {
					if i < (n - 1) {
						self.coinPicViews[i].overlapView = self.coinPicViews[i+1]
					} else {
						if n > 2 {
							self.coinPicViews[i].overlapView = self.coinPicViews[0]
						}
					}
				}
			} else {
				for i in (0..<n).reversed() {
					if i > 0 {
						self.coinPicViews[i].overlapView = self.coinPicViews[i-1]
					} else {
						if n > 2 {
							//self.coinPicViews[0].overlapView = self.coinPicViews[n-1]
						}
					}
				}
			}
		}
		
		// update intrinsic size
		myIntrinsicSize = contentRect.size
		
		invalidateIntrinsicContentSize()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		coinPicViews.forEach { coinView in
			coinView.outlineWidth = self.outlineWidth
			coinView.outlineColor = self.outlineColor
			coinView.viewBorderWidth = self.viewBorderWidth
			coinView.viewBorderColor = self.viewBorderColor
			coinView.imageViewBorderWidth = self.imageViewBorderWidth
			coinView.imageViewBorderColor = self.imageViewBorderColor
			coinView.missingImageColor = self.missingImageColor
			coinView.setNeedsLayout()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return myIntrinsicSize
	}
	
	private class DMCoinImageView: UIView {
		
		// reference to the view that is overlapping me
		public weak var overlapView: DMCoinImageView?
		
		// width of "outline"
		public var outlineWidth: CGFloat = 6
		
		// round view border
		public var viewBorderWidth: CGFloat = 0.0
		public var viewBorderColor: UIColor = .clear
		
		// round image view border
		public var imageViewBorderWidth: CGFloat = 0.0
		public var imageViewBorderColor: UIColor = .clear
		
		// outline color
		public var outlineColor: UIColor = .clear
		
		// image color if named image cannot be loaded
		public var missingImageColor: UIColor = .clear
		
		public var img: UIImage? = UIImage() {
			didSet {
				if img != nil {
					imgView.image = img
				} else {
					imgView.backgroundColor = missingImageColor
				}
			}
		}
		
		private let imgView = UIImageView()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			commonInit()
		}
		required init?(coder: NSCoder) {
			super.init(coder: coder)
			commonInit()
		}
		func commonInit() -> Void {
			addSubview(imgView)
			imgView.translatesAutoresizingMaskIntoConstraints = false
			imgView.clipsToBounds = true
			clipsToBounds = true
		}
		override func layoutSubviews() {
			super.layoutSubviews()
			
			backgroundColor = outlineColor
			
			if imgView.image == nil {
				imgView.backgroundColor = missingImageColor
			}
			
			layer.cornerRadius = bounds.height * 0.5
			layer.borderColor = viewBorderColor.cgColor
			layer.borderWidth = viewBorderWidth
			
			imgView.frame = bounds.insetBy(dx: outlineWidth, dy: outlineWidth)
			imgView.layer.cornerRadius = imgView.frame.size.height * 0.5
			imgView.layer.borderColor = imageViewBorderColor.cgColor
			imgView.layer.borderWidth = imageViewBorderWidth
			
			if let v = overlapView {
				// create a shape layer to use as a mask
				let mask = CAShapeLayer()
				// get bounds from overlapView
				//	converted to self
				//	inset by outlineWidth (negative numbers will make it grow)
				let maskRect = v.convert(v.bounds, to: self)
				// oval path from mask rect
				let path = UIBezierPath(ovalIn: maskRect.insetBy(dx: 0.5, dy: 0.5))
				// path from self bounds
				let clipPath = UIBezierPath(rect: bounds)
				//let clipPath = UIBezierPath(ovalIn: bounds)
				// append paths
				clipPath.append(path)
				mask.path = clipPath.cgPath
				mask.fillRule = .evenOdd
				// apply mask
				layer.mask = mask
			}
			
		}
	}
}


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
