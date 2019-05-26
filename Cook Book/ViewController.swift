//
//  ViewController.swift
//  Cook Book
//
//  Created by Yıldız Uysal on 19.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import  CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var prenameArray = [String]()
    var degreeArray = [Int]()
    var timeArray = [String]()
    var imageArray = [UIImage]()
    var selectedCook = ""
    
    @IBAction func buttonAdd(_ sender: Any) {
        selectedCook = ""
        performSegue(withIdentifier: "GoToEdit", sender: nil)
        
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getInfo), name: NSNotification.Name("newCooks"), object: nil)
    }
   
   @objc func getInfo(){
    nameArray.removeAll(keepingCapacity: false)
    degreeArray.removeAll(keepingCapacity: false)
    timeArray.removeAll(keepingCapacity: false)
    prenameArray.removeAll(keepingCapacity: false)
    imageArray.removeAll(keepingCapacity: false)
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
        fetchReguest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchReguest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let names = result.value(forKey: "cookName") as? String{
                        self.nameArray.append(names)
                    }
                    if let degrees = result.value(forKey: "cookDegree") as? Int{
                        self.degreeArray.append(degrees)
                    }
                    if let times = result.value(forKey: "cookTime") as? String{
                        self.timeArray.append(times)
                    }
                    if let prenames = result.value(forKey: "prepareName") as? String{
                        self.prenameArray.append(prenames)
                    }
                    if let images = result.value(forKey: "cookImage") as? Data{
                        let imagedata = UIImage(data: images)
                        self.imageArray.append(imagedata!)
                    }
                    self.tableView.reloadData()
                }
            }
            
        } catch  {
            print("hata var.")
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cooks")
            
            
            do{
               let results = try context.fetch(fetchReguest)
                
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "cookName") as? String{
                        if name == nameArray[indexPath.row]{
                            context.delete(result)
                            nameArray.remove(at: indexPath.row)
                            timeArray.remove(at: indexPath.row)
                            degreeArray.remove(at: indexPath.row)
                            prenameArray.remove(at: indexPath.row)
                            imageArray.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            do{
                                try context.save()
                            }
                            catch{
                                
                            }
                            break
                        }
                    }
                }
            }catch{
                
            }
            
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            let destinationDet = segue.destination as! DetailsController
            destinationDet.choosenCook = selectedCook
        }
        if segue.identifier == "GoToEdit" {
            let destinationVC = segue.destination as! EditsController
            destinationVC.chosedCook = selectedCook
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCook = nameArray[indexPath.row]
        performSegue(withIdentifier: "GoToDetails", sender: nil)
        
    }

}

