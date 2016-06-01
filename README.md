# AnaEE_Pipeline

 **master_pipeline Parameters :**
 
-    `$1 : Image_docker_name`

-    `$2 : Blazegraph_namespace`

-    `$3 : Ports  number `

-    `$4 : IP Container HOST_1 `

-    `$5 : IP Container HOST_2 `

-    `$6 : IP Container HOST_3 `

-    `$7 : READ-WRITE MODE ( ro - rw )`


Ex :

    ./master_pipeline.sh  \
      blz_img             \
      ola                 \
      9999                \
      192.168.56.10       \
      192.168.56.20       \
      192.168.56.30       \
      rw
     
     
Included Projects : 

   [https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes]( https://github.com/rac021/blazegraph_1_5_3_cluster_2_nodes)
   
   [https://github.com/rac021/obdaYedGen-3.14.2]( https://github.com/rac021/obdaYedGen-3.14.2)
   
   [https://github.com/rac021/CoreseInfer]( https://github.com/rac021/CoreseInfer)
   
   [https://github.com/rac021/ontop-matarializer]( https://github.com/rac021/ontop-matarializer)
   
   

Requirements :

-    `JAVA 8`
    
-    `CURL `
    
