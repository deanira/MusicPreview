//
//  LibraryViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine
import Foundation

final class LibraryViewModel: ObservableObject {
  private let libraryUseCase: LibraryUseCaseProtocol
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - UI state
  @Published private(set) var savedTracks: [TrackModel] = []
  @Published private(set) var errorMessage = ""

  init(libraryUseCase: LibraryUseCaseProtocol) {
    self.libraryUseCase = libraryUseCase
    observeSavedTracks()
  }

  private func observeSavedTracks() {
    libraryUseCase.fetchSavedTracks()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] tracks in
        self?.savedTracks = tracks
      }
      .store(in: &cancellables)
  }

  func deleteTrack(id: Int) {
    libraryUseCase.deleteSavedTrack(id: id)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self else { return }
        if case .failure(let error) = completion {
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
}
