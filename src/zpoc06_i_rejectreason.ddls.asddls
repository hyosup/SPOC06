@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reject Reason'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZPOC06_I_RejectReason as 
  select from tvagt 
{
    @EndUserText.label: '판매문서거부사유'
    @EndUserText.quickInfo: '판매문서거부사유'
    key abgru,
    @EndUserText.label: '언어키'
    @EndUserText.quickInfo: '언어키'
    key spras,
    
    @EndUserText.label: '내역'
    @EndUserText.quickInfo: '내역'
    bezei
    
}
