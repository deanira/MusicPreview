//
//  HomeViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
  private let homeUseCase: HomeUseCaseProtocol

  private var cancellables: Set<AnyCancellable> = []
  @Published private(set) var topTracks: [TrackModel] = []

  @Published private(set) var isLoadingTopTracks = false
  @Published private(set) var errorMessage = ""

  init(homeUseCase: HomeUseCaseProtocol) {
    self.homeUseCase = homeUseCase
  }

  func fetchTopTracks() {
    isLoadingTopTracks = true
    homeUseCase.fetchMostPlayedSongs(request: MostPlayedRequest(countryCode: "id", limit: 25))
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        case .finished:
          self.isLoadingTopTracks = false
        }
      } receiveValue: { tracks in
        self.topTracks = tracks
      }
      .store(in: &cancellables)
  }
}
