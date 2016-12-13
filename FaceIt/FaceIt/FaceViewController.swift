//
//  ViewController.swift
//  FaceIt
//
//  Created by Xinyuan Wang on 11/20/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

import UIKit


class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes:.Closed, eyeBrows: .Relaxed, mouth: .Smirk){didSet { updateUI()}}
    
    @IBOutlet weak var facView: FaceView! {
        didSet{
            let gr: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: facView, action: #selector(FaceView.changeScale(_:)))
            facView .addGestureRecognizer(gr)
            let happierSwipeGr = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGr.direction = .up
            facView.addGestureRecognizer(happierSwipeGr);
            let sadderSwipeGr = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGr.direction = .down
            facView.addGestureRecognizer(sadderSwipeGr);
            updateUI()
        }
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
        expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
    }
    func decreaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
        expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
    }
    @IBAction func tapToOpen(_ sender: UITapGestureRecognizer) {
        switch expression.eyes {
        case .Open:
            expression.eyes = .Closed
        case .Closed:
            expression.eyes = .Open
        case .Squinting: break 
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed:-0.5, .Relaxed:0.5, .Normal:0.0]
    func updateUI(){
        switch expression.eyes {
        case .Open:
            facView.eyeOpen = true
        case .Closed:
            facView.eyeOpen = false
        case .Squinting:
            facView.eyeOpen = false
        }
        facView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        facView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
}

