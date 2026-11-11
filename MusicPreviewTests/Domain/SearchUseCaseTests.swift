//
//  SearchUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class SearchUseCaseTests: XCTestCase {

  static var query = "Blinding"
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

  // MARK: - search
  func testSearchTracksSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.searchResult = .success(SearchUseCaseTests.tracks)
    let useCase = SearchUseCase(repository: repository)

    let expectation = expectation(description: "searchTracks success")
    var receivedTracks: [TrackModel]?

    useCase.searchTracks(query: SearchUseCaseTests.query)
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

    XCTAssert(repository.verifySearch())
    XCTAssertEqual(repository.receivedQuery, SearchUseCaseTests.query)
    XCTAssertEqual(receivedTracks?.count, SearchUseCaseTests.tracks.count)
    XCTAssertEqual(receivedTracks?.first?.id, SearchUseCaseTests.tracks.first?.id)
  }

  func testSearchTracksEmpty() throws {
    let repository = MusicRepositoryMock()
    repository.searchResult = .success([])
    let useCase = SearchUseCase(repository: repository)

    let expectation = expectation(description: "searchTracks empty")
    var receivedTracks: [TrackModel]?

    useCase.searchTracks(query: "zzzzzz")
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

    XCTAssert(repository.verifySearch())
    XCTAssertEqual(repository.receivedQuery, "zzzzzz")
    XCTAssertEqual(receivedTracks?.isEmpty, true)
  }

  func testSearchTracksFailure() throws {
    let repository = MusicRepositoryMock()
    repository.searchResult = .failure(MockError.generic)
    let useCase = SearchUseCase(repository: repository)

    let expectation = expectation(description: "searchTracks failure")
    var receivedError: Error?

    useCase.searchTracks(query: SearchUseCaseTests.query)
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

    XCTAssert(repository.verifySearch())
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
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

extension SearchUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var searchWasCalled = false
    var saveWasCalled = false
    var receivedQuery: String?
    var receivedTrackId: Int?
    var searchResult: Result<[TrackModel], Error> = .success([])
    var saveResult: Result<Bool, Error> = .success(true)

    func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
      searchWasCalled = true
      receivedQuery = query
      return searchResult.publisher.eraseToAnyPublisher()
    }

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
      saveWasCalled = true
      receivedTrackId = track.id
      return saveResult.publisher.eraseToAnyPublisher()
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func fetchProfile() -> AnyPublisher<MusicPreview.ProfileModel?, any Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func saveProfile(_ profile: MusicPreview.ProfileModel) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func deleteProfile() -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in SearchUseCaseTests")
    }

    func verifySearch() -> Bool {
      searchWasCalled
    }

    func verifySave() -> Bool {
      saveWasCalled
    }
  }
}
