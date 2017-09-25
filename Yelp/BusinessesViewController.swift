//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    //var searchedBusiness: [Business]!

    // create the search bar programatically since you won't be able to drag one onto the navigation bar
    let searchBar = UISearchBar()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.sizeToFit()

        /* the UIViewController comes with a navigationItem property this will automatically be initialized for you if when the view controller is added to a navigation controller's stack you just need to set the titleView to be the search bar */
        navigationItem.titleView = searchBar

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self


        // use whatever auto layout constrains told you to do
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120


        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()

            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        cell.business = businesses[indexPath.row]

        return cell
    }


     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.

        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController

        filtersViewController.delegate = self
     }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {

        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let sort = filters["sort"] as? YelpSortMode
        let distance = filters["distance"] as? UInt

        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error) -> Void in

            self.businesses = businesses
            self.tableView.reloadData()
        }

    }

}
