//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Dušan Janeček on 15/02/2019.
//  Copyright © 2019 Dušan Janeček. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _firstEvolution: String!
    private var _firstEvolutionId: Int!
    private var _firstEvolutionName: String!
    private var _evolutionLvl: String!
    private var _urlAddress: String!
    private var _secondEvolutionId: Int!
    private var _secondEvolutionName: String!
    private var _thirdEvolutionId: Int!
    private var _thirdEvolutionName: String!
    
    var thirdEvolutionId: Int {
        get {
            if _thirdEvolutionId == nil {
                _thirdEvolutionId = -1
            }
            return _thirdEvolutionId
        }
    }
    
    var thirdEvolutionName: String {
        get {
            if _thirdEvolutionName == nil {
                _thirdEvolutionName = ""
            }
            return _thirdEvolutionName
        }
    }
    
    var secondEvolutionName: String {
        get {
            if _secondEvolutionName == nil {
                _secondEvolutionName = ""
            }
            return _secondEvolutionName
        }
    }
    
    var secondEvolutionId: Int {
        get {
            if _secondEvolutionId == nil {
                _secondEvolutionId = -1
            }
            return _secondEvolutionId
        }
    }
    
    var firstEvolutionId: Int {
        get {
            if _firstEvolutionId == nil {
                _firstEvolutionId = -1
            }
            return _firstEvolutionId
        }
    }
    
    var firstEvolutionName: String {
        get {
            if _firstEvolutionName == nil {
                _firstEvolutionName = ""
            }
            return _firstEvolutionName
        }
    }
    
    var evolutionLvl: String {
        get {
            if _evolutionLvl == nil {
                _evolutionLvl = ""
            }
            return _evolutionLvl
        }
    }
    
    var urlAddress: String {
        get {
            return _urlAddress
        }
    }
    
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                _pokedexId = -1
            }
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    
    var nextEvolution: String {
        get {
            if _firstEvolution == nil {
                _firstEvolution = ""
            }
            return _firstEvolution
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._urlAddress = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadCompleted) {
        
        Alamofire.request(self._urlAddress).responseJSON { (response) in
            
            if let json = response.result.value as? Dictionary<String, Any> {
                
                if let height = json["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let weight = json["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let types = json["types"] as? [Dictionary<String, Any>], types.count > 0 {
                    
                    for i in 0..<types.count {
                        
                        if let typeStr = types[i]["type"] as? Dictionary<String, Any> {
                            
                            if let type = typeStr["name"] as? String {
                                if i < 1 {
                                    self._type = "\(type.capitalized)"
                                } else {
                                    self._type += "/\(type.capitalized)"
                                    if i != types.count-1 {
                                        self._type += "/"
                                    }
                                }
                            }
                        }
                    }
                }
                
                if let desc_uri = json["species"] as? Dictionary<String, Any> {
                    var index = -1
                    
                    if let url = desc_uri["url"] as? String {
                        
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            
                            if let descriptionJSON = response.result.value as? Dictionary<String, Any> {
                                
                                if let textEntries = descriptionJSON["flavor_text_entries"] as? [Dictionary<String, Any>], textEntries.count > 0 {
                                    
                                    for i in 0..<textEntries.count {
                                        
                                        if let langu = textEntries[i]["language"] as? Dictionary<String, Any> {
                                            
                                            if let language = langu["name"] as? String {
                                                
                                                if language == "en" {
                                                    index = i
                                                    break
                                                }
                                            }
                                        }
                                    }
                                    
                                    if index != -1 {
                                        
                                        if let description = textEntries[index]["flavor_text"] as? String {
                                            self._description = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                        }
                                        
                                    }
                                    
                                }
                                
                                if let evo_chain = descriptionJSON["evolution_chain"] as? Dictionary<String, Any> {
                                    
                                    if let evo_url = evo_chain["url"] as? String {
                                        
                                        Alamofire.request(evo_url).responseJSON(completionHandler: { (response) in
                                            
                                            if let evoJSON = response.result.value as? Dictionary<String, Any> {
                                                
                                                // First Evo ID
                                                if let chain = evoJSON["chain"] as? Dictionary<String, Any> {
                                                    
                                                    if let species = chain["species"] as? Dictionary<String, Any> {
                                                        
                                                        if let firstEvo = species["url"] as? String {
                                                            let firstEvoId = firstEvo.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "").replacingOccurrences(of: "/", with: "")
                                                            self._firstEvolutionId = Int(firstEvoId)
                                                        }
                                                        
                                                        if let firstEvoName = species["name"] as? String {
                                                            self._firstEvolutionName = firstEvoName
                                                        }
                                                        
                                                    }
                                                    
                                                    // Second Evo ID
                                                    
                                                    if let evoTo = chain["evolves_to"] as? [Dictionary<String, Any>], evoTo.count > 0 {
                                                        
                                                        for i in 0..<evoTo.count {
                                                            
                                                            if let firstElement = evoTo[0] as? Dictionary<String, Any> {
                                                                
                                                                if let species = firstElement["species"] as? Dictionary<String, Any> {
                                                                    
                                                                    if let secondEvo = species["url"] as? String {
                                                                        let secondEvoId = secondEvo.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "").replacingOccurrences(of: "/", with: "")
                                                                        self._secondEvolutionId = Int(secondEvoId)
                                                                    }
                                                                    
                                                                    if let secondEvoName = species["name"] as? String {
                                                                        self._secondEvolutionName = secondEvoName
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                            // Third Evo ID
                                                            
                                                            if evoTo.count > 1 {
                                                                
                                                                if let thirdElement = evoTo[1] as? Dictionary<String, Any> {
                                                                    
                                                                    if let species = thirdElement["species"] as? Dictionary<String, Any> {
                                                                        
                                                                        if let thirdEvo = species["url"] as? String {
                                                                            let thirdEvoId = thirdEvo.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "").replacingOccurrences(of: "/", with: "")
                                                                            self._thirdEvolutionId = Int(thirdEvoId)
                                                                        }
                                                                        
                                                                        if let thirdEvoName = species["name"] as? String {
                                                                            self._thirdEvolutionName = thirdEvoName
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            } else {
                                                                
                                                                if let thirdEvoTo = evoTo[0]["evolves_to"] as? [Dictionary<String, Any>], thirdEvoTo.count > 0 {
                                                                    
                                                                    if let species = thirdEvoTo[0]["species"] as? Dictionary<String, Any> {
                                                                        
                                                                        if let thirdEvo = species["url"] as? String {
                                                                            let thirdEvoId = thirdEvo.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "").replacingOccurrences(of: "/", with: "")
                                                                            self._thirdEvolutionId = Int(thirdEvoId)
                                                                        }
                                                                        
                                                                        if let thirdEvoName = species["name"] as? String {
                                                                            self._thirdEvolutionName = thirdEvoName
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                            completed()
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
//                           completed()
                        })
                        
                    }
                    
                }
                
                if let stats = json["stats"] as? [Dictionary<String, Any>], stats.count > 0 {
                    
                    guard stats.count >= 4 else {
                        return
                    }
                    
                    if let attack = stats[3]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                    
                    guard stats.count >= 5 else {
                        return
                    }
                    
                    if let defense = stats[4]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }

                }

            }
            
//          completed()
        }
    }
    
}
