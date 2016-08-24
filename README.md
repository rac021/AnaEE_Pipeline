# AnaEE_Pipeline

 **pipeline Parameters :**
 
-    `$1 : Image_docker_name`

-    `$2 : IP Container HOST_1 `

-    `$3 : IP Container HOST_2 `

-    `$4 : IP Container HOST_3 `

-    `$5 : Blazegraph_namespace`

-    `$6 : Ports  number `

-    `$7 : READ-WRITE MODE ( ro - rw )`


**Example :**

```
❯    ./pipeline_fullGraph.sh \
      blz_img                \
      192.168.56.10          \
      192.168.56.20          \
      192.168.56.30          \
      ola                    \
      6985                   \
      rw
```

**Included Projects :** 

-    [https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes]( https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes)
   
-    [https://github.com/rac021/yedGen]( https://github.com/rac021/yedGen.git)
   
-    [https://github.com/rac021/CoreseInfer]( https://github.com/rac021/CoreseInfer)
   
-    [https://github.com/rac021/ontop-matarializer]( https://github.com/rac021/ontop-matarializer)
   
-    [ Traefik Reverse proxy + load balancer ]( https://github.com/rac021/Traefik_reverse_proxy)   

**Requirements :**

-    `JAVA 8`
    
-    `MAVEN`
   
-    `CURL `
    
-    `Postgres`

-    `Docker 1.10 and + ` [https://docs.docker.com/engine/installation/binaries]( https://docs.docker.com/engine/installation/binaries)
     
    
 ----------------------------------------------------

**Quick setup ( using Docker Hub image ) no need scripts ; change IPs and ports if needed :**
 
 ```
❯    docker network create --subnet=192.168.56.250/24 mynet123

     docker run -d --net mynet123 --name blz_host_0                   \
                --memory-swappiness=0	                              \
                --add-host blz_host_0:192.168.56.10                   \
                --add-host blz_host_1:192.168.56.20                   \
                --add-host blz_host_2:192.168.56.30                   \
                --ip 192.168.56.10                                    \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "
                   
     docker run -d --net mynet123 --name blz_host_1                   \
                --memory-swappiness=0	                              \
                --add-host blz_host_0:192.168.56.10                   \
                --add-host blz_host_1:192.168.56.20                   \
                --add-host blz_host_2:192.168.56.30                   \
                --ip 192.168.56.20                                    \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "

     docker run -d --net mynet123 --name blz_host_2                   \
                --memory-swappiness=0	                              \
                --add-host blz_host_0:192.168.56.10                   \
                --add-host blz_host_1:192.168.56.20                   \
                --add-host blz_host_2:192.168.56.30                   \
                --ip 192.168.56.30                                    \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "
        
 ------------------------------------------------------------------------------------------

     docker run -d --net mynet123                                                         \
                -l traefik.backend=client_blz_backend                                     \
                -l traefik.frontend.rule=Host:client.blz.localhost                        \
                --name  client_01_blz                                                     \
                --ip    192.168.56.200                                                    \
                -p      9990:9999                                                         \
                --expose 9999                                                             \
                --memory-swappiness=0                                                     \
                --entrypoint /bin/bash -it rac021/blz_cluster_2_nodes                     \
                -c " ./nanoSparqlServer.sh 9999 ola rw ;  while true; do sleep 1000; done "
                           
     docker run -d --net mynet123                                                         \
                -l traefik.backend=client_blz_backend                                     \
                -l traefik.frontend.rule=Host:client.blz.localhost                        \
                --name  client_02_blz                                                     \
                --ip    192.168.56.210                                                    \
                -p      9995:9999                                                         \
                --memory-swappiness=0                                                     \
                --entrypoint /bin/bash -it rac021/blz_cluster_2_nodes                     \
                -c " ./nanoSparqlServer.sh 9999 ola rw ;  while true; do sleep 1000; done "
                
```
 

----------------------------------------------------


### **Pipeline description**
 
   As needs, scripts [pipeline_fullGraph.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/pipeline_fullGraph.sh), [pipeline_graphChunks.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/pipeline_graphChunks.sh) , [pipeline_patternGraphChunks.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/pipeline_patternGraphChunks.sh) *orchestrate the pipeline*
           
#### * **Scripts ( folder scripts )**

*  **[00_install_libs.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/00_install_libs.sh)**

     - Take 0, 1 or 2 arguments
     - **$1 DATA_BASE :** Postgresql / mySql 
     - **$2 TYPE_INSTALL :** demo / graphChunks / patternGraphChunks
     - Create needed folders
     - Default database : Postgresql. Supported database : mySql
     - Install [yedGen]( https://github.com/rac021/yedGen) : **libs/yedGen.jar**
     - Copy yedGen documentation + examples to **libs/Docs**
     - Install [ontop-matarializer]( https://github.com/rac021/ontop-matarializer) : **libs/Ontop-Materializer.jar**
     - Copy Ontop-Materializer documentation + examples to **libs/ontop**
     - Install [CoreseInfer]( https://github.com/rac021/CoreseInfer) : **libs/CoreseInfer.jar**
     - Copy CoreseInfer documentation + examples to **libs/corese**
     - Install [ Install Traefik reverse proxy]( https://github.com/rac021/Traefik_reverse_proxy) : **libs/traefik**     


*  **[01_infra_build.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/01_infra_build.sh)**

     - Take 1 argument
     - **$1 BLZ_IMAGE_NAME :** Name of the BlazeGraph Image to build.
     - Remove **DOCKER_BLZ_IMAGE** if already exists.
     - Buid BlazeGraph Docker image based on the [Dockerfile]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/Docker/Dockerfile)  

     
*  **[02_infra_deploy.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/02_infra_deploy.sh)** 

     - Take at least 5 arguments 
     - **$1 BLZ_IMAGE_NAME :** Name of the BlazeGraph Image built by the script **[01_infra_build.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/01_infra_build.sh)**.
     - **$2 IP_HOST_0 :**  IP Adress that will be assigned to the Container_Host_0
     - **$3 IP_HOST_1 :**  IP Adress that will be assigned to the Container_Host_1
     - **$4 IP_HOST_2 :**  IP Adress that will be assigned to the Container_Host_2
     - **$5 NameSpace :**  Name Space that will be used in the cluster
     - **$6 SUBNET_NAME :**  Optionnal. Default : **mynet123**
     - **$7 SUBNET_RANGE :**  Optionnal. Default : **192.168.56.250/24**
     - The script will remove all containers based on images **BLZ_IMAGE_NAME** before starting Build
     - Host_Name_0 = blz_host_0 [ Do not change ]
     - Host_Name_1 = blz_host_1 [ Do not change ]
     - Host_Name_2 = blz_host_2 [ Do not change ]
     - Write Hosts [ blz_host_0 , blz_host_1 , blz_host_2 ] in **scripts/conf/hosts**

*  **[03_infra_attach_services.sh](https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/03_infra_attach_services.sh)**

     - Take 1 or * ( with max arguments = 7 )
     - **$1 BLZ_IMAGE_NAME :** Name of the BlazeGraph Image built by the script **[01_infra_build.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/01_infra_build.sh)**.
     - **$2 Base-Name-Container :**  Each container will be created with name : Base-Name-Container "_" $IP++ "_blz"
     - **$3 StartIP :**  Assign **IP = startIP** to **Conainer_1**, **IP = startIP + 1** to **Conainer_2** ...
     - **$4 NbrInstances :**  number of instances that will be deployed
     - **$5 NameSpace :**  Name Space that will be used in the cluster
     - **$6 Port :**  Port that will be used by **nanoSparqlServer** ( in the docker container )
     - **$7 RW-Mode :**  if **rw** then enable **Read-Write** Mode. if **ro** then enable **Read-Only** Mode
     - **$8 SUBNET :** Optionnal. Default : **mynet123**
     - **$9 TRAEFIK_BACKEND :** Optionnal. Default : **client_blz_backend**
     - **$10 TRAEFIK_FRONTEND_RULE :**  Optionnal. Default : **Host:client.blz.localhost**
     - if **One Argument** is passed and **$1 = clearAll** , then all Services will be removed
     - For each service, Write : "Name_Container:IP:Port:NameSpace:RW-Mode" in **scripts/conf/nanoEndpoint**

*  **[04_infra_attach_service.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/04_infra_attach_service.sh)**

     - Take exactly Six arguments
     - **$1 BLZ_IMAGE_NAME :** Name of the BlazeGraph Image built by the script **[01_infra_build.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/01_infra_build.sh)**.
     - **$2 CONTAINER_NAME :**  Name of the container that will be created.
     - **$3 StartIP :**  Assign **IP = startIP** to **Conainer_1**, **IP = startIP + 1** to **Conainer_2** ...
     - **$4 NameSpace :**  Name Space that will be used in the cluster
     - **$5 Port :**  Port that will be used by **nanoSparqlServer** ( in the docker container )
     - **$6 RW-Mode :**  if **rw** then enable **Read-Write** Mode. if **ro** then enable **Read-Only** Mode
     - **$7 SUBNET :** Optionnal. Default : **mynet123**
     - **$8 TRAEFIK_BACKEND :** Optionnal. Default : **client_blz_backend**
     - **$9 TRAEFIK_FRONTEND_RULE :**  Optionnal. Default : **Host:client.blz.localhost**
     - The script will remove the container based on images **CONTAINER_NAME** if already exists
     - Write : "CONTAINER_NAME:IP:Port:NameSpace:RW-Mode" in **scripts/conf/nanoEndpoint**

*  **[05_infra_start_stop.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/05_infra_start_stop.sh)**

     - Take exactly One argument
     - if **$1 = start** : for each
          - container of the cluster do : **./bigdata start**
          - blazeGraph service container of the cluster do : **./nanoSparqlServer.sh Port NameSpace RW-Mode**
          - Wite **1** in **scripts/conf/status**
     - if **$1 = stop** : for each
          - container of the cluster do : **./bigdata stop**
          - blazeGraph service container of the cluster do :  **./bigdata stop** ( will kill nanoSparqlServer process )
          - Wite **0** in **scripts/conf/status**
                    
*  **[06_docker_nginx.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/06_docker_nginx.sh)**

     - Used to solves some proxy problems
     - Take 1 or * ( with max arguments = 9 )
     - if **$1 = start** : start nginx docker container
     - if **$1 = stop** : stop nginx docker container
     - **$2 DEFAULT_IP :** IP of the Nginx container. Optionnal. Default **192.168.56.110**
     - **$3 SUBNET :** Optionnal. Default : **mynet123**
     - **$4 SUBNET_RANGE :** Optionnal. Default : **192.168.56.250/24**
     - **$5 DEFAULT_PORT :** Nginx Port. Optionnal. Default : **80**
     - **$6 LOCAL_IP :** IP OF THE LocalHost. Optionnal. Default **127.0.0.1**
     - **$7 IMAGE_NAME :** Name of the Nginx Container. Optionnal. Default : **nginx-ecoinformatics**
     - **$8 HOST :** Host that will be add to **/etc/hosts** in the Host Machine. Optionnal. Default : **ecoinformatics.org**
     - **$9 FOLDER_DOCKER_FILE :** localtion of the wb files. Optionnal. Default : **docker_nginx_server**
     - The script will remove the container based on images **IMAGE_NAME** if already exists
      - Build and run **nginx-ecoinformatics** docker image 
     - Ontologies accessible locally
     - If start : add **"127.0.0.1 ecoinformatics.org"** to **/etc/hosts**
     - If stop : remove **"127.0.0.1 ecoinformatics.org"** from **/etc/hosts**
     
*  **[07_gen_mapping.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/07_gen_mapping.sh)**

     - Take 0 or * ( with max arguments = 3 )
     - **$1 INPUT :** path of graph files. Optionnal.Default **data/yedGen/**
     - **$2 OUTPUT :** obda file(s). Optionnal. Default **mapping/mapping.obda**
     - **$3 EXTENSION :** Extension of the graph files that wil be processed. Optionnal. Default **.graphml**
     - Refer to [https://github.com/rac021/yedGen]( https://github.com/rac021/yedGen)
     
*  **[08_ontop_gen_triples.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/08_ontop_gen_triples.sh)**

     - Take 0 or * ( with max arguments = 7 )
     - **$1 OWL :** Path of the Ontology(ies). Optionnal. Default  **mapping/ontology.owl**
     - **$2 OBDA :** Path of the obda mapping file. Optionnal. Default **mapping/mapping.obda**
     - **$3 OUTPUT :** Path output data. Optionnal. Default **data/ontop/ontopMaterializedTriples.ttl**
     - **$4 QUERY :** Query that will be executed. Optionnal. Default **SELECT ?S ?P ?O { ?S ?P ?O }**
     - **$5 TTL :** if **-ttl** then, enable **turtle format**, else xml. Optionnal. Default  **-ttl**
     - **$6 XMS :** Optionnal. Default **-Xms2048M**
     - **$7 XMX :** Optionnal. Default **-Xms2048M**
     - Refer to [https://github.com/rac021/ontop-matarializer]( https://github.com/rac021/ontop-matarializer)
     
*  **[09_corese_infer.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/09_corese_infer.sh)**

     - Used to infer triples
     - Take 0 or * ( with max arguments = 8 )
     - **$1 OWL :** Path of the Ontology(ies). Optionnal. Default  **mapping/ontology.owl**
     - **$2 TTL :** Path of the triples file. Optionnal. Default **data/ontop/ontopMaterializedTriples.ttl**
     - **$3 QUERY :** Query that will be executed. Optionnal. Default **SELECT ?S ?P ?O { ?S ?P ?O }**
     - **$4 OUTPUT :** Directory where output results.
     - **$5 f :** Fragments. Number of triples per file. if = 0 then unlimited. Optionnal. Default **100000**
     - **$6 F :** Output Format. **ttl**. Supported XML, CSV. Optionnal. Default : **ttl**
     - **$7 XMS :**  Optionnal. Default **-Xms2048M**
     - **$8 XMX :**  Optionnal. Default **-Xms2048M**
     - Refer to [https://github.com/rac021/CoreseInfer]( https://github.com/rac021/CoreseInfer)
     

*  **[10_load_data.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/10_load_data.sh)**

     - Used to load data on the blazeGraph endpoint.
     - Take 0 or 1 argument
     - **$1 DATA_DIR :** Directory where files to load are located. Optionnal. Default **data/corese**
     - Relies on **scripts/conf/nanoEndpoint** file
     - inform if endPoint not reachable

*  **[11_query_demo.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/11_query_demo.sh)**

     - Query blazeGraph endPoint using a spaql query demo.
     - Take **0** argument
     - Output Result on **console**
     
*  **[12_synthesis_portal.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/12_synthesis_portal.sh)**

     - Create Synthesis for portal
     - Take **1** argument
     - **$1 OUT :** Directory where result file will be localed. Optionnal. Default **../data/portail/ola_portal_synthesis.ttl**
     - Relies on **scripts/conf/nanoEndpoint** file
     - inform if endPoint not reachable
     
*  **[13_listServices.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/13_listServices.sh)**

     - List all available services in the blazeGraph cluster.
     - Take **0** argument
     - Relies on **scripts/conf/hosts**
     
*  **[14_listConfig.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/14_listConfig.sh)**

     - List all cluster Host names + IP + Ports + Clients
     - Take **0** argument
     - Relies on **scripts/conf/hosts**
     - Relies on **scripts/conf/status**
     - Relies on **scripts/conf/nanoEndpoint**
    
*  **[15_monitoring_kitematic.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/15_monitoring_kitematic.sh)**

     - Docker GUI
     - Take **0** argument
     - Must have a Docker Hub Account
   
----------------------------------------------------

## Summary

![pipeline_doc](https://cloud.githubusercontent.com/assets/7684497/17931196/7ac44556-6a0a-11e6-8f29-a2d8d369802a.jpg)


## Archi SI AnaEE :

![archi_si](https://cloud.githubusercontent.com/assets/7684497/17937033/140233de-6a21-11e6-82f7-081572e71ed0.jpg)

