//
//  AppDelegate.swift
//  A2_FA_IOS_Naina_C0789965
//
//  Created by user185555 on 2/1/21.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var letsearch: UISearchBar!
    @IBOutlet weak var segmentcontr: UISegmentedControl!
    let mngcontext =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var naiproducts : [Product] = []
    var naiprovider : [Provider] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getnaiProduct()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        change(self)
    }
    func getnaiProduct(){
        naiproducts = []
        naiproducts = try! mngcontext.fetch(Product.fetchRequest())
        insertnaiProuct()
        tableView.reloadData()
    }
    func insertnaiProuct(){
        if naiproducts.count == 0{
            let firstprovider = Provider(context: mngcontext)
            firstprovider.provider = "Amazon"
            
            let row1 = Product(context: mngcontext)
            row1.productDesc = "clothes"
            row1.productID = "c1"
            row1.productName = "top"
            row1.productPrice = "$2"
            row1.provider = firstprovider
            
            let p12 = Product(context: mngcontext)
            p12.productDesc = "electronic"
            p12.productID = "e1"
            p12.productName = "lights"
            p12.productPrice = "$4"
            p12.provider = firstprovider
            
            let p13 = Product(context: mngcontext)
            p13.productDesc = "Mobile"
            p13.productID = "m1"
            p13.productName = "iph"
            p13.productPrice = "$1000"
            p13.provider = firstprovider
            
            let secondprovider = Provider(context: mngcontext)
            secondprovider.provider = "walmart"
            
            let p21 = Product(context: mngcontext)
            p21.productDesc = "bags"
            p21.productID = "b1"
            p21.productName = "gm"
            p21.productPrice = "$10"
            p21.provider = secondprovider
            
            let p22 = Product(context: mngcontext)
            p22.productDesc = "shoe"
            p22.productID = "s1"
            p22.productName = "trufflecollection"
            p22.productPrice = "$30"
            p22.provider = secondprovider
            
            let p23 = Product(context: mngcontext)
            p23.productDesc = "makeup"
            p23.productID = "mk1"
            p23.productName = "foundation"
            p23.productPrice = "$40"
            p23.provider = secondprovider
            try! mngcontext.save()
            getnaiProduct()
        }
    }
    //part 2 Final exam
    @IBAction func change(_ sender: Any) {
        if segmentcontr.selectedSegmentIndex == 0{
            getnaiProduct()
            letsearch.isHidden = false
        }
        else{
            getProvider()
            letsearch.isHidden = true
        }
    }
    @IBAction func add(_ sender: Any) {
        if segmentcontr.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: self)
        }
        else{
            performSegue(withIdentifier: "addProvider", sender: self)
        }
    }
    func getProvider(){
        naiprovider = []
        naiprovider = try! mngcontext.fetch(Provider.fetchRequest())
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? String{
            if segmentcontr.selectedSegmentIndex == 0{
                let vc = segue.destination as! AddProductTableViewController
                vc.providertabed = naiproducts[tableView.indexPathForSelectedRow!.row]
            }
            else{
                let vc = segue.destination as! GetProductsTableViewController
                vc.providertabed = naiprovider[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentcontr.selectedSegmentIndex == 0{
            return naiproducts.count
        }
        else{
            return naiprovider.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if segmentcontr.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                naiproducts[indexPath.row].productName
            cell.detailTextLabel?.text = naiproducts[indexPath.row].provider?.provider
        }
        else{
            cell.textLabel?.text =
                naiprovider[indexPath.row].provider
            let req : NSFetchRequest<Product> = Product.fetchRequest()
            let productz = try! mngcontext.fetch(req)
            var count = 0
            for pro in productz{
                if pro.provider?.provider == naiprovider[indexPath.row].provider{
                    count = count + 1
                }
            }
            cell.detailTextLabel?.text = count.description
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentcontr.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: "me")
        }
        else{
            performSegue(withIdentifier: "getProduct", sender: "me")
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if segmentcontr.selectedSegmentIndex == 0{
                let pro = naiproducts[indexPath.row]
                mngcontext.delete(pro)
            }
            else{
                for prod in naiproducts{
                    if prod.provider == naiprovider[indexPath.row]{
                        mngcontext.delete(prod)
                    }
                }
                let pro = naiprovider[indexPath.row]
                mngcontext.delete(pro)
                
            }
            try! mngcontext.save()
            change(self)
            
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "productName contains[c] '\(searchText)' || productDesc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                naiproducts = try mngcontext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            getnaiProduct()
            
        }
        tableView.reloadData()
    }
}
