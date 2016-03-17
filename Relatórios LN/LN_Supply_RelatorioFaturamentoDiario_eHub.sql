SELECT distinct                                                                                                                       
   601               CIA,                                                                                                    
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                                              
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_FATURA,                                   
                                                                                               
  znsls401.t$orno$c                               NR_ORDEM,                                     	
  znsls401.t$pecl$c                               NR_PEDIDO,                                   
  TO_CHAR(znsls401.t$entr$c)                      NR_ENTREGA,                                  
  znsls410.PT_CONTR                               PONTO_TRACKING,                         
  nvl(customizacao.custom,'Não')                  CUSTOMIZADO,                               
                                                                             
  (select t$itpe$c || ' - ' || b.t$dsca$c                                                                          
    from baandb.tznsls002601  b                                  
    where b.t$tpen$c = znsls401.t$itpe$c)         TIPO_ENTREGA,                             
                                                                                                     
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,                                             
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_PEDIDO,                           
                                                                             
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c,                                              
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_APROVACAO,                              
                                                                                           
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS.t$dtoc$c,                                           
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           
      AT time zone 'America/Sao_Paulo') AS DATE)  LIBERADO_WMS,                                
                                                                                          
  case                                                                                      
    when to_char (tdsls401.t$ddta, 'yyyy') = 1969 then null                               
    when to_char (tdsls401.t$ddta, 'yyyy') = 1970 then null                               
    else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls401.t$ddta,                                  
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
          AT time zone 'America/Sao_Paulo') AS DATE)                                                    
    end                                           DT_LIMITE_EXPED ,
    
    --Quando pedido tiver customização com entrega expressa: 2 dias 
    case when nvl(customizacao.custom,'Não') = 'Sim' then
      case when (select b.t$dsca$c from baandb.tznsls002601 b where b.t$tpen$c = znsls401.t$itpe$c) = 'Expressa' then
          (to_date(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
          AT time zone 'America/Sao_Paulo') AS DATE),'DD-MM-YYYY HH24:MI:SS') 
            + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
            AT time zone 'America/Sao_Paulo') AS DATE),'d') as number) WHEN 7 THEN 2 WHEN 1 THEN 1 ELSE 0 END)) 
              + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
              AT time zone 'America/Sao_Paulo') AS DATE),'d') as number) when 5 then 4 when 6 then 3 ELSE 2 END)
      else
      --Quando pedido tiver customização com entrega normal: 4 dias
          (to_date(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
          AT time zone 'America/Sao_Paulo') AS DATE),'DD-MM-YYYY HH24:MI:SS') 
            + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
            AT time zone 'America/Sao_Paulo') AS DATE),'d') as number)WHEN 7 THEN 2 WHEN 1 THEN 1 ELSE 0 END)) 
              + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
            AT time zone 'America/Sao_Paulo') AS DATE),'d') as number) WHEN 7 THEN 4 WHEN 1 THEN 4 WHEN 2 THEN 4 ELSE 6 END)
      end
    else 
    --sem customização: 1 dia
      (to_date(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
      AT time zone 'America/Sao_Paulo') AS DATE),'DD-MM-YYYY HH24:MI:SS') 
        + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
        AT time zone 'America/Sao_Paulo') AS DATE),'d') as number)WHEN 7 THEN 2 WHEN 1 THEN 1 ELSE 0 END)) 
          + (CASE cast(to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$pven$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                   
            AT time zone 'America/Sao_Paulo') AS DATE),'d') as number) WHEN 6 THEN 3 ELSE 1 END)
    end DATA_LIMITE_CONTRATUAL  
    
 from baandb.tcisli940601  cisli940            
                                                                                           
 inner join baandb.tcisli245601  cisli245      
         on cisli940.t$fire$l=cisli245.t$fire$l                                                 
                                                                             
 inner join baandb.ttdsls400601  tdsls400      
         on cisli245.t$slso = tdsls400.t$orno                                      
                                                                             
 inner join baandb.ttdsls401601  tdsls401              
         on tdsls400.t$orno = tdsls401.t$orno                                                                 
                                                                                      
 inner join baandb.tznsls401601  znsls401      
        on tdsls401.t$orno = znsls401.t$orno$c                               
       and tdsls401.t$pono = znsls401.t$pono$c                               
                                                                                     
 inner join baandb.tznsls400601  znsls400      
        on znsls401.t$pecl$c=znsls400.t$pecl$c                                     
       and znsls401.t$sqpd$c=znsls400.t$sqpd$c                               
                                                                             
 inner join baandb.tznsls402601  znsls402      
        on znsls402.t$ncia$c=znsls400.t$ncia$c                                     
       and znsls402.t$uneg$c=znsls400.t$uneg$c                               
       and znsls402.t$pecl$c=znsls400.t$pecl$c                                                               
       and znsls402.t$sqpd$c=znsls400.t$sqpd$c                                                               
                                                                                                            
 inner join (select znsls410.t$ncia$c,                                                                       
                    znsls410.t$uneg$c,                                                                       
                    znsls410.t$pecl$c,                                                                       
                    znsls410.t$sqpd$c,                                                                       
                    znsls410.t$poco$c  PT_CONTR                                                            
          from baandb.tznsls410601  znsls410    
          where znsls410.t$poco$c = 'NFS'                                                                     
          group by znsls410.t$ncia$c,                                                                            
                   znsls410.t$uneg$c,                                                                            
                   znsls410.t$pecl$c,                                                                            
                   znsls410.t$sqpd$c,                                                                           
                   znsls410.t$poco$c) znsls410                                                           
        ON znsls410.t$ncia$c = znsls402.t$ncia$c                                                          
       AND znsls410.t$uneg$c = znsls402.t$uneg$c                                                          
       AND znsls410.t$pecl$c = znsls402.t$pecl$c                                                           
       AND znsls410.t$sqpd$c = znsls402.t$sqpd$c                                                          
                                                                             
 left join (select znsls410.t$ncia$c,                                                                           
                    znsls410.t$uneg$c,                                                                            
                    znsls410.t$pecl$c,                                                                            
                    znsls410.t$sqpd$c,                                       
                    max(znsls410.t$dtoc$c) t$dtoc$c,                         
                    znsls410.t$poco$c  PT_CONTR                                                          
          from baandb.tznsls410601  znsls410   
          where znsls410.t$poco$c = 'WMS'                                                                   
          group by znsls410.t$ncia$c,                                                                          
                   znsls410.t$uneg$c,                                                                        
                   znsls410.t$pecl$c,                                                                             
                   znsls410.t$sqpd$c,                                                                             
                   znsls410.t$poco$c) WMS                                       
        ON WMS.t$ncia$c = znsls402.t$ncia$c                                                              
       AND WMS.t$uneg$c = znsls402.t$uneg$c                                                              
       AND WMS.t$pecl$c = znsls402.t$pecl$c                                                               
       AND WMS.t$sqpd$c = znsls402.t$sqpd$c                                  
                                                                             
 left join                                                                                                            
    (select distinct a.t$pecl$c, a.t$sqpd$c, 'Sim' as custom                                 
      from baandb.tznsls430601  a              
      where exists (select distinct b.t$pecl$c, b.t$sqpd$c                                     
                 from baandb.tznsls401601  b   
                 where a.t$pecl$c = b.t$pecl$c                                                           
                 and a.t$sqpd$c = b.t$sqpd$c)) customizacao                              
        on customizacao.t$pecl$c = znsls401.t$pecl$c                                               
       and customizacao.t$sqpd$c = znsls401.t$sqpd$c                                                
                                                                                              
 where trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                          
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           
      AT time zone 'America/Sao_Paulo') AS DATE))                                                    
      between :DataFat_De                                                                                         
          and :DataFat_Ate                                                                                
 AND znsls401.t$iitm$c =  'P'      --Produto                                                               
 AND cisli940.t$stat$l IN (5,6)    --Status Fatura: impresso e lançado               
 AND cisli940.t$nfes$l IN (1,2,5)  --Status Sefaz: nenhum,transmitida,processada     
 AND cisli940.t$fdty$l != 14       --14-Retorno Mercadoria Cliente               
 
 order by                                                                    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                                          
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                         
      AT time zone 'America/Sao_Paulo') AS DATE),                            
    znsls401.t$orno$c   