//
//  PlayerViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine
import Foundation

final class PlayerViewModel: ObservableObject {
  private let playerUseCase: PlayerUseCaseProtocol
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - UI state
  @Published var track: TrackModel? = nil
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage = ""
  @Published private(set) var message = ""

  init(playerUseCase: PlayerUseCaseProtocol) {
    self.playerUseCase = playerUseCase
  }

  func saveTrack() {
    guard let track else { return }
    playerUseCase.saveTrack(track)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        case .finished:
          break
        }
      } receiveValue: { state in
        if state {
          self.message = "Saved to library"
        }
      }
      .store(in: &cancellables)
  }

  func deleteTrack() {
    guard let id = track?.id else { return }
    playerUseCase.deleteTrack(id: id)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        case .finished:
          break
        }
      } receiveValue: { state in
        if state {
          self.message = "Removed from library"
        }
      }
      .store(in: &cancellables)
  }
}
