//
//  ViewController.swift
//  FaceItTest
//
//  Created by 심 승민 on 2017. 10. 9..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // model을 생성. 모델의 값이 변경되면 뷰를 업데이트한다.
    // 하지만, 초기화 중에 값을 설정하면 didSet이 호출되지 않음 (즉 초기화 시의 값은 didSet으로 적용이 안 됨)
    // 따라서 updateUI()가 호출되지 않아 초기화한 값이 반영이 안 되는데, 뷰가 로드 또는 링크가 연결되는 시점에 updateUI를 호출하면 됨
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Normal, mouth: .Neutral) { didSet{ updateUI() } }
    
    // 뷰를 업데이트하기 위해 FaceView의 링크가 필요
    // faceView와 링크되고 나면 didSet이 호출됨
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            // 시뮬레이터에서 핀칭을 하려면 alt를 누르고 드래그 하면 됨
            // 뷰에서 직접 반영 (모델 변경 없음)
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale)))
            // 스와이프 시, 모델값을 변경해야 하므로 VC를 타겟으로 함. 단, 뷰가 인식해야 하므로 recognizer를 뷰에 붙임
            // 뷰가 제스처를 받으면 -> VC의 increaseHappiness 실행 -> expression(모델) 값 변경됨 -> updateUI() 호출 -> 뷰 변경
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            updateUI()
        }
    }
    
    func increaseHappiness(){
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    // 스토리보드 상에서 제스처를 만든 후 끌고 오면 addGestureRecognizer는 자동으로 됨
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended{
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    
    // 모델의 각 값들을 뷰에 적용할 실질적인 수치와 매핑
    let eyeBrowTilts = [FacialExpression.EyeBrows.Normal:0.0, .Relaxed:1.0, .Furrowed:-1.0]
    let mouthCurvature = [FacialExpression.Mouth.Smile:1.0, .Neutral:0.0, .Frown:1.0, .Smirk:-0.5, .Grin:0.5]
    
    // 모델의 값을 해석해서 뷰에게 전달. 뷰는 이를 받아 적용 (뷰의 변수들에..)
    private func updateUI(){
        // eyes 뜨고 안 뜨고 값 매칭
        switch expression.eyes {
        case .Open: faceView.isEyeOpen = true
        case .Closed : faceView.isEyeOpen = false
        case .Squinting : faceView.isEyeOpen = false
        }
        // eyeBrows 곡률 값 매칭
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        // mouth 곡률 값 매칭
        faceView.smileCurvature = mouthCurvature[expression.mouth] ?? 0.0
    }
}
