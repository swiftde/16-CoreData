//
//  PersonTVC.swift
//  BuchVerleih-Tutorial
//
//  Created by Benjamin Herzog on 04.07.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class PersonTVC: UITableViewController {

    var daten = [Person]()
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        title = "Personen"
        loadDataFromDB()
    }
    
    func loadDataFromDB() {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        daten = context.executeFetchRequest(fetchRequest, error: nil) as [Person]
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daten.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = "\(daten[indexPath.row].nachname), \(daten[indexPath.row].vorname)"
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Löschen des Datensatzes
            context.deleteObject(daten[indexPath.row])
            context.save(nil)
            let fetchRequest = NSFetchRequest(entityName: "Person")
            daten = context.executeFetchRequest(fetchRequest, error: nil) as [Person]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Löschen"
    }
    
    @IBAction func addPersonButtonPressed(sender : AnyObject) {
        var alert = UIAlertController(title: "Neue Person", message: "Bitte geben Sie den Vor- und Nachnamen der Person ein.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler() {
            textField in
            textField.placeholder = "Vorname"
            textField.becomeFirstResponder()
        }
        alert.addTextFieldWithConfigurationHandler() {
            textField in
            textField.placeholder = "Nachname"
        }
        
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .Default, handler: {
            action in
            // Person hinzufügen
            var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.context) as Person
            newPerson.nachname = (alert.textFields?[1] as UITextField).text
            newPerson.vorname = (alert.textFields?[0] as UITextField).text
            self.context.save(nil)
            self.loadDataFromDB()
            }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "detail" {
            (segue.destinationViewController as BuchTVC).person = daten[tableView.indexPathForCell(sender as UITableViewCell)!.row]
        }
    }

}

























