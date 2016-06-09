
PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#Standard>

SELECT ?varStandardName ?valueNitro WHERE {
  
     ?obs_1 a oboe-core:Observation ;  oboe-core:ofEntity :Variable ; oboe-core:hasMeasurement ?measureStandardName ; oboe-core:hasContext ?obs_5 .
     ?measureStandardName a oboe-core:Measurement ; oboe-core:ofCharacteristic oboe-core:Name ; oboe-core:hasValue ?varStandardName .
  	 ?obs_5 a oboe-core:Observation ;  oboe-core:ofEntity :Nitrogen ; oboe-core:hasMeasurement ?measurement_6 .
 	 ?measurement_6 a oboe-core:Measurement ; oboe-core:ofCharacteristic :MassConcentration ; oboe-core:usesStandard oboe-standard:MilligramPerLiter ; oboe-core:hasValue ?valueNitro .
  
         
}
