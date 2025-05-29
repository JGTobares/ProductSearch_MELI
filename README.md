# ProductSearch_MELI

- XCode project
- Swift + SwiftUI
- Arquitectura: MV (Model - View), este nuevo enfoque de arquitectura busca reemplazar al clasico MVVM, donde se utilizan clases con el nuevo protocolo Observable, disponible desde iOS 17. Este protocolo, presenta mejor funcionamiento y manejo de estados, ya que anteriormente con ObservableObject y @Published var se renderizaban todas las views que estuviesen utilizando esa clase. Permite la usabilidad de codigo de manera transversal entre vistas.
- Persistance: CoreData, se elije CoreData para almacenar e interactuar con SwiftUI, las opciones eran CoreData, SwiftData y Realm, se descarta SwiftData por ser un framework relativamente joven y en desarrollo, Realm por ser libreria de terceros y queda seleccionado CoreData por su estabilidad y robustez para manejar los datos.
- Proyecto estructurado en sistema de layers
    View <> Model <> Manager || Service
- API Request: NetworkService, se emplea el enfoque protocol oriented para el uso de una clase final para los API request con metodos genericos usando Combine
- Manejo de errores, NetworkError, se crea un custom enum para el manejo de errores conocidos y casos particulares como "keyNotFound" por parte del backend
- Se utiliza el modifier alert en la vista principal para mostrar los mensajes de error en un alert dialog.
- Se agregan unit test para ProductStore
- Para realizar pruebas, el endpoint que emplea el parametro q || q + domain_id, solamente arroja resultados para el query = "apple", aun asi dejando harcoded el domain_id para MLA-CELLULAR por ej. Para el detalle los productID que devuelve el query apple no existe o el back arroja keyNotFound, no pude obtener un repsonse real del back e intente armar la UI con un obj mockeado desde CoreData. La UI de ProductDetailsView quedo in progress.
