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
         
	     ?idVariableSynthesis   a                     :Variable             .
		    
	     ?idVariableSynthesis  :ofVariable            ?variable             .
	     ?variable             :hasCategory           ?category             .
       ?variable             :hasAnaeeVariableName  ?anaeeVariableName    .
       ?variable             :hasLocalVariableName  ?localVariableName    .
         
	     ?variable             :hasUnit               ?unit                 .
 	 
 	     ?category             :hasCategoryName       ?categoryName         .
 	     ?idVariableSynthesis  :hasSite               ?site                 .
 	     ?site		             :hasLocalSiteName      ?localSiteName        . 
       ?site		             :hasAnaeeSiteName      ?anaeeSiteName        .           
 	     ?site		             :hasSiteType           ?siteType             .
 	     ?idVariableSynthesis  :hasNbData             ?nbData               .
	     ?idVariableSynthesis  :hasYear               ?year                 .
          
	   } 
   
     WHERE {
         
	    SELECT ?idVariableSynthesis 
	           ?site  
	           ?anaeeSiteName
			     	 ?localSiteName	
				     ?siteType				
	           ?category
	           ?categoryName 
	           ?variable 
	           ?anaeeVariableName
			       ?localVariableName
	           ?unit
	           ?year 
				     (COUNT(*) as ?nbData) 
      WHERE  {
	      
        ?obs_var_1 a oboe-core:Observation ; 
		                 oboe-core:ofEntity ?undefinedVariable ; 
		                 oboe-core:hasMeasurement ?measu_unitAndValue_02 ; 
		                 oboe-core:hasContext ?obs_variable_03 ;
                     oboe-core:hasContext+ ?obs_timeInstant_25 , ?obs_expPlot_27 .             
                              
        ?measu_unitAndValue_02 a oboe-core:Measurement ; 
		                             oboe-core:usesStandard ?unit .
                  
        ?obs_variable_03 a oboe-core:Observation ; 
		                       oboe-core:ofEntity :Variable ; 
		                       oboe-core:hasMeasurement ?measu_variableStandardName_04 ; 
                           oboe-core:hasMeasurement ?measu_variableLocalName_07 ; 
		                       oboe-core:hasContext ?obs_categ_05 .
         
        ?obs_categ_05 a oboe-core:Observation ; 
		                    oboe-core:ofEntity :VariableCategory ; 
		                    oboe-core:hasMeasurement ?measu_categName_06 .  
              
        ?measu_categName_06 a oboe-core:Measurement ; 
		                          oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ; 
		                          oboe-core:hasValue ?category .
                  
        ?category rdfs:label ?categoryName .
        
        ?measu_variableLocalName_07 a oboe-core:Measurement ; 
   	                                  oboe-core:usesStandard :NamingStandard ; 
		                                  oboe-core:hasValue ?localVariableName .

        ?variable rdfs:label ?anaeeVariableName .
            
        ?measu_variableStandardName_04 a oboe-core:Measurement ; 
   	                                     oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; 
		                                     oboe-core:hasValue ?variable .
                  
        ?obs_timeInstant_25 a oboe-core:Observation ; 
		                          oboe-core:ofEntity 
		                          oboe-temporal:TimeInstant ; 
		                          oboe-core:hasMeasurement ?measu_date_26 .
	      
        ?measu_date_26 a oboe-core:Measurement ;
	 	                     oboe-core:hasValue ?date .
                   
        ?obs_expPlot_27 a oboe-core:Observation ; 
		                      oboe-core:ofEntity :ExperimentalPlot ; 
		                      oboe-core:hasContext ?obs_site_32   .
		               
	      ?obs_site_32 a oboe-core:Observation ; 
		                   oboe-core:ofEntity :ExperimentalSite ;
		                   oboe-core:hasContext ?obs_type_site_37 ;
		                   oboe-core:hasMeasurement ?meas_siteNameStandard_34, ?meas_siteName_33 .
		 
        ?obs_type_site_37 a oboe-core:Observation ; 
		                        oboe-core:ofEntity ?siteType .
                   
        FILTER ( NOT EXISTS { ?obs_type_site_37 oboe-core:ofEntity :ExperimentalNetwork . }) . 
         
        ?meas_siteNameStandard_34 a oboe-core:Measurement ; 
		                                oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ; 
		                                oboe-core:hasValue ?anaeeSiteNameStandard .
	    
        ?meas_siteName_33 a oboe-core:Measurement ; 
		                        oboe-core:usesStandard :NamingStandard ; 
		                        oboe-core:hasValue ?localSiteName .
	               
        BIND(YEAR(?date) as ?year).         
                  
        BIND (URI( REPLACE ( CONCAT("http://www.anaee-france.fr/ontology/anaee-france_ontology" , ?anaeeSiteNameStandard ) , " ", "_") ) AS ?site ) .
                  
        ?site rdfs:label ?anaeeSiteName .
	   
        BIND (URI( REPLACE ( CONCAT("http://anee-fr#ola/" , ?anaeeSiteName, "_" , ?categoryName, "_",?anaeeVariableName, "_", str(?year) ) , " ", "_") ) AS ?idVariableSynthesis ) 
      
      }  

	    GROUP BY ?idVariableSynthesis ?site ?anaeeSiteName ?localSiteName ?siteType ?category ?categoryName ?variable ?anaeeVariableName  ?localVariableName ?unit ?year
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
  
  		    SELECT ?site 
  		           ?anaeeSiteName
  		           ?localSiteName 
  		           ?siteType 
  		           ?category 
  		           ?categoryName
  		           ?variable 
  		           ?anaeeVariableName
  		           ?localVariableName 
  		           ?unit 
  		           ?year 
  		           ?nbData 
  		    WHERE  {  
      		    
      		   ?idVariableSynthesis   a                     :Variable             .
      		    
      	     ?idVariableSynthesis  :ofVariable            ?variable             .
      	     ?variable             :hasCategory           ?category             .
             ?variable             :hasAnaeeVariableName  ?anaeeVariableName    .
             ?variable             :hasLocalVariableName  ?localVariableName    .
               
      	     ?variable             :hasUnit               ?unit                 .
       	 
       	     ?category             :hasCategoryName       ?categoryName         .
       	     ?idVariableSynthesis  :hasSite               ?site                 .
       	     ?site		             :hasLocalSiteName      ?localSiteName        . 
             ?site		             :hasAnaeeSiteName      ?anaeeSiteName        .           
       	     ?site		             :hasSiteType           ?siteType             .
       	     ?idVariableSynthesis  :hasNbData             ?nbData               .
      	     ?idVariableSynthesis  :hasYear               ?year                 .
  		    }
  		    
  		    ORDER BY ?site ?year  '
		  
		   
