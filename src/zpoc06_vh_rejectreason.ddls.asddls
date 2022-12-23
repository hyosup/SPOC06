@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reject Reason Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}


@VDM: {
  viewType: #CONSUMPTION
}


define view entity ZPOC06_VH_RejectReason as 
  select from ZPOC06_I_RejectReason 
{
      @EndUserText.label: '판매문서거부코드'
      @EndUserText.quickInfo: '판매문서거부코드'
      @UI: { lineItem: [{position:10}],
             identification: [{position:10}],
             selectionField: [{position:10}]}
  key abgru as Status,

      @EndUserText.label: '판매문서거부사유'
      @EndUserText.quickInfo: '판매문서거부사유'
      @UI: { lineItem: [{position:20}],
             identification: [{position:20}],
             selectionField: [{position:20}]}
      bezei as StatusDesc
}
where spras = $session.system_language
