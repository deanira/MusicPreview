//
//  MusicRepository.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import Combine

final class MusicRepository {
  fileprivate let locale: LocaleDataSourceProtocol
  fileprivate let remote: RemoteDataSourceProtocol

  init(locale: LocaleDataSourceProtocol, remote: RemoteDataSourceProtocol) {
    self.locale = locale
    self.remote = remote
  }

  static let sharedInstance: (LocaleDataSourceProtocol, RemoteDataSourceProtocol) -> MusicRepository = { locale, remote in
    MusicRepository(locale: locale, remote: remote)
  }
}

extension MusicRepository: MusicRepositoryProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackModel], any Error> {
    return self.remote.searchTracks(query: query)
      .map { TrackMapper.mapTrackResponsesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }

  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], any Error> {
    return self.remote.fetchMostPlayedSongs(request: request)
      .flatMap { result -> AnyPublisher<[TrackModel], Error> in
        let ids = result
          .compactMap { $0.id }
          .joined(separator: ",")

        let searchRequest = SearchRequest(id: ids, entity: "song")
        return self.remote.fetchTrackDetail(request: searchRequest)
          .map { TrackMapper.mapTrackResponsesToDomains(input: $0) }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }

  func fetchSavedTracks() -> AnyPublisher<[TrackModel], any Error> {
    return self.locale.fetchSavedTracks()
      .map { TrackMapper.mapTrackEntitiesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }

  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, any Error> {
    return self.locale.addSavedTrack(TrackMapper.mapTrackDomainToEntity(input: track))
  }

  func deleteSavedTrack(id: String) -> AnyPublisher<Bool, any Error> {
    return self.locale.deleteSavedTrack(id: id)
  }

  func fetchProfile() -> AnyPublisher<ProfileModel?, Error> {
    return self.locale.fetchProfile()
      .map { entity in
        entity.map { ProfileMapper.mapProfileEntitiesToDomains(input: $0) }
      }
      .eraseToAnyPublisher()
  }

  func saveProfile(_ profile: ProfileModel) -> AnyPublisher<Bool, Error> {
    return self.locale.saveProfile(ProfileMapper.mapProfileDomainToEntity(input: profile))
  }

  func deleteProfile() -> AnyPublisher<Bool, Error> {
    return self.locale.deleteProfile()
  }
}
