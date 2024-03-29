import CampgroundManager
import CoreData
import Foundation
import XCTest

final class ReservationServiceTests: XCTestCase {
  // MARK: Properties

  var campSiteService: CampSiteService!
  var camperService: CamperService!
  var reservationService: ReservationService!
  var coreDataStack: CoreDataStack!

  override func setUp() {
    super.setUp()

    coreDataStack = TestCoreDataStack()
    camperService = CamperService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
    campSiteService = CampSiteService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
    reservationService = ReservationService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
  }

  override func tearDown() {
    super.tearDown()
    campSiteService = nil
    camperService = nil
    reservationService = nil
    coreDataStack = nil
  }

  func testReserveCampSitePositiveNumberOfDays() {
    let camper = camperService.addCamper(
      "Johnny Appleseed",
      phoneNumber: "408-555-1234"
    )!

    let campSite = campSiteService.addCampSite(
      15,
      electricity: false,
      water: false
    )

    let result = reservationService.reserveCampSite(
      campSite,
      camper: camper,
      date: .init(),
      numberOfNights: 5
    )

    XCTAssertNotNil(result.reservation, "Reservation should not be mil")
    XCTAssertNil(result.error, "No error should be presented")
    XCTAssertTrue(result.reservation?.status == "Reserved", "Status should be reserved")
  }

  func testReserveCampSiteNegativeNumberOfDays() {
    let camper = camperService.addCamper(
      "Johnny Appleseed",
      phoneNumber: "408-555-1234"
    )!

    let campSite = campSiteService.addCampSite(
      15,
      electricity: false,
      water: false
    )

    let result = reservationService.reserveCampSite(
      campSite,
      camper: camper,
      date: .init(),
      numberOfNights: -1
    )

    XCTAssertNotNil(result.reservation, "Reservation should not be mil")
    XCTAssertNotNil(result.error, "No error should be presented")
    XCTAssertTrue(
      result.error?.userInfo["Problem"] as? String == "Invalid number of days",
      "Error problem should be present"
    )
    XCTAssertTrue(
      result.reservation?.status == "Invalid",
      "Status should be Invalid"
    )
  }
}
