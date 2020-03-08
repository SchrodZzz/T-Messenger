import UIKit

var developer1: Developer? = Developer()
var developer2: Developer? = Developer()
var productManager: ProductManager? = ProductManager()
var ceo: CEO? = CEO()
var company: Company? = Company()

company?.ceo = ceo
company?.manager = productManager
company?.developers = [developer1, developer2]

ceo?.name = "Bob The CEO"
ceo?.manager = company?.manager

productManager?.name = "Tom The Manager"
productManager?.ceo = company?.ceo
productManager?.developers = company?.developers

developer1?.manager = company?.manager
developer1?.name = "Saru #1"
developer2?.manager = company?.manager
developer2?.name = "Saru #2"

ceo?.printProductManager()
ceo?.printCompany()
ceo?.printAllDevelopers()

company?.simulateChat()

company = nil
ceo = nil
developer2 = nil
developer1 = nil
productManager = nil
