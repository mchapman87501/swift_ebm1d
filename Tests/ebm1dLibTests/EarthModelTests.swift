import XCTest
import class Foundation.Bundle
@testable import ebm1dLib

final class EarthModelTests: XCTestCase {

    func testConstructor() throws {
        let numZones = 9
        let em = EarthModel(numZones: numZones)
        XCTAssertEqual(em.numZones, numZones)
        XCTAssertEqual(em.latsRad.count, numZones)
        XCTAssertEqual(em.latsHeight.count, numZones)
        XCTAssertEqual(em.latsFract.count, numZones)
        XCTAssertEqual(em.insolByLat.count, numZones)
    }

    static var allTests = [
        ("testConstructor", testConstructor),
    ]
}
