paramPersist <-
function(x,ttr="macd4",start=0,nSteps=0,stepSize=0,restrict=FALSE,bSamples=25,model="stationaryBootstrap",userParams=4,burn=0,short=FALSE,condition=NULL,silent=TRUE,TC=0.001,loud=TRUE,plot=TRUE,alpha=0.05,periods=2,file="",latex="")
{
then <- timeDate()
cvr <- subperiods(x,ttr=ttr,start=start,nSteps=nSteps,stepSize=stepSize,restrict=restrict,burn=burn,short=short,condition=condition,silent=silent,TC=TC,loud=loud,plot=plot,alpha=alpha,periods=periods,file=file,latex=latex)
## cv <- cvr[[1]]
rho <- cvr[[2]]
if(rho>0.5) {
cat("\n Null hypothesis has estimated probability zero for observed correlation",rho,">1/2.  Done\n")
0
}
else {
if(loud) cat("\nPreparing to Create",bSamples,"Bootstrapped Samples\n")
if(loud)
	{ 	now <- timeDate()
		rtime <- as.double(difftimeDate(now,then,unit="secs"))*bSamples
		days <- floor(rtime/(60*60*24))
		hours <- floor(rtime/(60*60)) - 24*days
		mins <- floor(rtime/60) - 24*60*days - 60*hours
		secs <- rtime - 24*60*60*days - 60*60*hours - 60*mins
		cat("Estimated Run Time:",days,"Days",hours,"Hours",mins,"Minutes",secs,"Seconds\n")
		cat("\n********************************************************************\n")
		cat("Completed: ")
		flush.console()
	}
## cvbs <- 0
rhobs <- 0

for(i in 1:bSamples)
{
	if(i>2) if( floor(10*i/bSamples) > floor(10*(i-1)/bSamples) ) {
		if(loud) cat(10*floor(10*i/bSamples),"% ")	
		flush.console() }
		

	nData <- generateSample(x=x,model=model,userParams=userParams)
	dum <- subperiods(x=nData,ttr=ttr,start=start,nSteps=nSteps,stepSize=stepSize,restrict=restrict,burn=burn,short=short,condition=condition,silent=TRUE,TC=TC,loud=FALSE,plot=FALSE,alpha=alpha,periods=periods,file="",latex="")
##	cvbs[i] <- dum[[1]]
	rhobs[i] <- dum[[2]]
}

if(loud) cat("\n********************************************************************\n")

##	mn <- mean(cvbs)
##	vr <- var(cvbs)

## 	rmn <- mean(rhobs)
##	vrr <- var(rhobs)

##	z <- (cv-mn)/sqrt(vr)
##	p <- ifelse(z>0,1-pt(z,df=bSamples),pt(z,df=bSamples))

	count <- sum( ifelse(rhobs > 2*rho,1,0) )
	pr <- count/bSamples

	sorted <- sort(2*rho - rhobs)

	iMin <- 1+floor(bSamples/100)
	iMax <- bSamples - iMin + 1
	quant1 <- sorted[iMin]
	quant99 <- sorted[iMax]

##	if(loud) cat("\nObserved z-value and p-score for covariance based on C-Hat =",cv,"\n")
##	if(loud) cat("z=",z,"p=",p,"\n")

##	if(loud) cat("\nMean correlation from Bootstrap =",rmn,"\n")
##	if(loud) cat("Standard Deviation =",sqrt(vrr),"for",length(rhobs),"observations\n")
##	ster <- sqrt(vrr/length(rhobs))
##	trh <- rmn/ster
##	prh <- ifelse(trh>0,1-pt(trh,df=bSamples),pt(trh,df=bSamples))

if(loud) cat("Observed Percentage:",pr,"\n")

## 	if(loud) cat("\nObserved t-value and p-score for observed correlation Rho-Hat =",rho,"\n")
## 	if(loud) cat("z=",zr,"p=",pr,"\n")

## 	if(loud) if(pr<alpha) cat("\nResults significant at level alpha=",alpha,"\n")
## 	if(loud) if(pr>=alpha) cat("\nResults not significant at level alpha=",alpha,"\n")


if(! latex=="")
		{
		cat("\n\\begin{table}[htp]\n",file=latex,append=TRUE)
		cat("\\centering\n",file=latex,append=TRUE)
		cat("\\begin{tabular}{ c c c c }\n",file=latex,append=TRUE)
		cat("1\\% quantile & 99\\% quantile & theta-hat & p-value \\\\ \\hline \n",file=latex,append=TRUE)
		cat(quant1," &",quant99," &",rho," &",pr," \\\\ \n",file=latex,append=TRUE)
		cat("\\end{tabular}\n",file=latex,append=TRUE)
		cat("\\caption{Bootstrapped Excess Returns from Model:",model,"}\n",file=latex,append=TRUE)
		cat("\\end{table}\n",file=latex,append=TRUE)
		if(loud) cat("\n Results written as latex figure to file:",latex,"\n")
	}
if(! file=="") {
	cat(rhobs,file=file,append=TRUE,sep="\n")
	if(loud) cat("\n bootstrapped correlations written to file:",file,"\n")
} 
list(rho,rhobs,pr)
}
}
