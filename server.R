
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
    colnames(t)=c("date","open","high","low","close","volume")
    rownames(t)=1:nrow(t)
    t[,2:ncol(t)] = round(t[,2:ncol(t)],2)
    return(t)
  })
  
  indicatorData = reactive({
    data = data()
    
    data$date = as.Date(data$date)
    data$close = as.numeric(data$close)
    data$open = as.numeric(data$open)
    data$high = as.numeric(data$high)
    data$low = as.numeric(data$low)
    data$volume = as.numeric(data$volume)
    hlc = data.frame(data$high,data$low,data$close)
    
    indicatorsSelected = indicators()
    print("inds")
    library("TTR")
    
    if('0' %in% indicatorsSelected){
      macd = MACD(x=data$close, nFast = 5, nSlow = 26, nSig = 20, percent = TRUE)
      data$macd = macd[,1]
    }
    stoch_14_3_3 = stoch(HLC=data$close, nFastK = 14, nFastD = 3, nSlowD = 3, bounded = TRUE,smooth = 1)
    if('1' %in% indicatorsSelected){
      data$stochfast = stoch_14_3_3[,1]*100
    }
    
    if('2' %in% indicatorsSelected){
      data$stochslow = stoch_14_3_3[,3]*100
    }
    if('3' %in% indicatorsSelected){
      stoch_volume = stoch(HLC=data$volume, nFastK = 14, nFastD = 3, nSlowD = 3, bounded = TRUE,smooth = 1)
      data$stoch_volume = stoch_volume[,1]*100
    }
    if('4' %in% indicatorsSelected){
      smi_13_2_25 = SMI(HLC=hlc, n = 13, nFast = 2, nSlow = 25, nSig = 9, bounded = TRUE,smooth = 1)
      data$smi = smi_13_2_25[,1]
    }
    if('5' %in% indicatorsSelected){
      rsi = RSI(data$close)
      data$rsi = rsi
    }
    adx = ADX(hlc)
    if('6' %in% indicatorsSelected){
      
      data$dmi_dx = adx[,3]
    }
    if('7' %in% indicatorsSelected){
      data$dmi_adx = adx[,4]
    }
    if('y' %in% indicatorsSelected){
      data = data[which(complete.cases(data)),]
    }
    
    output = data.frame(data[,1:2],data[,7:ncol(data)])
    
    #colnames(output)=c("date","close","macd","stochfast","stochslow","smi","stoch_volume","rsi","dmi_dx","dmi_adx")
    output[,3:ncol(output)]= round(output[,3:ncol(output)],2)
    return(output)
  })
  
  indicatorMetaData = reactive({
    inddata = indicatorData()
    metadata = data.frame(colnames(inddata))
    colnames(metadata)="column"
    metadata$max = 0
    metadata$min = 0
    
    for(i in 2:nrow(metadata)){
      metadata$max[i] = max(inddata[,i])
      
    }
    for(i in 2:nrow(metadata)){
      metadata$min[i] = min(inddata[,i])
      
    }
    for(i in 1:nrow(metadata)){
      metadata$datatype[i] = class(inddata[,i])
      
    }
    return(metadata)
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
  indicators = eventReactive(input$selectData,{
    return(input$indicatorsSelected)
  })
  output$stockDataTable = DT::renderDataTable({
    return(data())
  })
  output$stockIndicatorDataTable = DT::renderDataTable({
    out = indicatorData()
    #colnames(out)=c("Date","Close","macd","stochfast","stochslow","smi","stoch_vol","rsi","dmi","avg. dmi")
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
  output$downloadMetadata = downloadHandler(
    filename = function() {
      paste(selectionName(),"_marketdata_metadata", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(indicatorMetaData(), file, row.names = FALSE)
    }
  )
 

  output$debug=renderText({
    from=from()
    to = to()
    asset = selectionName()
    indsStr = paste(indicators(),collapse = ", ")
    print(class(indsStr))
    out = paste("Asset:",asset,"\nFrom:",from,"\nTo:",to,"\nIndicators Selected: ",indsStr)
    return(out)
  })
 
  output$showSelection<- renderText({

      return(selectionName())
    
    
  })

  
  
  
  
  
  
  
  
}