//
//  MockDataFiller.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class MockDataFiller {

    static func getConversationsList() -> [[MockConversation]] {
        return [
            [
                MockConversation(name: "BobBestFriend", messages: [
                    "Hello",
                    "Привет",
                    "Как дела?",
                    "ок",
                    "Это хорошо",
                    "Ваш дед портной, ваш дядя повар,",
                    "А вы, вы модный господин —",
                    "Таков об вас народный говор,",
                    "И дива нет — не вы один.",
                    """
                Потомку предков благородных,
                Увы, никто в моей родне
                Не шьет мне даром фраков модных
                И не варит обеда мне.
                """,], date: Date(from: "01.03.2020 20:00") ?? Date(), isOnline: true, hasUnreadMessages: true),
                
                MockConversation(name: "Bob2", messages: ["""
                Потомку предков благородных,
                Увы, никто в моей родне
                Не шьет мне даром фраков модных
                И не варит обеда мне.
                """], date: Date(from: "31.05.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                
                MockConversation(name: "Bob3", messages: [], date: Date(from: "31.05.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                MockConversation(name: "Bob4", messages: [], date: Date(), isOnline: true, hasUnreadMessages: false),
                
                MockConversation(name: "Bob5", messages: ["Hello"], date: Date(from: "25.07.1999 15:22") ?? Date(), isOnline: true, hasUnreadMessages: true),
                MockConversation(name: "Bob6", messages: ["Hello"], date: Date(from: "22.02.2019 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                MockConversation(name: "Bob7", messages: ["Hello"], date: Date(from: "13.12.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                MockConversation(name: "Bob8", messages: ["Hello"], date: Date(from: "01.05.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                MockConversation(name: "Bob9", messages: ["Hello"], date: Date(from: "05.01.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
                MockConversation(name: "Bob10", messages: ["Hello"], date: Date(from: "14.08.2016 15:22") ?? Date(), isOnline: true, hasUnreadMessages: false),
            ],
            [
                MockConversation(name: "TomBestFriend", messages: [
                    "Hello",
                    "Привет",
                    "Как дела?",
                    "ок",
                    "Это хорошо",
                    "Ваш дед портной, ваш дядя повар,",
                    "А вы, вы модный господин —",
                    "Таков об вас народный говор,",
                    "И дива нет — не вы один.",
                    """
                Потомку предков благородных,
                Увы, никто в моей родне
                Не шьет мне даром фраков модных
                И не варит обеда мне.
                """,], date: Date(from: "01.03.2020 20:00") ?? Date(), isOnline: false, hasUnreadMessages: true),
                
                MockConversation(name: "Tom2", messages: ["""
                Потомку предков благородных,
                Увы, никто в моей родне
                Не шьет мне даром фраков модных
                И не варит обеда мне.
                """], date: Date(from: "31.05.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                
                MockConversation(name: "Tom3", messages: [], date: Date(from: "31.05.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                MockConversation(name: "Tom4", messages: [], date: Date(), isOnline: false, hasUnreadMessages: false),
                
                MockConversation(name: "Tom5", messages: ["Hello"], date: Date(from: "25.11.1999 15:22") ?? Date(), isOnline: false, hasUnreadMessages: true),
                MockConversation(name: "Tom6", messages: ["Hello"], date: Date(from: "25.12.2019 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                MockConversation(name: "Tom7", messages: ["Hello"], date: Date(from: "25.09.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                MockConversation(name: "Tom8", messages: ["Hello"], date: Date(from: "21.03.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                MockConversation(name: "Tom9", messages: ["Hello"], date: Date(from: "13.01.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
                MockConversation(name: "Tom10", messages: ["Hello"], date: Date(from: "22.02.2016 15:22") ?? Date(), isOnline: false, hasUnreadMessages: false),
            ]
        ]
    }

}

struct MockConversation {
    let name: String
    let messages: [String]?
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

extension Date {
    init?(from: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        guard let date = dateFormatter.date(from: from) else { return nil }

        self.init(timeInterval: 0, since: date)
    }
}
