//
//  HomeUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine

protocol SearchUseCaseProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error>
}

final class SearchUseCase: SearchUseCaseProtocol {
  private let repository: MusicRepository

  init(repository: MusicRepository) {
    self.repository = repository
  }

  func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
    repository.searchTracks(query: query)
  }
}
