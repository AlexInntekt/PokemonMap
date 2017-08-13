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
    
    @IBOutlet weak var supportingViewForButton: UIView!
    
    @IBOutlet weak var updateViewLocation: UIButton!

    
    var manager = CLLocationManager()
    var updateCount = 0
    
    //this function hides the status bar upwards:
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            print("\n Current location already authorized.")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //Spawn a Pokemon
                
                print("Inside Timer")
                
                if let coord = self.manager.location?.coordinate
                {
                    let randomLatitude = (Double(arc4random_uniform(200)) - 100) / 10000
                    let randomLongitude = (Double(arc4random_uniform(200)) - 100) / 10000
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    annotation.coordinate.latitude += randomLatitude
                    annotation.coordinate.longitude += randomLongitude
                    self.mapView.addAnnotation(annotation)
                }

            })
            
        }else{
            manager.requestWhenInUseAuthorization()
        }
    
        
    }
    
    @IBAction func updateViewLocation(_ sender: Any)
    {
        
        if let coord = manager.location?.coordinate
        {
            let region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
        
        updateViewLocation.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.updateViewLocation.transform = .identity},completion: nil)
        

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if updateCount < 1
        {
            let region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 1000, 1000)
            mapView.setRegion(region, animated: true)
            updateCount += 3
        }
        else{
            manager.stopUpdatingLocation()
        }
    }



}

