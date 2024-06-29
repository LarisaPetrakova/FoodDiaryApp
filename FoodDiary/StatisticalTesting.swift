import Foundation

struct StatisticalTesting {
    static func chiSquareTest(data: [FoodSymptomData]) -> Double {
        var totalObservations = 0
        var rowTotals: [String: Int] = [:]
        var colTotals: [String: Int] = [:]
        var contingencyTable: [String: [String: Int]] = [:]
        
        for entry in data {
            totalObservations += entry.occurrences
            rowTotals[entry.food, default: 0] += entry.occurrences
            colTotals[entry.symptom, default: 0] += entry.occurrences
            
            if contingencyTable[entry.food] == nil {
                contingencyTable[entry.food] = [:]
            }
            contingencyTable[entry.food]?[entry.symptom, default: 0] += entry.occurrences
        }
        
        var chiSquare: Double = 0.0
        
        for (food, symptomCounts) in contingencyTable {
            for (symptom, observed) in symptomCounts {
                let expected = Double(rowTotals[food]! * colTotals[symptom]!) / Double(totalObservations)
                chiSquare += pow(Double(observed) - expected, 2) / expected
            }
        }
        
        return chiSquare
    }
}
