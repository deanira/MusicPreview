//
//  LibraryUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class LibraryUseCaseTests: XCTestCase {

  static var tracks: [TrackModel] = [
    TrackModel(
      id: 1,
      title: "Blinding Lights",
      artist: "The Weeknd",
      artworkUrlLarge: "https://example.com/artwork/blinding-lights-600.jpg",
      artworkUrlSmall: "https://example.com/artwork/blinding-lights-100.jpg",
      previewUrl: "https://example.com/preview/blinding-lights.m4a",
      durationMillis: 200_040
    ),
    TrackModel(
      id: 2,
      title: "Levitating",
      artist: "Dua Lipa",
      artworkUrlLarge: "https://example.com/artwork/levitating-600.jpg",
      artworkUrlSmall: "https://example.com/artwork/levitating-100.jpg",
      previewUrl: "https://example.com/preview/levitating.m4a",
      durationMillis: 203_064
    )
  ]

  private var cancellables = Set<AnyCancellable>()

  override func tearDown() {
    cancellables.removeAll()
    super.tearDown()
  }

  // MARK: - fetch
  func testFetchSavedTracksSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .success(LibraryUseCaseTests.tracks)
    let useCase = LibraryUseCase(repository: repository)

    let expectation = expectation(description: "fetchSavedTracks success")
    var receivedTracks: [TrackModel]?

    useCase.fetchSavedTracks()
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedTracks = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyFetch())
    XCTAssertEqual(receivedTracks?.count, LibraryUseCaseTests.tracks.count)
    XCTAssertEqual(receivedTracks?.first?.id, LibraryUseCaseTests.tracks.first?.id)
  }

  func testFetchSavedTracksEmpty() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .success([])
    let useCase = LibraryUseCase(repository: repository)

    let expectation = expectation(description: "fetchSavedTracks empty")
    var receivedTracks: [TrackModel]?

    useCase.fetchSavedTracks()
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedTracks = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyFetch())
    XCTAssertEqual(receivedTracks?.isEmpty, true)
  }

  func testFetchSavedTracksFailure() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .failure(MockError.generic)
    let useCase = LibraryUseCase(repository: repository)

    let expectation = expectation(description: "fetchSavedTracks failure")
    var receivedError: Error?

    useCase.fetchSavedTracks()
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            receivedError = error
          }
          expectation.fulfill()
        },
        receiveValue: { _ in XCTFail("Expected failure but got value") }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyFetch())
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
  }

  // MARK: - Delete
  func testDeleteTrackSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.deleteResult = .success(true)
    let useCase = PlayerUseCase(repository: repository)

    let expectation = expectation(description: "deleteTrack success")
    var receivedResult: Bool?

    useCase.deleteTrack(id: 42)
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedResult = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyDelete())
    XCTAssertEqual(repository.receivedDeleteId, "42") // Int -> String
    XCTAssertEqual(receivedResult, true)
  }

  func testDeleteTrackFailure() throws {
    let repository = MusicRepositoryMock()
    repository.deleteResult = .failure(MockError.generic)
    let useCase = PlayerUseCase(repository: repository)

    let expectation = expectation(description: "deleteTrack failure")
    var receivedError: Error?

    useCase.deleteTrack(id: 42)
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            receivedError = error
          }
          expectation.fulfill()
        },
        receiveValue: { _ in XCTFail("Expected failure but got value") }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyDelete())
    XCTAssertEqual(repository.receivedDeleteId, "42")
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
  }
}

extension LibraryUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var fetchWasCalled = false
    var deleteWasCalled = false
    var receivedDeleteId: String?
    var fetchResult: Result<[TrackModel], Error> = .success([])
    var deleteResult: Result<Bool, Error> = .success(true)

    func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
      fetchWasCalled = true
      return fetchResult.publisher.eraseToAnyPublisher()
    }

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error> {
      deleteWasCalled = true
      receivedDeleteId = id
      return deleteResult.publisher.eraseToAnyPublisher()
    }

    func fetchProfile() -> AnyPublisher<MusicPreview.ProfileModel?, any Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func saveProfile(_ profile: MusicPreview.ProfileModel) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func deleteProfile() -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in LibraryUseCaseTests")
    }

    func verifyFetch() -> Bool {
      fetchWasCalled
    }

    func verifyDelete() -> Bool {
      deleteWasCalled
    }
  }
}
