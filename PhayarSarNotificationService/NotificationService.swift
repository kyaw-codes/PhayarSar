//
//  NotificationService.swift
//  PhayarSarNotificationService
//
//  Created by Kyaw Zay Ya Lin Tun on 26/05/2024.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    if let bestAttemptContent = bestAttemptContent {
      let userInfo = request.content.userInfo
      
      if (userInfo["fcm_options"] as? [String: String])?["image"] == nil {
        contentHandler(bestAttemptContent)
        return
      }
      
      if let attachmentMedia = (userInfo["fcm_options"] as? [String: String])?["image"] {
        let mediaUrl = URL(string: attachmentMedia)
        let networkSession = URLSession(configuration: .default)
        networkSession.downloadTask(with: mediaUrl!, completionHandler: { temporaryLocation, response, error in
          if let err = error {
            print("Error with downloading rich push: \(String(describing: err.localizedDescription))")
            contentHandler(bestAttemptContent)
            return
          }
          
          let fileType = self.determineType(fileType: (response?.mimeType)!)
          let fileName = temporaryLocation?.lastPathComponent.appending(fileType)
          
          let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName!)
          
          do {
            try FileManager.default.moveItem(at: temporaryLocation!, to: temporaryDirectory)
            let attachment = try UNNotificationAttachment(identifier: "", url: temporaryDirectory, options: nil)
            
            bestAttemptContent.attachments = [attachment]
            contentHandler(bestAttemptContent)
            // The file should be removed automatically from temp
            // Delete it manually if it is not
            if FileManager.default.fileExists(atPath: temporaryDirectory.path) {
              try FileManager.default.removeItem(at: temporaryDirectory)
            }
          } catch {
            print("Error with the rich push attachment: \(error)")
            contentHandler(bestAttemptContent)
            return
          }
        }).resume()
        
      }
    }
  }
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
  
  // MARK: - Rich Push
  func determineType(fileType: String) -> String {
    // Determines the file type of the attachment to append to URL.
    if fileType == "image/jpeg" {
      return ".jpg"
    }
    if fileType == "image/gif" {
      return ".gif"
    }
    if fileType == "image/png" {
      return ".png"
    } else {
      return ".tmp"
    }
  }
  
}
