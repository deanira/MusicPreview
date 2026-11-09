//
//  ProfileViewModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine

final class ProfileViewModel: ObservableObject {
  private let profileUseCase: ProfileUseCaseProtocol

  init(profileUseCase: ProfileUseCaseProtocol) {
    self.profileUseCase = profileUseCase
  }
}
