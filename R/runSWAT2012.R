#' This runs the SWAT2012 executable in the current directory.
#'
#' This function runs the SWAT2012 executable in the current directory.
#'
#' @param simdir file.path
#' @param hist_wx Describe \code{hist_wx}
#' @param elev Describe \code{elev}
#' @param rch Describe \code{rch}
#' @export
#' @author Daniel R. Fuka
#'
#' @examples \dontrun{
#' setwd("test")
#' test <- runSWAT2012(file.path(getwd(), ""))
#' }
runSWAT2012 <- function(simdir = ".", hist_wx = NULL, elev = 100, rch = 3) {

  Sys.setenv(GFORTRAN_STDIN_UNIT  = -1)
  Sys.setenv(GFORTRAN_STDOUT_UNIT = -1)
  Sys.setenv(GFORTRAN_STDERR_UNIT = -1)

  if(length(hist_wx) > 2) {
    tmp_head <- paste("Tmp\nLati Not Used\nLong Not Used\nElev        ",
                      sprintf("%5.0f\n", elev), sep = "")
    pcp_head <- paste("Pcp\nLati Not Used\nLong Not Used\nElev        ",
                      sprintf("%5.0f\n", elev), sep = "")
    cat(tmp_head, sprintf("%s%005.1f%005.1f\n", format(hist_wx$DATE,
                                                       "%Y%j"), hist_wx$TMX, hist_wx$TMN), file = "tmp.tmp", sep = "")
    cat(pcp_head, sprintf("%s%005.1f\n", format(hist_wx$DATE, "%Y%j"),
                          hist_wx$PRECIP), file = "pcp.pcp", sep = "")
    print("built new pcp.pcp and tmp.tmp files, make sure they are correct in file.cio")
  }

  libarch <- if (nzchar(version$arch))
    paste("libs", version$arch, sep = "/") else "libs"
  swatbin <- "rswat2012.exe"

  if(!file.exists(file.path(simdir, swatbin))){
    invisible(
      file.copy(
        path.expand(path.package(package = "swatr")),
        file.path(path.package(package = "swatr"), "src", swatbin),
              file.path(simdir, swatbin)))
  }

  system(shQuote(file.path(simdir, swatbin)))

  start_year <- read.fortran(textConnection(readLines(
    file.path(simdir, "file.cio"))[9]), "f20")

  temp <- readLines(file(file.path(simdir, "output.rch")))
  rchcolname <- sub(" ", "", (substr(temp[9], 50, 61)))
  flow <- data.frame(as.numeric(as.character(substr(temp[10:length(temp)],
                                                    50, 61))))
  colnames(flow) <- rchcolname
  reach <- data.frame(as.numeric(as.character(substr(temp[10:length(temp)],
                                                     8, 10))))
  rchcolname <- sub(" ", "", (substr(temp[9], 8, 10)))
  colnames(reach) <- rchcolname
  outdata <- cbind(reach, flow)
  temp2 <- subset(outdata, outdata$RCH == rch)
  temp2$mdate <- as.Date(row(temp2)[, 1], origin = paste(start_year -
                                                           1, "-12-31", sep = ""))
  return(temp2)

}


