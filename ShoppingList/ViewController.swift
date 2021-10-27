public struct Cart: Codable{
    var name: String
    var price: Double
    
    func returnName() -> String{
        return name
    }
    
    mutating func changeName(one: String){
        print("got it")
        name = one
    }
    
    func returnPrice() -> Double{
        return price
    }
    
    mutating func changePrice(two: Double){
        print("got it")
        price = two
    }
        
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableOutlet: UITableView!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var priceFieldOutlet: UITextField!
    @IBOutlet weak var chuckText: UILabel!
    @IBOutlet weak var chuck: UIImageView!
    
    var selectedItem = ""
    var count = 0
    var cart: [Cart] = []
    
    var editName = ""
    var editPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cart.append(Cart.init(name: "Bananas", price: 2.99))
        tableOutlet.dataSource = self
        tableOutlet.delegate = self
        if let items = UserDefaults.standard.data(forKey: "theCart"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Cart].self, from: items){
                cart = decoded
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOutlet.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = cart[indexPath.row].returnName()
        cell.detailTextLabel?.text = "\(cart[indexPath.row].returnPrice())"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let blah = tableView.cellForRow(at: indexPath)?.textLabel?.text{
            selectedItem = blah
            print(selectedItem)
            let popup = UIAlertController(title: "Editing Item", message: "Fill in the Follwoing Information", preferredStyle: .alert)
            popup.addTextField { (textfield) in
                textfield.text = "Name"
            }
            popup.addTextField { (textfield2) in
                textfield2.text = "\(0)"
            }
           
            let edit = UIAlertAction(title: "Done", style: .default, handler: {action in
                let one = popup.textFields![0].text!
                let two = popup.textFields![1].text!
                self.editName = one
                self.editPrice = Double(two)!
                self.cart[indexPath.row].changeName(one: self.editName)
                self.cart[indexPath.row].changePrice(two: self.editPrice)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.cart){
                    UserDefaults.standard.set(encoded, forKey: "theCart")
                }
                tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            popup.addAction(edit)
            popup.addAction(cancel)
            present(popup, animated: true, completion: nil)
            
            tableView.reloadData()
        }
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let daBaby = textFieldOutlet.text!
        let lesGo = priceFieldOutlet.text!
        textFieldOutlet.text = ""
        priceFieldOutlet.text = ""
        let alert = UIAlertController(title: "Unexpected Item In Bagging Area", message: "Missing one or more responses", preferredStyle: .alert)
        let action = UIAlertAction(title: "Apologies Chuck", style: .default, handler: nil)
        let alertTwo = UIAlertController(title: "Unexpected Item In Bagging Area", message: "Item Already in Cart", preferredStyle: .alert)
        let actionTwo = UIAlertAction(title: "Sorry Chuckster", style: .default, handler: nil)
        
        if (daBaby == "" || lesGo == ""){
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            chuckText.text = "I'm not mad, just disappointed."
            return
        }else{
            for i in cart{
                if (i.returnName() == "\(daBaby)"){
                alertTwo.addAction(actionTwo)
                present(alertTwo, animated: true, completion: nil)
                    chuckText.text = "I'm not mad, just disappointed."
                    return
                }
                
            }
        }
        cart.append(Cart.init(name: "\(daBaby)", price: Double(lesGo)!))
         chuckText.text = "\(daBaby) has been added, my friend."
        
        textFieldOutlet.text = ""
        priceFieldOutlet.text = ""
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cart){
            UserDefaults.standard.set(encoded, forKey: "theCart")
        }
        print(cart.count)
        tableOutlet.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == .delete){
            cart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if(editingStyle == .insert){
                
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cart){
                UserDefaults.standard.set(encoded, forKey: "theCart")
                
                tableView.reloadData()
            }
        }
    }

    
    
    
}

