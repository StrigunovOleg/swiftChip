import Foundation

public struct Chip {
    public enum ChipType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let chipType: ChipType
    
    public static func make() -> Chip {
        guard let chipType = Chip.ChipType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        
        return Chip(chipType: chipType)
    }
    
    public func sodering() {
        let soderingTime = chipType.rawValue
        sleep(UInt32(soderingTime))
    }
}

class Storage {
    static var storage = [Chip]()
    
    private let queue = DispatchQueue(label: "Barrier", attributes: .concurrent)
    
    public func append(chip: Chip) {
        queue.async(flags: .barrier) {
            Storage.storage.append(chip)
            print(Storage.storage)
        }
    }

}

class Genarating: Thread {
    override func main() {
        let storage = Storage()
        print("launch Genarating")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            print("Create Chip")
            storage.append(chip: Chip.make())
        }
        
        let endTime = Date(timeIntervalSinceNow: 20)
        RunLoop.current.add(timer, forMode: .default)
        RunLoop.current.run(until: endTime)
    }
}

class Worker: Thread {
    override func main() {
        while (true) {
            if (Storage.storage.isEmpty == false) {
                print("sodering...")
                Chip.sodering(Storage.storage.last!)
                Storage.storage.removeLast()
                print(Storage.storage)
            } else {
                print("Thread sleep...")
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
}

// INIT
let worker = Worker()
worker.start()

let genarating = Genarating()
genarating.start()







