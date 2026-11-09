//
//  LocaleDataSource.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import Combine
import RealmSwift

protocol LocaleDataSourceProtocol {
  func fetchSavedTracks() -> AnyPublisher<[TrackEntity], Error>
  func addSavedTrack(_ track: TrackEntity) -> AnyPublisher<Bool, Error>
  func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource {
  private let realm: Realm?
  private init(realm: Realm?) {
    self.realm = realm
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }
}

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
