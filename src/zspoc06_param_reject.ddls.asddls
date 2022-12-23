@EndUserText.label: 'Input Parameter Reject All'
define abstract entity ZSPOC06_PARAM_REJECT 
{   
    @EndUserText.label: 'Pricing Date'
    pricingdate : prsdt;  
    
    @EndUserText.label: 'Reason for Rejection'
    @EndUserText.quickInfo: '거절사유'    
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPOC06_VH_RejectReason', element: 'Status'}  }]
    rejectreason : abgru;
}
