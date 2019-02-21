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
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolution: String!
    
    var name: String {
        get {
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            return _description
        }
    }
    
    var type: String {
        get {
            return _type
        }
    }
    
    var defense: String {
        get {
            return _defense
        }
    }
    
    var height: String {
        get {
            return _height
        }
    }
    
    var weight: String {
        get {
            return _weight
        }
    }
    
    var attack: String {
        get {
            return _attack
        }
    }
    
    var nextEvolution: String {
        get {
            return _nextEvolution
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
}
