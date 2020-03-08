import Foundation

public class ProductManager {
    public var name: String?
    public weak var ceo: CEO?
    public var developers: [Developer?]?

    public init(name: String? = nil, ceo: CEO? = nil, developers: [Developer]? = nil) {
        self.name = name
        self.ceo = ceo
        self.developers = developers
    }

    deinit {
        print("Product Manager \(self.name ?? "?") has been deinited.")
    }

    public func printAllDevelopers() {
        guard let developers = self.developers else { return }
        print("> Developers: ")
        developers.forEach { dev in
            print(">> \(dev?.name ?? "?")")
        }
        print()
    }

    public func printCompany() {
        guard let ceo = self.ceo else { return }
        
        print("Company: ")
        print("> CEO: \(ceo.name ?? "?")")
        print("> Product Manager: \(self.name ?? "?")")
        printAllDevelopers()
    }
}
