# AnaEE_Pipeline

the script `00_master_pipeline.sh` `BUILD` and `DEPLOY` Blazegraph cluster.

It just run `01_infra_build.sh` then `02_infra_deploy.sh` scripts.

00_master_pipeline.sh parameters :

      ` $1 : image_docker_name` 

     ` $2 :  blazegraph_namespace` 


Ex : 

     ` ./00_master_pipeline.sh blazegraph_image ola_namespace `
