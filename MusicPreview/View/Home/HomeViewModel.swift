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
    errorMessage = "" // reset error
    homeUseCase.fetchMostPlayedSongs(request: MostPlayedRequest(countryCode: "id", limit: 25))
      .sink { [weak self] completion in
        guard let self else { return }
        self.isLoadingTopTracks = false
        if case .failure(let error) = completion {
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] tracks in
        self?.topTracks = tracks
      }
      .store(in: &cancellables)
  }

  func addSavedTrack(_ track: TrackModel) {
    homeUseCase.addSavedTrack(track)
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
