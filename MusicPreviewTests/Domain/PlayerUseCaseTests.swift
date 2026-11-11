//
//  PlayerUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class PlayerUseCaseTests: XCTestCase {

  static var track = TrackModel(
    id: 1,
    title: "Blinding Lights",
    artist: "The Weeknd",
    artworkUrlLarge: "https://example.com/artwork/blinding-lights-600.jpg",
    artworkUrlSmall: "https://example.com/artwork/blinding-lights-100.jpg",
    previewUrl: "https://example.com/preview/blinding-lights.m4a",
    durationMillis: 200_040
  )

  private var cancellables = Set<AnyCancellable>()

  override func tearDown() {
    cancellables.removeAll()
    super.tearDown()
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

extension PlayerUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var saveWasCalled = false
    var deleteWasCalled = false
    var receivedTrackId: Int?
    var receivedDeleteId: String?
    var saveResult: Result<Bool, Error> = .success(true)
    var deleteResult: Result<Bool, Error> = .success(true)

    func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
      saveWasCalled = true
      receivedTrackId = track.id
      return saveResult.publisher.eraseToAnyPublisher()
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error> {
      deleteWasCalled = true
      receivedDeleteId = id
      return deleteResult.publisher.eraseToAnyPublisher()
    }

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func fetchProfile() -> AnyPublisher<MusicPreview.ProfileModel?, any Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func saveProfile(_ profile: MusicPreview.ProfileModel) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func deleteProfile() -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in PlayerUseCaseTests")
    }

    func verifySave() -> Bool {
      saveWasCalled
    }

    func verifyDelete() -> Bool {
      deleteWasCalled
    }
  }
}
