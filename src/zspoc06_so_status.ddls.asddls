@AbapCatalog.sqlViewName: 'ZSPOC_06_VBUK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_DEPENDENT
@EndUserText.label: 'Sales order status'
define view ZSPOC06_SO_STATUS as 
  select from vbuk
    association to parent ZSPOC06_OPEN_SO_LIST as _SoLIst
      on $projection.SalesOrder = _SoLIst.SalesOrderNumber
{
  @EndUserText.label: 'Sales Order Number'
  key vbeln as SalesOrder,
  
  @UI:{
    lineItem:[{position:10, label: 'Rejection status(all item)'}],
    identification: [{position:10, label: 'Rejection status(all item)'}]}
  @EndUserText.label: 'Rejection status(all item)'
  abstk as RejectionStatus,
     
  @UI:{
    lineItem:[{position:20, label: 'Status of Static check'}],
    identification: [{position:20, label: 'Status of Static check'}]}   
  @EndUserText.label: 'Status of Static check'
  cmpsa as StatusOfStatic,
  
  @UI:{
    lineItem:[{position:30, label: 'Delivery status'}],
    identification: [{position:30, label: 'Delivery status'}]}     
  @EndUserText.label: 'Delivery status'  
  lfstk as DeliverStatus,
  
  
  _SoLIst
  
}
