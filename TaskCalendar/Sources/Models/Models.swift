import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var category: TaskCategory
    var priority: TaskPriority
    var date: Date
    var isCompleted: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        category: TaskCategory = .work,
        priority: TaskPriority = .low,
        date: Date = Date(),
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.priority = priority
        self.date = date
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

enum TaskCategory: String, Codable, CaseIterable {
    case work = "work"
    case personal = "personal"
    case health = "health"
    case learning = "learning"
    case finance = "finance"

    var name: String {
        switch self {
        case .work: return "💼 Работа"
        case .personal: return "🏠 Личное"
        case .health: return "❤️ Здоровье"
        case .learning: return "📚 Учёба"
        case .finance: return "💰 Финансы"
        }
    }

    var color: String {
        switch self {
        case .work: return "purple"
        case .personal: return "green"
        case .health: return "orange"
        case .learning: return "cyan"
        case .finance: return "red"
        }
    }
}

enum TaskPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"

    var name: String {
        switch self {
        case .low: return "Низкий"
        case .medium: return "Средний"
        case .high: return "Высокий"
        }
    }

    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}

struct ProjectIdea: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isAdded: Bool = false

    static let all: [ProjectIdea] = [
        ProjectIdea(title: "Мобильное приложение для медитации"),
        ProjectIdea(title: "Система умного дома на Raspberry Pi"),
        ProjectIdea(title: "Telegram-бот для напоминаний"),
        ProjectIdea(title: "Веб-приложение для управления финансами"),
        ProjectIdea(title: "PWA для чтения книг"),
        ProjectIdea(title: "Сервис для совместного планирования путешествий"),
        ProjectIdea(title: "Приложение для трекинга привычек"),
        ProjectIdea(title: "Чат-приложение с end-to-end шифрованием"),
        ProjectIdea(title: "Система автоматизации тестирования"),
        ProjectIdea(title: "Генератор персональных сайтов-портфолио"),
        ProjectIdea(title: "Платформа для онлайн-курсов"),
        ProjectIdea(title: "Приложение для сканирования документов"),
        ProjectIdea(title: "Сервис для создания мокапов"),
        ProjectIdea(title: "Блог-платформа с markdown"),
        ProjectIdea(title: "Инструмент для дизайнеров интерфейсов"),
        ProjectIdea(title: "Приложение для изучения языков"),
        ProjectIdea(title: "Система управления проектами"),
        ProjectIdea(title: "Сервис для коротких ссылок"),
        ProjectIdea(title: "Парсер для агрегации новостей"),
        ProjectIdea(title: "Веб-игра на WebGL"),
        ProjectIdea(title: "Приложение для заметок с синхронизацией"),
        ProjectIdea(title: "Система мониторинга серверов"),
        ProjectIdea(title: "Генератор резюме"),
        ProjectIdea(title: "Планировщик питания"),
        ProjectIdea(title: "Трекер времени для фрилансеров"),
        ProjectIdea(title: "Сервис для онлайн-голосований"),
        ProjectIdea(title: "Приложение для управления долгами"),
        ProjectIdea(title: "Система бронирования переговорных"),
        ProjectIdea(title: "Веб-редактор кода"),
        ProjectIdea(title: "Приложение для сравнения цен"),
        ProjectIdea(title: "Сервис для создания опросов"),
        ProjectIdea(title: "Инструмент для SEO-анализа"),
        ProjectIdea(title: "Приложение для трекинга сна"),
        ProjectIdea(title: "Платформа для краудфандинга"),
        ProjectIdea(title: "Система управления инвентарём"),
        ProjectIdea(title: "Приложение для заказа еды"),
        ProjectIdea(title: "Сервис для email-рассылок"),
        ProjectIdea(title: "Инструмент для дизайна презентаций"),
        ProjectIdea(title: "Приложение для учёта рабочего времени"),
        ProjectIdea(title: "Платформа для репетиторов"),
        ProjectIdea(title: "Система для управления заказами"),
        ProjectIdea(title: "Приложение для отслеживания посылок"),
        ProjectIdea(title: "Веб-аналитика для малого бизнеса"),
        ProjectIdea(title: "Сервис для создания резервных копий"),
        ProjectIdea(title: "Приложение для планирования свадьбы"),
        ProjectIdea(title: "Инструмент для A/B тестирования"),
        ProjectIdea(title: "Система управления контентом"),
        ProjectIdea(title: "Приложение для учёта расходов"),
        ProjectIdea(title: "Сервис для совместной работы над документами"),
        ProjectIdea(title: "Платформа для онлайн-консультаций"),
        ProjectIdea(title: "Приложение для трекинга спорта"),
        ProjectIdea(title: "Система для управления задачами в команде"),
        ProjectIdea(title: "Веб-конструктор форм"),
        ProjectIdea(title: "Приложение для записи на приём"),
        ProjectIdea(title: "Сервис для автоматизации email"),
        ProjectIdea(title: "Инструмент для визуализации данных"),
        ProjectIdea(title: "Приложение для измерения расстояний"),
        ProjectIdea(title: "Платформа для онлайн-бронирования отелей"),
        ProjectIdea(title: "Система управления знаниями"),
        ProjectIdea(title: "Приложение для управления подписками"),
        ProjectIdea(title: "Сервис для проверки орфографии"),
        ProjectIdea(title: "Инструмент для создания инфографики"),
        ProjectIdea(title: "Приложение для учёта времени"),
        ProjectIdea(title: "Платформа для благотворительности"),
        ProjectIdea(title: "Система для управления контактами"),
        ProjectIdea(title: "Приложение для записи подкастов"),
        ProjectIdea(title: "Веб-редактор изображений"),
        ProjectIdea(title: "Сервис для создания комиксов"),
        ProjectIdea(title: "Приложение для управления налогами"),
        ProjectIdea(title: "Инструмент для прототипирования"),
        ProjectIdea(title: "Система для управления событиями"),
        ProjectIdea(title: "Приложение для чтения RSS"),
        ProjectIdea(title: "Платформа для онлайн-конференций"),
        ProjectIdea(title: "Сервис для валидации форм"),
        ProjectIdea(title: "Приложение для управления паролями"),
        ProjectIdea(title: "Инструмент для генерации паролей"),
        ProjectIdea(title: "Система для отзывов и рейтингов"),
        ProjectIdea(title: "Приложение для планирования вечеринок"),
        ProjectIdea(title: "Веб-конструктор резюме"),
        ProjectIdea(title: "Сервис для мониторинга криптовалют"),
        ProjectIdea(title: "Приложение для учёта топлива"),
        ProjectIdea(title: "Платформа для маркетплейса"),
        ProjectIdea(title: "Система для управления файлами"),
        ProjectIdea(title: "Приложение для загрузки видео"),
        ProjectIdea(title: "Сервис для оптимизации изображений"),
        ProjectIdea(title: "Инструмент для цветовой палитры"),
        ProjectIdea(title: "Приложение для учёта товаров"),
        ProjectIdea(title: "Платформа для подкастов"),
        ProjectIdea(title: "Система для управления закладками"),
        ProjectIdea(title: "Приложение для напоминаний о воде"),
        ProjectIdea(title: "Веб-редактор видео"),
        ProjectIdea(title: "Сервис для конвертации файлов"),
        ProjectIdea(title: "Приложение для управления бюджетом"),
        ProjectIdea(title: "Инструмент для создания диаграмм"),
        ProjectIdea(title: "Система для управления задачами"),
        ProjectIdea(title: "Приложение для заказа такси"),
        ProjectIdea(title: "Платформа для фриланса"),
        ProjectIdea(title: "Сервис для генерации QR-кодов"),
        ProjectIdea(title: "Приложение для учёта больничных"),
        ProjectIdea(title: "Инструмент для планирования спринтов"),
        ProjectIdea(title: "Система для управления документами"),
        ProjectIdea(title: "Приложение для заметок о фильмах")
    ]
}

struct Integration: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    let color: String
    var isConnected: Bool
}
