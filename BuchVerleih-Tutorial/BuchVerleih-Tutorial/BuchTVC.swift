//
//  BuchTVC.swift
//  BuchVerleih-Tutorial
//
//  Created by Benjamin Herzog on 04.07.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class BuchTVC: UITableViewController {

    var person: Person?
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var daten = [Buch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nachname = person?.nachname! {
            title = nachname
        }
        loadDataFromDB()
    }
    
    func loadDataFromDB() {
        var fetchRequest = NSFetchRequest(entityName: "Buch")
        // Bücher, die von self.person ausgeliehen sind
        fetchRequest.predicate = NSPredicate(format: "person = %@", person!)
        daten = context.executeFetchRequest(fetchRequest, error: nil) as [Buch]
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daten.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = daten[indexPath.row].titel
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Löschen"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            person?.removeBuecherObject(daten[indexPath.row])
            context.save(nil)
            var fetchRequest = NSFetchRequest(entityName: "Buch")
            // Bücher, die von self.person ausgeliehen sind
            fetchRequest.predicate = NSPredicate(format: "person = %@", person!)
            daten = context.executeFetchRequest(fetchRequest, error: nil) as [Buch]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func addBuchButtonPressed(sender : AnyObject) {
        var alert = UIAlertController(title: "Neues Buch", message: "Bitte geben Sie den Titel des Buches ein.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler() {
            textField in
            textField.placeholder = "Titel"
            textField.becomeFirstResponder()
        }
        
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .Default, handler: {
            action in
            // Person hinzufügen
            var newBuch = NSEntityDescription.insertNewObjectForEntityForName("Buch", inManagedObjectContext: self.context) as Buch
            newBuch.titel = (alert.textFields?[0] as UITextField).text
            self.person?.addBuecherObject(newBuch)
            self.context.save(nil)
            self.loadDataFromDB()
            }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
