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
        
        buttonClose.backgroundColor = UIColor.red
        buttonClose.setTitleColor(UIColor.white, for: UIControl.State.normal)
        buttonClose.layer.cornerRadius = 0.5 * buttonClose.bounds.size.height
        textView.layer.cornerRadius = 0.01 * textView.bounds.size.width
        
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
        
        MainController.playSound(name:"click", ext: "mp3")
        
        self.dismiss(animated:true, completion: {});
        
    }

    
}
