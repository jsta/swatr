% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runSWAT2012.R
\name{runSWAT2012}
\alias{runSWAT2012}
\title{This runs the SWAT2012 executable in the current directory.}
\usage{
runSWAT2012(simdir = ".", hist_wx = NULL, elev = 100, rch = 3)
}
\arguments{
\item{simdir}{file.path}

\item{hist_wx}{Describe \code{hist_wx}}

\item{elev}{Describe \code{elev}}

\item{rch}{Describe \code{rch}}
}
\description{
This function runs the SWAT2012 executable in the current directory.
}
\examples{
\dontrun{
setwd("test")
test <- runSWAT2012(file.path(getwd(), ""))
}
}
\author{
Daniel R. Fuka
}
