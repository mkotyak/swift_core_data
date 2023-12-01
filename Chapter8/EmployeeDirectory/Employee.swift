/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreData
import Foundation

public class Employee: NSManagedObject {}

public extension Employee {
  @nonobjc
  class func fetchRequest() -> NSFetchRequest<Employee> {
    NSFetchRequest<Employee>(entityName: "Employee")
  }

  @NSManaged var about: String?
  @NSManaged var active: NSNumber?
  @NSManaged var address: String?
  @NSManaged var department: String?
  @NSManaged var email: String?
  @NSManaged var guid: String?
  @NSManaged var name: String?
  @NSManaged var phone: String?
  @NSManaged var pictureThumbnail: Data?
  @NSManaged var picture: EmployeePicture?
  @NSManaged var startDate: Date?
  @NSManaged var vacationDays: NSNumber?
  @NSManaged var sales: NSSet?
}

// MARK: Generated accessors for sales

public extension Employee {
  @objc(addSalesObject:)
  @NSManaged func addToSales(_ value: Sale)

  @objc(removeSalesObject:)
  @NSManaged func removeFromSales(_ value: Sale)

  @objc(addSales:)
  @NSManaged func addToSales(_ values: NSSet)

  @objc(removeSales:)
  @NSManaged func removeFromSales(_ values: NSSet)
}
