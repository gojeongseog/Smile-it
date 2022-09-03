//
//  CoreDataManager.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/03.
//
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var postitems: [NSManagedObject]?
    
    //데이터 불러오기
    func getItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Entity의 fetchRequest 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostItem")
        
        do {
            // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
            let postCDitems = try context.fetch(fetchRequest)
            self.postitems = postCDitems

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //데이터 저장
    func createItem(content: String, color: String) {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // App Delegate 내부에 있는 viewContext 호출
        let context = appDelegate.persistentContainer.viewContext
        
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "PostItem", in: context)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        // 값 설정
        object.setValue(content, forKey: "content")
        object.setValue(color, forKey: "color")
        object.setValue(Date(), forKey: "date")
        
        do {
            // managedContext 내부의 변경사항 저장
            try context.save()
        } catch let error as NSError {
            // 에러 발생시
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func deleteItem(object: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // 객체를 넘기고 바로 삭제
        context.delete(object)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    //데이터 업데이트
    func updateitem(content: String, color: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "PostItem")
//        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let result = try context.fetch(fetchRequest)
            let object = result[0] as! NSManagedObject
            
            object.setValue(content, forKey: "content")
            object.setValue(color, forKey: "color")
            object.setValue(Date(), forKey: "date")
            
            try context.save()
            return
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return
        }
    }
}
