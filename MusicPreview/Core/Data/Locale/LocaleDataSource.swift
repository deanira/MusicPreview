//
//  LocaleDataSource.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import Combine
import RealmSwift
import Foundation

protocol LocaleDataSourceProtocol {
  // Saved tracks (Realm)
  func fetchSavedTracks() -> AnyPublisher<[TrackEntity], Error>
  func addSavedTrack(_ track: TrackEntity) -> AnyPublisher<Bool, Error>
  func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error>

  // Profile (UserDefaults)
  func fetchProfile() -> AnyPublisher<ProfileEntity?, Error>
  func saveProfile(_ profile: ProfileEntity) -> AnyPublisher<Bool, Error>
  func deleteProfile() -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource {
  private let realm: Realm?
  private let userDefaults: UserDefaults
  private let profileKey = "user.profile.v1"

  private init(realm: Realm?, userDefaults: UserDefaults = .standard) {
    self.realm = realm
    self.userDefaults = userDefaults
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }

  // MARK: - for unit test
  static func make(realm: Realm?, userDefaults: UserDefaults) -> LocaleDataSource {
    return LocaleDataSource(realm: realm, userDefaults: userDefaults)
  }
}

// MARK: - Tracks
extension LocaleDataSource: LocaleDataSourceProtocol {
  func fetchSavedTracks() -> AnyPublisher<[TrackEntity], Error> {
    Deferred {
      Future<[TrackEntity], Error> { completion in
        guard let realm = self.realm else {
          completion(.failure(DatabaseError.invalidInstance))
          return
        }
        let tracks = realm.objects(TrackEntity.self)
        completion(.success(tracks.toArray(ofType: TrackEntity.self)))
      }
    }
    .eraseToAnyPublisher()
  }

  func addSavedTrack(_ track: TrackEntity) -> AnyPublisher<Bool, Error> {
    Deferred {
      Future<Bool, Error> { completion in
        guard let realm = self.realm else {
          completion(.failure(DatabaseError.invalidInstance))
          return
        }
        do {
          try realm.write {
            realm.add(track, update: .modified)
          }
          completion(.success(true))
        } catch {
          completion(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error> {
    Deferred {
      Future<Bool, Error> { completion in
        guard let realm = self.realm else {
          completion(.failure(DatabaseError.invalidInstance))
          return
        }
        guard let track = realm.object(ofType: TrackEntity.self, forPrimaryKey: id) else {
          completion(.success(false)) // missing track, nothing to delete
          return
        }
        do {
          try realm.write {
            realm.delete(track)
          }
          completion(.success(true))
        } catch {
          completion(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - PRofile
extension LocaleDataSource {
  func fetchProfile() -> AnyPublisher<ProfileEntity?, Error> {
    Deferred {
      Future<ProfileEntity?, Error> { completion in
        guard let data = self.userDefaults.data(forKey: self.profileKey) else {
          completion(.success(nil))
          return
        }
        do {
          let profile = try JSONDecoder().decode(ProfileEntity.self, from: data)
          completion(.success(profile))
        } catch {
          completion(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func saveProfile(_ profile: ProfileEntity) -> AnyPublisher<Bool, Error> {
    Deferred {
      Future<Bool, Error> { completion in
        do {
          let data = try JSONEncoder().encode(profile)
          self.userDefaults.set(data, forKey: self.profileKey)
          completion(.success(true))
        } catch {
          completion(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func deleteProfile() -> AnyPublisher<Bool, Error> {
    Deferred {
      Future<Bool, Error> { completion in
        let existed = self.userDefaults.object(forKey: self.profileKey) != nil
        self.userDefaults.removeObject(forKey: self.profileKey)
        completion(.success(existed))
      }
    }
    .eraseToAnyPublisher()
  }
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0..<count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}
