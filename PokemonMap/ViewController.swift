//
//  ViewController.swift
//  PokemonMap
//
//  Created by Manolescu Mihai Alexandru on 12/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            print("\n Current location already authorized.")
        }else{
            manager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = true
    }



}

