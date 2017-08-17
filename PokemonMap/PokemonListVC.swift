//
//  PokemonListVC.swift
//  PokemonMap
//
//  Created by Manolescu Mihai Alexandru on 13/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Foundation

class PokemonListVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{


    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
    }
    
    //this function hides the status bar upwards:
    override var prefersStatusBarHidden: Bool
    {
        return true
    }


    //go back to the map, by dismissing the current viewController:
    @IBOutlet weak var goToMap: UIButton!
    @IBAction func goToMap(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //the number of cells in the table view is equal with the numbers of caught pokemons:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return caughtpokemon.count
    }
    
    
    //define each cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let identifier :String = caughtpokemon[indexPath.row].identifier!
        
        cell.textLabel?.text = identifier
        cell.imageView?.image = UIImage(named: "\(identifier).png")
        
        return cell;
    }
    


}



