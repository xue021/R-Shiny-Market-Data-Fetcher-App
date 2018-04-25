
function(input, output) {
  
  data = reactive({
    library(quantmod)
    symbol = selectionName()
    source = "yahoo"
    dateFrom = from()
    dateTo = to()
    print(symbol)
    
    t = as.data.frame(getSymbols(symbol,src=source,auto.assign=FALSE,from=dateFrom,to=dateTo))
    t$Date = rownames(t)
    t = t[,c(7,1:5)]
    colnames(t)=c("Date","Open","High","Low","Close","Volume")
    rownames(t)=1:nrow(t)
    return(t)
  })
  indicatorData = reactive({
    data = data()
    
    
    data$Date = as.Date(data$Date)
    data$Close = as.numeric(data$Close)
    data$High = as.numeric(data$High)
    data$Low = as.numeric(data$Low)
    data$Volume = as.numeric(data$Volume)
    hlc = data.frame(data$High,data$Low,data$Close)
    
    library("TTR")
    data$sma10 = SMA(x = data$Close,n=10)
    data$sma20 = SMA(x = data$Close,n=20)
    
    macd = MACD(x=data$Close, nFast = 5, nSlow = 26, nSig = 20, percent = TRUE)
    data$macd = macd[,1]
    
    
    
    stoch_14_3_3 = stoch(HLC=data$Close, nFastK = 14, nFastD = 3, nSlowD = 3, bounded = TRUE,smooth = 1)
    data$stochfast = stoch_14_3_3[,1]*100
    data$stochslow = stoch_14_3_3[,3]*100
    
    smi_13_2_25 = SMI(HLC=hlc, n = 13, nFast = 2, nSlow = 25, nSig = 9, bounded = TRUE,smooth = 1)
    data$smi = smi_13_2_25[,1]
    
    stoch_volume = stoch(HLC=data$Volume, nFastK = 14, nFastD = 3, nSlowD = 3, bounded = TRUE,smooth = 1)
    data$stoch_volume = stoch_volume[,1]*100
    
    rsi = RSI(data$Close)
    data$rsi = rsi
    
    adx = ADX(hlc)
    data$adx_DX = adx[,3]
    data$adx_ADX = adx[,4]
    
    output = data.frame(data$Date,data$Close,data[,9:16])
    output = output[which(complete.cases(output)),]
    colnames(output)=c("Date","Close","macd","stochfast","stochslow","smi","stoch_volume","rsi","adx_DX","adx_ADX")
    output[,3:ncol(output)]= round(output[,3:ncol(output)],2)
    return(output)
  })
  selectionName = eventReactive(input$selectData,{
    return(input$symInput)
  })
  
  from = eventReactive(input$selectData,{
    return(input$dateFrom)
  })
  to = eventReactive(input$selectData,{
    return(input$dateTo)
  })
  
  output$stockDataTable = DT::renderDataTable({
    return(data())
  })
  output$stockIndicatorDataTable = DT::renderDataTable({
    out = indicatorData()
    colnames(out)=c("Date","Close","macd","stochfast","stochslow","smi","stoch_vol","rsi","dmi","avg. dmi")
    return(out)
  })
  
  output$downloadRaw = downloadHandler(
    filename = function() {
      paste(selectionName(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
  output$downloadIndicator = downloadHandler(
    filename = function() {
      paste(selectionName(),"_marketdata", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(indicatorData(), file, row.names = FALSE)
    }
  )
 

  output$daterange=renderText({
    from=from()
    to = to()
    asset = selectionName()
    out = paste("Asset:",asset,"\nFrom:",from,"\nTo:",to)
    return(out)
  })
 
  output$showSelection<- renderText({

      return(selectionName())
    
    
  })

  
  
  
  
  
  
  
  
}