Alias:   SCT = http://snomed.info/sct

Profile:        FishPatient
Parent:         Patient
Id:             fish-patient
Title:          "Fish Patient"
Description:    "A patient that is a type of fish."
* name 1..*
* maritalStatus 0..0 // Fish don't get marries
* communication 0..0 // Fish don't talk
* extension contains FishSpecies named species 0..1 // Add species extension
* extension[FishSpecies] and contact MS // Make Species and Contact MS

Instance: Shorty
InstanceOf: FishPatient
Title: "Shorty the Koi-Fish"
Description: "An example of a Fish Patient"
* name
  * given[0] = "Shorty"
  * family = "Koi-Fish"
* extension[FishSpecies].valueCodeableConcept =  SCT#47978005 "Carpiodes cyprinus (organism)"