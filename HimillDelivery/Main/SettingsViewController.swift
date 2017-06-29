//
//  SettingsViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/22.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
