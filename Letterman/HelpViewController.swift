//
//  HelpViewController.swift
//  Letterman
//
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonClose: UIButton!
    //@IBOutlet weak var viewHeader: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonClose.backgroundColor = UIColor.systemBlue
        buttonClose.setTitleColor(UIColor.white, for: UIControl.State.normal)
        buttonClose.layer.cornerRadius = 10 //0.5 * buttonClose.bounds.size.height
        textView.layer.cornerRadius = 0.05 * textView.bounds.size.width
        
        //buttonClose.center = self.view.center
        
        // Do any additional setup after loading the view.
        
        self.view.bringSubviewToFront(buttonClose)
        //self.view.bringSubviewToFront(viewHeader)
        self.view.bringSubviewToFront(textView)
        
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    override var prefersStatusBarHidden: Bool {get {return true}}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = CGAffineTransform.identity
                    // actual code
                    MainController.playSound(name:"click", ext: "mp3")
                    self.dismiss(animated:true, completion: {});

                    // end of actual code
                }
            })
        
        
    }

    
}
