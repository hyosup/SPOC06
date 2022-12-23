@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ztest'
define root view entity ztest as select from ZSPOC06_OPEN_SO_LIST

{
  key SalesOrderNumber,
  key _Items.posnr,
  
  _Items.abgru
}
