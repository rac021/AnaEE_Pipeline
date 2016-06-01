#!/bin/bash
 
  USER="anaee_user"
  PASSWORD="anaee_user"
  DATABASE="anaee_db"
  TABLE="physicochimiebysitevariableyear"
  
  
  tput setaf 2
   echo 
   echo -e " ##################################### "
   echo -e " ######### Create DataBase ########### "
   echo -e " ------------------------------------- "
   echo -e " \e[90m$0        \e[32m                "
   echo 
   echo -e " ##  USER      : $USER                 "
   echo -e " ##  PASSWORD  : $PASSWORD             "
   echo -e " ##  DATABASE  : $DATABASE             "
   echo -e " ##  TABLE     : $TABLE                "
   echo
   echo -e " ##################################### "
   echo 
   sleep 2
   tput setaf 7

    
  sudo -u postgres psql  << EOF
  
  DROP  DATABASE $DATABASE ;
  DROP  USER     $USER     ;
 
  CREATE DATABASE $DATABASE TEMPLATE template0 ; 
  CREATE USER $USER WITH PASSWORD '$PASSWORD'  ;
  
  \connect $DATABASE ;  

  CREATE TABLE $TABLE (
	site_code      	varchar(255) ,
	site_name      	varchar(255) ,
	datatype_code 	varchar(255) , 
	datatype_name 	varchar(255) ,
	variable_code 	varchar(255) ,
	variable_name 	varchar(255) , 
	unite_id        varchar(255) ,
	unite_code      varchar(255) ,
	unite_name      varchar(255) ,
	year 	        varchar(255) ,
	nb_data         integer      ,
	
	CONSTRAINT pk_site_datatype_variable PRIMARY KEY (site_code, datatype_code, variable_code )
  
  );

  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_1', 's_name_1', 'dtype_code_1', 'dtype_name_1', 'var_code_1', 'var_name_1', 'uni_id_1', 'uni_code_1','uni_name_1', '06-09-2015', 69) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_2', 's_name_2', 'dtype_code_2', 'dtype_name_2', 'var_code_2', 'var_name_2', 'uni_id_2', 'uni_code_2','uni_name_1', '06-09-2015', 81) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_3', 's_name_3', 'dtype_code_3', 'dtype_name_3', 'var_code_3', 'var_name_3', 'uni_id_3', 'uni_code_3','uni_name_1', '06-09-2015', 75) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_4', 's_name_4', 'dtype_code_4', 'dtype_name_4', 'var_code_4', 'var_name_4', 'uni_id_4', 'uni_code_4','uni_name_4', '06-09-2015', 20) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_5', 's_name_5', 'dtype_code_5', 'dtype_name_5', 'var_code_5', 'var_name_5', 'uni_id_5', 'uni_code_5','uni_name_5', '06-09-2015', 56) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_6', 's_name_6', 'dtype_code_6', 'dtype_name_6', 'var_code_6', 'var_name_6', 'uni_id_6', 'uni_code_6','uni_name_6', '06-09-2015', 64) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_7', 's_name_7', 'dtype_code_7', 'dtype_name_7', 'var_code_7', 'var_name_7', 'uni_id_7', 'uni_code_7','uni_name_7', '06-09-2015', 94) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_8', 's_name_8', 'dtype_code_8', 'dtype_name_8', 'var_code_8', 'var_name_8', 'uni_id_8', 'uni_code_8','uni_name_8', '06-09-2015', 20) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_9', 's_name_9', 'dtype_code_9', 'dtype_name_9', 'var_code_9', 'var_name_9', 'uni_id_9', 'uni_code_9','uni_name_9', '06-09-2015', 21) ;
  INSERT INTO physicochimiebysitevariableyear VALUES ('s_code_10', 's_name_10', 'dtype_code_10', 'dtype_name_10', 'var_code_10', 'var_name_10', 'uni_id_10', 'uni_code_10','uni_name_10', '06-09-2015', 69) ;

  GRANT SELECT ON $TABLE to $USER ;	

EOF

