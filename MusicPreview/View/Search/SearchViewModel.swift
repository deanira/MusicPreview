//
//  SearchViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
  private let searchUseCase: SearchUseCaseProtocol
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - UI state
  @Published private(set) var resultTracks: [TrackModel] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage = ""
  @Published var query = ""

  init(searchUseCase: SearchUseCaseProtocol) {
    self.searchUseCase = searchUseCase
    observeQuery()
  }

  func observeQuery() {
    $query
      .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
      .filter { $0.count > 0 }
      .sink { query in
        self.searchTracks()
      }
      .store(in: &cancellables)
  }

  func searchTracks() {
    isLoading = true
    errorMessage = "" // reset error
    searchUseCase.searchTracks(query: query)
      .sink { [weak self] completion in
        guard let self else { return }
        self.isLoading = false
        if case .failure(let error) = completion {
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] tracks in
        guard let self else { return }
        self.resultTracks = tracks
      }
      .store(in: &cancellables)
  }

  func addSavedTrack(_ track: TrackModel) {
    searchUseCase.addSavedTrack(track)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self else { return }
        if case .failure(let error) = completion {
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] state in
        guard let self else { return }
        if state { }
        else { }
      }
      .store(in: &cancellables)
  }
}
