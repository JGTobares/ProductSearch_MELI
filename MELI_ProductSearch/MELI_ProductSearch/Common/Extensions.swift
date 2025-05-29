//
//  Extensions.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 29/05/2025.
//

import Foundation
import CoreData

extension DBManager {
    func generateMockProductDetails(productId: String, in context: NSManagedObjectContext) -> ProductDetails {
        // Crear ProductDetails
        let productDetails = ProductDetails(context: context)
        productDetails.id = productId
        productDetails.status = "active"
        productDetails.domain_id = "MLA-TABLETS"
        productDetails.permalink = "https://www.mercadolibre.com.ar/ipad-apple-6th-generation-2018-a1954-97-con-red-movil-32gb-gold/p/MLA14719808"
        productDetails.name = "iPad Apple 6th generation 2018 A1954 9.7\" 32GB Gold"
        productDetails.family_name = "Apple iPad 6th generation 2018 A1954"
        
        let shortDescription = ShortDescriptionDetails(context: context)
        shortDescription.content = "Este producto combina la potencia y la capacidad de una computadora con la versatilidad y facilidad de uso que solo un iPad puede brindar..."
        productDetails.shortdescription = shortDescription
        productDetails.parent_id = "MLA9592536"
        //productDetails.childrenIds = try? JSONEncoder().encode([String]())
        //productDetails.settings = try? JSONEncoder().encode(APISettingsDetails(listingStrategy: "catalog_required"))
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        //productDetails.buy_box_activation_date = dateFormatter.date(from: "2019-11-11T14:59:19Z")
        //productDetails.date_created = dateFormatter.date(from: "2019-06-04T18:43:31Z") ?? Date()
        
        // Atributos
        let attribute1 = AttributeDetails(context: context)
        attribute1.id = "BRAND"
        attribute1.name = "Marca"
        attribute1.valueID = "9344"
        attribute1.valueName = "Apple"
        
        let attribute2 = AttributeDetails(context: context)
        attribute2.id = "COLOR"
        attribute2.name = "Color"
        attribute2.valueID = "59628"
        attribute2.valueName = "Gold"
        
        let picture1 = PictureDetails(context: context)
        picture1.id = "777713-MLA32660788040_102019"
        picture1.url = "https://mla-s2-p.mlstatic.com/777713-MLA32660788040_102019-F.jpg"
        picture1.maxWidth = 1051
        picture1.maxHeight = 1478
        
        let picture2 = PictureDetails(context: context)
        picture2.id = "611193-MLA32649508843_102019"
        picture2.url = "https://mla-s1-p.mlstatic.com/611193-MLA32649508843_102019-F.jpg"
        picture2.maxWidth = 773
        picture2.maxHeight = 1092
        
        // Características principales
        let feature1 = MainFeatureDetails(context: context)
        feature1.text = "Sistema operativo: iOS 12.0"
        feature1.type = "key_value"
        
        let feature2 = MainFeatureDetails(context: context)
        feature2.text = "Pantalla: Retina 9.7\""
        feature2.type = "key_value"
        
        // Pickers
        let picker1 = PickerDetails(context: context)
        picker1.pickerID = "COLOR"
        picker1.pickerName = "Color"
        
        let pickerProduct1 = PickerProductDetails(context: context)
        pickerProduct1.productID = "MLA14719808"
        pickerProduct1.pickerLabel = "Gold"
        pickerProduct1.pictureID = "611193-MLA32649508843_102019"
        pickerProduct1.thumbnail = "https://mla-s1-p.mlstatic.com/611193-MLA32649508843_102019-I.jpg"
        pickerProduct1.permalink = "https://www.mercadolibre.com.ar/MLA14719808"
        
        let pickerProduct2 = PickerProductDetails(context: context)
        pickerProduct2.productID = "MLA15061140"
        pickerProduct2.pickerLabel = "Silver"
        pickerProduct2.pictureID = "924731-MLA08843_001"
        pickerProduct2.thumbnail = "https://mla-s2-p.mlstatic.com/924731-MLA08843_001-I.jpg"
        pickerProduct2.permalink = "https://www.mercadolibre.com.ar/MLA15061140"
        
        let picker2 = PickerDetails(context: context)
        picker2.pickerID = "CAPACITY"
        picker2.pickerName = "Capacidad"
        
        let pickerProduct3 = PickerProductDetails(context: context)
        pickerProduct3.productID = "MLA14719808"
        pickerProduct3.pickerLabel = "32GB"
        pickerProduct3.pictureID = ""
        pickerProduct3.thumbnail = ""
        pickerProduct3.permalink = "https://www.mercadolibre.com.ar/MLA14719808"
        
        let pickerProduct4 = PickerProductDetails(context: context)
        pickerProduct4.productID = "MLA9592537"
        pickerProduct4.pickerLabel = "128GB"
        pickerProduct4.pictureID = ""
        pickerProduct4.thumbnail = ""
        pickerProduct4.permalink = "https://www.mercadolibre.com.ar/MLA9592537"
        
        return productDetails
    }
}
