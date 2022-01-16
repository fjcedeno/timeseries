library(forecast)
library(dlm)
library(MLmetrics)

train<-head(Nile,-4)
test<-tail(Nile,4)

lambda <- BoxCox.lambda(train,lower=0)

train=BoxCox(train, lambda)





#mod<- auto.arima(train,allowdrift = FALSE, allowmean = FALSE,d=0,max.q = 0)

mod<-Arima(train,order = c(2,0,0),include.mean = FALSE,include.drift = TRUE)

nileBuild <- function(par) {
  dlmModARMA(ar = mod$coef, ma = NULL, dV=par[1],sigma2 =mod$sigma2 )
}
nileMLE <- dlmMLE(train, c(0.1), nileBuild)
nileMod <- nileBuild(nileMLE$par)

nileFilt <- dlmFilter(train, nileMod)
nileSmooth <- dlmSmooth(nileFilt)

timeSeries<-na.omit(cbind(train, nileFilt$m, nileSmooth$s,mod$fitted))


lwd=c(1,2,2,2)
col=c("black","red","blue","grey")
legend=c("Original","Kalman Filter ","Kalman smoother","ARIMA")

plot(timeSeries,
     plot.type='s',
     col=col, ylab="Level", main="Nile river", lwd=lwd)

legend("topright", legend =legend , col = col,lwd=lwd)
       

a=checkresiduals(mod)

Box.test (mod$residuals, lag = 10, type = "Ljung")

shapiro.test(mod$residuals)


InvBoxCox(, lambda, biasadj = FALSE, fvar = NULL)



predKF<-dlmForecast(nileFilt, nAhead = 4)$a

pred<-forecast::forecast(mod,h=4)$mean

MLmetrics::MAPE(pred, test)

MLmetrics::MAPE(predKF, test)

plot(cbind(predKF,pred,test))
