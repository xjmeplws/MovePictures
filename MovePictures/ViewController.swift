//
//  ViewController.swift
//  MovePictures
//
//  Created by huangyawei on 15/10/29.
//  Copyright © 2015年 sapze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?
    var imgView: UIImageView?
    var imagePickerController: UIImagePickerController = UIImagePickerController()
    var containerView = UIView()
    var rowTextField: UITextField?
    var columnTextField: UITextField?
    var coverView: UIView?
    var resetView: UIView?
    
    var defaultColumn = 4
    var defaultRow = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 120)
        self.view.addSubview(containerView)
        containerView.backgroundColor = UIColor(red: 240 / 255.0, green: 212 / 255.0, blue: 240 / 255.0, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 100, 100))
        titleLabel.text = "请选择图片开始游戏"
        containerView.addSubview(titleLabel)
        titleLabel.setWidthPercent(80)
        titleLabel.alignCenter()
        titleLabel.verticalCenter()
        titleLabel.textAlignment = .Center
        
        let bottomView = UIView(frame: CGRectMake(0, 0, 100, 100))
        self.view.addSubview(bottomView)
        bottomView.setWidthPercent(100)
        bottomView.alignBottom()
        
        let selectImageButtom = UIButton(frame: CGRectMake(0, 20, 100, 30))
        selectImageButtom.layer.cornerRadius = 3.0
        selectImageButtom.backgroundColor = UIColor(red: 170 / 255.0, green: 104 / 255.0, blue: 169 / 255.0, alpha: 1)
        selectImageButtom.titleLabel?.font = UIFont.systemFontOfSize(14)
        selectImageButtom.setTitle("选择图片", forState: .Normal)
        selectImageButtom.addTarget(self, action: "SelectImage:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(selectImageButtom)
        selectImageButtom.setWidthPercent(20)
        selectImageButtom.alignRight(percent: 10)
        
        let selectHardButton = UIButton(frame: CGRectMake(0, 20, 100, 30))
        selectHardButton.layer.cornerRadius = 3.0
        selectHardButton.backgroundColor = UIColor(red: 170 / 255.0, green: 104 / 255.0, blue: 169 / 255.0, alpha: 1)
        selectHardButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        selectHardButton.setTitle("选择难度", forState: .Normal)
        selectHardButton.addTarget(self, action: "reSetHardLevel:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(selectHardButton)
        selectHardButton.setWidthPercent(20)
        selectHardButton.alignRight(percent: 10)
        selectHardButton.alignTopToView(selectImageButtom, top: 10)
        
        let startButtom = UIButton(frame: CGRectMake(0, 15, 70, 70))
        startButtom.layer.cornerRadius = 35.0
        startButtom.setTitle("Start", forState: .Normal)
        startButtom.backgroundColor = UIColor(red: 170 / 255.0, green: 104 / 255.0, blue: 169 / 255.0, alpha: 1)
        startButtom.addTarget(self, action: "startGame:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(startButtom)
        startButtom.alignRightToView(selectImageButtom, right: 20)
        
        imgView = UIImageView(frame: CGRectMake(0, 5, 80, 90))
        imgView?.backgroundColor = UIColor.blackColor() //UIColor(red: 240 / 255.0, green: 212 / 255.0, blue: 240 / 255.0, alpha: 1)
        bottomView.addSubview(imgView!)
        imgView?.alignLeft(percent: 10)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imgView?.userInteractionEnabled = true
        let tapEvent = UITapGestureRecognizer(target: self, action: "imgPress:")
        imgView?.addGestureRecognizer(tapEvent)
    }
    var tempImageView: UIImageView?
    func imgPress(sender: AnyObject) {
        tempImageView = UIImageView(frame: CGRectMake(0, self.view.frame.size.height, 0, self.view.frame.height - 20))
        tempImageView?.removeFromSuperview()
        self.view.addSubview(tempImageView!)
        tempImageView!.image = self.image
        let animationDuration: NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeView", context: nil)
        UIView.setAnimationDuration(animationDuration)
        tempImageView!.frame = self.view.frame
        UIView.commitAnimations()
        tempImageView!.userInteractionEnabled = true
        let tapEvent = UITapGestureRecognizer(target: self, action: "tempImgPress:")
        tempImageView!.addGestureRecognizer(tapEvent)
    }
    func tempImgPress(sender: AnyObject) {
        let animationDuration: NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeView", context: nil)
        UIView.setAnimationDuration(animationDuration)
        tempImageView!.frame = CGRectMake(0, self.view.frame.size.height, 0, self.view.frame.height - 20)
        UIView.commitAnimations()
        //tempImageView!.removeFromSuperview()
    }
    
    func initGame(){
        totalStep = 0
        emptyPoint = [0, -1]
        containerView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 120)
        for v in self.containerView.subviews {
            v.removeFromSuperview()
        }
        
        var lastView = UIView(frame: CGRectZero)
        var lastPoint = CGPoint(x: 0, y: 0)
        
        let picview0 = PictureCellView(frame: CGRectMake(100, 100, 100, 100))
        
        self.containerView.addSubview(picview0)
        picview0.tag = -999
        picview0.setWidthPercent(100 / defaultColumn)
        picview0.setHeightPercent(100 / (defaultRow + 1))
        picview0.layer.borderColor = UIColor.whiteColor().CGColor
        picview0.layer.borderWidth = 1.5
        picview0.frame.origin = lastPoint
        lastView = picview0
        lastPoint = CGPoint(x: 0, y: lastPoint.y + lastView.frame.size.height)
        
        var totalWidth: CGFloat = 0.0
        var totalHeight: CGFloat = 0.0
        for i in 0...(defaultRow - 1) {
            totalWidth = 0.0
            for j in 0...(defaultColumn - 1) {
                let picview = PictureCellView(frame: CGRectMake(100, 100, 100, 100))
                picview.defaultLocation = [j, i]
                picview.currentlocation = [j, i]
                self.containerView.addSubview(picview)
                picview.setWidthPercent(100 / defaultColumn)
                picview.setHeightPercent(100 / (defaultRow + 1))
                picview.frame.origin = lastPoint
                picview.layer.borderColor = UIColor.whiteColor().CGColor
                picview.layer.borderWidth = 0.5
                lastPoint = CGPoint(x: lastPoint.x + picview.frame.size.width, y: lastPoint.y)
                lastView = picview
                totalWidth += picview.frame.size.width
                
                picview.image = getPartOfImage([j, i])
            }
            totalHeight += lastView.frame.size.height
            lastPoint = CGPoint(x: 0, y: lastPoint.y + lastView.frame.size.height)
        }
        containerView.frame = CGRectMake(0, 20, totalWidth, totalHeight + picview0.frame.size.height)
        containerView.alignCenter()
    }
    func startGame(sender: UIButton){
        totalStep = 0
        let count = defaultColumn * defaultRow - 1
        var defaultArray = [Int]()
        for i in 1...count {
            defaultArray.append(i)
        }
        
        if count < 25 {
            let animationDuration: NSTimeInterval = 0.3
            UIView.beginAnimations("ResizeView", context: nil)
            UIView.setAnimationDuration(animationDuration)
        }
        for picView in self.containerView.subviews {
            if picView is PictureCellView {
                let cell = picView as! PictureCellView
                if cell.defaultLocation == [0, 0] || cell.tag == -999{
                    continue
                }
                var currentArray = defaultArray
                
                var j = count - 1
                while j > -1 {
                    let randNumber = rand(0, max: UInt32(currentArray.count))
                    let currentIndex = currentArray[Int(randNumber)]
                    let tempPicView = self.containerView.subviews[currentIndex + 1] as! PictureCellView
                    let cTFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
                    let cTLocation = cell.currentlocation
                    cell.currentlocation = tempPicView.currentlocation
                    tempPicView.currentlocation = cTLocation
                    cell.frame = tempPicView.frame
                    tempPicView.frame = cTFrame
                    j--
                    currentArray.removeAtIndex(Int(randNumber))
                }
            }
        }
        if count < 25 {
            UIView.commitAnimations()
        }
    }
    func reSetHardLevel(sender: UIButton){
        if coverView == nil {
            coverView = UIView(frame: self.view.frame)
            coverView!.backgroundColor = UIColor.blackColor()
            coverView!.alpha = 0.5
            coverView?.hidden = false
            self.view.addSubview(coverView!)
            
            resetView = UIView(frame: CGRectMake(0, 0, 100, 250))
            resetView?.hidden = false
            resetView?.backgroundColor = UIColor.whiteColor()
            resetView?.layer.cornerRadius = 4.0
            self.view.addSubview(resetView!)
            resetView?.setWidthPercent(80)
            resetView?.alignTop(percent: 20)
            resetView?.alignCenter()
            
            let rowLabel = UILabel(frame: CGRectMake(50, 100, 50, 30))
            rowLabel.hidden = false
            rowLabel.text = "行数:"
            rowLabel.textAlignment = .Right
            self.resetView!.addSubview(rowLabel)
            rowLabel.verticalCenter(-30, left: 0)
            
            rowTextField = UITextField(frame: CGRectMake(0, 100, 100, 30))
            rowTextField?.hidden = false
            rowTextField!.text = "\(defaultRow)"
            rowTextField!.borderStyle = .RoundedRect
            rowTextField!.keyboardType = .NumberPad
            rowTextField!.returnKeyType = .Done
            self.resetView!.addSubview(rowTextField!)
            rowTextField!.alignLeftToView(rowLabel, left: 20)
            rowTextField!.verticalCenter(-30, left: 0)
            
            let columnLabel = UILabel(frame: CGRectMake(50, 100, 50, 30))
            columnLabel.hidden = false
            columnLabel.text = "列数:"
            columnLabel.textAlignment = .Right
            self.resetView!.addSubview(columnLabel)
            columnLabel.alignTopToView(rowLabel, top: 20.0)
            
            columnTextField = UITextField(frame: CGRectMake(0, 100, 100, 30))
            columnTextField?.hidden = false
            columnTextField!.text = "\(defaultColumn)"
            columnTextField!.borderStyle = .RoundedRect
            columnTextField!.keyboardType = .NumberPad
            columnTextField!.returnKeyType = .Done
            self.resetView!.addSubview(columnTextField!)
            columnTextField!.alignLeftToView(rowLabel, left: 20)
            columnTextField!.alignTopToView(rowTextField!, top: 20.0)
            
            let cancelButton = UIButton(frame: CGRectMake(100, 100, 100, 40))
            cancelButton.setTitle("取消", forState: .Normal)
            cancelButton.layer.cornerRadius = 4.0
            cancelButton.backgroundColor = UIColor(red: 98 / 255.0, green: 69 / 255.0, blue: 98 / 255.0, alpha: 1)
            cancelButton.addTarget(self, action: "cancelReset:", forControlEvents: .TouchUpInside)
            if #available(iOS 8.2, *) {
                cancelButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: 500)
            } else {
                cancelButton.titleLabel?.font = UIFont.systemFontOfSize(18)
            }
            self.resetView!.addSubview(cancelButton)
            cancelButton.setWidthPercent(30)
            cancelButton.alignTopToView(columnTextField!, top: 20)
            cancelButton.alignLeft(percent: 17)
            
            let confirmButton = UIButton(frame: CGRectMake(100, 100, 100, 40))
            confirmButton.setTitle("确定", forState: .Normal)
            confirmButton.layer.cornerRadius = 4.0
            confirmButton.backgroundColor = UIColor(red: 98 / 255.0, green: 69 / 255.0, blue: 98 / 255.0, alpha: 1)
            confirmButton.addTarget(self, action: "confirmReset:", forControlEvents: .TouchUpInside)
            if #available(iOS 8.2, *) {
                confirmButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: 500)
            } else {
                confirmButton.titleLabel?.font = UIFont.systemFontOfSize(18)
            }
            self.resetView!.addSubview(confirmButton)
            confirmButton.setWidthPercent(30)
            confirmButton.alignTopToView(columnTextField!, top: 20)
            confirmButton.alignRight(percent: 17)
        } else {
            coverView?.hidden = false
            resetView?.hidden = false
        }
    }
    
    func confirmReset(sender: UIButton) {
        if rowTextField!.isEmpty || !rowTextField!.isNumber || columnTextField!.isEmpty || !columnTextField!.isNumber {
            UIAlertView(title: "警告", message: "参数填写不正确", delegate: self, cancelButtonTitle: "确定").show()
            return
        }
        defaultColumn = Int(columnTextField!.text!)!
        defaultRow = Int(rowTextField!.text!)!
        coverView?.hidden = true
        resetView?.hidden = true
        self.view.endEditing(false)
        initGame()
    }
    func cancelReset(sender: UIButton) {
        coverView?.hidden = true
        resetView?.hidden = true
        self.view.endEditing(false)
    }
    
    private func rand(min: UInt32, max: UInt32) -> UInt32 {
        return arc4random_uniform(max - min) + min
    }
    
    func SelectImage(sender: UIButton) {
        imagePickerController.delegate = self
        //imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    func isPhotoAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    var imageRef: CGImageRef?
    func getPartOfImage(location: [Int]) -> UIImage? {
        guard let imageRef = imageRef else {
            return nil
        }
        let h = (image?.size.height)! / CGFloat(defaultRow)
        let w = (image?.size.width)! / CGFloat(defaultColumn)
        
        let x = w * CGFloat(location[0])
        let y = h * CGFloat(location[1])
        
        let r = CGRectMake(x, y, w, h)
        
        let partRef: CGImageRef = CGImageCreateWithImageInRect(imageRef, r)!
        let retImg = UIImage(CGImage: partRef)
        
        return retImg
    }
    
    func getNewImage(img: UIImage, scale: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(scale)
        img.drawInRect(CGRectMake(0, 0, scale.width, scale.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var tempImage: UIImage
        if picker.allowsEditing {
            tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        self.image = getNewImage(tempImage, scale: self.containerView.frame.size)
        
        imgView?.image = image
        imageRef = self.image?.CGImage
        initGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        image = nil
        imageRef = nil
        rowTextField = nil
        columnTextField = nil
        if let views = resetView?.subviews {
            for v in views {
                v.removeFromSuperview()
            }
        }
        coverView = nil
        resetView = nil
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(false)
    }

}

public extension UITextField{
    func validate(RegEx: String, text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return predicate.evaluateWithObject(text)
    }
    
    public var isEmpty: Bool {
        return self.text == ""
    }
    
    public func validate(RegEx: String) -> Bool {
        return validate(RegEx, text: self.text!)
    }
    
    public var isEmail: Bool {
        return self.validate("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
    }
    
    public var isNumber: Bool {
        return self.validate("^[0-9]*$")
    }
    
    public var length: Int {
        return self.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
}
