import UIKit
public class SNode<T> {
    var value : T
    var next: SNode<T>?
    
    init(value: T) {
        self.value = value
    }
}

class SingleLinkedList<T> {
    var head : SNode<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first : SNode<T>? {
        return head;
    }
    
    public func append(value : T) {
        let newNode = SNode(value: value)
        if var h = head {
            while h.next != nil {
                h = h.next!
            }
            h.next = newNode
        } else {
            head = newNode
        }
    }
    public func insert(data: T, at position : Int) {
        let newNode = SNode(value: data)
        if position == 0 {
            newNode.next = head
            head = newNode
        } else {
            var previous = head
            var current = head
            for _ in 0..<position {
                previous = current
                current = current?.next
            }
            newNode.next = previous?.next
            previous?.next = newNode
        }
    }
    
    func deleteNode(at position: Int) {
        if head == nil {
            return
        }
        var temp = head
        if position == 0 {
            head = temp?.next
            return
        }
        for _ in 0..<position - 1 where temp != nil {
            temp = temp?.next;
        }
        if temp == nil || temp?.next == nil {
            return
        }
        let nextToNextNode = temp?.next?.next
        temp?.next = nextToNextNode
    }
    
    func printList() {
        var current: SNode? = head
        while (current != nil) {
            print("LL item is : \(String(describing: (current?.value)) )")
            current = current?.next
        }
    }
}
let ll = SingleLinkedList<Int>()
ll.append(value: 1)
ll.append(value: 2)
ll.append(value: 4)
ll.insert(data: 5, at: 0)
ll.insert(data: 10, at: 1)
ll.printList()
ll.deleteNode(at: 0)
ll.printList()
