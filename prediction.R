library(forecast)
library(dlm)
library(MLmetrics)

train<-head(log(Nile),-4)
test<-tail(log(Nile),4)





mod<-Arima(train,order = c(2,0,0),include.mean = FALSE,include.drift = FALSE)

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






predKF<-dlmForecast(nileFilt, nAhead = 4)$a

pred<-forecast::forecast(mod,h=4)$mean

MLmetrics::MAPE(pred, test)

MLmetrics::MAPE(predKF, test)

plot(cbind(predKF,pred,test))
