import Foundation

/// This class is a wrapper around an objects that should be cached to disk.
/// 
/// NOTE: It is currently not possible to use generics with a subclass of NSObject
/// 	 However, NSKeyedArchiver needs a concrete subclass of NSObject to work correctly
class CacheObject: NSObject, NSCoding {
	let value: AnyObject
	let expiryDate: NSDate
	
    /// Designated initializer.
    ///
    /// - parameter value:      An object that should be cached
    /// - parameter expiryDate: The expiry date of the given value
	init(value: AnyObject, expiryDate: NSDate) {
		self.value = value
		self.expiryDate = expiryDate
	}
	
    /// Determines if cached object is expired
    ///
    /// - returns: True If objects expiry date has passed
    func isExpired() -> Bool {
        return expiryDate.isInThePast
    }
	
	
	/// NSCoding

	required init?(coder aDecoder: NSCoder) {
        guard let val = aDecoder.decodeObjectForKey("value"),
              let expiry = aDecoder.decodeObjectForKey("expiryDate") as? NSDate else {
                value = NSObject()
                expiryDate = NSDate.distantPast()
                super.init()
                return nil
        }
        
        self.value = val
        self.expiryDate = expiry
        
		super.init()
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(value, forKey: "value")
		aCoder.encodeObject(expiryDate, forKey: "expiryDate")
	}
}

extension NSDate {
    var isInThePast: Bool {
        return self.timeIntervalSinceNow < 0
    }
}
