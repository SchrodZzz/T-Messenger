import Foundation

public class CEO {
    public var name: String?
    public var manager: ProductManager?
    
    public init(name: String? = nil, manager: ProductManager? = nil) {
        self.name = name
        self.manager = manager
    }

    deinit {
        print("CEO \(self.name ?? "?") has been deinited.")
    }
    
    public lazy var printProductManager = { [weak self] in
        guard let manager = self?.manager else { return }
        print("Product Manager: \(manager.name ?? "")")
    }
    
    public lazy var printAllDevelopers = { [weak self] in
        guard let manager = self?.manager else { return }
        manager.printAllDevelopers()
    }
    
    public lazy var printCompany = { [weak self] in
        guard let manager = self?.manager else { return }
        manager.printCompany()
    }
}
