//
//  ViewController.swift
//  Pokedex3
//
//  Created by Dušan Janeček on 14/02/2019.
//  Copyright © 2019 Dušan Janeček. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
//            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csvData = try CSV(contentsOfURL: path)
            let rows = csvData.rows
            
            for row in rows {
                let name = row["identifier"]!
                let id = Int(row["id"]!)!
                
                let poke = Pokemon(name: name, pokedexId: id)
                pokemons.append(poke)
            }
            
            filteredPokemons = pokemons
            
        } catch let err as NSError {
            print(err)
        }
        
    }
    
    @IBAction func musicPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let destinationVC = segue.destination as? PokemonDetailVC {
                if let pokemon = sender as? Pokemon {
                    destinationVC.pokemon = pokemon
                }
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pokemon = filteredPokemons[indexPath.row]
            cell.configureCell(pokemon: pokemon)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = filteredPokemons[indexPath.row]
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text == "" || searchBar.text == nil {
            
            filteredPokemons = pokemons
            
        } else {
            
            let filter = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.hasPrefix(filter)})
            
        }
        
        collectionView.reloadData()
    }
    
}

