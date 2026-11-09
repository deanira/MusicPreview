//
//  ProfileUseCase.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Combine

protocol ProfileUseCaseProtocol {
  func fetchProfile() -> AnyPublisher<ProfileEntity?, Error>
  func saveProfile(_ profile: ProfileEntity) -> AnyPublisher<Bool, Error>
}

final class ProfileUseCase: ProfileUseCaseProtocol {
  private let repository: MusicRepositoryProtocol

  init(repository: MusicRepositoryProtocol) {
    self.repository = repository
  }

  func fetchProfile() -> AnyPublisher<ProfileEntity?, any Error> {
    repository.fetchProfile()
  }

  func saveProfile(_ profile: ProfileEntity) -> AnyPublisher<Bool, any Error> {
    repository.saveProfile(profile)
  }

}
