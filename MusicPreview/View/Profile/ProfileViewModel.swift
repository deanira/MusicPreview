//
//  ProfileViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine
import Foundation

final class ProfileViewModel: ObservableObject {
  private let profileUseCase: ProfileUseCaseProtocol

  private var cancellables = Set<AnyCancellable>()

  @Published private(set) var profile: ProfileEntity?
  @Published var errorMessage: String?

  init(profileUseCase: ProfileUseCaseProtocol) {
    self.profileUseCase = profileUseCase
  }

  func load() {
    profileUseCase.fetchProfile()
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] profile in
        self?.profile = profile
      })
      .store(in: &cancellables)
  }

  func save(_ newProfile: ProfileEntity, onSuccess: @escaping () -> Void) {
    profileUseCase.saveProfile(newProfile)
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] success in
        guard success else { return }
        self?.profile = newProfile
        onSuccess()
      })
      .store(in: &cancellables)
  }
}
