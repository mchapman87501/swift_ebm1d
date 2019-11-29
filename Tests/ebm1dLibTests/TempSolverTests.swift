import XCTest
import class Foundation.Bundle
@testable import ebm1dLib

extension Array where Element == Double {
    func delta() -> [Element] {
        return (1..<count).map {
            self[$0] - self[$0 - 1]
        }
    }

    func formatted() -> String {
        let svals = self.map {
            String(format: "%.2f", $0)
        }
        return "[\(svals.joined(separator: ", "))]"
    }
}

final class TempSolverTests: XCTestCase {
    func getTAvg(
        solver: TempSolver, sm: [Double], temps tempsInitial: [Double]
    ) throws -> (avgTemps: [Double], finalTemps: [Double]) {
        var avgTemps = [Double]()
        var temps = tempsInitial
        for m in sm {
            let solution = try solver.solve(solarMultiplier: m, temp: temps)
            avgTemps.append(solution.avg)
            temps = solution.temps
        }
        return (avgTemps: avgTemps, finalTemps: temps)
    }

    func testDefaultScenario() throws {
        let numZones = 9
        let em = EarthModel(numZones: numZones)
        let solver = TempSolver(em: em)
        let temps = [Double](repeating: -60.0, count: numZones)

        let smRising = stride(from: 0.1, to: 100.0, by: 0.5).map {$0}
        let smFalling = stride(from: 100.0, to: 0.1, by: -0.5).map {$0}

        let risingResults = try getTAvg(solver: solver, sm: smRising, temps: temps)
        let fallingResults = try getTAvg(solver: solver, sm: smFalling, temps: risingResults.finalTemps)

        // There should be one step up and one step down, with slope being relatively
        // flat otherwise.
        let flatThresh = 2.0
        let dgatRising = risingResults.avgTemps.delta()
        let dgat2Rising = dgatRising.delta()
        let isStep = dgat2Rising.map { abs($0) > flatThresh }
        let stepCount = isStep.reduce(0) { $0 + ($1 ? 1 : 0) }
        XCTAssertEqual(stepCount, 2)

        let dgatFalling = fallingResults.avgTemps.delta()
        let dgat2Falling = dgatFalling.delta()
        let isFStep = dgat2Falling.map { abs($0) > flatThresh }
        let fStepCount = isFStep.reduce(0) { $0 + ($1 ? 1 : 0) }
        XCTAssertEqual(fStepCount, 2)
    }
}
