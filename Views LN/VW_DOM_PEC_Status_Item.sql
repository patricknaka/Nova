Select 
  1           CD_STATUS_ITEM, 
  'A'         NM_STATUS_ITEM, 
  'Aberto'    DS_STATUS_ITEM 
From Dual 

UNION 

Select 
  2           CD_STATUS_ITEM, 
  'L'         NM_STATUS_ITEM, 
  'Liquidado' DS_STATUS_ITEM 
From Dual

UNION 

Select 
  5           CD_STATUS_ITEM, 
  'C'         NM_STATUS_ITEM, 
  'Cancelado' DS_STATUS_ITEM 
From Dual