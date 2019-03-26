import Foundation

protocol Drink {
    var price: Double { get }
}

class SimpleCoffee: Drink {
    var price: Double {
        return 50.0
    }
}

protocol DrinkDecorator: Drink {
    var base: Drink { get }
    var overprice: Double { get }
    init(base: Drink)
}

class Milk: DrinkDecorator {
    let base: Drink
    var price: Double {
        return base.price + self.overprice
    }
    internal let overprice: Double = 20
    
    required init(base: Drink) {
        self.base = base
    }
}

class Sugar: DrinkDecorator {
    let base: Drink
    var price: Double {
        return base.price + self.overprice
    }
    internal let overprice: Double = 10
    
    required init(base: Drink) {
        self.base = base
    }
}

class HotChocolate: DrinkDecorator {
    let base: Drink
    var price: Double {
        return base.price + self.overprice
    }
    internal let overprice: Double = 50
    
    required init(base: Drink) {
        self.base = base
    }
}

let coffee = SimpleCoffee()
coffee.price

let coffeeWithMilk = Milk(base: coffee)
coffeeWithMilk.price

let coffeeWithChocolate = HotChocolate(base: coffee)
coffeeWithChocolate.price

let coffeeWithMilAndChocolate = Milk(base: coffeeWithChocolate)
coffeeWithMilAndChocolate.price
