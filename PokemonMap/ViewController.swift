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

    //this is the map:
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
        
        //fetch objects from coredata and assign them to the local array:
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
                    
                    //create randomly a pokemon and place it somewhere randomly on the map:
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
            //request access to the user's current location:
            manager.requestWhenInUseAuthorization()
        }
    
        
    }
    
    @IBAction func updateViewLocation(_ sender: Any)
    {
        
        if (manager.location?.coordinate) != nil
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
            
            //create a frame, set its dimensions, and use it to set the size of the pokemons on the map:
            var frame = annoView.frame
            frame.size.height = 32
            frame.size.width = 32
            annoView.frame = frame
            
            return annoView
        }
        
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
            let pokemon = (annotation as! wildPokemonAnnotation).pokemone
        
            annoView.image = UIImage(named: "\(pokemon.itsIdentifier).png")
            
            //create a frame, set its dimensions, and use it to set the size of the pokemons on the map:
            var frame = annoView.frame
            frame.size.height = 32
            frame.size.width = 32
            annoView.frame = frame
            
            return annoView
    }
    
    //when an annotation is tapped...:
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        //this makes sure that the annotation is not the current user location (that would be a hillarious bug),
        //if it is, then exits the function:
        if view.annotation is MKUserLocation
        {
            return
        }
        
        
        let pokemonName = (view.annotation! as! wildPokemonAnnotation).pokemone.itsIdentifier

        //call the function that will save (with persistent data) the pokemon by an identifier:
        catchPokemon(named: pokemonName)
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        print("\nAnnotation tapped.")
        
        //remove the pokemon from the map:
        mapView.removeAnnotation(view.annotation!)
    
    
    }

    //by using an identifier as argument in the call, save it object with coredata:
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

