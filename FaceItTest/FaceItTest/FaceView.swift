//
//  FaceView.swift
//  FaceItTest
//
//  Created by 심 승민 on 2017. 10. 9..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    // 전역변수 -> 다른 사람들도 접근할 수 있어 원하는 크기 또는 표정을 만들 수 있음
    // VC에서 값을 변경해도 '다시 그려달라'고 요청해야 값이 반영됨. 이를 위해 didSet에 setNeedsDisplay() 호출
    // 3~4개를 변경해서 함수가 3~4번 호출되도 결과적으로 한 번만 수행되므로 효율적이다.
    // 얼굴 비율
    @IBInspectable
    var scale: CGFloat = 0.97 { didSet{ setNeedsDisplay() } }
    // 입 곡률 (1이면 함박웃음, -1이면 찡그림)
    @IBInspectable
    var smileCurvature: Double = 1.0 { didSet{ setNeedsDisplay() } }
    // 눈썹 곡률 (1이면 릴렉스, -1이면 화남)
    @IBInspectable
    var eyeBrowTilt: Double = 1.0 { didSet{ setNeedsDisplay() } }
    // 눈 뜨면 true, 감으면 false
    @IBInspectable
    var isEyeOpen: Bool = true { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.orange { didSet{ setNeedsDisplay() } }
    
    // 제스처 핸들러는 GestureRecognizer를 인자로 받아서 처리해야 함
    func changeScale(recognizer: UIPinchGestureRecognizer){
        // recognizer의 state 값에 따라 다르게 처리해 줄 수 있다.
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            // changing되면서 계속 scale이 누적되므로, recognizer의 scale을 계속 1로 초기화시켜줄 필요가 있다.
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var faceRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var faceCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    // 참고: 그냥 'center' 값은 frame 기준이므로, bounds 기준으로 변환
    //let faceCenter = convert(center, from: superview)
    
    
    // swift에서 구조체는 다음과 같이 사용함.
    private struct Ratios{
        static let FaceRadiusToEyeOffset: CGFloat = 3
        static let FaceRadiusToEyeRadius: CGFloat = 10
        static let FaceRadiusToMouthWidth: CGFloat = 1
        static let FaceRadiusToMouthHeight: CGFloat = 3
        static let FaceRadiusToMouthOffset: CGFloat = 3
        static let FaceRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye{
        case left
        case right
    }
    
    private func getCenterOfEye(eye: Eye) -> CGPoint{
        let eyeOffset = faceRadius / Ratios.FaceRadiusToEyeOffset
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadius
        let eyeCenter = getCenterOfEye(eye: eye)
        
        if isEyeOpen{
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        }else{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x-eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x+eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForEyeBrow(eye: Eye) -> UIBezierPath{
        var tilt = eyeBrowTilt
        let eyeBrowOffset = faceRadius / Ratios.FaceRadiusToBrowOffset
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadius
        switch eye {
        case .left: tilt *= -1
        case .right: break
        }
        var browCenter = getCenterOfEye(eye: eye)
        browCenter.y -= eyeBrowOffset
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let start = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let end = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath{
        let mouthOffset = faceRadius / Ratios.FaceRadiusToMouthOffset
        let mouthWidth = faceRadius / Ratios.FaceRadiusToMouthWidth
        let mouthHeight = faceRadius / Ratios.FaceRadiusToMouthHeight
        
        let mouthRect = CGRect(x: faceCenter.x - faceRadius/2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        // 변수의 범위는 다음과 같이 정함 ( -1 ~ 1)
        let smileOffset = CGFloat(max(-1, min(smileCurvature, 1))) * mouthHeight
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath{
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(midPoint: faceCenter, withRadius: faceRadius).stroke()
        pathForEye(eye: .left).stroke()
        pathForEye(eye: .right).stroke()
        pathForMouth().stroke()
        pathForEyeBrow(eye: .left).stroke()
        pathForEyeBrow(eye: .right).stroke()
    }
 
}
