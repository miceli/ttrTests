\name{generateSample}
\Rdversion{1.7}
\alias{generateSample}
\title{
Generates a Bootstrap Sample from Price Data
}
\description{
Given a data set, this function returns a randomly generated data set
of the same size using a modified bootstrap procedure.  For now, standard
(i.i.d.) bootstrapping and Stationary (block) bootstrapping are
supported.  If random data is desired from other model distributions,
for example ARIMA or GARCH, a user defined function can be input.

Because it is assumed that we are using price data, this function
will compute the returns series, bootstrap that series, and exponentiate
and aggregate back to a price series.
}
\usage{
generateSample(x, model = "stationaryBootstrap", userParams = 4)
}
\arguments{
  \item{x}{
The data set (a univariate series)
}
  \item{model}{
Currently built in choices are "bootstrap" and "stationaryBootstrap".
 Also accepts a user defined function whose output is a series of 
 the same length as the input data.
}
  \item{userParams}{
Will be passed to the function 'model', in the case that 'model' is
 a user defined function.  Hence, a user defined function should take 
 two parameters, the data and a list of other needed inputs.
If "stationaryBootstrap" is used, userParams is the average block
 length from a geometric distribution, i.e. (1/lambda).
}
}
\details{
By design the bootstrapping procedure produces samples with the same
 statistical properties as the original data.  If a user defined
 function is used that generates samples with mis-matching
 statistical properties, these samples will not likely be useful.
}
\value{
sample - a univariate series the same length as the input series
}
\references{
B. Efron. Bootstrap methods: Another look at the jackknife. The Annals
of Statistics, 7(1):1-26, 1979.

Politis, Dimitris, and Joseph Romano, 1994, The stationary bootstrap, Journal of the American
Statistical Association 89, 1303-1313.
}
\author{
David St John
}
\note{
A USER DEFINED MODEL MUST HAVE THE FOLLOWING FORM:
function ( x , userParams )
Where x is the data, userParams is a numeric vector.
}
\examples{

data(spData)
mean(diff(log(spData)))
var(diff(log(spData)))
plot(spData)

sample <- generateSample(spData)
mean(diff(log(sample)))
var(diff(log(sample)))
plot(sample)

}
\keyword{ distribution }
