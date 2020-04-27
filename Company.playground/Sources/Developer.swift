import Foundation

public class Developer {
    public var name: String?
    public weak var manager: ProductManager?

    public init(name: String? = nil, manager: ProductManager? = nil) {
        self.name = name
        self.manager = manager
    }

    deinit {
        print("Developer \(self.name ?? "?") has been deinited.")
    }

    public func send(message: String, to developerNamed: String) {
        guard let manager = self.manager else { return }
        if let developer = manager.developers?.filter({ $0?.name == developerNamed }).first {
            print("Developer \(self.name ?? "?") send message \"\(message)\" to developer \(developer?.name ?? "?").")
        } else {
            print("Developer \(self.name ?? "?") tried to send message \"\(message)\" to another developer, but Product Manager didn't find \(developerNamed).")
        }
    }

    public func sendMessageToManager(_ message: String) {
        guard let manager = self.manager else { return }
        print("Developer \(self.name ?? "?") send message \"\(message)\" to Product Manager \(manager.name ?? "?").")
    }

    public func sendMessageToCEO(_ message: String) {
        guard let manager = self.manager else { return }
        guard let ceo = manager.ceo else { return }
        print("Developer \(self.name ?? "?") send message \"\(message)\" to CEO \(ceo.name ?? "?").")
    }

}
