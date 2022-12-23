@AbapCatalog.sqlViewName: 'ZSPOC06_CREDIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit Amount'
define view ZSPOC06_CREDIT_AMOUNT as
select from I_BusinessPartnerCustomer as bupa left outer join ukmbp_cms_sgm as _CreditSeg  on   bupa.BusinessPartner   = _CreditSeg.partner  
                                              left outer join ukmcred_sgm0c as _CreditAmt  on  _CreditSeg.credit_sgmnt = _CreditAmt.credit_sgmnt 
                                              left outer join ukm_item      as _CreditItem on  _CreditSeg.partner      = _CreditItem.partner
                                                                                           and _CreditSeg.credit_sgmnt = _CreditItem.credit_sgmnt                                                                                                
{     
      @UI:{
      lineItem:[{position:10, label: 'Business Partner'}],
      identification: [{position:10, label: 'Business Partner'}]}
      @EndUserText.label: 'Business Partner'
      key bupa.BusinessPartner as BusinessPartner,
      
      @UI:{
      lineItem:[{position:20, label: 'Credit Segment'}],
      identification: [{position:20, label: 'Credit Segment'}]}
      @EndUserText.label: 'Credit Segment'
      key _CreditSeg.credit_sgmnt as Credit_sgmnt,
      
      @UI:{
      lineItem:[{position:30, label: 'Credit Category'}],
      identification: [{position:30, label: 'Credit Category'}]}
      @EndUserText.label: 'Credit Category'
      _CreditItem.comm_typ as Credit_category,
      
      @UI:{
      lineItem:[{position:40, label: 'Credit Limit'}],
      identification: [{position:40, label: 'Credit Limit'}]}
      @Semantics.amount.currencyCode: 'Credit_Limit_curky'
      @EndUserText.label: 'Credit Limit'
      _CreditSeg.credit_limit as Credit_Limit,
      
      @UI:{
      lineItem:[{position:50, label: 'Credit Item Amount'}],
      identification: [{position:50, label: 'Credit Item Amount'}]}
      @Semantics.amount.currencyCode: 'Credit_Item_amt_curky'
      @EndUserText.label: 'Credit Item Amount'
      sum( _CreditItem.amount ) as Credit_Item_amt,
            
      @Semantics.currencyCode: true      
      @EndUserText.label: 'Credit Limit Currency'
      _CreditAmt.currency as Credit_Limit_curky,
      
      @UI:{
      lineItem:[{position:60, label: 'Credit Item Currency'}],
      identification: [{position:60, label: 'Credit Item Currency'}]}
      @Semantics.currencyCode: true
      @EndUserText.label: 'Credit Item Currency'
      _CreditItem.currency as Credit_Item_amt_curky,
            
      @Semantics.amount.currencyCode: 'Credit_Limit_curky'
      @EndUserText.label: 'Total receivables'
      case ( _CreditItem.comm_typ )
        when '500' then sum( _CreditItem.amount )
        else cast( 0 as abap.dec( 15, 2 ) )
      end as TotalAmt,
            
      @Semantics.amount.currencyCode: 'Credit_Limit_curky'
      @EndUserText.label: 'Open orders'
      case ( _CreditItem.comm_typ )
        when '100' then sum( _CreditItem.amount )
        else cast( 0 as abap.dec( 15, 2 ) )
      end as OrdersAmt,
        
      @Semantics.amount.currencyCode: 'Credit_Limit_curky'
      @EndUserText.label: 'Open delivery'
      case ( _CreditItem.comm_typ )
        when '400' then sum( _CreditItem.amount )
        else cast( 0 as abap.dec( 15, 2 ) )
      end as DeliveryAmt
}
group by bupa.BusinessPartner, _CreditSeg.credit_sgmnt, _CreditItem.comm_typ,
         _CreditSeg.credit_limit, _CreditAmt.currency, _CreditItem.currency
