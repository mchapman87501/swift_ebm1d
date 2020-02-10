extension Array where Element == Double {
    func sum() -> Element {
        return self.reduce(0) { $0 + $1 }
    }
}

enum ConvergeError: Error {
    case failedToConverge
}

public struct TempSolver {
    public struct Solution {
        public let temps: [Double]
        public let albedos: [Double]
        public let avg: Double
    }

    let em: EarthModel
    let f: Double

    init(
        em earthModel: EarthModel,
        f latTransferCoeff: Double = Defaults.latTransferCoeff) {
        em = earthModel
        f = latTransferCoeff
    }

    func solve(solarMultiplier m: Double, temp tempIn: [Double], maxIter: Int = 100) throws -> Solution {
        let threshold = 0.05
        let insol = em.insolByLat.map { $0 * m }
        let a = 204.0  // Radiative heat-loss coefficient, intercept
        let b = 2.17   // ... slope
        let denom = b + f

        var temp = tempIn
        for _ in 0..<maxIter {
            let tempOld = temp.map { $0 }
            let albedo = getAlbedo(temp)
            let fractTemps = zip(em.latsFract, temp).map { $0 * $1 }
            let tempAvg = fractTemps.sum()

            temp = (0..<albedo.count).map { i in
                let currAlb = albedo[i]
                let currIns = insol[i]
                return (currIns * (1.0 - currAlb) + f * tempAvg - a) / denom
            }

            let absTempDiff = (0..<temp.count).map { i in
                abs(tempOld[i] - temp[i])
            }
            let maxTempDiff = absTempDiff.max()!
            if maxTempDiff <= threshold {
                return Solution(temps: temp, albedos: albedo, avg: tempAvg)
            }
        }
        throw ConvergeError.failedToConverge
    }

    private func getAlbedo(_ temp: [Double]) -> [Double] {
        let ice = 0.6
        let land = 0.3
        let tCrit = -10.0
        return temp.map { ($0 <= tCrit) ? ice : land }
    }
}
