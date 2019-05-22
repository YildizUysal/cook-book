//
//  EditsController.swift
//  Cook Book
//
//  Created by Yıldız Uysal on 20.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import CoreData

class EditsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var txtCookDegree: UITextField!
    @IBOutlet weak var txtPrepareName: UITextField!
    @IBOutlet weak var txtCookTime: UITextField!
    @IBOutlet weak var txtCookName: UITextField!
    
    var chosedCook = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditsController.selectImage))
        editImage.addGestureRecognizer(gestureRecognizer)
        
        print("geldim edit")
        if chosedCook != "" {
            print(chosedCook)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
            fetchReguest.predicate = NSPredicate(format: "cookName = %@", self.chosedCook) //Filtreleme
            fetchReguest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchReguest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        txtCookName.text = self.chosedCook
                        if let prename = result.value(forKey: "prepareName") as? String{
                            txtPrepareName.text = prename
                        }
                        if let degree = result.value(forKey: "cookDegree") as? Int{
                            txtCookDegree.text = String(degree)
                        }
                        if let time = result.value(forKey: "cookTime") as? String{
                            txtCookTime.text = time
                        }
                        if let imagedata = result.value(forKey: "cookImage") as? Data{
                            let img = UIImage(data: imagedata)
                            self.editImage.image = img
                        }
                    }
                }
            }catch{
                
            }
        }
        else{
            print("Doktor heryer boş")
        }
    }
    
    @objc func selectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        editImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSave(_ sender: Any) {
        if chosedCook == "" {
            print("boş basıldı save")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
        
            let newCook = NSEntityDescription.insertNewObject(forEntityName: "Cooks", into: context)
        //attributes
        
            if let degree = Int(txtCookDegree.text!){
                newCook.setValue(degree, forKey: "cookDegree")
            }
            newCook.setValue(txtCookName.text, forKey: "cookName")
            newCook.setValue(txtPrepareName.text, forKey: "prepareName")
            newCook.setValue(txtCookTime.text, forKey: "cookTime")
            let data  = UIImageJPEGRepresentation(editImage.image!, 0.5)
            newCook.setValue(data, forKey: "cookImage")
        
                do{
                    try context.save()
                    print("No Error")
                }
                catch {
                    print("Save Error")
                }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newCooks"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        if chosedCook != ""{
         
            print("boş değil save")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
            fetchReguest.predicate = NSPredicate(format: "cookName = %@", self.chosedCook) //Filtreleme
            fetchReguest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchReguest)
                if results.count > 0 {
                    print("resim kaydetme")
                    for result in results as! [NSManagedObject]{
                        if let name = txtCookName.text{
                            result.setValue(name, forKey: "cookName")
                        }
                        if let prename = txtPrepareName.text{
                            result.setValue(prename, forKey: "prepareName")
                        }
                        
                        if let degree = Int(txtCookDegree.text!){
                            result.setValue(degree, forKey: "cookDegree")
                        }
                        
                        if let imagedata = editImage.image{
                            let data  = UIImageJPEGRepresentation(imagedata, 0.5)
                            result.setValue(data, forKey: "cookImage")
                        }
                        
                        if let time = txtCookTime.text{
                            result.setValue(time, forKey: "cookTime")
                        }
                        
                    }
                }
//               DetailsController.choosenCook
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goDetails"), object: chosedCook)
                self.navigationController?.popViewController(animated: true)
            }catch{
                
            }
           
        }
        
    }
    

}
