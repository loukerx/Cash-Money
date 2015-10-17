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
    let widthRatio:CGFloat = 0.5
    let audTextFieldTag = 123
    
    var selectedCurrencyTag = 0
    var currencyRateDictionary = [String: Float]()
    

    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        
        self.settingView()

        self.prepareData()//修改普通读取jason的方法
        
        //判断金额长度
        //修改字体  The font is Helvetica (56pt max, scaling down dynamically as required eg. for really big numbers).
        //scrollview 获取内容
        
        self.AUDTextField.delegate = self
        

    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Prepare ScrollView
        self.prepareScrollView()
    }
    
    
    private func prepareScrollView(){
        
        //修改paging size，可视size不一样
        
        //scroll选中uilabel，选中label 调整alpha值，修改数字
        //
        
        
        let width = self.scrollView.frame.size.width// * widthRatio
        let height = self.scrollView.frame.size.height
        let currencyCount = self.currencyArray.count
        let contentSizeWidth = width * CGFloat(currencyCount)
        self.scrollView.contentSize = CGSizeMake(contentSizeWidth, 0)
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        var count:Int = 0
        
        for name in self.currencyArray {
            
            
            let nameStr = name as String
            
            let currencyLabel = UILabel(frame: CGRectMake(width * CGFloat(count), 0, width, height))
            currencyLabel.text = nameStr
            currencyLabel.textColor = UIColor.whiteColor()
            //            currencyLabel.backgroundColor = UIColor.clearColor()
            currencyLabel.textAlignment = NSTextAlignment.Center
            currencyLabel.font = UIFont(name: "Helvetica", size: 50)
            currencyLabel.backgroundColor = UIColor.blackColor()
            
            currencyLabel.layer.borderColor = UIColor.whiteColor().CGColor
            currencyLabel.layer.borderWidth = 1.0
            currencyLabel.alpha = 0.2
            //            currencyLabel.layer.cornerRadius = 4.0
            currencyLabel.clipsToBounds = true
            
            self.scrollView.addSubview(currencyLabel)
            
            
            
            count++
            
            
        }
        
        
        
        
    }
    
    
    //MARK: ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int((self.scrollView.contentOffset.x * 2.0 + pageWidth) / CGFloat(pageWidth * 2.0))
        
        self.selectedCurrencyTag = page
        
        //update new Amount by currency
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = "AUD"
        
        if let audAmountStr = formatter.numberFromString(self.AUDTextField.text!){
            let audAmount:Float = ("\(audAmountStr)" as NSString).floatValue
            print(audAmountStr)
            self.displayAmountBySelectedCurrency(audAmount)
        }
        
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
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
            
            //add "$" before the money
            
//            let audAmountStr = (textField.text! as NSString).substringFromIndex(1)
// self.AUDTextField.text = "\(audAmountStr!)"
       
    
            //display number
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.currencyCode = "AUD"

            let audAmountStr = formatter.numberFromString(textField.text!)//"A$1231231")
            
            self.AUDTextField.text = "\(audAmountStr!)"
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if textField.tag == audTextFieldTag && textField.text!.characters.count>0{
            let audAmount:Float = (self.AUDTextField.text! as NSString).floatValue
            
            //add "$" before the money
//            let formatter = NSNumberFormatter()
//            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
//            self.AUDTextField.text = "$\(formatter.stringFromNumber(audAmount)!)"
//

            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.currencyCode = "AUD"
            //display converted amount
            self.AUDTextField.text = "\(formatter.stringFromNumber(audAmount)!)"

            self.displayAmountBySelectedCurrency(audAmount)

            
            
        }else{
            self.amountDisplayLabel.text = ""
        }
    }
    
    private func displayAmountBySelectedCurrency(audAmount:Float){
        //calculate Amount
        let currencyCode = self.currencyArray[self.selectedCurrencyTag] //CAD, EUR, GBP, JPY, USD.
        let rate:Float = self.currencyRateDictionary[currencyCode]!
        let displayAmount = audAmount * rate
        
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = currencyCode
        //display converted amount
        self.amountDisplayLabel.text = "\(formatter.stringFromNumber(displayAmount)!)"
    }

}

