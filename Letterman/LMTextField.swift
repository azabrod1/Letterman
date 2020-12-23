//
//  LMTextField.swift
//  Letterman
//
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
