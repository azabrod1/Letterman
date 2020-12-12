//
//  LMTextField.swift
//  Letterman
//
//  Created by Tatyana kudryavtseva on 26/08/16.
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit

class LMTextField: UITextField {
    
    var myDelegate : MainController!
    
    override func deleteBackward() {
        super.deleteBackward()
        
        myDelegate.handleBackspace(tag: self.tag)
        
    }
    

}
