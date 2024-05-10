//
//  HomeVC.swift
//  GoQii
//
//  Created by Neosoft on 02/05/24.
//

import UIKit
import CoreData
import UserNotifications

class HomeVC: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var lblTotalAmountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var logInTake: UIButton!
    
    var totalWaterIntake: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateProgressView()
        updateDailySummary()
        scheduleHydrationNotification()
        requestNotificationAuthorization()
        UNUserNotificationCenter.current().delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDailySummary()
    }
    
    func setUI() {
        logInTake.applyCornerRadius(8.0)
        logInTake.applyShadow()
        logInTake.applyOpacity(0.8)
    }

    func updateDailySummary() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
        
        // Get the start and end date for today
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
        
        // Set the predicate to fetch water intake entries for today
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", todayStart as NSDate, todayEnd as NSDate)
        
        do {
            // Fetch the water intake entries for today
            let result = try context.fetch(fetchRequest)
            // Calculate the total amount of water intake for today
            let totalAmount = result.reduce(0) { $0 + $1.amount }
            // Display the total amount on the label
            lblTotalAmountLabel.text = "\(totalAmount) ml"
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func updateProgressView() {
            let context = CoreDataStack.shared.context
            let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
            let todayStart = Calendar.current.startOfDay(for: Date())
            let todayEnd = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", todayStart as NSDate, todayEnd as NSDate)
            
            do {
                let result = try context.fetch(fetchRequest)
                let totalAmount = result.reduce(0) { $0 + $1.amount }
                let dailyGoal: Double = 2000 // Assuming a daily goal of 2000 ml
                let progress = Float(min(totalAmount / dailyGoal, 1.0))
                progressView.progress = progress
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }


    @IBAction func logIntakeButtonTapped(_ sender: Any) {
        let logWaterIntakeVC = LogWaterIntakeVC()
            navigationController?.pushViewController(logWaterIntakeVC, animated: true)
    }

    func scheduleHydrationNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Stay Hydrated!"
            content.body = "Remember to drink 250ml of water every hour to stay hydrated."

            var dateComponents = DateComponents()
            dateComponents.minute = 0 // Fire at the top of every hour
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "hydrationNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Display the notification
            completionHandler([.alert, .sound])
        }
        
        // Handle notification response (e.g., user taps on the notification)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            // Handle the notification response here
            completionHandler()
        }


    
}
