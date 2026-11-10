//
//  MusicRepositoryProtocol.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Combine

protocol MusicRepositoryProtocol {
  func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error>
  func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error>
  func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error>
  func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error>
  func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error>
  func fetchProfile() -> AnyPublisher<ProfileModel?, Error>
  func saveProfile(_ profile: ProfileModel) -> AnyPublisher<Bool, Error>
  func deleteProfile() -> AnyPublisher<Bool, Error>
}
