import SwiftUI

extension Color {
    static let accentPurple = Color(hex: "6366f1")
    static let bgPrimary = Color(hex: "0f0f1a")
    static let bgSecondary = Color(hex: "1a1a2e")
    static let bgTertiary = Color(hex: "252540")
    static let borderColor = Color(hex: "2d2d4a")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }

    var dayNumber: Int {
        Calendar.current.component(.day, from: self)
    }

    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }

    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}
