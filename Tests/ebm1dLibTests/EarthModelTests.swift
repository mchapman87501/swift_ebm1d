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

    // Parameterized test.
    func pTestLatsFract(_ numZones: Int) throws {
        let em = EarthModel(numZones: numZones)
        let sum = em.latsHeight.reduce(0) { $0 + $1 }
        XCTAssertEqual(sum, 1.0, accuracy: 0.00001)
    }

    func testLatsFract1() throws {
        try pTestLatsFract(9)
        try pTestLatsFract(18)
        try pTestLatsFract(36)
    }

    static var allTests = [
        ("testConstructor", testConstructor),
    ]
}
