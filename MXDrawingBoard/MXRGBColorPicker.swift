//
//  MXRGBColorPicker.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXRGBColorPicker: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var colorChangeBlock:((color: UIColor) ->Void)?
    private var sliders = [UISlider]()
    private var labels = [UILabel]()
    override init(frame:CGRect){
        super.init(frame:frame)
        initial()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initial()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let sliderHeight = CGFloat(31)
        let labelWidth = CGFloat(29)
        let yHeight = self.bounds.size.height / CGFloat(sliders.count)
        for index in 0..<self.sliders.count{
            let slider = sliders[index]
            slider.frame = CGRectMake(0, CGFloat(index) * yHeight, self.bounds.size.width, sliderHeight)
            let label = labels[index]
            label.frame = CGRectMake(CGRectGetMaxX(slider.frame) + 5, slider.frame.origin.y, labelWidth, sliderHeight)
        }
    }
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 107)
    }
    private func initial(){
       self.backgroundColor = UIColor.clearColor()
        let trackColors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
        for index in 1...3{
            let slider = UISlider()
            slider.minimumValue = 0
            slider.value = 0
            slider.maximumValue = 255
            slider.minimumTrackTintColor = trackColors[index - 1]
            slider.addTarget(self, action: "colorChanged:", forControlEvents: .ValueChanged)
            self.addSubview(slider)
            self.sliders.append(slider)
            let label = UILabel()
            label.text = "0"
            self.addSubview(label)
            self.labels.append(label)
        }
    }
     func colorChanged(slider:UISlider){
        let color = UIColor(red:CGFloat(sliders[0].value / 255.0) , green:CGFloat(sliders[1].value / 255.0), blue:CGFloat(sliders[2].value / 255.0), alpha: 1)
        let label = self.labels[find(self.sliders, object: slider)]
        label.text = NSString(format: "%.0f", slider.value) as String
        if let colorChangedBlock = self.colorChangeBlock{
            colorChangedBlock(color:color)
        }
        
    }
    private func find(array:NSArray, object:NSObject)->NSInteger{
       return array.indexOfObject(object)
    }
     func setCurrent(color:UIColor){
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let colors = [red, green, blue]
        for index in 0..<self.sliders.count{
            let slider = self.sliders[index]
            slider.value = Float(colors[index]) * 255
            let label = self.labels[index]
            label.text = NSString(format: "%.0f", slider.value) as String
        }
    }

}
