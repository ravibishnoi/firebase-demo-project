//
//  ViewController.swift
//  Firebase Chat App
//
//  Created by AshutoshD on 03/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var tblView: UITableView!
    static let shared = ViewController()
    var arrData = [ChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tblView.delegate = self
        tblView.dataSource = self
//        self.tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFIRData()
    }
    
    func saveFIRDAta(){
        self.ref.child("chat").setValue("Ravi")
        //        var ref: DatabaseReference! = Database.database().reference()
        //        var dataDictionary: [String: Any] = [:]
        //        dataDictionary["First Name"] = "Johnny"
        //        dataDictionary["Last name"] =  "Appleseed"
        //        ref.setValue(dataDictionary)
        
    }
    
    func getFIRData(){
        arrData.removeAll()
        self.ref.child("chat").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot {
                    if let mainDict = snap.value as? [String : Any]{
                        let userId = mainDict["userID"] as? String ?? ""
                        let fname = mainDict["firstName"] as? String
                        let lname = mainDict["lastName"] as? String
                        let profileImageUrl = mainDict["profileUrl"] as? String ?? ""
                        self.arrData.append(ChatModel(userID: userId, firstName: fname!, lastName: lname!, profileUrl: profileImageUrl))
                        print(self.arrData)
                        self.tblView.reloadData()
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)}
    }
    
    
    @IBAction func BtnAddTapped(_ sender: Any) {
        
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "DataPickerVC") as! DataPickerVC
        self.navigationController?.pushViewController(newView, animated: true)
    }
    
//    @IBAction func BtnAddTapped(_ sender: UIBarButtonItem) {
//
//        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: UIAlertController.Style.alert)
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter Second Name"
//        }
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter First Name"
//        }
//
//        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
//
//            let firstTextField = alertController.textFields![0] as UITextField
//            let secondTextField = alertController.textFields![1] as UITextField
//            let dict = ["firstName" : firstTextField.text , "lastName" : secondTextField.text]
//            self.ref.child("chat").childByAutoId().setValue(dict)
////            self.arrData.removeAll()
//            self.getFIRData()
//            self.tblView.reloadData()
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
//            (action : UIAlertAction!) -> Void in })
//
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "DataTableCell", for: indexPath) as! DataTableCell
//        if !arrData.isEmpty {
//            cell.lblLName.text = arrData[indexPath.row].lastName
//            cell.lblFName.text = arrData[indexPath.row].firstName
//        }
//        else{
//            print("Data not saved")
//        }
        cell.ChatModel = arrData[indexPath.row]
        return cell
    }
    
   
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteString = arrData[indexPath.row].userID
            if deleteString != "" {
            ViewController.shared.removePost(withID: deleteString)
            tblView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }
    
}

// MARK: - Removing functions
extension ViewController {
    public func removePost(withID: String) {
        let reference = self.ref.child("chat").child(withID)
        reference.removeValue { error, _ in
            print(error!.localizedDescription)
        }
    }
}
