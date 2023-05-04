//
//  ViewController.swift
//  Core-Database
//
//  Created by R92 on 20/09/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableview: UITableView!
    var dataStore = [String]()
    
    func randomName() -> String {
        var string = ""
        for i in (0..<(4...6).randomElement()!) {
            let str = i % 2 == 0 ? "BDHSHREILCGEFJRKLDBVJKD".randomElement()! : "AEIOU".randomElement()!
            string += String(str)
        }
        return string
    }
    
    func setData() {
        
        let appdele = (UIApplication.shared.delegate as! AppDelegate)
        let vCon = appdele.persistentContainer.viewContext
        let tbl = NSEntityDescription.entity(forEntityName: "Student", in: vCon)!
        for _ in 0..<200 {
            let obj = NSManagedObject(entity: tbl, insertInto: vCon)
            obj.setValue(UUID(), forKey: "id")
            obj.setValue(randomName(), forKey: "name")
        }
        appdele.saveContext()

//        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
//        let objs = try? vCon.fetch(req)
//        appdele.saveContext()
    }

    func getData(offset : Int, limite : Int) {
        let appdele = (UIApplication.shared.delegate as! AppDelegate)
        let vCon = appdele.persistentContainer.viewContext
        let req2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
//        req2.predicate = NSPredicate(format: "name = %@", "123")
        req2.fetchOffset = offset
        req2.fetchLimit = limite
        let objs2 = try? vCon.fetch(req2) as? [Student]
        for i in objs2 ?? [] {
            dataStore.append(i.value(forKey: "name") as! String)
        }
        appdele.saveContext()
        if objs2?.count != 0 {
            myTableview.reloadData()
        }
    }
    
    func deleteAllData() {
        let appdele = (UIApplication.shared.delegate as! AppDelegate)
        let vCon = appdele.persistentContainer.viewContext
        let req2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let obje3 = try? vCon.fetch(req2) as? [Student]
        for i in obje3 ?? [] {
            vCon.delete(i)
        }
        appdele.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableview.delegate = self
        myTableview.dataSource = self
        myTableview.layer.cornerRadius = 10
        
//        deleteAllData()
//        setData()
        getData(offset: 1, limite: 30)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == dataStore.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! cell1
            cell.loder.startAnimating()
            return cell
        }
        cell.textLabel?.text = "\(indexPath.row)). \(dataStore[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataStore.count - 1 {
            getData(offset: dataStore.count, limite: 50)
        }
    }
}

