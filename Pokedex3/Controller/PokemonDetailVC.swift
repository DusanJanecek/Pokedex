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
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    private var _firstId: Int!
    private var _secondId: Int = -1
    private var _thirdId: Int = -1

    
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
        
        
        
        // Download data from API and update screen after downloading
        pokemon.downloadPokemonDetail {
            self.setEvolutions()
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        defenseLabel.text = pokemon.defense
        attackLabel.text = pokemon.attack
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        typeLabel.text = pokemon.type
        descLabel.text = pokemon.description
        
        
        if self._secondId == -1 || self._thirdId == -1 {
            
            evoLabel.text = "There is only one evolution"
            
            if self._secondId == -1 && self._thirdId == -1 {
                evoLabel.text = "The are no evolutions"
            }
            
        } else {
            
            evoLabel.text = "The other evolutions"
        }
        
        if self._firstId != -1 {
            mainImage.image = UIImage(named: "\(self._firstId!)")
        }
        if self._secondId != -1 {
            currentEvoImage.image = UIImage(named: "\(self._secondId)")
        }
        if self._thirdId != -1 {
            nextEvoImage.image = UIImage(named: "\(self._thirdId)")
        }
        
    }
    
    func setEvolutions() {
        
        switch pokemon.pokedexId {
        case pokemon.firstEvolutionId:
            self._firstId = pokemon.firstEvolutionId
            self._secondId = pokemon.secondEvolutionId
            self._thirdId = pokemon.thirdEvolutionId
            nameLabel.text = pokemon.firstEvolutionName.capitalized
            break
        case pokemon.secondEvolutionId:
            self._firstId = pokemon.secondEvolutionId
            self._secondId = pokemon.firstEvolutionId
            self._thirdId = pokemon.thirdEvolutionId
            nameLabel.text = pokemon.secondEvolutionName.capitalized

            break
        case pokemon.thirdEvolutionId:
            self._firstId = pokemon.thirdEvolutionId
            self._secondId = pokemon.firstEvolutionId
            self._thirdId = pokemon.secondEvolutionId
            nameLabel.text = pokemon.thirdEvolutionName.capitalized
            
            break
        default:
            print("Error")
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func changeSecEvo(_ sender: Any) {
        self._pokemon = Pokemon(name: pokemon.secondEvolutionName, pokedexId: _secondId)
        self.viewDidLoad()
    }
    
    @IBAction func changeThirdEvo(_ sender: Any) {
        self._pokemon = Pokemon(name: pokemon.thirdEvolutionName, pokedexId: _thirdId)
        self.viewDidLoad()
    }
    
    
}
