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

  func provideHomeUseCase() -> HomeUseCase {
    return HomeUseCase(repository: provideRepository())
  }

  func provideSearchUseCase() -> SearchUseCase {
    return SearchUseCase(repository: provideRepository())
  }

  func provideLibraryUseCase() -> LibraryUseCase {
    return LibraryUseCase(repository: provideRepository())
  }

  func provideProfileUseCase() -> ProfileUseCase {
    return ProfileUseCase(repository: provideRepository())
  }

  func providePlayerUseCase() -> PlayerUseCase {
    return PlayerUseCase(repository: provideRepository())
  }
}
