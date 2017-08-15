//
//  CoreDataManipulator.swift
//  PokemonMap
//
//  Created by Manolescu Mihai Alexandru on 13/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import Foundation
import UIKit
import CoreData



func fetchCaughtPokemon()
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do
    {
        caughtpokemon = try context.fetch(Pokemon.fetchRequest())
    }
    catch
    {
        //print("\nError found while fetching Core data elements.")
    }
}

func eraseData()
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    for instance in caughtpokemon
    {
           context.delete(instance)
        print("#Deleted ITEM")
    }
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    fetchCaughtPokemon()
    
}
