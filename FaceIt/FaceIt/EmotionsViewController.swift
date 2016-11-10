//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Bo Wen Wang on 2016/11/9.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "angry": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Closed , eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Smile),
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        
        if let faceviewvc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    faceviewvc.expression = expression
                    if let clickingButton = sender as? UIButton {
                        faceviewvc.navigationItem.title = clickingButton.currentTitle
                    }
                }
            }
        }
    }
}
