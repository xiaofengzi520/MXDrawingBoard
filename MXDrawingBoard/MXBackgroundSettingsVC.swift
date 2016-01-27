//
//  MXBackgroundSettingsVC.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXBackgroundSettingsVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    

    var backgroundImageChangedBlock: ((backgroundImage: UIImage) -> Void)?
    var backgroundColorChangedBlock: ((backgroundColor: UIColor) -> Void)?
    var pickerController:UIImagePickerController?
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController = UIImagePickerController()
        pickerController?.delegate = self;
        self.colorPicker.colorChangeBlock = {
            [unowned self] (color:UIColor) in
            if let backgroundColorChangedlBlock = self.backgroundColorChangedBlock{
                backgroundColorChangedlBlock(backgroundColor: color)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickImage(sender: UIButton) {
        self.presentViewController(pickerController!, animated: true, completion: nil)

    }

    @IBOutlet weak var colorPicker: MXRGBColorPicker!
   
    func setColor(color:UIColor){
        self.colorPicker.setCurrent(color)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
            backgroundImageChangedBlock(backgroundImage: image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
