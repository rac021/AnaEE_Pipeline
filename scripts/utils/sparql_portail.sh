
  PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
  PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
  PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
  PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

  SELECT ?site ?categName ?variable ?unite ?date (COUNT(?variable) as ?nbVariable) WHERE {

  ?obs_var_1 a oboe-core:Observation ; oboe-core:ofEntity :Variable ; oboe-core:hasMeasurement ?measu_variable_02 ; 
               oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .

  ?measu_variable_02 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; oboe-core:hasValue ?variableUri .

  ?variableUri rdfs:label ?variable .

  ?obs_categ_03 a oboe-core:Observation ; oboe-core:ofEntity :VariableCategory ; 
                  oboe-core:hasMeasurement ?measu_categName_4 .  

  ?measu_categName_4 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ; oboe-core:hasValue ?categ  .

  ?categ rdfs:label ?categName .

  ?obs_var_05 a oboe-core:Observation ; oboe-core:ofEntity :Nitrogen ; oboe-core:hasMeasurement ?measu_unit_06 ;
                oboe-core:hasContext+ ?obs_timeinstant_13 , ?obs_exPlot_15 .

  ?measu_unit_06 a oboe-core:Measurement ; oboe-core:usesStandard ?unite .

  ?obs_timeinstant_13 a oboe-core:Observation ; oboe-core:ofEntity oboe-temporal:TimeInstant ; oboe-core:hasMeasurement ?measu_date_15 .

  ?measu_date_15 a oboe-core:Measurement ; oboe-core:hasValue ?date .


  ?obs_exPlot_15 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalPlot ; oboe-core:hasContext ?obs_site_17 .

  ?obs_site_17 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalSite ; oboe-core:hasMeasurement ?meas_siteName_18 .

  ?meas_siteName_18 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ; oboe-core:hasValue ?site .

 }

  GROUP BY ?site ?categName ?variable ?unite ?date




***************************************************************
















PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standard.owl#>
PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>


SELECT ?site ?categName ?variable ?unite ?date WHERE {
  
?obs_var_1 a oboe-core:Observation ; oboe-core:ofEntity :Variable ; oboe-core:hasMeasurement ?measu_variable_02 ; 
             oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .
  
?measu_variable_02 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; oboe-core:hasValue ?variable .
  
?obs_categ_03 a oboe-core:Observation ; oboe-core:ofEntity :VariableCategory ; 
                oboe-core:hasMeasurement ?measu_categName_4 .  

  
?measu_categName_4 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ;
oboe-core:hasValue ?categName .
    
  
  
  
  
?obs_var_05 a oboe-core:Observation ; oboe-core:ofEntity :Nitrogen ; oboe-core:hasMeasurement ?measu_unit_06 ;
              oboe-core:hasContext   ?obs_ammo_7 .
              
 
?measu_unit_06 a oboe-core:Measurement ; oboe-core:usesStandard ?unite .
  
 
 ?obs_solute_07 a oboe-core:Observation ; oboe-core:ofEntity :Solutes ; oboe-core:hasContext ?obs_Water_09 .
 
  ?obs_Water_09 a oboe-core:Observation ; oboe-core:ofEntity :Water ; oboe-core:hasContext  ?obs_timeinstant_13 , ?obs_exPlot_15 .
  
    ?obs_timeinstant_13 a oboe-core:Observation ; oboe-core:ofEntity oboe-temporal:TimeInstant ; oboe-core:hasMeasurement ?measu_date_15 .
     ?measu_date_15 a oboe-core:Measurement ; oboe-core:hasValue ?date .
  
  
    ?obs_exPlot_15 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalPlot ; oboe-core:hasContext ?obs_site_17 .
  
   ?obs_site_17 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalSite ; oboe-core:hasMeasurement ?meas_siteName_18 .
  
     ?meas_siteName_18 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ;oboe-core:hasValue ?site .
  
}

limit 10

















PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standard.owl#>
PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>


SELECT ?site ?categName ?variable ?unite ?date WHERE {
  
?obs_var_1 a oboe-core:Observation ; oboe-core:ofEntity :Variable ; oboe-core:hasMeasurement ?measu_variable_02 ; 
             oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .
  
?measu_variable_02 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; oboe-core:hasValue ?variable .
  
?obs_categ_03 a oboe-core:Observation ; oboe-core:ofEntity :VariableCategory ; 
                oboe-core:hasMeasurement ?measu_categName_4 .  

  
?measu_categName_4 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ;
oboe-core:hasValue ?categName .
    
  
  
  
  
?obs_var_05 a oboe-core:Observation ; oboe-core:ofEntity :Nitrogen ; oboe-core:hasMeasurement ?measu_unit_06 ;
              oboe-core:hasContext   ?obs_ammo_7 .
              
 
?measu_unit_06 a oboe-core:Measurement ; oboe-core:usesStandard ?unite .
  
 
 ?obs_solute_07 a oboe-core:Observation ; oboe-core:ofEntity :Solutes ; oboe-core:hasContext ?obs_Water_09 .
 
  ?obs_Water_09 a oboe-core:Observation ; oboe-core:ofEntity :Water ; oboe-core:hasContext  ?obs_timeinstant_13 , ?obs_exPlot_15 .
  
    ?obs_timeinstant_13 a oboe-core:Observation ; oboe-core:ofEntity oboe-temporal:TimeInstant ; oboe-core:hasMeasurement ?measu_date_15 .
     ?measu_date_15 a oboe-core:Measurement ; oboe-core:hasValue ?date .
  
  
    ?obs_exPlot_15 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalPlot ; oboe-core:hasContext ?obs_site_17 .
  
   ?obs_site_17 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalSite ; oboe-core:hasMeasurement ?meas_siteName_18 .
  
     ?meas_siteName_18 a oboe-core:Measurement ; oboe-core:hasValue ?site .
  
#?obs_timeinstant_13 a oboe-core:Observation ; oboe-core:ofEntity oboe-temporal:TimeInstant ; oboe-core:hasMeasurement ?measu_date_14 .
#?measu_date_14 a oboe-core:Measurement ; oboe-core:hasValue ?date .
  
  
  # ?obs_timeinstant_13 .
  
}

limit 10


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








CONSTRUCT 
{  ?nameSite a :An...
   ?anneedipso a :Yead ...
   ?count a Total..
   ?target :mentionCount ?mentionCount .
} 
WHERE
{  SELECT (COUNT(?mention) AS ?mentionCount) ?target
   {  ?mention :mentionOf ?target .
   } GROUP BY ?target
}









PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#Standard>


SELECT ?categName  ?unite WHERE  {
  
    ?obs_var_1 a oboe-core:Observation ; oboe-core:ofEntity :Variable ; oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .
  
    ?obs_categ_03  a oboe-core:Observation ; oboe-core:ofEntity :VariableCategory ; oboe-core:hasMeasurement ?measu_categName_4 .
    ?measu_categName_4 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ;
                         oboe-core:hasValue ?categName .
  
    ?obs_var_05  a oboe-core:Observation ; oboe-core:ofEntity  ?notVariableCateg ;  oboe-core:hasMeasurement ?measu_unit_06 .
    NOT EXISTS { ?obs_var_05 a :VariableCategory . }
        
    ?measu_unit_06 a oboe-core:Measurement ; oboe-core:hasValue ?unite .
      
  
     
      
  
}
