@EndUserText.label: 'Projection Consum view - Open SO List'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZSPOC06_C_OPEN_SO_LIST 
as 
projection on ZSPOC06_OPEN_SO_LIST
{
    @Search.defaultSearchElement: true
    key SalesOrderNumber, 
        
    @ObjectModel.text.element: ['CustomerName']
    SoldToParty,
    
    OrderType,
    
    CreateDate,
    
    @Consumption: {
      valueHelpDefinition: [{entity: {name: 'I_SalesArea', element: 'SalesOrganization'},
      additionalBinding: [{element: 'DistributionChannel', localElement: 'DistChannel'},
                          {element: 'Division',            localElement: 'Division'}] }] }
    SalesOrganization,
    
    DistChannel,
    
    Division,
    
    SalesOffice,
    
    SalesGroup,
    
    RiskCategory,
    
    @Semantics.currencyCode: true
    DocCurrency,

    CreatedBy,
    
    @ObjectModel.text.element: ['CustomerName']
    CreditAcct,
    
    
    CreditArea,
    BusinessPartner,
    
    _Customer.CustomerName as CustomerName,
    
    _Status.RejectionStatus as RejectionStatus,
    _Status.StatusOfStatic as StatusOfStatic,
    _Status.DeliverStatus as DeliverStatus,
    
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CA_SOLIST_VIRTUAL'
    @Semantics.amount.currencyCode: 'DocCurrency'
    @EndUserText.label: 'Value (Inc. Tax)'
    virtual value : abap.curr(20,2),
    
    @EndUserText.label: 'Credit Currency'
    _CreditAmt.Credit_Limit_curky as Credit_Limit_curky,
    
    @EndUserText.label: 'Credit Limit'
    _CreditAmt.Credit_Limit as Credit_Limit,
    
    @EndUserText.label: 'Credit Exposure'
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CA_SOLIST_VIRTUAL'
    virtual Credit_Exposure : abap.curr(20,2),
    
    @EndUserText.label: 'Total Receivables'
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CA_SOLIST_VIRTUAL'
    virtual Tot_Receivable : abap.curr(20,2),
    
    @EndUserText.label: 'Open Order'
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CA_SOLIST_VIRTUAL'
    virtual Open_Order : abap.curr(20,2),
    
    @EndUserText.label: 'Open Delivery'
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CA_SOLIST_VIRTUAL'
    virtual Open_Delivery : abap.curr(20,2),
    
    
    _Items,       
    _Status,
    _CreditAmt
}
