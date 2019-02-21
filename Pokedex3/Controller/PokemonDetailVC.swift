//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by Dušan Janeček on 17/02/2019.
//  Copyright © 2019 Dušan Janeček. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    private var _pokemon: Pokemon!
    
    var pokemon: Pokemon {
        get {
            return _pokemon
        } set {
            _pokemon = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = _pokemon.name
    }
    
    

}
