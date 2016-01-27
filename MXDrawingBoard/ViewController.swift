//
//  ViewController.swift
//  MXDrawingBoard
//
//  Created by 牟潇 on 16/1/26.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var brushes = [MXPencilBrush(), MXLineBrush(),MXDashLineBrush(),MXRectangleBrush(),MXEllipseBrush(),MXEraserBrush()]


    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var boardView: MXBoardView!
    
    @IBOutlet weak var toolbarConstraintHeight: NSLayoutConstraint!
    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.selectedSegmentIndex < self.brushes.count, "!!!!!");
        self.boardView.brush = self.brushes[sender.selectedSegmentIndex];
    }

    func updateToolbarForSettingsView() {
        self.toolbarConstraintHeight.constant = self.currentSettingsView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 44
        self.toolBar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolBar.layoutIfNeeded()
        UIView.commitAnimations()
        self.toolBar.bringSubviewToFront(self.currentSettingsView!)
    }
    var toolbarEditingItems:[UIBarButtonItem]?
    var currentSettingsView:UIView?
    func addConstraintsToToolbarForSettingsView(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.addSubview(view)
        self.toolBar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingsView]-0-|", options: .DirectionLeadingToTrailing, metrics: nil,views: ["settingsView" : view]))
        self.toolBar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingsView(==height)]",
            options: .DirectionLeadingToTrailing,
            metrics: ["height" : view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height],
            views: ["settingsView" : view]))
    }
    func setupBrushSettingsView() {
        let brushSettingsView = UINib(nibName: "MXPaintingBrushSettingsView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! MXPaintingBrushSettingsView
        self.addConstraintsToToolbarForSettingsView(brushSettingsView)
        brushSettingsView.hidden = true
        brushSettingsView.tag = 1
        brushSettingsView.backgroundColor = UIColor.whiteColor()
        brushSettingsView.setSubviewColor(self.boardView.strokeColor)
        brushSettingsView.strokeWidthChangedBlock = {
            [unowned self] (strokeWidth: CGFloat) -> Void in
            self.boardView.strokeWidth = strokeWidth
        }
        brushSettingsView.strokeColorChangedBlock = {
            [unowned self] (strokeColor: UIColor) -> Void in
            self.boardView.strokeColor = strokeColor
        }
    }
    func setupBackgroundSettingsView() {
         let backgroundSettingVc = MXBackgroundSettingsVC()
        self.addConstraintsToToolbarForSettingsView(backgroundSettingVc.view)
        backgroundSettingVc.view.hidden = true
        backgroundSettingVc.view.tag = 2
        backgroundSettingVc.view.backgroundColor = UIColor.whiteColor()
        backgroundSettingVc.setColor(self.boardView.strokeColor)
        self.addChildViewController(backgroundSettingVc)
        backgroundSettingVc.backgroundImageChangedBlock = {
            [unowned self] (backgroundImage: UIImage) in
            self.boardView.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        backgroundSettingVc.backgroundColorChangedBlock = {
            [unowned self] (backgroundColor: UIColor) in
            self.boardView.backgroundColor = backgroundColor
        }
    }

    @IBAction func setting(sender: UIBarButtonItem) {
        self.currentSettingsView = self.toolBar.viewWithTag(1)
        self.currentSettingsView?.hidden = false
        updateToolbarForSettingsView()

    }
    
    func endSetting() {
        self.toolbarConstraintHeight.constant = 44
        self.toolBar.setItems(self.toolbarItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolBar.layoutIfNeeded()
        UIView.commitAnimations()
        self.currentSettingsView?.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundSetting(sender: UIBarButtonItem) {
        self.currentSettingsView = self.toolBar.viewWithTag(2)
        self.currentSettingsView?.hidden = false
        self.updateToolbarForSettingsView()

    }
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewConstraintY: NSLayoutConstraint!

    @IBOutlet weak var toolbarConstraintBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.boardView.brush = brushes[0]
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style:.Plain, target: self, action: "endSetting")
        ]
        self.toolbarItems = self.toolBar.items
        self.setupBrushSettingsView()
        setupBackgroundSettingsView()
        self.boardView.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state != .Moved {
                UIView.beginAnimations(nil, context: nil)
                if state == .Began {
                    self.topViewConstraintY.constant = -self.topView.frame.size.height
                    self.toolbarConstraintBottom.constant = -self.toolBar.frame.size.height
                    self.topView.layoutIfNeeded()
                    self.toolBar.layoutIfNeeded()
                } else if state == .Ended {
                    UIView.setAnimationDelay(1.0)
                    self.topViewConstraintY.constant = 0
                    self.toolbarConstraintBottom.constant = 0
                    self.topView.layoutIfNeeded()
                    self.toolBar.layoutIfNeeded()
                }
                UIView.commitAnimations()
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveImage(sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(self.boardView.takeImage(),nil,nil,nil)
    }
    
    
    

}

