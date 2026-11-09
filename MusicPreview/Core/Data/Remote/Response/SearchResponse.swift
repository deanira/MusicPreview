//
//  SongResponse.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

struct SearchResponse: Decodable {
  let results: [TrackResponse]?
}

struct TrackResponse: Decodable {
  let id: Int?
  let title: String?
  let artist: String?
  let artworkUrlLarge: String?
  let artworkUrlSmall: String?
  let previewUrl: String?
  let durationMillis: Int?

  private enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case title = "trackName"
    case artist = "artistName"
    case artworkUrlLarge = "artworkUrl100"
    case artworkUrlSmall = "artworkUrl60"
    case previewUrl = "previewUrl"
    case durationMillis = "trackTimeMillis"
  }
}
