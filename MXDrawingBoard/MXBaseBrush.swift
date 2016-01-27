//
//  MXBaseBrush.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
protocol MXPaintBrush{
    func supportedContinuousDrawing() ->Bool; //是否要连续不断的绘图
    func drawInContext(context:CGContextRef); //基于context的绘图方法,子类必须实现的具体绘图
}

class MXBaseBrush: NSObject, MXPaintBrush {
    var beginPoint:CGPoint!
    var endPoint:CGPoint!
    var lastPoint:CGPoint?
    var strokeWidth:CGFloat!
    func supportedContinuousDrawing() -> Bool {
        return false;
    }
    func drawInContext(context: CGContextRef) {
        assert(false, "must implements in subclass.")
    }
}
class MXPencilBrush:MXBaseBrush{
    override func drawInContext(context: CGContextRef) {
        if let newPoint = self.lastPoint{
            CGContextMoveToPoint(context, newPoint.x, newPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        }else{
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
            CGContextAddLineToPoint(context, endPoint!.x, endPoint!.y)

        }
        
    }
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
class MXLineBrush:MXBaseBrush{
    override func drawInContext(context: CGContextRef) {
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }
}

class MXDashLineBrush:MXBaseBrush{
    override func drawInContext(context: CGContextRef) {
        let lengths:[CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3];
        CGContextSetLineDash(context, 0, lengths, 2)
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }

}
class MXRectangleBrush:MXBaseBrush{
    override func drawInContext(context: CGContextRef) {
        CGContextAddRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)),
            size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}

class MXEllipseBrush:MXBaseBrush{
    override func drawInContext(context: CGContextRef) {
        CGContextAddEllipseInRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)),
            size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}
class MXEraserBrush:MXPencilBrush{
    override func drawInContext(context: CGContextRef) {
        CGContextSetBlendMode(context, CGBlendMode.Clear);
        super.drawInContext(context);
    }
}
