//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Dušan Janeček on 15/02/2019.
//  Copyright © 2019 Dušan Janeček. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        get {
            return _name.capitalized
        }
    }
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
}
