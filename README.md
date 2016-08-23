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
*Note : Ports 6981 6982 6983 are reserved*
     
**Included Projects :** 

-    [https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes]( https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes)
   
-    [https://github.com/rac021/yedGen]( https://github.com/rac021/yedGen.git)
   
-    [https://github.com/rac021/CoreseInfer]( https://github.com/rac021/CoreseInfer)
   
-    [https://github.com/rac021/ontop-matarializer]( https://github.com/rac021/ontop-matarializer)
   
-    [Reverse proxy + load balancer ]( https://github.com/rac021/Traefik_reverse_proxy)   

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
                --ip 192.168.56.10 -p  6981:9999                      \
                --expose 9999                                         \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "
                   
     docker run -d --net mynet123 --name blz_host_1                   \
                --memory-swappiness=0	                              \
                --add-host blz_host_0:192.168.56.10                   \
                --add-host blz_host_1:192.168.56.20                   \
                --add-host blz_host_2:192.168.56.30                   \
                --ip 192.168.56.20 -p  6982:9999                      \
                --expose 9999                                         \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "

     docker run -d --net mynet123 --name blz_host_2                   \
                --memory-swappiness=0	                              \
                --add-host blz_host_0:192.168.56.10                   \
                --add-host blz_host_1:192.168.56.20                   \
                --add-host blz_host_2:192.168.56.30                   \
                --ip 192.168.56.30 -p  6983:9999                      \
                --expose 9999                                         \
                -it --entrypoint /bin/bash rac021/blz_cluster_2_nodes \
                -c "./bigdata start; while true; do sleep 1000; done  "
         
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

*  **[01_infra_build.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/01_infra_build.sh)**

*  **[02_infra_deploy.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/02_infra_deploy.sh)**

*  **[03_infra_attach_services.sh](https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/03_infra_attach_services.sh)**

*  **[04_infra_attach_service.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/04_infra_attach_service.sh)**

*  **[05_infra_start_stop.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/05_infra_start_stop.sh)**

*  **[06_docker_nginx.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/06_docker_nginx.sh)**

*  **[07_gen_mapping.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/07_gen_mapping.sh)**

*  **[08_ontop_gen_triples.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/08_ontop_gen_triples.sh)**

*  **[09_corese_infer.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/09_corese_infer.sh)**

*  **[10_load_data.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/10_load_data.sh)**

*  **[11_query_demo.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/11_query_demo.sh)**

*  **[12_synthesis_portal.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/12_synthesis_portal.sh)**

*  **[13_listServices.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/13_listServices.sh)**

*  **[14_listConfig.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/14_listConfig.sh)**

*  **[15_monitoring_kitematic.sh]( https://github.com/rac021/AnaEE_Pipeline/blob/master/scripts/15_monitoring_kitematic.sh)**

   
----------------------------------------------------

## Summary

![pipeline_01](https://cloud.githubusercontent.com/assets/7684497/17776064/4f954b40-655b-11e6-9d23-7f02c64c6ea9.png)



## Archi AnaEE :

![archi_anaee](https://cloud.githubusercontent.com/assets/7684497/17859243/1535f7ac-6889-11e6-82d0-cd213fd66f88.png)

