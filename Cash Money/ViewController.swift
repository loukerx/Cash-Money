//
//  ViewController.swift
//  Cash Money
//
//  Created by Yin Hua on 16/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var AUDLabel: UILabel!
    
    @IBOutlet weak var AUDTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var amountDisplayLabel: UILabel!
    
    //variable
    var appDelegate = AppDelegate()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        
        
        
    }

    private func settingView(){
        
        self.mainView.backgroundColor = UIColor.greenColor()
        self.upView.backgroundColor = UIColor.clearColor()
        
    }


}

