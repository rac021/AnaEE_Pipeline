

  #!/bin/bash

    OUT=$1
	
	  # CONSTRUCT QUERY FOR PORTAIL 
	  
    curl -X POST http://172.17.0.1:9999/blazegraph/namespace/kb/sparql --data-urlencode \
    'query=PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
    PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
    PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

    CONSTRUCT { 
    
        :VariableSynthesis :hasVariableUri       ?variableUri .
        ?variableUri       :hasVariableName      ?variable    .
        ?variableUri       :hasSiteName          ?site        .
        ?variableUri       :hasCategName         ?categName   .
        ?variableUri       :hasUnite             ?unite       .
        
        ?variableUri       :hasDate              ?dateUri     .
        ?dateUri           :hasTotalVariable     ?nbVariable  .
            
    }
    
    WHERE {
        
        SELECT ?site ?variableUri ?categName ?variable ?unite ?dateUri ?date (COUNT(?variable) as ?nbVariable) WHERE {

    ?obs_var_1 a oboe-core:Observation ; oboe-core:ofEntity :Variable ; oboe-core:hasMeasurement ?measu_variable_02 ; 
                oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .

    ?measu_variable_02 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; oboe-core:hasValue ?variableUri .

    ?variableUri rdfs:label ?variable .

    ?obs_categ_03 a oboe-core:Observation ; oboe-core:ofEntity :VariableCategory ; 
                    oboe-core:hasMeasurement ?measu_categName_4 .  

    ?measu_categName_4 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ; oboe-core:hasValue ?categUri .

    ?categUri rdfs:label ?categName .

    ?obs_var_05 a oboe-core:Observation ; oboe-core:ofEntity ?notVariableCategory ; oboe-core:hasMeasurement ?measu_unit_06 ;
                    oboe-core:hasContext+ ?obs_timeinstant_13 , ?obs_exPlot_15 .
    
    FILTER ( NOT EXISTS {  ?notVariableCategory  a  :VariableCategory  . })  .
        
    ?measu_unit_06 a oboe-core:Measurement ; oboe-core:usesStandard ?unite .

    ?obs_timeinstant_13 a oboe-core:Observation ; oboe-core:ofEntity oboe-temporal:TimeInstant ; oboe-core:hasMeasurement ?measu_date_15 .

    ?measu_date_15 a oboe-core:Measurement ; oboe-core:hasValue ?date .

    BIND (URI(CONCAT("http://date/year-",?date)) AS ?dateUri)

    
    ?obs_exPlot_15 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalPlot ; oboe-core:hasContext ?obs_site_17 .

    ?obs_site_17 a oboe-core:Observation ; oboe-core:ofEntity :ExperimentalSite ; oboe-core:hasMeasurement ?meas_siteName_18 .

    ?meas_siteName_18 a oboe-core:Measurement ; oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ; oboe-core:hasValue ?site .

    }

    GROUP BY ?site ?categName ?variableUri ?variable ?unite ?date ?dateUri  

    }

   ' \
    -H 'Accept:text/rdf+n3' >> $OUT
   
    echo ; echo 
    
  
  
 # SELECT QUERY FOR PORTAIL
 
 # PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
 #  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
 # PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
 #  PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
 # PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
 # PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
 
 # SELECT DISTINCT ?site ?categName ?variable ?unite ?dateUri  ?nbVariable WHERE {

 #  :VariableSynthesis :hasVariableUri ?variableUri .
 #  ?variableUri       :hasVariableName      ?variable    .
      
 #	?variableUri       :hasSiteName          ?site        .
 #  ?variableUri       :hasCategName         ?categName   .
 #  ?variableUri       :hasUnite             ?unite       .
    
 #  ?variableUri       :hasDate              ?dateUri     .
 #  ?dateUri           :hasTotalVariable     ?nbVariable  .
   
 # }


