//
//  LibraryUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 06/11/26.
//

import Combine

protocol LibraryUseCaseProtocol {
  func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error>
  func deleteSavedTrack(id: Int) -> AnyPublisher<Bool, Error>
}

final class LibraryUseCase: LibraryUseCaseProtocol {
  private let repository: MusicRepositoryProtocol

  init(repository: MusicRepositoryProtocol) {
    self.repository = repository
  }

  func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
    repository.fetchSavedTracks()
  }

  func deleteSavedTrack(id: Int) -> AnyPublisher<Bool, Error> {
    let stringId = String(id)
    return repository.deleteSavedTrack(id: stringId)
  }
}
