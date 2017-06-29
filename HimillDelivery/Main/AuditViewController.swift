//
//  AuditViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/16.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import BEMCheckBox

enum ImageViewPickedType {
    case handheldId
    case frontId
}

class AuditViewController: BaseViewController {
    
    @IBOutlet weak var realNameView: UIView!
    @IBOutlet weak var realNameTextField: UITextField!
    
    @IBOutlet weak var idNumberView: UIView!
    @IBOutlet weak var idNumberTextField: UITextField!
    
    @IBOutlet weak var handheldIdCardView: UIView!
    @IBOutlet weak var handheldIdCardButton: UIButton!
    @IBOutlet weak var handheldIdCardImageView: UIImageView!
    @IBOutlet weak var handheldTakingPhotoImageView: UIImageView!
    
    @IBOutlet weak var frontIdCardView: UIView!
    @IBOutlet weak var frontIdCardButton: UIButton!
    @IBOutlet weak var frontIdCardImageView: UIImageView!
    @IBOutlet weak var frontIdTakingPhotoImageView: UIImageView!
    
    @IBOutlet weak var commitButton: UIButton!
    
    var imageViewType: ImageViewPickedType?
    
    @IBOutlet weak var readedCheckBox: BEMCheckBox!
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var imagePicker: UIImagePickerController? = nil
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.configUIForView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private method
    
    private func configUIForView() {
        self.realNameView.layer.cornerRadius = 3.0
        self.realNameView.layer.borderWidth = 1.0
        self.realNameView.layer.borderColor = UIColor.clear.cgColor
        self.realNameView.clipsToBounds = true
        
        self.idNumberView.layer.cornerRadius = 3.0
        self.idNumberView.layer.borderWidth = 1.0
        self.idNumberView.layer.borderColor = UIColor.clear.cgColor
        self.idNumberView.clipsToBounds = true
        
        self.handheldIdCardView.layer.cornerRadius = 3.0
        self.handheldIdCardView.layer.borderWidth = 1.0
        self.handheldIdCardView.layer.borderColor = UIColor.lightGray.cgColor
        self.handheldIdCardView.clipsToBounds = true
        self.handheldIdCardButton.addTarget(self, action: #selector(handheldCardButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        self.frontIdCardView.layer.cornerRadius = 3.0
        self.frontIdCardView.layer.borderWidth = 1.0
        self.frontIdCardView.layer.borderColor = UIColor.lightGray.cgColor
        self.frontIdCardView.clipsToBounds = true
        self.frontIdCardButton.addTarget(self, action: #selector(frontIdCardButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        self.handheldTakingPhotoImageView.isHidden = false
        self.handheldIdCardImageView.isHidden = true
        self.frontIdTakingPhotoImageView.isHidden = false
        self.frontIdCardImageView.isHidden = true
        
        self.commitButton.layer.cornerRadius = 3.0
        self.commitButton.layer.borderWidth = 1.0
        self.commitButton.layer.borderColor = UIColor.clear.cgColor
        self.commitButton.addTarget(self, action: #selector(commitButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        self.readedCheckBox.on = true
    }
    
    @objc private func commitButtonClicked(sender: Any) {
        
    }
    
    @objc private func handheldCardButtonClicked(sender: Any) {
        self.imagePickerPopUp()
        self.imageViewType = ImageViewPickedType.handheldId
    }
    
    @objc private func frontIdCardButtonClicked(sender: Any) {
        self.imagePickerPopUp()
        self.imageViewType = ImageViewPickedType.frontId
    }
    
    private func sharingImagePicker() {
        if self.imagePicker == nil {
            self.imagePicker = UIImagePickerController.init()
        }
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = true
    }
    
    private func loadLocalImage() {
        self.sharingImagePicker()
        self.imagePicker?.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        self.present(self.imagePicker!, animated: true, completion: nil)
    }
    
    private func loadCamera() {
        self.sharingImagePicker()
        self.imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
        self.present(self.imagePicker!, animated: true, completion: nil)
    }
    
    private func imagePickerPopUp() {
        let alert: UIAlertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction.init(title: "从相册选择", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.loadLocalImage()
        }))
        alert.addAction(UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.loadCamera()
        }))
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
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


extension AuditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let imagePicked: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        switch self.imageViewType! {
        case .handheldId:
            self.handheldIdCardImageView.image = imagePicked
            
            self.handheldTakingPhotoImageView.isHidden = true
            self.handheldIdCardImageView.isHidden = false
            break
        case .frontId:
            self.frontIdCardImageView.image = imagePicked
            
            self.frontIdTakingPhotoImageView.isHidden = true
            self.frontIdCardImageView.isHidden = false
            break
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
