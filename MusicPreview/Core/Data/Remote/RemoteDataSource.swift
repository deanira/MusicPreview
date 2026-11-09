//
//  RemoteDataSource.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import Alamofire
import Combine
import Foundation

protocol RemoteDataSourceProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackResponse], Error>
  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[MostPlayedSong], Error>
  func fetchTrackDetail(request: SearchRequest) -> AnyPublisher<[TrackResponse], Error>
}

final class RemoteDataSource: NSObject {
  private override init() {}

  static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackResponse], Error> {
    let request = SearchRequest(term: query, media: "music", entity: "song", limit: 25)

    return perform(ITunesApi.searchTracks(request: request), as: SearchResponse.self)
      .map { $0.results ?? [] }
      .eraseToAnyPublisher()
  }

  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[MostPlayedSong], Error> {
    perform(ITunesApi.mostPlayedSongs(request: request), as: MostPlayedResponse.self)
      .map { $0.feed?.results ?? [] }
      .eraseToAnyPublisher()
  }

  func fetchTrackDetail(request: SearchRequest) -> AnyPublisher<[TrackResponse], Error> {
    return perform(ITunesApi.lookupSong(request: request), as: SearchResponse.self)
      .map { $0.results ?? [] }
      .eraseToAnyPublisher()
  }

  // MARK: - Helper
  private func perform<T: Decodable & Sendable>(
    _ api: ITunesApi,
    as type: T.Type
  ) -> AnyPublisher<T, Error> {
    Deferred {
      Future<T, Error> { completion in
        do {
          let urlRequest = try URLRequestUtils.setupURLRequest(from: api)

          AF.request(urlRequest)
            .cURLDescription { print("debug: ➡️ cURLDescription \($0)") }
            .validate()
            .responseDecodable(of: T.self) { response in
              print("debug: ➡️ response \(urlRequest):", response)
              completion(response.result.mapError { $0 as Error })
            }
        } catch {
          print("debug: ➡️ error", error)
          completion(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
