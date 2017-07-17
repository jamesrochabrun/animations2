//
//  ViewController.swift
//  Animations2
//
//  Created by James Rochabrun on 7/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

//MARK: NON constraint animations

class ViewController: UIViewController {

    //MARK: Util
    var isNewImage: Bool = false
    var showEffects: Bool = false
    
    //MARK: UI
    lazy var snowClipView: UIView = {
       let snowClipView = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 50))
        let snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
        snowClipView.clipsToBounds = true
        snowClipView.alpha = 0.0
        snowClipView.addSubview(snowView)
        return snowClipView
    }()
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var planeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        backgroundImageView.addSubview(snowClipView)
    }
}

//MARK: animating using the center of a view
extension ViewController {
    
    @IBAction func fadeIn(_ sender: Any) {
        
        isNewImage = !isNewImage
        showEffects = !showEffects
        let weatherImage = isNewImage ? #imageLiteral(resourceName: "bg-snowy") : #imageLiteral(resourceName: "bg-sunny")
        fade(toImage: weatherImage)
        fadeSnowEffect(self.showEffects)
        
        if showEffects {
            departureLabel.text = "PUQ"
            arrivalLabel.text = "MIA"
            statusLabel.text = "ARRIVED"
        
        } else {
            departureLabel.text = "MIA"
            arrivalLabel.text = "PUQ"
            statusLabel.text = "DEPARTED"

        }
        
        let offSetDeparting = CGPoint(
            x: showEffects ? -80.0 : 80.0,
            y: 0.0)
        moveLabel(departureLabel, offSet: offSetDeparting)
        
        let offSetArriving = CGPoint(
            x: 0.0,
            y: showEffects ? 50.0 : -50.0)
        moveLabel(arrivalLabel, offSet: offSetArriving)
        cubeTransition(label: statusLabel)
        planeDepart()
    }
    
    //MARK: helper methods
    func fade(toImage: UIImage) {
        
        //create & set up helper view
        let overlayView = UIImageView(frame: backgroundImageView.frame)
        overlayView.image = toImage
        overlayView.alpha = 0.0
        overlayView.center.y += 20
        overlayView.bounds.size.width = self.backgroundImageView.bounds.width * 1.3
        backgroundImageView.superview?.insertSubview(overlayView, aboveSubview: backgroundImageView)
        
        UIView.animate(withDuration: 0.5, animations: {
            //Fade helper view in
            overlayView.alpha = 1.0
            overlayView.center.y -= 20
            overlayView.bounds.size = self.backgroundImageView.bounds.size
            
        }, completion: { _ in
            //update background view & remove helper view
            self.backgroundImageView.image = toImage
            overlayView.removeFromSuperview()
        })
    }
    
    private func fadeSnowEffect(_ show: Bool) {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [],
                       animations: {
                        self.snowClipView.alpha = show ? 1.0 : 0.0
        }, completion: nil)
    }
}

//MARK: animating labels by transformation
extension ViewController {
    
    //MARK: Helepr method
    func moveLabel(_ label: UILabel,  offSet: CGPoint) {
        
        //create & setup helper label
        let auxLabel = duplicateLabel(label: label)
        auxLabel.transform = CGAffineTransform(translationX: offSet.x, y: offSet.y)
        auxLabel.alpha = 0
        view.addSubview(auxLabel)
        //Fade out & translate real label
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, animations: {
                        label.transform = CGAffineTransform(translationX: offSet.x, y: offSet.y)
                        label.alpha = 0
        }, completion: nil)
        
        //Fade in & translate helper label
        UIView.animate(withDuration: 0.25,
                       delay: 0.2,
                       options: .curveEaseIn, animations: { 
                        auxLabel.transform = .identity
                        auxLabel.alpha = 1.0
        }, completion: { _ in
            //Update real label & remove helper label
            label.alpha = 1.0
            label.transform = .identity
            auxLabel.removeFromSuperview()
        })
    }
    
    func cubeTransition(label: UILabel) {
        
        //Create & set up a helper label
        let auxLabel = duplicateLabel(label: label)
        
        let auxLabelOffset = label.frame.size.height/2.0
        
        let scale = CGAffineTransform(
            scaleX: 1.0,
            y: 0.1
        )
        let translate = CGAffineTransform(
            translationX: 0.0,
            y: auxLabelOffset
        )
        
        auxLabel.transform = scale.concatenating(translate)
        
        label.superview?.addSubview(auxLabel)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                //Scale and translate the helper label down
                auxLabel.transform = .identity
                //Scale and translate the real label up
                label.transform = scale
                    .concatenating(translate.inverted())
        },
            completion: {_ in
                //Update the real label's text and reset its transform
                label.text = auxLabel.text
                label.transform = .identity
                
                //Remove the helper label
                auxLabel.removeFromSuperview()
        }
        )
    }
}

//MARK: Keyframe API
extension ViewController {
    
    func planeDepart() {
        //Store plane center value
        let originalCenter = planeImageView.center
        
        //Creat keyframe animation
        UIView.animateKeyframes(withDuration: 1.5,
                                delay: 0.0,
                                animations: {
                                    //Create keyframes
                                    
                                    //Move plane to the right & up
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.planeImageView.center.x += 80.0
                                                        self.planeImageView.center.y -= 10.0
                                    })
                                    //rotate the plane
                                    UIView.addKeyframe(withRelativeStartTime: 0.1,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.planeImageView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
                                    })
                                    //Move plane to the right & up off screen, while fading out
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.planeImageView.center.x += 100
                                                        self.planeImageView.center.y -= 50.0
                                                        self.planeImageView.alpha = 0.0
                                    })
                                    //Move plane just off left side of screen, reste its transform & height
                                    UIView.addKeyframe(withRelativeStartTime: 0.52,
                                                       relativeDuration: 0.01, animations: {
                                                        self.planeImageView.transform = .identity
                                                        self.planeImageView.center = CGPoint(x: 0, y: originalCenter.y)
                                    })
                                    //Move plane back to ist original position & fade in
                                    UIView.addKeyframe(withRelativeStartTime: 0.55,
                                                       relativeDuration: 0.45, animations: {
                                                        self.planeImageView.alpha = 1.0
                                                        self.planeImageView.center = originalCenter
                                    })
        }, completion: nil)
    }
    
    func summarySwitch(to summaryText: String) {
        
    }
}


extension ViewController {
    
    //MARK: utility methods
    func delay(seconds: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    func duplicateLabel(label: UILabel) -> UILabel {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        return auxLabel
    }
}







