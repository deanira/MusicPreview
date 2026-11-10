//
//  Injection.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import RealmSwift

final class Injection {
  static let sharedInstance = Injection()

  private func provideRepository() -> MusicRepository {
    let realm = try? Realm()
    let locale = LocaleDataSource.sharedInstance(realm)
    let remote = RemoteDataSource.sharedInstance
    return MusicRepository.sharedInstance(locale, remote)
  }

  func provideHomeUseCase() -> HomeUseCaseProtocol {
    return HomeUseCase(repository: provideRepository())
  }

  func provideSearchUseCase() -> SearchUseCaseProtocol {
    return SearchUseCase(repository: provideRepository())
  }

  func provideLibraryUseCase() -> LibraryUseCaseProtocol {
    return LibraryUseCase(repository: provideRepository())
  }

  func provideProfileUseCase() -> ProfileUseCaseProtocol {
    return ProfileUseCase(repository: provideRepository())
  }

  func providePlayerUseCase() -> PlayerUseCaseProtocol {
    return PlayerUseCase(repository: provideRepository())
  }
}
