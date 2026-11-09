//
//  HomeUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine

protocol HomeUseCaseProtocol {
  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error>
  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error>
}

final class HomeUseCase: HomeUseCaseProtocol {
  private let repository: MusicRepositoryProtocol

  init(repository: MusicRepositoryProtocol) {
    self.repository = repository
  }

  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
    repository.fetchMostPlayedSongs(request: request)
  }

  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
    repository.addSavedTrack(track)
  }
}
