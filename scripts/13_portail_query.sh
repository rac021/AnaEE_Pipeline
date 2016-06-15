#!/bin/bash

    OUT=$1
	
    curl -X POST http://172.17.0.1:9999/blazegraph/namespace/kb/sparql --data-urlencode \
    'query=
	    PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
	    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
	    PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
	    PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
	    PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
	    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

	    CONSTRUCT { 

	         ?idVariableSynthesis   a                    :Variable             .
		    
		 ?idVariableSynthesis  :ofVariable           ?variable             .
		 ?variable             :hasCategory          ?category             .
		 ?variable             :hasVariableName      ?variableName         .
		 ?variable             :hasUnit              ?unit                 .
 		 
 		 ?category             :hasCategoryName      ?categoryName         .
 		 ?idVariableSynthesis  :hasSite              ?site                 .
 		 ?site		       :hasSiteName          ?siteName             . 
 		 ?site		       :hasSiteType          ?siteType             .
 		 ?idVariableSynthesis  :hasNbData            ?nbData               .
		 ?idVariableSynthesis  :hasYear              ?year                 .
	    }

	    WHERE {

	      SELECT ?idVariableSynthesis 
	             ?site  
	             ?siteName
	             ?siteType
	             ?category
	             ?categoryName 
	             ?variable 
	             ?variableName 
	             ?unit
	             ?year (COUNT(*) as ?nbData) WHERE {

	       ?obs_var_1 a oboe-core:Observation ; 
		            oboe-core:ofEntity :Variable ; 
		            oboe-core:hasMeasurement ?measu_variable_02 ; 
		            oboe-core:hasContext ?obs_categ_03 , ?obs_var_05 .

	      ?measu_variable_02 a oboe-core:Measurement ; 
		                   oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; 
		                   oboe-core:hasValue ?variable .

	      ?variable rdfs:label ?variableName .

	      ?obs_categ_03 a oboe-core:Observation ; 
		              oboe-core:ofEntity :VariableCategory ; 
		              oboe-core:hasMeasurement ?measu_categName_4 .  

	      ?measu_categName_4 a oboe-core:Measurement ; 
		                   oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ; 
		                   oboe-core:hasValue ?category .

	      ?category rdfs:label ?categoryName .

	      ?obs_var_05 a oboe-core:Observation ; 
		            oboe-core:ofEntity ?notVariableCategory ; 
		            oboe-core:hasMeasurement ?measu_unit_06 ;
		            oboe-core:hasContext+ ?obs_timeinstant_13 , ?obs_exPlot_15 .

	      FILTER ( NOT EXISTS {  ?notVariableCategory  a  :VariableCategory . })   .

	      ?measu_unit_06 a oboe-core:Measurement ; 
		               oboe-core:usesStandard ?unit .
		
	      # ?unit rdfs:label ?unitName .
	      
	      ?obs_timeinstant_13 a oboe-core:Observation ; 
		                    oboe-core:ofEntity 
		                    oboe-temporal:TimeInstant ; 
		                    oboe-core:hasMeasurement ?measu_date_15 .

	      ?measu_date_15 a oboe-core:Measurement ;
		               oboe-core:hasValue ?year .

	      ?obs_exPlot_15 a oboe-core:Observation ; 
		               oboe-core:ofEntity :ExperimentalPlot ; 
		               oboe-core:hasContext ?obs_site_17   .

	      ?obs_site_17 a oboe-core:Observation ; 
		             oboe-core:ofEntity :ExperimentalSite ;
		             oboe-core:hasContext ?obs_type_site_24 ;
		             oboe-core:hasMeasurement ?meas_siteName_18 .

	      ?obs_type_site_24 a oboe-core:Observation ; 
		                  oboe-core:ofEntity ?siteType .
	
	       FILTER ( NOT EXISTS { ?obs_type_site_24 oboe-core:ofEntity :ExperimentalNetwork . }) . 
	      
	      ?meas_siteName_18 a oboe-core:Measurement ; 
		                  oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ; 
		                  oboe-core:hasValue ?siteNameStandard .
	       
	      BIND (URI( REPLACE ( CONCAT("http://www.anaee-france.fr/ontology/anaee-france_ontology" , ?siteNameStandard ) , " ", "_") ) AS ?site ) .
	       
    	      BIND (URI( REPLACE ( CONCAT("http://anee-fr#ola/" , ?siteNameStandard, "_" , ?categoryName, "_",?variableName, "_", ?year ) , " ", "_") ) AS ?idVariableSynthesis ) .
	      
	      ?site rdfs:label ?siteName .
	       
	     }

	     GROUP BY ?idVariableSynthesis ?site ?siteName ?siteType ?category ?categoryName ?variable ?variableName ?unit ?year 
           }
        ' \
        -H 'Accept:text/rdf+n3' > $OUT
   
    echo ; echo 

    portail_query='
		    PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
		    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
		    PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
		    PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
		    PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
		    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

		    SELECT ?site ?siteName ?siteType ?category ?categoryName ?variable ?variableName ?unit ?year ?nbData  WHERE { 
		    
		         ?idVariableSynthesis   a                    :Variable             .
			    
			 ?idVariableSynthesis  :ofVariable           ?variable             .
			 ?variable             :hasCategory          ?category             .
			 ?variable             :hasVariableName      ?variableName         .
			 ?variable             :hasUnit              ?unit                 .
	 		 
	 		 ?category             :hasCategoryName      ?categoryName         .
	 		 ?idVariableSynthesis  :hasSite              ?site                 .
	 		 ?site		       :hasSiteName          ?siteName             . 
	 		 ?site		       :hasSiteType          ?siteType             .
	 		 ?idVariableSynthesis  :hasNbData            ?nbData               .
			 ?idVariableSynthesis  :hasYear              ?year                 .
		    }
		    
		    ORDER BY ?site ?year  '
		  
		   
