//
//  MainTable.swift
//  toDoApp
//
//  Created by Mahmoud on 1/17/22.
//

import UIKit
import ChameleonFramework
import RealmSwift

class MainTable: UIViewController {
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    let realm = try! Realm()
    lazy var items: Results<Items>? = {self.realm.objects(Items.self)}() // define a model to fetch objects
    var selectedItem: Items!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewStyle()
    }

    func tableViewStyle() {
        
        myTableView.rowHeight = 50.0
        myTableView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [UIColor.randomFlat()!,UIColor.randomFlat()!])
        myTableView.separatorStyle = .none
    }

    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
            //create an alert
            let alert = UIAlertController(title: "Add item", message: "write someting..", preferredStyle: .alert)
            alert.addTextField { (textFields) in
                textFields.placeholder = "write the note.."
                textField = textFields
                
            }
            
            // add the an action (Button)
            alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [self] (action) in
                do{
                    try! realm.write() {
                        guard let newText = textField.text else {return} // txt
                        let newItem = Items()
                        newItem.task = newText
                        self.realm.add(newItem)
                    }
                    items = realm.objects(Items.self)
                }catch{
                    print(error)
                }
                self.myTableView.reloadData()
            } ))
            
            //show the alert
            self.present(alert, animated: true, completion: nil)

    }
}
//MARK:- UITableViewDataSource

extension MainTable:UITableViewDataSource, UITableViewDelegate {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableVC
        if let item = items?[indexPath.row] {
            cell.labelLbl.text = item.task
            
            // Ternary Operator
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        }
        return cell

    }
    
    //MARK:- UITableViewdelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // to delete items
            do{
                try! realm.write() {
                    guard let deletedItem = items?[indexPath.row] else {return}
                    
                    self.realm.delete(deletedItem.self)
                }
                items = realm.objects(Items.self)
            }catch{
                print(error)
            }
            myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items?[indexPath.row]
        
        // to hide and show the checkmark
        do {
            try! realm.write(){
                if selectedItem.done == false {
                    selectedItem.done = true
                }else{
                    selectedItem.done = false
                }
                realm.add(selectedItem)
            }
            items = realm.objects(Items.self)
        }catch{
            print("Error from DidSelect \(error)")
        }
        myTableView.reloadData()        // force the data method to reload again
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
