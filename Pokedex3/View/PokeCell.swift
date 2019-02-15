//
//  PokeCell.swift
//  Pokedex3
//
//  Created by Dušan Janeček on 15/02/2019.
//  Copyright © 2019 Dušan Janeček. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        pokeImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        pokeLabel.text = self.pokemon.name
    }
    
    
}
