//
//  CustomSpinner.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import UIKit

final class CustomSpinnerSimple: UIView {
    private lazy var replicatorLayer: CAReplicatorLayer = {
        let caLayer = CAReplicatorLayer()
        return caLayer
    }()

    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()

    private let keyAnimation = "opacityAnimation"

    convenience init(squareLength: CGFloat) {
        let mainBounds = UIScreen.main.bounds
        let rect = CGRect(origin: CGPoint(x: (mainBounds.width - squareLength) / 2,
                                          y: (mainBounds.height - squareLength) / 2),
                          size: CGSize(width: squareLength, height: squareLength))
        self.init(frame: rect)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(shapeLayer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = min(bounds.width / 2, bounds.height / 2)
        let rect = CGRect(x: size / 4, y: size / 4, width: size / 4, height: size / 4)
        let path = UIBezierPath(ovalIn: rect)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemYellow.cgColor
        replicatorLayer.frame = bounds
        replicatorLayer.position = CGPoint(x: size, y: size)
    }

    func startAnimation(delay: TimeInterval = 0.01, replicates: Int = 120) {
        replicatorLayer.instanceCount = replicates
        replicatorLayer.instanceDelay = delay
        let angle = CGFloat(2.0 * Double.pi) / CGFloat(replicates)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        shapeLayer.opacity = 0
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.1
        opacityAnimation.toValue = 0.7

        opacityAnimation.duration = Double(replicates) * delay
        opacityAnimation.repeatCount = Float.infinity
        shapeLayer.add(opacityAnimation, forKey: keyAnimation)
    }

    func stopAnimation() {
        guard shapeLayer.animation(forKey: keyAnimation) != nil else {
            return
        }
        shapeLayer.removeAnimation(forKey: keyAnimation)
    }

    deinit {
        stopAnimation()
    }
}
