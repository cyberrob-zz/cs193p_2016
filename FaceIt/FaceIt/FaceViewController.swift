//
//  ViewController.swift
//  FaceIt
//
//  Created by Bo Wen Wang on 2016/10/29.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smirk) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwiperGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwiperGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwiperGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    
    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness()
    {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures =
    [FacialExpression.Mouth.Frown: -1.0,
    .Grin: 0.5,
    .Smile: 1.0,
    .Smirk: -0.5,
    .Neutral: 0.0]
    
    private var eyeBrowTilts =
        [FacialExpression.EyeBrows.Furrowed: -0.5,
         .Normal: 0.0,
         .Relaxed: 0.5]
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyeOpen = true
            case .Closed: faceView.eyeOpen = false
            case .Squinting: faceView.eyeOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}

