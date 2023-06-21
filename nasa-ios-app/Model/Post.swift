//
//  Post.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 21/06/2023.
//

import Foundation

typealias posts = [post]

struct post: Decodable {
    var img_src: String
    
}

struct fotos: Decodable{
    var photos: posts
}

