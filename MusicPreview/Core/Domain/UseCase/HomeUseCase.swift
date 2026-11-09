//
//  HomeUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine

protocol HomeUseCaseProtocol {
  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error>
}

final class HomeUseCase: HomeUseCaseProtocol {
  private let repository: MusicRepository

  init(repository: MusicRepository) {
    self.repository = repository
  }

  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
    repository.fetchMostPlayedSongs(request: request)
  }
}
