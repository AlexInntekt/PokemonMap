//
//  PokeAnnoClass.swift
//  PokemonMap
//
//  Created by Manolescu Mihai Alexandru on 15/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//this is nothing more than a customized annotation. Why we needed it insteand the default one, is the fact that it can contains an identifier to the pokemons list:
class wildPokemonAnnotation : NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var pokemone: wildPokemon
    
    
    init(coord: CLLocationCoordinate2D, pokemon: wildPokemon){
        self.coordinate = coord
        self.pokemone = pokemon
    }
    
    
    
    
}
