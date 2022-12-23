 @AbapCatalog.sqlViewName: 'ZSPOC06_VBAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view - Sales Order Item'
define view ZSPOC06_SO_ITEM as select 
       from vbap
       association to parent ZSPOC06_OPEN_SO_LIST as _parent
       on $projection.vbeln = _parent.SalesOrderNumber
       association [0..1] to ZPOC06_VH_RejectReason as _vh on $projection.abgru = _vh.Status
{   
    @EndUserText.label: 'Sales Oder Number'
    key vbap.vbeln,
    
    @UI:{
    lineItem:[{position:10, label: 'Sales Order Item'}],
    identification: [{position:10, label: 'Sales Oder Item'}]}
    @EndUserText.label: 'Sales Order Item'
    key vbap.posnr,
    
    @UI:{
    lineItem:[{position:20, label: 'Net Price'}],
    identification: [{position:20, label: 'Net Price'}]}
    @Semantics.amount.currencyCode: 'WAERK'
    @EndUserText.label: 'Net Price'
    vbap.cmpre,
    
    @Semantics.currencyCode: true
    @EndUserText.label: 'Doc. Curr'
    vbap.waerk,
    
    @UI:{
    lineItem:[{position:30, label: 'Qty.'}],
    identification: [{position:30, label: 'Qty.'}]}
    @Semantics.quantity.unitOfMeasure: 'VRKME'
    @EndUserText.label: 'Quantity in sales unit'
    vbap.kbmeng,
    
    @Semantics.unitOfMeasure: true
    @EndUserText.label: 'Unit'
    vbap.vrkme,
    
    @UI:{
    lineItem:[{position:40, label: 'Value (Inc. Tax)'}],
    identification: [{position:40, label: 'Value (Inc. Tax)'}]}
    @Semantics.amount.currencyCode: 'WAERK'
    @EndUserText.label: 'Value (Inc. Tax)'
    cast (kbmeng * cmpre as abap.curr( 20, 2 )) as multiple,
    
    vbap.abgru,
    _parent  ,
    _vh
}  
