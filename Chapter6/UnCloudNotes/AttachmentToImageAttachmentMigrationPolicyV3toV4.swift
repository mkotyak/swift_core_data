import CoreData
import Foundation
import UIKit

let errorDomain = "Migration"

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  override func createDestinationInstances(
    forSource sInstance: NSManagedObject,
    in mapping: NSEntityMapping,
    manager: NSMigrationManager
  ) throws {
    let description = NSEntityDescription.entity(
      forEntityName: "ImageAttachment",
      in: manager.destinationContext
    )

    let newAttachment = ImageAttachment(
      entity: description!,
      insertInto: manager.destinationContext
    )

    // 2
    func traversePropertyMappings(
      block: (NSPropertyMapping, String) -> Void
    ) throws {
      if let attributeMappings = mapping.attributeMappings {
        for propertyMapping in attributeMappings {
          if let destinationName = propertyMapping.name {
            block(propertyMapping, destinationName)
          } else {
            let message = "Attribute destination not configured properly"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]

            throw NSError(
              domain: errorDomain,
              code: 0,
              userInfo: userInfo
            )
          }
        }
      } else {
        let message = "No Attribute Mappings found!"
        let userInfo = [NSLocalizedFailureReasonErrorKey: message]

        throw NSError(
          domain: errorDomain,
          code: 0,
          userInfo: userInfo
        )
      }
    }

    try traversePropertyMappings { propertyMapping, destinationName in
      guard let valueExpression = propertyMapping.valueExpression else {
        return
      }

      let context: NSMutableDictionary = ["source": sInstance]

      guard let destinationValue = valueExpression.expressionValue(
        with: sInstance,
        context: context
      ) else {
        return
      }

      newAttachment.setValue(
        destinationValue,
        forKey: destinationName
      )
    }

    if let image = sInstance.value(forKey: "image") as? UIImage {
      newAttachment.setValue(
        image.size.width,
        forKey: "width"
      )
      
      newAttachment.setValue(
        image.size.height,
        forKey: "height"
      )
    }

    let body = sInstance.value(forKeyPath: "note.body") as? NSString ?? ""
    newAttachment.setValue(
      body.substring(to: 80),
      forKey: "caption"
    )

    manager.associate(
      sourceInstance: sInstance,
      withDestinationInstance: newAttachment,
      for: mapping
    )
  }
}
