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
        let sum = em.latsFract.reduce(0) { $0 + $1 }
        XCTAssertEqual(sum, 1.0, accuracy: 0.000001)
    }

    func testLatsFract() throws {
        try pTestLatsFract(9)
        try pTestLatsFract(18)
        try pTestLatsFract(36)
    }

    func pTestLatsHeight(_ numZones: Int) throws {
        let em = EarthModel(numZones: numZones)
        let sum = em.latsFract.reduce(0) { $0 + $1 }
        XCTAssertEqual(sum, 1.0, accuracy: 0.000001)
    }

    func testLatsHeight() throws {
        try pTestLatsHeight(9)
        try pTestLatsHeight(18)
        try pTestLatsHeight(36)
    }

    func pTestEffectiveSolarConst(_ numZones: Int) throws {
        let em = EarthModel(numZones: numZones)
        let sum = em.insolByLat.reduce(0) { $0 + $1 }
        XCTAssertEqual(sum, 1370.0 / 4.0, accuracy: 0.000001)
    }

    func testEffectiveSolarConst() throws {
        try pTestEffectiveSolarConst(9)
        try pTestEffectiveSolarConst(18)
        try pTestEffectiveSolarConst(36)
    }

    static var allTests = [
        ("testConstructor", testConstructor),
        ("testLatsFract", testLatsFract),
        ("testLatsHeight", testLatsHeight),
        ("testEffectiveSolarConst", testEffectiveSolarConst)
    ]
}
