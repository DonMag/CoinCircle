//
//  DMCoinCircleView.swift
//  CoinCircle
//
//  Created by Don Mag on 9/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class DMCoinCircleView: UIView {
	
	// Overlap Order
	//	true (forward) == 2 overlaps 1, 3 overlaps 2, etc
	//		i.e. you lay down 1, lay down 2 on top of 1, lay down 3 on top of 2, etc
	//	false (backward) == 1 overlaps 2, 2 overlaps 3, etc
	//		i.e. you lay down 1, put 2 under 1, put 3 under 2, etc
	// default is true
	public var forward: Bool = true {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
	// Layout Direction
	// default is TRUE
	public var clockwise: Bool = true {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
	// Start Angle (in degrees)
	//	  0 == 12 o'clock
	//	 90 == 3 o'clock
	//	180 == 6 o'clock
	//	270 == 9 o'clock
	//	or any angle in between, such as with 4 images
	//		start at 0 degrees for a "diamond" layout
	//		start at 45 degrees for a "square" layout
	public var startAngle: CGFloat = 0 {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
	// width & height of the individual images (1:1 ratio)
	public var coinSize: CGFloat = 66.0 {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
	// distance of center of each image from center of circle
	public var radius: CGFloat = 60 {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
	// false prevents radius from being too small
	public var allowInvalidRadius: Bool = false {
		didSet {
			needsArrangement = true
			setNeedsLayout()
		}
	}
	
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
	
	// outer view border
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
	
	// inner image view border
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
	
	// image background color (will only be visible if image has alpha)
	@objc
	public var imageBackgroundColor: UIColor = .clear {
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
	
	public func setImagesByName(_ picNames: [String]) -> Void {
		addRemoveCoinViews(picNames.count)
		for (v, s) in zip(subviews, picNames) {
			if let cv = v as? DMCoinImageView {
				if let img = UIImage(named: s) {
					cv.setImg(img)
				} else {
					cv.setImg(nil)
				}
			}
		}
	}
	public func setImagesByImage(_ picImages: [UIImage]) -> Void {
		addRemoveCoinViews(picImages.count)
		for (v, img) in zip(subviews, picImages) {
			if let cv = v as? DMCoinImageView {
				cv.setImg(img)
			}
		}
	}
	private func addRemoveCoinViews(_ n: Int) -> Void {
		// clear out extra objects if they exists
		while subviews.count > n {
			subviews.last?.removeFromSuperview()
		}
		while subviews.count < n {
			let coinView = DMCoinImageView()
			addSubview(coinView)
		}
		needsArrangement = true
	}

	private var myIntrinsicSize: CGSize = .zero
	private var needsArrangement: Bool = true
	
	private func updateLayout() -> Void {
		var coinPicViews: [DMCoinImageView] = []
		subviews.forEach { v in
			if let cv = v as? DMCoinImageView {
				coinPicViews.append(cv)
			}
		}
		coinPicViews.forEach { cv in
			cv.frame = CGRect(origin: .zero, size: CGSize(width: coinSize, height: coinSize))
			cv.overlapView = nil
		}
		var contentRect: CGRect = coinPicViews.first?.frame ?? .zero
		// if there is only one image, we don't have to do anything else
		if coinPicViews.count > 1 {
			// start at "12 o'clock"
			var curAngle = (startAngle - 90) * .pi / 180
			
			// angle increment
			var incAngle: CGFloat = ( 360.0 / CGFloat(coinPicViews.count) ) * .pi / 180.0
			
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
			coinPicViews.forEach { imgView in
				let xPos = cos(curAngle) * validRadius
				let yPos = sin(curAngle) * validRadius
				imgView.center = CGPoint(x: xPos, y: yPos)
				curAngle += incAngle
			}
			
			// "normalize" bounding box and image positions
			contentRect = subviews.reduce(into: .zero) { rect, view in
				rect = rect.union(view.frame)
			}
			coinPicViews.forEach { imgView in
				imgView.frame.origin.x += CGFloat(abs(contentRect.origin.x))
				imgView.frame.origin.y += CGFloat(abs(contentRect.origin.y))
			}
			
			// set "overlapView" property for each image view
			let n = coinPicViews.count
			
			if forward {
				for i in (0..<n) {
					if i < (n - 1) {
						coinPicViews[i].overlapView = coinPicViews[i+1]
					} else {
						if n > 2 {
							coinPicViews[i].overlapView = coinPicViews[0]
						}
					}
				}
			} else {
				for i in (0..<n).reversed() {
					if i > 0 {
						coinPicViews[i].overlapView = coinPicViews[i-1]
					} else {
						if n > 2 {
							coinPicViews[0].overlapView = coinPicViews[n-1]
						}
					}
				}
			}
		}
		
		// update intrinsic size
		myIntrinsicSize = contentRect.size
		
		invalidateIntrinsicContentSize()
		
		needsArrangement = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if needsArrangement {
			updateLayout()
		}
		subviews.forEach { v in
			if let coinView = v as? DMCoinImageView {
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
		
		// image background color (will only be visible if image has alpha)
		public var imageBackgroundColor: UIColor = .clear
		
		// image color if named image cannot be loaded
		public var missingImageColor: UIColor = .clear
		
		private let imgView = UIImageView()
		
		public func setImg(_ img: UIImage?) -> Void {
			imgView.image = img
		}
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			commonInit()
		}
		required init?(coder: NSCoder) {
			super.init(coder: coder)
			commonInit()
		}
		private func commonInit() -> Void {
			addSubview(imgView)
			imgView.translatesAutoresizingMaskIntoConstraints = false
			imgView.clipsToBounds = true
			clipsToBounds = true
		}
		override func layoutSubviews() {
			super.layoutSubviews()
			
			backgroundColor = outlineColor
			
			imgView.backgroundColor = imgView.image == nil ? missingImageColor : imageBackgroundColor
			
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
			} else {
				layer.mask = nil
			}
			
		}
	}
}
