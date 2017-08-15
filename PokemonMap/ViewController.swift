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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    
    
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
        fetchCaughtPokemon()
        eraseData()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            
            
            print("\n Current location already authorized.")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            mapView.delegate = self
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //Spawn a Pokemon
                
                
                if let coord = self.manager.location?.coordinate
                {
                    
                    let PokemonOnSpot = wildPokemon()
                    
                    let itsIdentifier = allPokemonIdentifiersList[ Int( arc4random_uniform(UInt32(allPokemonIdentifiersList.count)) ) ]
                    PokemonOnSpot.itsIdentifier = itsIdentifier
                    
                    
                    let annotation = wildPokemonAnnotation(coord: coord, pokemon: PokemonOnSpot)
                    
                    let randomLatitude = (Double(arc4random_uniform(200)) - 100) / 10000
                    let randomLongitude = (Double(arc4random_uniform(200)) - 100) / 10000
                    
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            annoView.image = UIImage(named: "trainer.png")
            
            var frame = annoView.frame
            frame.size.height = 32
            frame.size.width = 32
            annoView.frame = frame
            
            return annoView
        }
        
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
            let pokemon = (annotation as! wildPokemonAnnotation).pokemone
        
            annoView.image = UIImage(named: "\(pokemon.itsIdentifier).png")
            
            
            var frame = annoView.frame
            frame.size.height = 32
            frame.size.width = 32
            annoView.frame = frame
            
            return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            return
        }
        
        
        
        let pokemonName = (view.annotation! as! wildPokemonAnnotation).pokemone.itsIdentifier

        catchPokemon(named: pokemonName)
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        print("\nAnnotation tapped.")
        
        mapView.removeAnnotation(view.annotation!)
    
    
    }

    func catchPokemon(named uncaughtPokemon: String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let pokemon = Pokemon(context: context)
        pokemon.identifier = uncaughtPokemon
        
        do{
           try context.save()
        }catch{
                
            }
        fetchCaughtPokemon()
        
    }


}

