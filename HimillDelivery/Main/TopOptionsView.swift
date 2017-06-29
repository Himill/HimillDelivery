//
//  TopOptionsView.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/20.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

enum TopOptions {
    case newTask
    case toPickUp
    case distribution
}


protocol TopOptionsViewDelegate {
    func topOptionsButtonClicked(whichOption: TopOptions)
}


class TopOptionsView: UIView {
    
    @IBOutlet weak var newTaskLabel: UILabel?
    @IBOutlet weak var newTaskButton: UIButton?
    
    @IBOutlet weak var toPickUpLabel: UILabel?
    @IBOutlet weak var toPickUpButton: UIButton?
    
    @IBOutlet weak var distributionLabel: UILabel?
    @IBOutlet weak var distributionButton: UIButton?
    
    @IBOutlet weak var lineView: UIView?
    
    
    var delegate: TopOptionsViewDelegate? = nil
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newTaskButton?.addTarget(self, action: #selector(newTaskButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.toPickUpButton?.addTarget(self, action: #selector(toPickUpButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.distributionButton?.addTarget(self, action: #selector(distributionButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    
    // MARK: - Private method
    
    func newTaskButtonClicked(sender: Any) {
        self.changeOption(option: TopOptions.newTask)
    }
    
    func toPickUpButtonClicked(sender: Any) {
        self.changeOption(option: TopOptions.toPickUp)
    }
    
    func distributionButtonClicked(sender: Any) {
        self.changeOption(option: TopOptions.distribution)
    }
    
    private func changeOption(option: TopOptions) {
        switch option {
        case .newTask:
            self.newTaskLabel?.textColor = Constant().kRedColor
            self.toPickUpLabel?.textColor = Constant().kBlackLightFontColor
            self.distributionLabel?.textColor = Constant().kBlackLightFontColor
            
            UIView.animate(withDuration: 0.3, animations: {
                self.lineView?.frame = CGRect(x: 0, y: (self.lineView?.frame.origin.y)!, width: (self.lineView?.frame.size.width)!, height: (self.lineView?.frame.size.height)!)
            })
            
            self.delegate?.topOptionsButtonClicked(whichOption: TopOptions.newTask)
            
            break
        case .toPickUp:
            self.newTaskLabel?.textColor = Constant().kBlackLightFontColor
            self.toPickUpLabel?.textColor = Constant().kRedColor
            self.distributionLabel?.textColor = Constant().kBlackLightFontColor
            
            UIView.animate(withDuration: 0.3, animations: {
                self.lineView?.frame = CGRect(x: (self.lineView?.frame.size.width)!, y: (self.lineView?.frame.origin.y)!, width: (self.lineView?.frame.size.width)!, height: (self.lineView?.frame.size.height)!)
            })
            
            self.delegate?.topOptionsButtonClicked(whichOption: TopOptions.toPickUp)
            
            break
        case .distribution:
            self.newTaskLabel?.textColor = Constant().kBlackLightFontColor
            self.toPickUpLabel?.textColor = Constant().kBlackLightFontColor
            self.distributionLabel?.textColor = Constant().kRedColor
            
            UIView.animate(withDuration: 0.3, animations: {
                self.lineView?.frame = CGRect(x: (self.lineView?.frame.size.width)! * 2, y: (self.lineView?.frame.origin.y)!, width: (self.lineView?.frame.size.width)!, height: (self.lineView?.frame.size.height)!)
            })
            
            self.delegate?.topOptionsButtonClicked(whichOption: TopOptions.distribution)
            
            break
        }
    }

}
