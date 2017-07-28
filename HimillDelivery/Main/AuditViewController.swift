//
//  AuditViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/16.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import BEMCheckBox
import Alamofire
import SwiftyJSON

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
        
        if self.checkAllInfoReady() {
            
            self.requestForUploadAudit()
            
        }
        
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
    
    
    // MARK: - Network
    
    private func requestForUploadAudit() {
        
        let frontIDImageData = UIImageJPEGRepresentation(self.frontIdCardImageView.image!, 0.5)
        let handheldIdImageData = UIImageJPEGRepresentation(self.handheldIdCardImageView.image!, 0.5)
        
        let requestUrlString: String = CommonUrls.sharedInstance.kServerUrl + CommonUrls.sharedInstance.kProjectUrl + CommonUrls.sharedInstance.kSubmitIdAuditUrl
        
        let parameters = [
            "mobile": UserData.sharedInstance.userPhoneNumber,
            "idNumber": self.idNumberTextField.text,
            "name": self.realNameTextField.text]
        
        self.showProgressHUD(message: nil)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(frontIDImageData!, withName: "frontimageFile", fileName: "frontimageFile.jpg", mimeType: "image/jpg")
            multipartFormData.append(handheldIdImageData!, withName: "reverseimageFile", fileName: "reverseimageFile.jpg", mimeType: "image/jpg")
            
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: String.Encoding.utf8))!, withName: key)
            }
            
        }, to: requestUrlString) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    guard let result = response.result.value else {
                        print(response.result.error!)
                        self.hideProgressHUD()
                        return
                    }
                    
                    let resultJson = JSON(result)
                    print(resultJson)
                    
                    // 更新审核状态.
                    UserData.sharedInstance.userCheckStatus = resultJson["map"]["courier"]["isCheck"].string
                    UserData.sharedInstance.saveUserData()
                    
                    self.showAlert(titleString: "提交成功", messageString: "审核通过后，即可正常抢单", dismissTime: 0.5, finishedBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.hideProgressHUD()
                }
                
                break
                
            case .failure(let encodingError):
                
                print(encodingError)
                
                self.hideProgressHUD()
                
                break
            }
        }
    
    }
    
    private func checkAllInfoReady() -> Bool {
        
        if (self.realNameTextField.text?.characters.count)! == 0 {
            
            self.showAlert(titleString: "请输入真实姓名", messageString: "")
            return false
        }
        
        if self.checkIdNumberCorrect() == false {
            
            self.showAlert(titleString: "请输入正确的身份证", messageString: "")
            return false
        }
        
        if self.checkAllImageReady() == false {
            
            return false
        }
    
        return true
    }
    
    private func checkIdNumberCorrect() -> Bool {
    
        if self.idNumberTextField.text?.characters.count != 18 {
            return false
        }
        
        return true
    }
    
    private func checkAllImageReady() -> Bool {
    
        if (self.handheldIdCardImageView == nil) || (self.handheldIdCardImageView.isHidden == true) {
            
            self.showAlert(titleString: "请选择手持身份证照片", messageString: "")
            return false
        }
        
        if (self.frontIdCardImageView == nil) || (self.frontIdCardImageView.isHidden == true) {
            
            self.showAlert(titleString: "请选择身份证正面照片", messageString: "")
            return false
        }
    
        return true
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
        
        let imagePicked: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
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
