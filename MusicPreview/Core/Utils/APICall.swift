//
//  APICall.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

public protocol NetworkModelRequest {
    var baseURL: String { get }
    var path: String { get }
    var parameters: Codable? { get }
}

enum ITunesApi {
  case searchTracks(request: SearchRequest)
  case lookupSong(request: SearchRequest)
  case mostPlayedSongs(request: MostPlayedRequest)
}

extension ITunesApi: NetworkModelRequest {
  var baseURL: String {
    switch self {
    case .searchTracks, .lookupSong:
      "https://itunes.apple.com"
    case .mostPlayedSongs:
      "https://rss.marketingtools.apple.com"
    }
  }

  var path: String {
    switch self {
    case .searchTracks:
      "/search"
    case .lookupSong:
      "/lookup"
    case .mostPlayedSongs(let request):
      "/api/v2/\(request.countryCode)/music/most-played/\(request.limit)/songs.json"
    }
  }

  var parameters: (any Codable)? {
    switch self {
    case .searchTracks(let request):
      request
    case .lookupSong(let request):
      request
    case .mostPlayedSongs(let request):
      request
    }
  }
}
