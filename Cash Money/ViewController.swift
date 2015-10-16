//
//  ViewController.swift
//  Cash Money
//
//  Created by Yin Hua on 16/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var AUDLabel: UILabel!
    @IBOutlet weak var AUDTextField: UITextField!
    @IBOutlet weak var dashBorderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountDisplayLabel: UILabel!
    
    //variable
    var appDelegate = AppDelegate()
    
    let currencyArray = ["CAD","EUR","GBP","JPY","USD"]
    let widthRatio:CGFloat = 0.4
    let audTextFieldTag = 123
    
    
    var currencyRateDictionary = [String: Float]()
    

    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        
        self.settingView()
        self.prepareScrollView()
        self.prepareData()
        
        self.AUDTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }
    

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

    private func settingView(){
        
        self.mainView.backgroundColor = appDelegate.appBackgroundColor
        self.scrollView.backgroundColor = appDelegate.scrollViewBackgrundColor
//        self.upView.backgroundColor = UIColor.clearColor()
        
       /*
        //Dash Border
        let borderLayer = CAShapeLayer()
        let viewWidth = self.dashBorderView.bounds.size.width
        let viewHeight = self.dashBorderView.bounds.size.height
        borderLayer.bounds = CGRectMake(0, 0, viewWidth, viewHeight)
        borderLayer.position = CGPointMake(CGRectGetMaxX(self.dashBorderView.bounds), CGRectGetMaxY(self.dashBorderView.bounds))
        borderLayer.path = UIBezierPath.init(roundedRect: borderLayer.bounds, cornerRadius: CGRectGetWidth(borderLayer.bounds)/2).CGPath
        borderLayer.lineWidth = 1
        
        borderLayer.lineDashPattern = [8,8]
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.strokeColor = UIColor.blackColor().CGColor
        
        self.dashBorderView.layer.addSublayer(borderLayer)
        self.dashBorderView.backgroundColor = UIColor.clearColor()
        
        
*/
        

        
    }
    

    
    private func prepareScrollView(){
        
        let width = self.view.bounds.width * widthRatio
        let height = self.view.bounds.height
        let currencyCount = self.currencyArray.count
        let contentSizeWidth = width * CGFloat(currencyCount)
        self.scrollView.contentSize = CGSizeMake(contentSizeWidth, 0)
        self.scrollView.delegate = self
        
        var count:Int = 0
        
        for name in self.currencyArray {
            
            
            let nameStr = name as String
            
            let currencyLabel = UILabel(frame: CGRectMake(width * CGFloat(count), 0, width, height))
            currencyLabel.text = nameStr
            currencyLabel.textColor = UIColor.whiteColor()
//            currencyLabel.backgroundColor = UIColor.clearColor()
            currencyLabel.textAlignment = NSTextAlignment.Center
            currencyLabel.font = UIFont(name: "System", size: 30)
            
                
            
            self.scrollView.addSubview(currencyLabel)
            
            
   
            count++
            
            
        }
        
        
        
        
    }
    

    
    
    
    
    
    //MARK: - Prepare Data
    private func prepareData(){
        
        
        let URL = NSURL(string: "http://api.fixer.io/latest")!
        let parameters = [
            "base": "AUD",
            "symbols": "CAD,EUR,GBP,JPY,USD"
        ]
        
        Alamofire.request(.GET, URL, parameters: parameters).responseJSON { response in
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                self.currencyRateDictionary = JSON["rates"] as! Dictionary<String,Float>
                
                
            }
        }
    }
    
    
    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == audTextFieldTag && textField.text?.characters.count>0{
            let audAmount = (textField.text! as NSString).substringFromIndex(1)
            
            //add "$" before the money
            self.AUDTextField.text = audAmount
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if textField.tag == audTextFieldTag && textField.text!.characters.count>0{
            let audAmount:Float = (self.AUDTextField.text! as NSString).floatValue
            
            //add "$" before the money
            self.AUDTextField.text = "$\(audAmount)"
            
            //calculate rate
            let currencyName = "USD"
            let rate:Float = self.currencyRateDictionary[currencyName]!
            let displayAmount = audAmount * rate
            self.amountDisplayLabel.text = "\(displayAmount)"
        }
    }
    
    

}

