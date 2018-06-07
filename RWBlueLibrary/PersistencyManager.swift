//
//  PersistencyManager.swift
//  RWBlueLibrary
//
//  Created by Tamanh BUI on 6/6/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

final class PersistencyManager {
  private var albums = [Album]()
  
  private var documents: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  private enum Filenames {
    static let Albums = "albums.json"
  }
  
  func saveAlbums() {
    let url = documents.appendingPathComponent(Filenames.Albums)
    let encoder = JSONEncoder()
    guard let encodedData = try? encoder.encode(albums) else {
      return
    }
    try? encodedData.write(to: url)
  }
  
  
  init() {
    let savedURL = documents.appendingPathComponent(Filenames.Albums)
    var data = try? Data(contentsOf: savedURL)
    if data == nil, let bundleURL = Bundle.main.url(forResource: Filenames.Albums, withExtension: nil) {
      data = try? Data(contentsOf: bundleURL)
    }
    
    if let albumData = data,
      let decodeAlbums = try? JSONDecoder().decode([Album].self, from: albumData) {
      albums = decodeAlbums
      saveAlbums()
    }
  }
  
  func getAlbums() -> [Album] {
    return albums
  }
  
  func addAlbum(_ album: Album, at index: Int) {
    if (albums.count >= index) {
      albums.insert(album, at: index)
    } else {
      albums.append(album)
    }
  }
  
  func deleteAlbum(at index: Int) {
    albums.remove(at: index)
  }
  
  private var cache: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
  }
  
  func saveImage(_ image: UIImage, filename: String) {
    let url = cache.appendingPathComponent(filename)
    guard let data = UIImagePNGRepresentation(image) else {
      return
    }
    try? data.write(to: url)
  }
  
  func getImage(with filename: String) -> UIImage? {
    
    print("Inside of getImage")
    
    let url = cache.appendingPathComponent(filename)
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    return UIImage(data: data)
  }
  
}














