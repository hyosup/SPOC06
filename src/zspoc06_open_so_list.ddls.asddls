@AbapCatalog.sqlViewName: 'ZSPOC06_VBAK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view - Open Sales Order'

@Metadata.allowExtensions: true
//@ObjectModel.query.implementedBy: 'ABAP:ZCL_OPEN_SO_LIST_UQ'

define root view ZSPOC06_OPEN_SO_LIST
as 
select from vbak
    composition [1..*] of ZSPOC06_SO_ITEM   as _Items
    composition [1]    of ZSPOC06_SO_STATUS as _Status
    
    association [1]    to I_Customer              as _Customer     on  $projection.SoldToParty       = _Customer.Customer   
    association [1..*] to I_SalesOrganizationText as _SalesOrgText on  $projection.SalesOrganization = _SalesOrgText.SalesOrganization
    association [0..1] to ZSPOC06_CREDIT_AMOUNT   as _CreditAmt    on  $projection.SoldToParty       = _CreditAmt.BusinessPartner
                                                                   and $projection.CreditArea        = _CreditAmt.Credit_sgmnt                                                                           
{   
    @EndUserText.label: 'Sales Order Number'
    key vbak.vbeln as SalesOrderNumber,
    
    @ObjectModel.text.association: '_Customer'
    @EndUserText.label: 'Sold-to Party'
    kunnr as SoldToParty,
    
    @EndUserText.label: 'Order Type'        
    auart as OrderType,
    
    @EndUserText.label: 'Create Date'
    audat as CreateDate,
    
    @ObjectModel.text.association: '_SalesOrgText'
    @EndUserText.label: 'Sales Organization'
    vkorg as SalesOrganization,
    
    @EndUserText.label: 'Dustribution Channel'
    vtweg as DistChannel,
    
    @EndUserText.label: 'Division'
    spart as Division,
    
    @EndUserText.label: 'Sales Office'
    vkbur as SalesOffice,
    
    @EndUserText.label: 'Sales Group'
    vkgrp as SalesGroup,
    
    @EndUserText.label: 'Risk category'
    ctlpc as RiskCategory,
    
    @EndUserText.label: 'Doc. Currency'
    waerk as DocCurrency,
    
    @EndUserText.label: 'Created By'  
    ernam as CreatedBy,
   
    @EndUserText.label: 'Credit Account'
    knkli as CreditAcct,
    
    kkber as CreditArea,
    
    kunnr as BusinessPartner,  
    
    /* Association Expose*/
    _Items,       
    _Status,
    _Customer,
    _SalesOrgText,
    _CreditAmt
}

