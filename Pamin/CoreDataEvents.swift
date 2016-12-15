//
//  CoreDataEvents.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 15/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import CoreData

class CoreDataEvents {
    
    // Recuperar contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    /*
    // Adicionar todos os Eventos
    func adicionarTodosEventos(){
        
        self.criarPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criarPokemon(nome: "Abra", nomeImagem: "abra", capturado: false)
        self.criarPokemon(nome: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        self.criarPokemon(nome: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.criarPokemon(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.criarPokemon(nome: "Charmander", nomeImagem: "charmander", capturado: false)
        self.criarPokemon(nome: "Dratini", nomeImagem: "dratini", capturado: false)
        self.criarPokemon(nome: "Eevee", nomeImagem: "eevee", capturado: false)
        self.criarPokemon(nome: "Jigglypuff", nomeImagem: "jigglypuff", capturado: false)
        self.criarPokemon(nome: "Mankey", nomeImagem: "mankey", capturado: false)
        self.criarPokemon(nome: "Pidgey", nomeImagem: "pidgey", capturado: false)
        self.criarPokemon(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: false)
        self.criarPokemon(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.criarPokemon(nome: "Rattata", nomeImagem: "rattata", capturado: false)
        self.criarPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criarPokemon(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.criarPokemon(nome: "Venonat", nomeImagem: "venonat", capturado: false)
        self.criarPokemon(nome: "Weedle", nomeImagem: "weedle", capturado: false)
        self.criarPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        let context = self.getContext()
        do{
            try context.save()
        }catch{
            print("Erro ao salvar os pokémons")
        }
    }
    
    // Criar evento
    func criarEvento(nome: String, nomeImagem: String, capturado: Bool){
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
        pokemon.quantidade = 0
    }
    */
    
}
