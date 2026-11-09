//
//  HomeUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine

protocol SearchUseCaseProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error>
  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error>
}

final class SearchUseCase: SearchUseCaseProtocol {
  private let repository: MusicRepositoryProtocol

  init(repository: MusicRepositoryProtocol) {
    self.repository = repository
  }

  func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
    repository.searchTracks(query: query)
  }

  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
    repository.addSavedTrack(track)
  }
}
