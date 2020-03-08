import Foundation

public class Company {
    public weak var manager: ProductManager?
    public weak var ceo: CEO?
    public var developers: [Developer?]?

    public init(manager: ProductManager? = nil, ceo: CEO? = nil, developers: [Developer]? = nil) {
        self.manager = manager
        self.ceo = ceo
        self.developers = developers
    }

    public func simulateChat() {
        print("Chat simulation: ")
        guard let developers = self.developers else { return }
        guard let manager = self.manager else { return }
        guard let ceo = self.ceo else { return }
        if developers.count > 0 {
            developers[0]?.sendMessageToCEO("CEO, я хочу зарплату больше")
            print("CEO \(ceo.name ?? "?") send message \"нет, не повышу\" to developer \(developers[0]?.name ?? "?").")
            developers[0]?.sendMessageToManager("Продукт-менеджер, дай ТЗ")
            print("Product Manager \(manager.name ?? "?") send message \"пожалуйтса, ожидайте\" to developer \(developers[0]?.name ?? "?").")
        }
        if developers.count > 1 {
            developers[0]?.send(message: "Ты говнокодер", to: developers[1]?.name ?? "")
            developers[1]?.send(message: "А вот и нет - я отправил тебе pull-request", to: developers[0]?.name ?? "")
        }
        print(" >> simulation end <<")
    }
}
