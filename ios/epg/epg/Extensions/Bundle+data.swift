import Foundation

extension Bundle {
    func data(forResource: String?, withExtension: String?) -> Data? {
        guard let filePath = Bundle.main.url(forResource: forResource, withExtension: withExtension) else {
            return nil
        }

        return try? Data(contentsOf: filePath)
    }
}
