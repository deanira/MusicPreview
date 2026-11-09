//
//  LibraryUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 06/11/26.
//

import Combine

protocol LibraryUseCaseProtocol {
  func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error>
}

final class LibraryUseCase: LibraryUseCaseProtocol {
  private let repository: MusicRepository

  init(repository: MusicRepository) {
    self.repository = repository
  }

  func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
    repository.fetchSavedTracks()
  }
}
