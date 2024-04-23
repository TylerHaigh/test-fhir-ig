Alias: $loinc = http://loinc.org
Alias: $au-core-diagnosticresult = http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult
Alias: $au-core-practitioner = http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitioner
Alias: $evaluation-procedure = https://healthterminologies.gov.au/fhir/ValueSet/evaluation-procedure-1

Profile: LungFunctionTest
Parent: $au-core-diagnosticresult // Observation
Id: LungFunctionTest
Title: "Lung Function Test"
* ^status = #draft
* ^experimental = true
* ^date = "2024-04-23"
* ^publisher = "Tyler Haigh"
* code = $loinc#19868-9
* method 1..
* method from $evaluation-procedure (required)
* performer only Reference($au-core-practitioner) // Practitioner