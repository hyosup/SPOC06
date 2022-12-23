@EndUserText.label: 'test1'
@AccessControl.authorizationCheck: #CHECK
define root view entity zspoc06_projection_1 as 
  projection on ZSPOC06_OPEN_SO_LIST 
{
  @UI.facet: [
        {id: 'SOLIST',
         purpose: #HEADER,
         type: #IDENTIFICATION_REFERENCE,         
         position: 10,
         label: 'Sales Document'},
         
        {id: 'Items',
         purpose: #STANDARD,
         type: #IDENTIFICATION_REFERENCE,
         label: 'Itmes',
         targetElement: '_Items',
         position: 20},
        
        {id: 'Status',
         purpose: #STANDARD,
         type: #IDENTIFICATION_REFERENCE,
         label: 'Status',
         targetElement: '_Status',
         position: 30},
         
         {id: 'Credit',
         purpose: #STANDARD,
         type: #IDENTIFICATION_REFERENCE,
         label: 'Credit',
         targetElement: '_CreditAmt',
         position: 40}
    ]
    
  @UI: { 
    selectionField: [{
      position: 10
    }],
    identification: [{
      position: 10,
      type: #STANDARD,
      label: 'SO Number'
  //    dataAction: '',
    }],
    lineItem: [{
      position: 10,
//      type: #STANDARD,
      label: 'SO Number'
//      dataAction: '',
    }]
  }
  key SalesOrderNumber,
  
//  @ObjectModel.text.element: ['CustomerName']
    SoldToParty,
    
    OrderType,
    
    CreateDate,
    
//    @Consumption: {
//    //filter.mandatory: true,
//      valueHelpDefinition: [{entity: {name: 'I_SalesArea', element: 'SalesOrganization'},
//      additionalBinding: [{element: 'DistributionChannel', localElement: 'DistChannel'},
//                          {element: 'Division',            localElement: 'Division'}] }] }
    SalesOrganization,
    
    DistChannel,
    
    Division,
    
    SalesOffice,
    
    SalesGroup,
    
    RiskCategory,
    
    @Semantics.currencyCode: true
    DocCurrency,

    CreatedBy,
    
//    @ObjectModel.text.element: ['CustomerName']
    CreditAcct,
    
    
    CreditArea,
    BusinessPartner,
    
    _Customer.CustomerName as CustomerName,
    
    @UI: { 
    selectionField: [{
      position: 170
    }],
    identification: [{
      position: 170,
      type: #STANDARD,
      label: 'Rejection Status'
  //    dataAction: '',
    }],
    lineItem: [{
      position: 170,
//      type: #STANDARD,
      label: 'Rejection Status'
//      dataAction: '',
    }]
  }
    _Status.RejectionStatus as RejectionStatus,
    
    @UI: { 
    selectionField: [{
      position: 180
    }],
    identification: [{
      position: 180,
      type: #STANDARD,
      label: 'Status of Static'
  //    dataAction: '',
    }],
    lineItem: [{
      position: 180,
//      type: #STANDARD,
      label: 'Status of Static'
//      dataAction: '',
    }]
  }
    _Status.StatusOfStatic as StatusOfStatic,
    
    @UI: { 
    selectionField: [{
      position: 190
    }],
    identification: [{
      position: 190,
      type: #STANDARD,
      label: 'Delivery Status'
  //    dataAction: '',
    }],
    lineItem: [{
      position: 190,
//      type: #STANDARD,
      label: 'Delivery Status'
//      dataAction: '',
    }]
  }
    _Status.DeliverStatus as DeliverStatus,
    
//    @EndUserText.label: 'Value (Inc. Tax)'
//    virtual value : abap.curr(20,2),
    
    _Items,       
    _Status,
    _CreditAmt
}
