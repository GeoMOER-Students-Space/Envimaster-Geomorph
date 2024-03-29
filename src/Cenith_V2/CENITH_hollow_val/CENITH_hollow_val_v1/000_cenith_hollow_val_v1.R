#' Mandatory: Cenith Hollow Validation v1
#'
#' @description Optional: used to test optimal moving window for the Cenith Segmentation
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: chm - a canopy height model or raster with elevation values
#' @param Mandatory if function: a, b - parameters for moving window
#' predefinition in var is recommended
#' @param Mandatory if function: h - minimum height to detect trees
#' @param Mandatory if function: optional f - numeric, must be odd, fxf filter,
#' uses a spatial sum filter
#' @param Mandatory if function: vp - a pointlayer (shp) with positions of Objects
#' @param Mandatory if function: min - the minimum area in m� for polygons
#' @param Mandatory if function: max - the maximum area in m� for polygons

#note: v1 merging polygons and clipping of min and max area

cenith_hollow_val <-function(chm,f=1,a,b,h,vp,min,max){
  result <- data.frame(matrix(nrow = 3, ncol = 5))
  maxsom <- raster::cellStats(chm, "max")
  if (max(h)>maxsom){
    stop("max of h is higher than the highest cell in som")
  }
  if (f>1){
    cat(paste0("### Cenith computes som with sum filter ",as.factor(f)," ###",sep = "\n"))
    chm <- raster::focal(chm,w=matrix(1/(f*f),nrow=f,ncol=f))
  } else {chm = chm}   ### filter function seperate
  
  
for (c in seq(1:length(h))){
  cat(paste0("### Cenith starts with loop h ",as.factor(c)," / ",as.factor(length(h))," ###",sep = "\n"))
  cat       ("#############################",sep="\n")
  if(c==1){
    res  <-cenith_hollow_val_a_v1(chm,a,b,h[c],vp,min,max)
  }    else {
    res2 <-cenith_hollow_val_a_v1(chm,a,b,h[c],vp,min,max)
    res= rbind(res,res2)}


  
}   
  names(res)<- c("a","b","height","hit","sum_area","miss","obj/vp","empty","nobj_final","poly_after_merge","poly_seg")
  
  cat       ("################################",sep="\n")
  cat       ("   CC EEEE N   N  I TTTTT H   H ",sep="\n")
  cat       ("  C   E    NN  N  I   T   H   H ",sep="\n")
  cat       (" C    EE   N N N  I   T   HHHHH ",sep="\n")
  cat       ("  C   E    N  NN  I   T   H   H ",sep="\n")
  cat       ("   CC EEEE N   N  I   T   H   H ",sep="\n")
  cat       ("                                ",sep="\n")
  cat       ("Finished hollow validation ",sep="\n")
  return(res)
}

#'@examples
#'\dontrun

#'### first load envrmt
#'require(ForestTools)
#'require(uavRst)
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_val4b_v2.R")))
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/dev_sf_cenith_val_a.R")))
#'
#'##load data 
#'chm <- raster::raster(file.path(root_folder, file.path(pathdir,"Cenith_V2/exmpl_chm.tif")))
#'vp <-  rgdal::readOGR(file.path(root_folder, file.path(pathdir,"Cenith_V2/vp_wrongproj.shp")))
#'vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
#'compareCRS(chm,vp)  

###run Cenith Validation
#'cval <- cenith_val_v2_1(chm,f=1,c(0.04,0.08),c(0.1),h=c(8,13),vp=vp)
#'cval
#'cval[which.max(cval$hitrate),]

  