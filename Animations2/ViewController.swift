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

    var isNewImage: Bool = false
    var showEffects: Bool = false
    
    lazy var snowClipView: UIView = {
       let snowClipView = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 50))
        let snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
        snowClipView.clipsToBounds = true
        snowClipView.alpha = 0.0
        snowClipView.addSubview(snowView)
        return snowClipView
    }()
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        backgroundImageView.addSubview(snowClipView)
    }

    
    @IBAction func fadeIn(_ sender: Any) {
        
        isNewImage = !isNewImage
        showEffects = !showEffects
        let weatherImage = isNewImage ? #imageLiteral(resourceName: "bg-snowy") : #imageLiteral(resourceName: "bg-sunny")
        fade(toImage: weatherImage)
        fadeSnowEffect(self.showEffects)
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

extension ViewController {
    
    //MARK: utility methods
    func delay(seconds: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}







