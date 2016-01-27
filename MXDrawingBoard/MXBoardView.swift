//
//  MXBoardView.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
enum DrawingState{
    case Began ,Moved ,Ended
}

class MXBoardView: UIImageView {

    var strokeWidth: CGFloat
    var strokeColor:UIColor
    var brush: MXBaseBrush?
    private var realImage:UIImage?
    private var drawingState:DrawingState!
    var drawingStateChangedBlock: ((state: DrawingState) -> ())?
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let newBrush = self.brush{
            newBrush.lastPoint = nil;
            newBrush.beginPoint = (touches as NSSet).anyObject()?.locationInView(self)
            newBrush.endPoint = newBrush.beginPoint;
            drawingState = DrawingState.Began
            drawingImage()
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let newBrush = self.brush{
            newBrush.endPoint = (touches as NSSet).anyObject()?.locationInView(self)
            drawingState = DrawingState.Moved
            drawingImage()
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let newBrush = self.brush{
            newBrush.endPoint = nil;
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let newBrush = self.brush{
            newBrush.endPoint = (touches as NSSet).anyObject()?.locationInView(self)
            drawingState = DrawingState.Ended
            drawingImage()
        }
    }
    private func drawingImage(){
        if let newBrush = self.brush{
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(state: self.drawingState)
            }
            UIGraphicsBeginImageContext(self.bounds.size)
            let context = UIGraphicsGetCurrentContext()
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds);
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context,  strokeWidth)
            CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
            if let newImage = self.realImage{
                newImage.drawInRect(self.bounds)
            }
            newBrush.strokeWidth = self.strokeWidth
            newBrush.drawInContext(context!)
            CGContextStrokePath(context)
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if drawingState == DrawingState.Ended || newBrush.supportedContinuousDrawing(){
                self.realImage = previewImage
            }
            UIGraphicsEndImageContext()
            self.image = previewImage;
            newBrush.lastPoint = newBrush.endPoint
        }
        
    }
    override init(frame:CGRect){
        strokeColor = UIColor.blackColor()
        strokeWidth = 1
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        strokeWidth = 1
        strokeColor = UIColor.blackColor()
        super.init(coder: aDecoder)
    }

    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        self.image?.drawInRect(self.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
