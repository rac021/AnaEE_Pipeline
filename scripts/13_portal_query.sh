#!/bin/bash

  EXIT() {
    parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
    if [ $parent_script = "bash" ] ; then
        exit 2
    else
        kill -9 `ps --pid $$ -oppid=`;
        exit 2
    fi
  }
  
  CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  cd $CURRENT_PATH
  OUT=${1:-"../data/portail/ola_portal_synthesis.ttl"}
  mkdir -p "$(dirname "$OUT")"
 
  NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
  
  
  if [ -f $NANO_END_POINT_FILE ] ; then
    
    FIRST_END_POINT=$(head -n 1 $NANO_END_POINT_FILE )

    IFS=’:’ read -ra INFO_NANO <<< "$FIRST_END_POINT" 
    NANO_END_POINT_IP=${INFO_NANO[1]}
    NANO_END_POINT_PORT=${INFO_NANO[2]}
    NANO_END_POINT_NAMESPACE=${INFO_NANO[3]}

    ENDPOINT="http://$NANO_END_POINT_IP:$NANO_END_POINT_PORT/bigdata/namespace/$NANO_END_POINT_NAMESPACE/sparql"
    
    RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
    COUNT=0
    echo
    
    while [ -z $RES ] || [ $RES -ne 200 ] ;do
       sleep 1
       RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
       let "COUNT++" 
           
       if  [ -z $RES ] || [ $RES != 200 ] ; then 
          if [ `expr $COUNT % 3` -eq 0 ] ; then
              echo -e " \e[90m -> attempt to join cluster on namespace $NAMESPACE .. \e[39m"
          fi
          if [ $COUNT -eq 20 ] ; then
              echo -e " \e[31m ENDPOINT $ENDPOINT Not reachable !! \e[39m"
              echo
              EXIT
          fi
       fi
           
    done
    
    tput setaf 2
    echo -e "-------------------------------------------------------- "
    echo -e "## Query Demo usning Curl ##                             "
    echo -e "-----------------------------                            "
    echo -e "\e[90m$0       \e[32m                                    "
    echo
    echo -e " ## EndPoint : $ENDPOINT                                 "
    echo
    echo -e "-------------------------------------------------------- "
    echo 
    sleep 1
    tput setaf 7
  	
    curl -X POST $ENDPOINT --data-urlencode \
    'query=
	      PREFIX : <http://www.anaee-france.fr/ontology/anaee-france_ontology#> 
	      PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
	      PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#> 
	      PREFIX oboe-standard: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-standards.owl#>
	      PREFIX oboe-temporal: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-temporal.owl#>
	      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
		  		 
	      CONSTRUCT { 
	         
	            ?idVariableSynthesis  a                      :Variable             .
			    
		    ?idVariableSynthesis  :ofVariable            ?variable             .
		    ?variable             :hasCategory           ?category             .
	            ?variable        	  :hasAnaeeVariableName  ?anaeeVariableName    .
	            ?variable             :hasLocalVariableName  ?localVariableName    .
		    ?variable             :hasUnit               ?unit                 .
		     
		    ?unit                 :hasAnaeeUnitName      ?anaeeUnitName        .
	 	 
	 	    ?category             :hasCategoryName       ?categoryName         .
	 	    ?idVariableSynthesis  :hasSite               ?site                 .
	 	    ?site		  :hasLocalSiteName      ?localSiteName        . 
	            ?site	       	  :hasAnaeeSiteName      ?anaeeSiteName        .           
	 	    ?site		  :hasSiteType           ?siteType             .
	 	    ?site		  :hasSiteTypeName       ?siteTypeName         .
	 	    ?site		  :hasInfra              ?infra                .
	 	    ?infra                :hasInfraName          ?infraName            .
	 	     
	 	    ?idVariableSynthesis  :hasNbData             ?nbData               .
		    ?idVariableSynthesis  :hasYear               ?year                 .
		     
		   } 
	      WHERE {
	         
		    SELECT ?infra
		           ?infraName
		           ?idVariableSynthesis 
		           ?site  
		           ?anaeeSiteName
		           ?localSiteName	
			   ?siteType
			   ?siteTypeName
		           ?category
		           ?categoryName 
		           ?variable 
		           ?anaeeVariableName
			   ?localVariableName
		           ?unit
		           ?anaeeUnitName
		           ?year 
			   (COUNT(*) as ?nbData) 
			   
		    WHERE  {
			      
		        ?obs_var_1 a oboe-core:Observation ; 
				     oboe-core:ofEntity ?undefinedVariable ; 
				     oboe-core:hasMeasurement ?measu_unitAndValue_02 ; 
				     :hasVariableContext ?obs_variable_03 ;
		                     oboe-core:hasContext+ ?obs_timeInstant_55 , ?obs_expPlot_57 .             
		                              
		        ?measu_unitAndValue_02 a oboe-core:Measurement ; 
				                 oboe-core:usesStandard ?unit .
		       
		        ?unit rdfs:label ?anaeeUnitName .
		         
		        FILTER (lang(?anaeeUnitName) = "en") .
		          
		        ?obs_variable_03 a oboe-core:Observation ; 
				           oboe-core:ofEntity :Variable ; 
				           oboe-core:hasMeasurement ?measu_variableStandardName_05 ; 
		                           oboe-core:hasMeasurement ?measu_variableLocalName_04 ; 
				           oboe-core:hasContext ?obs_categ_06 .
		         
		        ?obs_categ_06 a oboe-core:Observation ; 
				        oboe-core:ofEntity :VariableCategory ; 
				        oboe-core:hasMeasurement ?measu_categName_07 .  
		              
		        ?measu_categName_07 a oboe-core:Measurement ; 
				              oboe-core:usesStandard :Anaee-franceVariableCategoryNamingStandard ; 
				              oboe-core:hasValue ?category .
		                  
		        ?category rdfs:label ?categoryName .
		        
		        ?measu_variableLocalName_04 a oboe-core:Measurement ; 
	     	   	                              oboe-core:usesStandard :NamingStandard ; 
			            	              oboe-core:hasValue ?localVariableName .
		
		        ?variable rdfs:label ?anaeeVariableName .
		            
		        ?measu_variableStandardName_05 a oboe-core:Measurement ; 
		   	                                 oboe-core:usesStandard :Anaee-franceVariableNamingStandard ; 
				                         oboe-core:hasValue ?variable .
		                  
		        ?obs_timeInstant_55 a oboe-core:Observation ; 
				              oboe-core:ofEntity 
				              oboe-temporal:TimeInstant ; 
				              oboe-core:hasMeasurement ?measu_date_56 .
			      
		        ?measu_date_56 a oboe-core:Measurement ;
			 	         oboe-core:hasValue ?date .
		                   
		        ?obs_expPlot_57 a oboe-core:Observation ; 
				          oboe-core:ofEntity :ExperimentalPlot ; 
				          oboe-core:hasContext ?obs_site_62   .
				               
		        ?obs_site_62 a oboe-core:Observation ; 
		   	               oboe-core:ofEntity :ExperimentalSite ;
				       oboe-core:hasContext ?obs_type_site_67 ;
				       oboe-core:hasContext ?obs_expNetWork_65 ;
				       oboe-core:hasMeasurement ?meas_siteNameStandard_64, ?meas_siteName_63 .
				 
		        ?obs_type_site_67 a oboe-core:Observation ; 
				            oboe-core:ofEntity ?siteType .
		        
		        ?siteType rdfs:label ?siteTypeName ;
		        
		        FILTER (lang(?siteTypeName ) = "en") .
		         
		        FILTER ( NOT EXISTS { ?obs_type_site_67 oboe-core:ofEntity :ExperimentalNetwork . }) . 
		         
		        ?obs_expNetWork_65 a oboe-core:Observation ; 
				             oboe-core:ofEntity :ExperimentalNetwork ;
				             oboe-core:hasMeasurement ?measu_expNetWorkName_66.
			
			?measu_expNetWorkName_66 a oboe-core:Measurement ; 
			                           oboe-core:usesStandard :Anaee-franceExperimentalNetworkNamingStandard ; 
				                   oboe-core:hasValue ?infra .
				            
			?infra rdfs:label ?infraName .
			
		        ?meas_siteNameStandard_64 a oboe-core:Measurement ; 
				                    oboe-core:usesStandard :Anaee-franceExperimentalSiteNamingStandard ; 
				                    oboe-core:hasValue ?anaeeSiteNameStandard .
			    
		        ?meas_siteName_63 a oboe-core:Measurement ; 
				            oboe-core:usesStandard :NamingStandard ; 
				            oboe-core:hasValue ?localSiteName .
			               
		        BIND(YEAR(?date) AS ?year).         
		                  
		        BIND (URI( REPLACE ( CONCAT("http://www.anaee-france.fr/ontology/anaee-france_ontology" , 
		                             ?anaeeSiteNameStandard ) , " ", "_") ) AS ?site ) .
		                  
		        ?site rdfs:label ?anaeeSiteName .
			   
		        BIND (URI( REPLACE ( CONCAT("http://anee-fr#ola/" , 
		                                     ?anaeeSiteName, "_" , 
		                                     ?categoryName, "_", 
		                                     ?anaeeVariableName, "_",
		                                     str(?year) ) , " ", "_") ) AS ?idVariableSynthesis ) 
		    }  
		    
	            GROUP BY ?infra ?infraName ?idVariableSynthesis ?site ?anaeeSiteName ?localSiteName 
	            ?siteType ?siteTypeName ?category ?categoryName ?variable ?anaeeVariableName
	            ?localVariableName ?unit ?anaeeUnitName ?year
	     }
     ' \
    -H 'Accept:text/rdf+n3' > $OUT
   
    echo ; echo 
    echo -e " \e[47m\e[30m Powered by EcoInfo-Orleans & Ontop Corese BlazeGraph © 2016 \e[49m\e[39m "
    echo
   
  else 
        
    echo -e "\e[91m Oupss, config  [ $NANO_END_POINT_FILE ] missed !!\e[39m "
 
  fi
    
   
