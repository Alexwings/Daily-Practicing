//
//  FaceView.swift
//  FaceIt
//
//  Created by Xinyuan Wang on 11/28/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale: CGFloat = 0.8 {didSet { setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature: Double = 1.0 {didSet { setNeedsDisplay()}}//between -1 ~ 1
    @IBInspectable
    var eyeOpen: Bool = true {didSet {setNeedsDisplay()}}
    @IBInspectable
    var eyeBrowTilt: Double = 0.0 {didSet {setNeedsDisplay()}}// -1 fully furrow, 1 fully relaxed
    @IBInspectable
    var color: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {didSet {setNeedsDisplay()}}
    
    var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    func changeScale(_ gesture: UIPinchGestureRecognizer){
        switch gesture.state {
        case .changed, .ended:
            scale *= gesture.scale
            gesture.scale = 1.0
        default:
            break
        }
    }
    
    private enum Eye {
        case Left
        case Right
    }
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 4
        static let skullRadiusToBrowOffset: CGFloat = 5
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat)-> UIBezierPath{
        let eye = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true);
        eye.lineWidth = lineWidth;
        return eye;
    }
    
    private func centerForEye(eye: Eye)->CGPoint{
        var eyeCenter: CGPoint
        switch eye {
        case Eye.Left:
            eyeCenter = CGPoint(x:skullCenter.x - skullRadius / Ratios.skullRadiusToEyeOffset,
                                            y: skullCenter.y - skullRadius / Ratios.skullRadiusToEyeOffset)
        case Eye.Right:
            eyeCenter = CGPoint(x:skullCenter.x + skullRadius / Ratios.skullRadiusToEyeOffset,
                                            y: skullCenter.y - skullRadius / Ratios.skullRadiusToEyeOffset)
        }
        return eyeCenter
    }
    private func radiusForEye(eye: Eye)->CGFloat{
        return skullRadius / Ratios.skullRadiusToEyeRadius;
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath{
        let eyeCenter = centerForEye(eye: eye);
        let radius: CGFloat = radiusForEye(eye: eye);
        if(eyeOpen){
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: radius);
        }else{
            let path = UIBezierPath();
            path.move(to: CGPoint(x: eyeCenter.x - radius, y: eyeCenter.y));
            path.addLine(to: CGPoint(x: eyeCenter.x + radius, y: eyeCenter.y));
            path.lineWidth = lineWidth;
            return path;
        }
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(1, mouthCurvature))) * mouthRect.height;
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY);
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY);
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth / 3, y: mouthRect.minY + smileOffset);
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth / 3, y: mouthRect.minY + smileOffset);
        let path = UIBezierPath();
        path.move(to: start);
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2);
        path.lineWidth = lineWidth;
        return path;
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye{
        case .Left: tilt *= -1.0
        case.Right: break
        }
        var browCenter = centerForEye(eye: eye)
        browCenter.y -= skullRadius / Ratios.skullRadiusToBrowOffset
        let eyeRadius = radiusForEye(eye: eye)
        let tiltOffset = CGFloat (max(-1, min(1, tilt))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y:browCenter.y + tiltOffset);
        let path = UIBezierPath();
        path.move(to: browStart);
        path.addLine(to: browEnd);
        path.lineWidth = lineWidth;
        return path;
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
}
