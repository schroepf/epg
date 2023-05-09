import Foundation

extension Result {
    var valueOrNil: Success? {
        guard case .success(let value) = self else {
            return nil
        }

        return value
    }
}
