//
//  HomeUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class HomeUseCaseTests: XCTestCase {

  static var request = MostPlayedRequest(countryCode: "id", limit: 25)
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

  // MARK: - Fetch
  func testFetchMostPlayedSongsSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .success(HomeUseCaseTests.tracks)
    let useCase = HomeUseCase(repository: repository)

    let expectation = expectation(description: "fetchMostPlayedSongs success")
    var receivedTracks: [TrackModel]?

    useCase.fetchMostPlayedSongs(request: HomeUseCaseTests.request)
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
    XCTAssertEqual(receivedTracks?.count, HomeUseCaseTests.tracks.count)
  }

  func testFetchMostPlayedSongsFailure() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .failure(MockError.generic)
    let useCase = HomeUseCase(repository: repository)

    let expectation = expectation(description: "fetchMostPlayedSongs failure")
    var receivedError: Error?

    useCase.fetchMostPlayedSongs(request: HomeUseCaseTests.request)
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
  }

  // MARK: - Save
  func testSaveTrackSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.saveResult = .success(true)
    let useCase = PlayerUseCase(repository: repository)

    let expectation = expectation(description: "saveTrack success")
    var receivedResult: Bool?

    useCase.saveTrack(PlayerUseCaseTests.track)
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

    XCTAssert(repository.verifySave())
    XCTAssertEqual(repository.receivedTrackId, PlayerUseCaseTests.track.id)
    XCTAssertEqual(receivedResult, true)
  }

  func testSaveTrackFailure() throws {
    let repository = MusicRepositoryMock()
    repository.saveResult = .failure(MockError.generic)
    let useCase = PlayerUseCase(repository: repository)

    let expectation = expectation(description: "saveTrack failure")
    var receivedError: Error?

    useCase.saveTrack(PlayerUseCaseTests.track)
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

    XCTAssert(repository.verifySave())
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
  }
}

extension HomeUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var saveWasCalled = false
    var fetchWasCalled = false
    var receivedTrackId: Int?
    var fetchResult: Result<[TrackModel], Error> = .success([])
    var saveResult: Result<Bool, Error> = .success(true)

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      fetchWasCalled = true
      return fetchResult.publisher.eraseToAnyPublisher()
    }

    func searchTracks(query: String) -> AnyPublisher<[MusicPreview.TrackModel], any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func fetchSavedTracks() -> AnyPublisher<[MusicPreview.TrackModel], any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func addSavedTrack(_ track: MusicPreview.TrackModel) -> AnyPublisher<Bool, any Error> {
      saveWasCalled = true
      receivedTrackId = track.id
      return saveResult.publisher.eraseToAnyPublisher()
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }
    
    func fetchProfile() -> AnyPublisher<MusicPreview.ProfileEntity?, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func saveProfile(_ profile: MusicPreview.ProfileEntity) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func deleteProfile() -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func verifyFetch() -> Bool {
      return fetchWasCalled
    }

    func verifySave() -> Bool {
      saveWasCalled
    }
  }
}
