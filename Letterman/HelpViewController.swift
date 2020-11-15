//
//  HelpViewController.swift
//  Letterman
//
//  Created by Tatyana kudryavtseva on 19/07/16.
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewHeader: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonClose.backgroundColor = UIColor.redColor()
        buttonClose.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonClose.layer.cornerRadius = 0.5 * buttonClose.bounds.size.height
        textView.layer.cornerRadius = 0.1 * textView.bounds.size.width
        
        //buttonClose.center = self.view.center
        
        // Do any additional setup after loading the view.
        
        self.view.bringSubviewToFront(buttonClose)
        self.view.bringSubviewToFront(viewHeader)
        self.view.bringSubviewToFront(textView)
        
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed( sender: UIButton) {
        
        MainController.playSound("click", ext: "mp3")
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }

    
}
