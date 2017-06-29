//
//  LoginViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/16.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import QuartzCore
import MZTimerLabel

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var veryficationCodeTextField: UITextField!
    
    @IBOutlet weak var getVerificationCodeView: UIView!
    @IBOutlet weak var getVerificationCodeLabel: UILabel!
    @IBOutlet weak var getVerificationCodeButton: UIButton!
    
    @IBOutlet weak var loginButtonView: UIView!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let dashboardViewController: DashboardViewController = self.getViewController(storyboardName: "Dashboard", viewControllerId: "SID_DashboardViewController") as! DashboardViewController
        self.navigationController?.pushViewController(dashboardViewController, animated: true)
    }
    
    var timerLabel: MZTimerLabel? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.configRoundRect()
        
        self.configTimerLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private method
    
    private func configRoundRect() {
        self.phoneNumberTextField.layer.cornerRadius = 3.0
        self.phoneNumberTextField.layer.borderWidth = 1.0
        self.phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberTextField.clipsToBounds = true
        
        self.veryficationCodeTextField.layer.cornerRadius = 3.0
        self.veryficationCodeTextField.layer.borderWidth = 1.0
        self.veryficationCodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.veryficationCodeTextField.clipsToBounds = true
        
        self.getVerificationCodeView.layer.cornerRadius = 3.0
        self.getVerificationCodeView.layer.borderWidth = 1.0
        self.getVerificationCodeView.layer.borderColor = UIColor.clear.cgColor
        
        self.loginButtonView.layer.cornerRadius = 3.0
        self.loginButtonView.layer.borderWidth = 1.0
        self.loginButtonView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configTimerLabel() {
        self.timerLabel = MZTimerLabel.init(label: self.getVerificationCodeLabel, andTimerType: MZTimerLabelTypeTimer)
        self.timerLabel?.delegate = self
        self.timerLabel?.timeFormat = "ss"
        self.timerLabel?.timeLabel.text = "获取验证码"
        
        self.getVerificationCodeButton.addTarget(self, action: #selector(getVerificationButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    private func startTimerLabel() {
        self.timerLabel?.reset()
        self.getVerificationCodeButton.setTitle("", for: UIControlState.normal)
        
        let timerString: String = "here秒后重发"
        let textRange: Range = timerString.range(of: "here")!
        let textNSRange: NSRange = timerString.nsRange(from: textRange)
        self.timerLabel?.text = timerString
        self.timerLabel?.textRange = textNSRange
        self.timerLabel?.setCountDownTime(60)
        self.timerLabel?.start()
        
        self.getVerificationCodeButton.isEnabled = false
    }
    
    @objc private func getVerificationButtonClicked(sender: UIButton) {
        self.startTimerLabel()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: MZTimerLabelDelegate {

    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        self.getVerificationCodeButton.isEnabled = true

        self.timerLabel?.timeLabel.text = "获取验证码"
        self.getVerificationCodeButton.isEnabled = true
    }
    
}


extension String {
    
    // range转换为NSRange.
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    // NSRange转化为range.
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

