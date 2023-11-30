import CampgroundManager
import CoreData
import XCTest

final class CamperServiceTests: XCTestCase {
  // MARK: Properties

  var camperService: CamperService!
  var coreDataStack: CoreDataStack!

  override func setUp() {
    super.setUp()

    coreDataStack = TestCoreDataStack()
    camperService = CamperService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
  }

  override func tearDown() {
    super.tearDown()

    camperService = nil
    coreDataStack = nil
  }

  func testAddCamper() {
    let camper = camperService.addCamper(
      "Bacon Lover",
      phoneNumber: "910=390-39203"
    )

    XCTAssertNotNil(camper, "Camper should not be nil")
    XCTAssertTrue(camper?.fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910=390-39203")
  }

  func testRootContextIsSavedAfterAddingCamper() {
    let derivedContext = coreDataStack.newDerivedContext()

    camperService = .init(
      managedObjectContext: derivedContext,
      coreDataStack: coreDataStack
    )

    expectation(
      forNotification: .NSManagedObjectContextDidSave,
      object: coreDataStack.mainContext
    ) { _ in
      true
    }

    derivedContext.perform {
      let camper = self.camperService.addCamper(
        "Bacon Lover",
        phoneNumber: "910=390-39203"
      )

      XCTAssertNotNil(camper)
    }

    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }
}
