//
//  AppDelegate.swift
//  A2_FA_IOS_Naina_C0789965
//
//  Created by user185555 on 2/1/21.
//
import UIKit
import CoreData

class GetProductsTableViewController: UITableViewController {
    var providertabed : Provider?
    var naiproducts : [Product] = []
    let mngcontext =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = providertabed{
            let requests : NSFetchRequest<Product> =  Product.fetchRequest()
            naiproducts = try! mngcontext.fetch(requests)
            naiproducts = naiproducts.filter({$0.provider?.provider == providertabed?.provider})
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return naiproducts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text =
            naiproducts[indexPath.row].productName
        cell.detailTextLabel?.text = naiproducts[indexPath.row].provider?.provider

        return cell
    }
    

}
