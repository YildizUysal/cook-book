//
//  DetailsController.swift
//  Cook Book
//
//  Created by Yıldız Uysal on 20.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import CoreData

class DetailsController: UIViewController {

    @IBOutlet weak var detailsImage: UIImageView!
    
    @IBOutlet weak var lblPrepareName: UILabel!
    @IBOutlet weak var lblCookTime: UILabel!
    @IBOutlet weak var lblCookDegree: UILabel!
    @IBOutlet weak var lblCookName: UILabel!
    
    var choosenCook = ""
    var editchoosenCook = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getInfoget()
    
        
    }
    
    @objc func getInfoget(){
        if choosenCook != "" {
            print(choosenCook)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
            fetchReguest.predicate = NSPredicate(format: "cookName = %@", self.choosenCook) //Filtreleme
            fetchReguest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchReguest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "cookName") as? String{
                            lblCookName.text = name
                        }
                        if let prename = result.value(forKey: "prepareName") as? String{
                            lblPrepareName.text = prename
                        }
                        if let degree = result.value(forKey: "cookDegree") as? Int{
                            lblCookDegree.text = String(degree)
                        }
                        if let time = result.value(forKey: "cookTime") as? String{
                            lblCookTime.text = time
                        }
                        if let imagedata = result.value(forKey: "cookImage") as? Data{
                            let img = UIImage(data: imagedata)
                            self.detailsImage.image = img
                        }
                    }
                }
            }catch{
                
            }
        }
            if choosenCook == "" {
                print(choosenCook)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
                fetchReguest.predicate = NSPredicate(format: "cookName = %@", self.choosenCook) //Filtreleme
                fetchReguest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchReguest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "cookName") as? String{
                                lblCookName.text = name
                            }
                            if let prename = result.value(forKey: "prepareName") as? String{
                                lblPrepareName.text = prename
                            }
                            if let degree = result.value(forKey: "cookDegree") as? Int{
                                lblCookDegree.text = String(degree)
                            }
                            if let time = result.value(forKey: "cookTime") as? String{
                                lblCookTime.text = time
                            }
                            if let imagedata = result.value(forKey: "cookImage") as? Data{
                                let img = UIImage(data: imagedata)
                                self.detailsImage.image = img
                            }
                        }
                    }
                }catch{
                    
                }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsController.getInfoget), name: NSNotification.Name("goDetails"), object: choosenCook)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetEdit" {
            let destinationVC = segue.destination as! EditsController
            destinationVC.chosedCook = editchoosenCook
        }
    }
    
    
    @IBAction func btnEditDetails(_ sender: Any) {
        editchoosenCook = choosenCook
        performSegue(withIdentifier: "GoToDetEdit", sender: nil)
      
    }
  

}
