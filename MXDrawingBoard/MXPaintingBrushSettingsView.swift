//
//  MXPaintingBrushSettingsView.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXPaintingBrushSettingsView: UIView {

    @IBOutlet weak var colorPicker: MXRGBColorPicker!
    @IBOutlet weak var strokeWidthSlider: UISlider!
    @IBOutlet weak var strokeColorPreview: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func strokeWidthSliderChange(sender: UISlider) {
        if let strokeWidthChangedlBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedlBlock(strokeWidth: CGFloat(sender.value))
        }
    }
    var strokeWidthChangedBlock:((strokeWidth:CGFloat) ->Void)?
    var strokeColorChangedBlock:((strokeColor:UIColor) ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.strokeColorPreview.layer.borderColor = UIColor.blackColor().CGColor
        self.strokeColorPreview.layer.borderWidth = 1
        self.colorPicker.colorChangeBlock = {
            [unowned self] (color:UIColor) in
            self.strokeColorPreview.backgroundColor = color
            if let strokkVlock = self.strokeColorChangedBlock{
                strokkVlock(strokeColor: color)
            }
        }
    }
   public  func setSubviewColor(color:UIColor){
        self.strokeColorPreview.backgroundColor = color
        self.colorPicker.setCurrent(color)
    }
    

}
