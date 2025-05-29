//
//  DBManager.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//

import CoreData
import Combine

// MARK: - DBManager
class DBManager {
    let persistentContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "MELI_ProductSearch")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
    }
    
    func saveProducts(from searchResponse: SearchResponse) throws {
        let context = persistentContainer.viewContext
        
        // Identificar productos existentes
        let productIds = searchResponse.results.map { $0.id }
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", productIds)
        let existingProducts = try context.fetch(fetchRequest)
        let existingProductIds = Set(existingProducts.map { $0.id })
        
        // Preparar batch insert para nuevos productos
        var newProducts = searchResponse.results.filter { !existingProductIds.contains($0.id) }
        if !newProducts.isEmpty {
            let batchInsert = NSBatchInsertRequest(entity: Product.entity()) { (managedObject: NSManagedObject) in
                guard let product = managedObject as? Product,
                      let apiProduct = newProducts.popLast() else { return false }
                
                product.id = apiProduct.id
                product.name = apiProduct.name
                product.status = apiProduct.status
                product.domain_id = apiProduct.domain_id
                product.listing_strategy = apiProduct.settings.listing_strategy
                product.parent_id = apiProduct.parent_id
                product.lastUpdated = Date()
                
                return true
            }
            try context.execute(batchInsert)
        }
        
        // Actualizar productos existentes
        for apiProduct in searchResponse.results where existingProductIds.contains(apiProduct.id) {
            if let existingProduct = existingProducts.first(where: { $0.id == apiProduct.id }) {
                existingProduct.name = apiProduct.name
                existingProduct.status = apiProduct.status
                existingProduct.domain_id = apiProduct.domain_id
                existingProduct.listing_strategy = apiProduct.settings.listing_strategy
                existingProduct.parent_id = apiProduct.parent_id
                existingProduct.lastUpdated = Date()
                
                //existingProduct.attributes?.forEach { context.delete($0 as! NSManagedObject) }
                //existingProduct.pictures?.forEach { context.delete($0 as! NSManagedObject) }
            }
        }
        
        // Insertar atributos y pictures (no soportan batch insert directamente)
        for apiProduct in searchResponse.results {
            guard let product = try fetchProduct(byId: apiProduct.id) else { continue }
            
            apiProduct.attributes.forEach { apiAttribute in
                let attribute = Attribute(context: context)
                attribute.id = apiAttribute.id
                attribute.name = apiAttribute.name
                attribute.value_id = apiAttribute.value_id
                attribute.value_name = apiAttribute.value_name
                attribute.product = product
            }
            
            apiProduct.pictures.forEach { apiPicture in
                let picture = Picture(context: context)
                picture.id = apiPicture.id
                picture.url = apiPicture.url
                picture.product = product
            }
        }
        
        try context.save()
    }

    func saveProductDetails(from response: ProductDetailsResponse) throws {
        let context = persistentContainer.viewContext
        
        do {
            guard try fetchProduct(byId: response.id) != nil else {
                throw NSError(domain: "DBManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
            }
            
            let fetchRequest: NSFetchRequest<ProductDetails> = ProductDetails.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", response.id)
            let productDetails = try context.fetch(fetchRequest).first ?? ProductDetails(context: context)
            
            productDetails.id = response.id
            productDetails.status = response.status
            productDetails.domain_id = response.domainID
            productDetails.permalink = response.permalink
            productDetails.name = response.name
            productDetails.family_name = response.familyName
            productDetails.shortdescription?.content = response.shortDescription.content
            productDetails.parent_id = response.parentID
            //productDetails.settings = try? JSONEncoder().encode(response.settings)
            productDetails.buyBoxActivationDate = response.buyBoxActivationDate
            productDetails.dateCreated = response.dateCreated
            
            // Limpiar relaciones existentes
            //productDetails.pickers?.forEach { context.delete($0 as! NSManagedObject) }
            //productDetails.main_features?.forEach { context.delete($0 as! NSManagedObject) }
            //productDetails.attributes?.forEach { context.delete($0 as! NSManagedObject) }
            //productDetails.pictures?.forEach { context.delete($0 as! NSManagedObject) }
            
            // Guardar atributos
            response.attributes.forEach { apiAttribute in
                let attribute = AttributeDetails(context: context)
                attribute.id = apiAttribute.id
                attribute.name = apiAttribute.name
                attribute.valueID = apiAttribute.valueID
                attribute.valueName = apiAttribute.valueName
            }
            
            // Guardar imágenes
            response.pictures.forEach { apiPicture in
                let picture = PictureDetails(context: context)
                picture.id = apiPicture.id
                picture.url = apiPicture.url
                //picture.suggestedForPicker = try? JSONEncoder().encode(apiPicture.suggested_for_picker)
                picture.maxWidth = Int64(apiPicture.maxWidth)
                picture.maxHeight = Int64(apiPicture.maxHeight)
            }
            
            // Guardar características principales
            response.mainFeatures.forEach { feature in
                let mainFeature = MainFeatureDetails(context: context)
                mainFeature.text = feature.text
                mainFeature.type = feature.type
            }
            
            response.pickers.forEach { picker in
                let newPicker = PickerDetails(context: context)
                newPicker.pickerID = picker.pickerID
                newPicker.pickerName = picker.pickerName
                
                picker.products.forEach { product in
                    let pickerProduct = PickerProductDetails(context: context)
                    pickerProduct.productID = product.productID
                    pickerProduct.pickerLabel = product.pickerLabel
                    pickerProduct.pictureID = product.pictureID
                    pickerProduct.thumbnail = product.thumbnail
                    pickerProduct.permalink = product.permalink
                    //pickerProduct.tags = product.tags.joined(separator: ",")
                }
            }
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    func fetchProduct(byId productId: String) throws -> Product? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        return try context.fetch(fetchRequest).first
    }
    
    func fetchProductDetails(byId productId: String) throws -> ProductDetails? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductDetails> = ProductDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        return try context.fetch(fetchRequest).first
    }
        
    func fetchAllProductDetails() throws -> [ProductDetails] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductDetails> = ProductDetails.fetchRequest()
        return try context.fetch(fetchRequest)
    }
}
