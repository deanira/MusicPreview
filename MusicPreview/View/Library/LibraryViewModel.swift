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
  @Published private(set) var savedTracks: [TrackModel] = []

  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage = ""

  init(libraryUseCase: LibraryUseCaseProtocol) {
    self.libraryUseCase = libraryUseCase
  }

  func fetchSavedTracks() {
    isLoading = true
    libraryUseCase.fetchSavedTracks()
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { tracks in
        self.savedTracks = tracks
      }
      .store(in: &cancellables)
  }
}
