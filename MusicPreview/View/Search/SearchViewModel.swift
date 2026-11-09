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
  @Published private(set) var resultTracks: [TrackModel] = []

  @Published var query = ""
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage = ""

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
    searchUseCase.searchTracks(query: query)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { tracks in
        self.resultTracks = tracks
      }
      .store(in: &cancellables)
  }
}
