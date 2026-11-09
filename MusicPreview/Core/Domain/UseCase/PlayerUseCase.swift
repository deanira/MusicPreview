//
//  LibraryUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 06/11/26.
//

import Combine

protocol PlayerUseCaseProtocol {
  func saveTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error>
  func deleteTrack(id: Int) -> AnyPublisher<Bool, Error>
}

final class PlayerUseCase: PlayerUseCaseProtocol {
  private let repository: MusicRepositoryProtocol

  init(repository: MusicRepositoryProtocol) {
    self.repository = repository
  }

  func saveTrack(_ track: TrackModel) -> AnyPublisher<Bool, any Error> {
    repository.addSavedTrack(track)
  }

  func deleteTrack(id: Int) -> AnyPublisher<Bool, any Error> {
    let stringId = String(id)
    return repository.deleteSavedTrack(id: stringId)
  }
}
