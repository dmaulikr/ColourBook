//
//  DataService - Save.swift
//  ColourBook
//
//  Created by Anthony Ma on 29/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Public Database (Create new)
    
    // Save a business or address
    
    func saveAddress(screenState: ScreenState, location: Location?, business: Business?) {
        getLocationRef(screenState: screenState, location: location, business: business)
        
        let newCategories = self.startingCategories(screenState: screenState)
        let locationRef = self.generalRef
        
        if screenState == .business {
            let businessProfile: Dictionary<String, Any> = ["postalCode": business!.postalCode ?? ""]
            locationRef?.setValue(businessProfile)
        }
        if screenState == .homes {
            let locationProfile: Dictionary<String, Any> = ["postalCode": location!.postalCode, "categories": newCategories ?? ""]
            locationRef?.setValue(locationProfile)
        }
    }
    
    // Public Database refs
    
    func getLocationRef(screenState: ScreenState, location: Location?, business: Business?) {
        if screenState == .business {
            self.generalRef = self.businessRef.child(business!.location)
        }
        if screenState == .homes {
            self.generalRef = self.addressRef.child(location!.locationName)
        }
    }
    
    // MARK: Saving Profile Infos
    
    // business profile
    
    // SaveBusinessProfile file
    
    // addresses
    
    func saveInfoFor(user: String, screenState: ScreenState, location: String?, image: String?, name: String?) {
        getSaveRef(screenState: screenState, user: user, location: location)
        
        let infoRef = self.generalRef
        infoRef?.updateChildValues(["image" : image ?? "", "name": name ?? ""])
    }
    
    func getSaveRef(screenState: ScreenState, user: String, location: String?) {
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!)
        }
    }
    
    // MARK: Save Paint Can to Public Database
    
    func saveProductFor(location: String?, screenState: ScreenState, barcode: String, value: Dictionary<String, Any>) {
        getPublicLocationRef(screenState: screenState, location: location)
        let publicRef = self.generalRef
        publicRef?.child(barcode).setValue(value)
    }
    
    func getPublicLocationRef(screenState: ScreenState, location: String?) {
        if screenState == .business {
            self.generalRef = self.businessRef.child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.addressRef.child(location!).child(Barcodes)
        }
    }
    
    func getPublicLocationCategoriesRef(screenState: ScreenState, location: String?, category: String) {
        if screenState == .business {
            self.generalRef = self.businessRef.child(location!).child("categories").child(category)
        }
        else if screenState == .homes {
            self.generalRef = self.addressRef.child(location!).child("categories").child(category)
        }
    }
    
    // MARK: Save Paint Can to Location (Public)
    
    func saveProductIn(location: String?, screenState: ScreenState, barcode: String, value: Dictionary<String, Any>, category: String) {
        getPublicLocationCategoriesRef(screenState: screenState, location: location, category: category)
        let publicRef = self.generalRef
        publicRef?.child(barcode).setValue(value)
    }
    
    // MARK: Save Paint Can to User Database (Personal)
    
    func saveProductIn(user: String, screenState: ScreenState, location: String?, barcode: String, value: Dictionary<String, Any>, category: String) {
        getDashboardRef(screenState: screenState, user: user, location: location, category: category)
        let infoRef = self.generalRef
        
        infoRef?.child(barcode).setValue(value)
    }
    
    func getDashboardRef(screenState: ScreenState, user: String, location: String?, category: String) {
        
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user).child(PersonalDashboard).child(category).child(Barcodes)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!).child("categories").child(category).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!).child("categories").child(category).child(Barcodes)
        }
        
    }
    
    // MARK: User Database 
    
    // Save Address
    
    func saveAddressTo(user: User, location: Location, business: Business?, screenState: ScreenState) {
        
        getUserlocationRef(screenState: screenState, user: user)
        let locationRef = self.generalRef
        let newCategories = self.startingCategories(screenState: screenState)
        
        let locationProfile: Dictionary<String, Any> = ["postalCode": location.postalCode, "categories": newCategories ?? [:]]
        locationRef?.child(location.locationName).setValue(locationProfile)
    }
    
    // User Dashboard Reference
    
    func getUserlocationRef(screenState: ScreenState, user: User) {
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard).child("addresses")
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
    
    // MARK: - Save New User
    
    // Create new
    
    func createNewUser(uid: String, email: String, image: String) {
        
        let dashboardCats: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Garage": "", "Exterior": "", "Trim": "", "Hallway": "", "Unsorted": ""]
        
        let newProfile: Dictionary<String, Any> = ["email": email, PersonalDashboard: dashboardCats]
        
        usersRef.child(uid).setValue(newProfile)
        
    }
    
    // Starting Categories
    
    func startingCategories(screenState: ScreenState) -> Dictionary<String, String>? {
        if screenState == .business {
            let locationDefaultCategories: Dictionary<String, String> = ["Interior re-paint": "", "Exterior re-paint": "", "Commercial": "", "Homebuilders": "", "Renovations": "", "Unsorted": ""]
            return locationDefaultCategories
        }
        if screenState == .homes {
            let locationDefaultCategories: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Garage": "", "Exterior": "", "Trim": "", "Hallway": "", "Unsorted": ""]
            return locationDefaultCategories
        }
        return nil
    }
    
}