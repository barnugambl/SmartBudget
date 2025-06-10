//
//  NotificationService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func startNotificationTimer(interval: TimeInterval?)
    func stopNotificationTimer(interval: TimeInterval?)
    func showNotification() async
    func registerForNotification() async throws -> Bool
}

final class NotificationService: NSObject, NotificationServiceProtocol {
    static let shared = NotificationService(notificationAPIService: NotificationAPIService(apiService: ApiService()))
    private let notificationAPIService: NotificationAPIServiceProtocol
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notification = UNMutableNotificationContent()
    private var notificationTimer: Timer?
    private var notificationInterval: TimeInterval = 900
    private let currentUserId = Int(UserCoreDataManager.shared.getCurrentUser()?.id ?? 0)
    
    init(notificationAPIService: NotificationAPIServiceProtocol) {
        self.notificationAPIService = notificationAPIService
        super.init()
        notificationCenter.delegate = self
    }
    
    func startNotificationTimer(interval: TimeInterval? = nil) {
        stopNotificationTimer()
        
        if let interval = interval {
            notificationInterval = interval
        }
        
        notificationTimer = Timer.scheduledTimer(timeInterval: notificationInterval,
                                  target: self,
                                  selector: #selector(triggerNotifications),
                                  userInfo: nil,
                                  repeats: true)
        triggerNotifications()
    }
    
    func stopNotificationTimer(interval: TimeInterval? = nil) {
        notificationTimer?.invalidate()
        notificationTimer = nil
    }
    
    @objc private func triggerNotifications() {
        Task {
            await showNotification()
        }
    }
    
    func showNotification() async {
        do {
            let fetchNotifications = try await fetchNotification(userId: currentUserId)
            guard let notifications = fetchNotifications else { return }
            
            for (index, notificationData) in notifications.enumerated() {
                let content = UNMutableNotificationContent()
                
                switch notificationData.level {
                case "WARNING":
                    content.title = R.string.localizable.notificationWarningTitle()
                    content.sound = .defaultCritical
                case "ERROR":
                    content.title = R.string.localizable.notificationErrorTitle()
                    content.sound = .defaultCritical
                case "INFO":
                    content.title = R.string.localizable.notificationInfoTitle()
                    content.sound = .default
                default:
                    break
                }
                
                content.subtitle = R.string.localizable.notificationCategorySubtitle(notificationData.category)
                content.body = notificationData.message
                content.badge = NSNumber(value: notifications.count)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "notification_\(index)",
                    content: content,
                    trigger: trigger
                )
                
                try await UNUserNotificationCenter.current().add(request)
            }
        } catch {
            print("Ошибка при показе уведомлений: \(error)")
        }
    }
    
    func registerForNotification() async throws -> Bool {
        try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }
}

// MARK: API
extension NotificationService {
    func fetchNotification(userId: Int) async throws -> [Notification]? {
        do {
            return try await notificationAPIService.getNotifications(userId: userId)
        } catch {
            print("Не удалось получить уведомления: \(error)")
            return nil
        }
    }
}

// MARK: Delegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
