enum TempSolverError: Error {
    case failedToConverge
    case differentLengths(Int, Int)
}

public struct TempSolver {
    public struct Solution {
        public let temps: [Double]
        public let albedos: [Double]
        public let avg: Double
    }

    let em: EarthModel
    let f: Double

    init(em earthModel: EarthModel, f latTransferCoeff: Double = Defaults.latTransferCoeff) {
        em = earthModel
        f = latTransferCoeff
    }

    func solve(
        solarMultiplier m: Double, temp tempIn: [Double], maxIter: Int = 100
    ) throws
        -> Solution
    {
        let threshold = 0.05
        let insol = em.insolByLat.map { $0 * m }

        let a = 204.0  // Radiative heat-loss coefficient, intercept
        let b = 2.17  // ... slope
        let denom = b + f

        var temp = tempIn
        for _ in 0..<maxIter {
            let tempOld = temp
            let albedo = getAlbedo(temp)
            guard albedo.count == insol.count else {
                throw TempSolverError.differentLengths(albedo.count, insol.count)
            }

            let fractTemps = zip(em.latsFract, temp).map { $0 * $1 }
            let tempAvg = fractTemps.reduce(0) { $0 + $1 }

            temp = zip(albedo, insol).map { currAlbedo, currInsol in
                (currInsol * (1.0 - currAlbedo) + f * tempAvg - a) / denom
            }

            let absTempDiff = zip(tempOld, temp).map { abs($0 - $1) }
            if let maxTempDiff = absTempDiff.max(), maxTempDiff <= threshold {
                return Solution(temps: temp, albedos: albedo, avg: tempAvg)
            }
        }
        throw TempSolverError.failedToConverge
    }

    private func getAlbedo(_ temp: [Double]) -> [Double] {
        let ice = 0.6
        let land = 0.3
        let tCrit = -10.0
        return temp.map { ($0 <= tCrit) ? ice : land }
    }
}
