//
//  MostPlayedResponse.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 06/11/26.
//

struct MostPlayedResponse: Codable {
  let feed: Feed?
}

struct Feed: Codable {
  let results: [MostPlayedSong]?
}

struct MostPlayedSong: Codable {
  let id: String?
}
