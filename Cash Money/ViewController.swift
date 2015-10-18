//
//  ViewController.swift
//  Cash Money
//
//  Created by Yin Hua on 16/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate {

    //MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var AUDLabel: UILabel!
    @IBOutlet weak var AUDTextField: UITextField!
    @IBOutlet weak var dashBorderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountDisplayLabel: UILabel!
    
    //variables
    var appDelegate = AppDelegate()
    var pagingScrollView = UIScrollView()
    
    let currencyArray = ["CAD","EUR","GBP","JPY","USD"]
    let widthRatio:CGFloat = 0.5
    let audTextFieldTag = 123
    let pagingScrollViewTag = 222
    let unselectedLabelAlpha:CGFloat = 0.2
    
    var selectedCurrencyTag = 0
    var currencyRateDictionary = [String: Float]()
    

    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        self.settingView()
        self.propareCurrencyArray()
        
        self.AUDTextField.delegate = self
        
    }

    override func viewDidLayoutSubviews() {
        if let pointSize = self.AUDTextField.font?.pointSize{
            self.amountDisplayLabel.font = UIFont(name: "Helvetica", size: pointSize)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Prepare ScrollView
        self.prepareScrollView()
    }
    

    
    //MARK: - View Setting
    private func settingView(){
        
        self.mainView.backgroundColor = appDelegate.appBackgroundColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    func DismissKeyboard(){

        self.view.endEditing(true)
    }
    
    private func prepareScrollView(){
        
        //修改paging size，可视size不一样
        
        var labelNameArray = self.currencyArray
        labelNameArray.append("")
        labelNameArray.insert("", atIndex: 0)
        print(labelNameArray)
        
        //scrollview with labels
        let width = self.scrollView.frame.size.width * widthRatio
        let height = self.scrollView.frame.size.height
        let currencyCount = labelNameArray.count //self.currencyArray.count
        let contentSizeWidth = width * CGFloat(currencyCount)
        self.scrollView.contentSize = CGSizeMake(contentSizeWidth, 0)
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = appDelegate.scrollViewBackgrundColor
        
        
        
        var count:Int = 0
        
        for name in labelNameArray { //self.currencyArray {
            
            
            let nameStr = name as String
            
            let currencyLabel = UILabel(frame: CGRectMake(width * CGFloat(count), 0, width, height))
            currencyLabel.text = nameStr
            currencyLabel.textColor = UIColor.whiteColor()
            currencyLabel.textAlignment = NSTextAlignment.Center
            currencyLabel.font = UIFont(name: "Helvetica", size: 56)
            currencyLabel.backgroundColor = UIColor.clearColor()
            
            if count != 1{
                currencyLabel.alpha = self.unselectedLabelAlpha
            }
            
            self.scrollView.addSubview(currencyLabel)

            count++
            
        }
        
        //scroll to the first position
        self.scrollView.setContentOffset(CGPointMake(width * CGFloat(0.5), 0), animated: true)
        
        //paging scrollview
        let tmpFrame = self.view.bounds
        let w:CGFloat = tmpFrame.size.width
        let h:CGFloat = height
        self.pagingScrollView = UIScrollView(frame: CGRectMake(0, 0, w, h))
        self.pagingScrollView.delegate = self
        self.pagingScrollView.pagingEnabled = true
        self.pagingScrollView.tag = pagingScrollViewTag
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.contentSize = CGSizeMake(w * CGFloat(self.currencyArray.count), 0)
        self.pagingScrollView.backgroundColor = UIColor.clearColor()
        self.middleView.addSubview(self.pagingScrollView)
    }
    
    /*
    //MARK: ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == pagingScrollViewTag {
          
            
            let pageWidth = pagingScrollView.frame.size.width
            let page = Int((self.scrollView.contentOffset.x * 2.0 + pageWidth) / CGFloat(pageWidth * 2.0))
//            print(self.scrollView.contentOffset.x)
            self.selectedCurrencyTag = page
//            let inset = self.view.bounds.size.width * 0.5;
//            let scale = (self.scrollView.bounds.size.width-2*inset)/scrollView.bounds.size.width;
//            self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x*scale - inset, 0);
//        
//          
            let width = self.scrollView.bounds.size.width * widthRatio
            
            
            
            let distance = CGFloat(page) + 0.5
//            self.scrollView.setContentOffset(CGPointMake(width + number, 0), animated: true)
        }
        if scrollView == self.scrollView {
            
            print("self.scrollview")
            /*
            let pageWidth = scrollView.frame.size.width * widthRatio
            let page = Int((self.scrollView.contentOffset.x * 2.0 * widthRatio + pageWidth) / CGFloat(pageWidth * 2.0))
            print(self.scrollView.contentOffset.x)
            self.selectedCurrencyTag = page
            
            //update new Amount by currency
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.currencyCode = "AUD"
            
            if let audAmountStr = formatter.numberFromString(self.AUDTextField.text!){
            let audAmount:Float = ("\(audAmountStr)" as NSString).floatValue
            self.displayAmountBySelectedCurrency(audAmount)
            }*/
        }
        
    }
    */
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        if scrollView.tag == pagingScrollViewTag {
            
            let pageWidth = pagingScrollView.frame.size.width
            let page = Int((self.pagingScrollView.contentOffset.x * 2.0 + pageWidth) / CGFloat(pageWidth * 2.0))
            //            print(self.scrollView.contentOffset.x)
            self.selectedCurrencyTag = page

            print(page)
            let width = self.scrollView.bounds.size.width * widthRatio
            let number = CGFloat(page) + 0.5
            self.scrollView.setContentOffset(CGPointMake(width * number, 0), animated: true)
        }
        
        //Update selected UILabel.alpha
        for view in self.scrollView.subviews{
            if let currencyLabel = view as? UILabel {
                if currencyLabel.text == self.currencyArray[self.selectedCurrencyTag] {
                    
                    currencyLabel.alpha = 1
                }else{
                    currencyLabel.alpha = self.unselectedLabelAlpha
                }
            }
        }
        
        
        //update new Amount by currency
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = "AUD"
        
        if let audAmountStr = formatter.numberFromString(self.AUDTextField.text!){
            let audAmount:Float = ("\(audAmountStr)" as NSString).floatValue
            self.displayAmountBySelectedCurrency(audAmount)
        }
        
    }
    
    
    //MARK: - Prepare Data
    /*
    private func prepareData(){
        
        
        let URL = NSURL(string: "http://api.fixer.io/latest")
        let parameters = [
            "base": "AUD",
            "symbols": "CAD,EUR,GBP,JPY,USD"
        ]
        
        Alamofire.request(.GET, URL!, parameters: parameters).responseJSON { response in
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                self.currencyRateDictionary = JSON["rates"] as! Dictionary<String,Float>
                
                
            }
        }
    }*/
    
    private func propareCurrencyArray(){
        
        let url = NSURL(string: "http://api.fixer.io/latest?base=AUD&symbols=CAD,EUR,GBP,JPY,USD")
        let request = NSURLRequest(URL: url!)
        _ = NSURLConnection(request: request, delegate:self, startImmediately: true)

    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    { //It says the response started coming
        NSLog("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection, didReceiveData _data: NSData)
    { //This will be called again and again unil you get the full response
       NSLog("didReceiveData")

        do {
           let jsonResults = try NSJSONSerialization.JSONObjectWithData(_data, options: [])
            // success ...
            print(jsonResults)
            self.currencyRateDictionary = jsonResults["rates"] as! Dictionary<String,Float>
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }

    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        // This will be called when the data loading is finished i.e. there is no data left to be received and now you can process the data.
        NSLog("connectionDidFinishLoading")

    }

    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == audTextFieldTag && textField.text?.characters.count>0{
            
            //display number
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.currencyCode = "AUD"
            
            if let audAmountStr = formatter.numberFromString(self.AUDTextField.text!){
                self.AUDTextField.text = "\(audAmountStr)"
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == audTextFieldTag && textField.text!.characters.count>0{
            
            let audAmount:Float = (self.AUDTextField.text! as NSString).floatValue
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

