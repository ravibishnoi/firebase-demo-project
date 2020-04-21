//
//  DataPickerVC.swift
//  FirebaseDemoProject
//
//  Created by AshutoshD on 07/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class DataPickerVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtScndName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    var ref: DatabaseReference!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
  
  
    @IBAction func BtnSelectImgTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgView.contentMode = .scaleToFill
            imgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitTapped(_ sender: UIButton) {
        saveFIRData()
    }
    
    func  saveFIRData() {
        self.uploadImage(self.imgView.image!){ url in
            self.saveImage(userID: Date().asUUID, Fname: self.txtFirstName.text!, LName: self.txtScndName.text!, profileURL: url!){ success in
                if success != nil {
                    print("Yeah Yes")
                }
            }
        }
    }
   
    func uploadImage(_ image:UIImage, completion: @escaping (_ _url : URL? ) -> ()){
        
        
        let storageRef = Storage.storage().reference().child("lock.png")
        let imgData = imgView.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metadata , error) in
            if error == nil {
                print("success")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                print("error in save image")
            }
        }
    }

    func saveImage(userID : String ,Fname : String , LName : String , profileURL:URL, completion: @escaping ((_ url: URL?)-> ())){
        let dict = ["userID" : Date().asUUID ,"firstName" : txtFirstName.text!, "lastName" : txtScndName.text! , "profileUrl" : profileURL.absoluteString] as [String:Any]
        self.ref.child("chat").child(Date().asUUID).setValue(dict)
    }
}

extension Date {
    var asUUID: String {
        let asInteger = Int(self.timeIntervalSince1970)
        return String(asInteger)
    }
}

