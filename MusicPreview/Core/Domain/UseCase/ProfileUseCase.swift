//
//  ProfileUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine

protocol ProfileUseCaseProtocol {
  
}

final class ProfileUseCase: ProfileUseCaseProtocol {
  private let repository: MusicRepository

  init(repository: MusicRepository) {
    self.repository = repository
  }
}
