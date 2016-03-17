
 select Q1.DATA_EMISSAO,   
        Q1.FILIAL,   
        Q1.ENTREGA,   
        Q1.CONTRATO,   
        Q1.DESCR_CONTRATO,   
        Q1.NOTA,   
        Q1.SERIE,   
        max(Q1.PESO) PESO,   
        sum(Q1.VOLUME_M3) VOLUME_M3,   
        sum(Q1.VOLUME_CUBICO) VOLUME_CUBICO,   
        Q1.VLR_TOTAL_NF,   
        Q1.VLR_FRETE_CLIENTE,   
        Q1.ALIQUOTA,   
        Q1.CNPJ_TRANS,   
        Q1.APELIDO,   
        Q1.ID_CONHECIMENTO,   
        Q1.ID_NR,   
        Q1.DATA_DEV_EMISS_NR,   
        Q1.CPF_DESTINATARIO,   
        Q1.CEP,   
        Q1.MUNICIPIO,   
        Q1.UF,   
        Q1.REGIAO,   
        Q1.ID_OCORRENCIA,   
        Q1.DATA_OCORRENCIA,   
        Q1.TIPO_DOCUMENTO_FIS,   
        Q1.DESCR_TIPO_DOC_FIS,   
        Q1.TIPO_NF,   
        Q1.CODE_TIPO_DOC,   
        Q1.DESCR_TIPO_DOC,   
        Q1.CFO_ENTREGA,   
        DESC_CFO_ENTREGA,   
   
        Q1.VLR_ICMS,   
        sum(Q1.PESO_VOLUME)              FRETE_TOTAL,   
        DESC_CFO_ENTREGA,   
        Q1.ETIQUETA,   
        Q1.MARCA   
   
 from ( SELECT   
          DISTINCT   
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,   
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
               AT time zone 'America/Sao_Paulo') AS DATE)   
                                           DATA_EMISSAO,   
            znfmd630.t$fili$c              FILIAL,   
            znfmd630.t$pecl$c              ENTREGA,   
            znfmd630.t$cono$c              CONTRATO,   
            znfmd060.t$cdes$c              DESCR_CONTRATO,   
            znfmd630.t$docn$c              NOTA,   
            znfmd630.t$seri$c              SERIE,   
            znfmd610.t$wght$c              PESO,   
            znfmd610.t$pcub$c              VOLUME_M3,   
            znfmd630.t$etiq$c              ETIQUETA,   
   
            nvl( ( select sum(wmd.t$hght   *   
                              wmd.t$wdth   *   
                              wmd.t$dpth   *   
                              sli.t$dqua$l )   
                     from baandb.tcisli941601  sli,   
                          baandb.twhwmd400601  wmd   
                    where sli.t$fire$l = cisli940.t$fire$l   
                      and wmd.t$item = sli.t$item$l), 0 )   
                                           VOLUME_CUBICO,   
   
            cisli940.t$amnt$l              VLR_TOTAL_NF,   
            znfmd630.t$vlfr$c              VLR_FRETE_CLIENTE,   
   
            cisli943.t$rate$l              ALIQUOTA,   
            cisli943.t$amnt$l              VLR_ICMS,   
   
            znfmd630.t$vlfc$c              PESO_VOLUME,   
            znfmd068.t$adva$c *   
            ( cisli940.t$amnt$l / 100 )    AD_VALOREM,   
            znfmd068.t$peda$c              PEDAGIO,   
            NVL(znfmd660.valor_adic,0)     ADICIONAIS,   
            TCCOM130T.T$FOVN$L             CNPJ_TRANS,   
            tcmcs080.t$seak                APELIDO,   
            znfmd630.t$ncte$c              ID_CONHECIMENTO,   
            cisli940.t$fire$l              ID_NR,   
   
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
                AT time zone 'America/Sao_Paulo') AS DATE)   
                                           DATA_DEV_EMISS_NR,   
   
            tccom130.t$fovn$l              CPF_DESTINATARIO,   
            tccom130.t$pstc                CEP,   
            tccom130.t$dsca                MUNICIPIO,   
            tccom130.t$cste                UF,   
   
            ( select znfmd061.t$dzon$c   
                from baandb.tznfmd062601  znfmd062,   
                     baandb.tznfmd061601  znfmd061   
               where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c   
                 and znfmd062.t$cono$c = znfmd630.t$cono$c   
                 and znfmd062.t$cepd$c <= tccom130.t$pstc   
                 and znfmd062.t$cepa$c >= tccom130.t$pstc   
                 and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c   
                 and znfmd061.t$cono$c = znfmd062.t$cono$c   
                 and znfmd061.t$creg$c = znfmd062.t$creg$c   
                 and rownum = 1 )          REGIAO,   
   
            ( select max(znfmd640.t$coci$c)   
                from BAANDB.tznfmd640601  znfmd640   
               where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c)   
                                             from BAANDB.tznfmd640601  znfmd640b   
                                            where znfmd640b.t$fili$c = znfmd640.t$fili$c   
                                              and znfmd640b.t$etiq$c = znfmd640.t$etiq$c )   
                 and znfmd640.t$fili$c = znfmd630.t$fili$c   
                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )   
                                           ID_OCORRENCIA,   
   
            ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c),   
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
                        AT time zone 'America/Sao_Paulo') AS DATE)   
                from baandb.tznfmd640601  znfmd640   
               where znfmd640.t$fili$c = znfmd630.t$fili$c   
                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )   
                                           DATA_OCORRENCIA,   
   
            cisli940.t$fdty$l              TIPO_DOCUMENTO_FIS,   
            TIPO_DOC_FIS.                  DESCR_TIPO_DOC_FIS,   
   
            CASE WHEN cisli940.t$fdty$l = 14   
                   THEN 'NFE'   
                 ELSE   'NFS'   
             END AS                        TIPO_NF,   
   
            cisli940.t$doty$l              CODE_TIPO_DOC,   
            TIPO_DOC.                      DESCR_TIPO_DOC,   
            cisli940.t$ccfo$l              CFO_ENTREGA,   
            tcmcs940.t$dsca$l              DESC_CFO_ENTREGA,   
            NVL(tcmcs031.t$dsca,                      
             'Pedido Interno')             MARCA   
   
       FROM BAANDB.tznfmd630601  znfmd630   
   
 INNER JOIN BAANDB.tznfmd610601  znfmd610   
         ON znfmd610.t$cfrw$c = znfmd630.t$cfrw$c   
        AND znfmd610.t$fili$c = znfmd630.t$fili$c   
        AND znfmd610.t$ngai$c = znfmd630.t$ngai$c   
        AND znfmd610.t$etiq$c = znfmd630.t$etiq$c   
   
 INNER JOIN BAANDB.tcisli942601  cisli943   
         ON cisli943.t$fire$l = znfmd630.t$fire$c   
        AND cisli943.t$brty$l = 1   
   
 INNER JOIN BAANDB.ttcmcs080601  tcmcs080   
         ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c   
   
 INNER JOIN BAANDB.TTCCOM130601  TCCOM130T   
         ON TCCOM130T.T$CADR = TCMCS080.T$CADR$L   
   
  LEFT JOIN BAANDB.tcisli940601  cisli940   
         ON cisli940.t$fire$l = znfmd630.t$fire$c   
   
 INNER JOIN baandb.ttcmcs031301  tcmcs031  
         ON tcmcs031.t$cbrn =  cisli940.t$cbrn$c  
   
  LEFT JOIN BAANDB.tznfmd060601  znfmd060   
         ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c   
        AND znfmd060.t$cono$c = znfmd630.t$cono$c   
   
  LEFT JOIN ( select a.t$adva$c,   
                     a.t$peda$c,   
                     a.t$cfrw$c,   
                     a.t$cono$c,   
                     max(a.t$nlis$c) t$nlis$c   
                from baandb.tznfmd068601  a   
               where a.t$ativ$c = 1   
            group by a.t$cfrw$c,   
                     a.t$cono$c,   
                     a.t$adva$c,   
                     a.t$peda$c ) znfmd068   
         ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c   
        AND znfmd068.t$cono$c = znfmd630.t$cono$c   
   
  LEFT JOIN BAANDB.ttcmcs940601  tcmcs940   
         ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l   
   
  LEFT JOIN BAANDB.ttccom130601  tccom130   
         ON tccom130.t$cadr = cisli940.t$stoa$l   
   
  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC_FIS,   
                     d.t$cnst   
                from baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               where d.t$cpac = 'ci'   
                 and d.t$cdom = 'sli.tdff.l'   
                 and l.t$clan = 'p'   
                 and l.t$cpac = 'ci'   
                 and l.t$clab = d.t$za_clab   
                 and rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4) )   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 and rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                 rpad(l1.t$rele,2) ||   
                                                 rpad(l1.t$cust,4) )   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FIS   
         ON TIPO_DOC_FIS.t$cnst = cisli940.t$fdty$l   
   
  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC,   
                     d.t$cnst   
                from baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               where d.t$cpac = 'tc'   
                 and d.t$cdom = 'doty.l'   
                 and l.t$clan = 'p'   
                 and l.t$cpac = 'tc'   
                 and l.t$clab = d.t$za_clab   
                 and rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4) )   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 and rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                 rpad(l1.t$rele,2) ||   
                                                 rpad(l1.t$cust,4) )   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC   
      ON TIPO_DOC.t$cnst = cisli940.t$doty$l   
   
  LEFT JOIN ( select a.t$cfrw$c,   
                     a.t$cono$c,   
                     a.t$fili$c,   
                     a.t$ngai$c,   
                     a.t$etiq$c,   
                     sum(a.t$vafr$c) valor_adic   
                from baandb.tznfmd660601  a   
            group by a.t$cfrw$c,   
                     a.t$cono$c,   
                     a.t$fili$c,   
                     a.t$ngai$c,   
                     a.t$etiq$c ) znfmd660   
         ON ZNFMD660.t$cfrw$c = ZNFMD630.t$cfrw$c   
        AND ZNFMD660.t$cono$c = ZNFMD630.t$cono$c   
        AND ZNFMD660.t$fili$c = ZNFMD630.t$fili$c   
        AND ZNFMD660.t$ngai$c = ZNFMD630.t$ngai$c   
        AND ZNFMD660.t$etiq$c = ZNFMD630.t$etiq$c   
   
 WHERE ( select max(znfmd640.t$coci$c)   
           from BAANDB.tznfmd640601  znfmd640   
          where znfmd640.t$coci$c IN ('ETR', 'COL','CTR', 'POS')   
            and znfmd640.t$fili$c = znfmd630.t$fili$c   
            and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) IS NOT NULL )  Q1   
   
 WHERE Q1.TIPO_NF IN (:TipoNF)   
   AND TRUNC(Q1.DATA_EMISSAO)   
      Between :DataDe   
          And :DataAte   
   AND ( (regexp_replace(Q1.CNPJ_TRANS, '[^0-9]', '')  like '%' || Trim(:CNPJ)  || '%' ) OR (Trim(:CNPJ) is null) )   
   
 GROUP BY Q1.DATA_EMISSAO,   
          Q1.FILIAL,   
          Q1.ENTREGA,   
          Q1.CONTRATO,   
          Q1.DESCR_CONTRATO,   
          Q1.NOTA,   
          Q1.SERIE,   
          Q1.VLR_TOTAL_NF,   
          Q1.VLR_FRETE_CLIENTE,   
          Q1.ALIQUOTA,   
          Q1.VLR_ICMS,   
          Q1.CNPJ_TRANS,   
          Q1.APELIDO,   
          Q1.ID_CONHECIMENTO,   
          Q1.ID_NR,   
          Q1.DATA_DEV_EMISS_NR,   
          Q1.CPF_DESTINATARIO,   
          Q1.CEP,   
          Q1.MUNICIPIO,   
          Q1.UF,   
          Q1.REGIAO,   
          Q1.ID_OCORRENCIA,   
          Q1.DATA_OCORRENCIA,   
          Q1.TIPO_DOCUMENTO_FIS,   
          Q1.DESCR_TIPO_DOC_FIS,   
          Q1.TIPO_NF,   
          Q1.CODE_TIPO_DOC,   
          Q1.DESCR_TIPO_DOC,   
          Q1.CFO_ENTREGA,   
          Q1.DESC_CFO_ENTREGA,   
          Q1.ETIQUETA,   
          Q1.MARCA    
  
	ORDER BY Q1.DATA_EMISSAO, 
			 Q1.ENTREGA 



--view com parâmetros

=IIF(Parameters!Table.Value <> 1,

" select Q1.DATA_EMISSAO,  " &
"        Q1.FILIAL,  " &
"        Q1.ENTREGA,  " &
"        Q1.CONTRATO,  " &
"        Q1.DESCR_CONTRATO,  " &
"        Q1.NOTA,  " &
"        Q1.SERIE,  " &
"        max(Q1.PESO) PESO,  " &
"        sum(Q1.VOLUME_M3) VOLUME_M3,  " &
"        sum(Q1.VOLUME_CUBICO) VOLUME_CUBICO,  " &
"        Q1.VLR_TOTAL_NF,  " &
"        Q1.VLR_FRETE_CLIENTE,  " &
"        Q1.ALIQUOTA,  " &
"        Q1.CNPJ_TRANS,  " &
"        Q1.APELIDO,  " &
"        Q1.ID_CONHECIMENTO,  " &
"        Q1.ID_NR,  " &
"        Q1.DATA_DEV_EMISS_NR,  " &
"        Q1.CPF_DESTINATARIO,  " &
"        Q1.CEP,  " &
"        Q1.MUNICIPIO,  " &
"        Q1.UF,  " &
"        Q1.REGIAO,  " &
"        Q1.ID_OCORRENCIA,  " &
"        Q1.DATA_OCORRENCIA,  " &
"        Q1.TIPO_DOCUMENTO_FIS,  " &
"        Q1.DESCR_TIPO_DOC_FIS,  " &
"        Q1.TIPO_NF,  " &
"        Q1.CODE_TIPO_DOC,  " &
"        Q1.DESCR_TIPO_DOC,  " &
"        Q1.CFO_ENTREGA,  " &
"        DESC_CFO_ENTREGA,  " &
"  " &
"        Q1.VLR_ICMS,  " &
"        sum(Q1.PESO_VOLUME)              FRETE_TOTAL,  " &
"        DESC_CFO_ENTREGA,  " &
"        Q1.ETIQUETA,  " &
"        Q1.MARCA  " &
"  " &
" from ( SELECT  " &
"          DISTINCT  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"               AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_EMISSAO,  " &
"            znfmd630.t$fili$c              FILIAL,  " &
"            znfmd630.t$pecl$c              ENTREGA,  " &
"            znfmd630.t$cono$c              CONTRATO,  " &
"            znfmd060.t$cdes$c              DESCR_CONTRATO,  " &
"            znfmd630.t$docn$c              NOTA,  " &
"            znfmd630.t$seri$c              SERIE,  " &
"            znfmd610.t$wght$c              PESO,  " &
"            znfmd610.t$pcub$c              VOLUME_M3,  " &
"            znfmd630.t$etiq$c              ETIQUETA,  " &
"  " &
"            nvl( ( select sum(wmd.t$hght   *  " &
"                              wmd.t$wdth   *  " &
"                              wmd.t$dpth   *  " &
"                              sli.t$dqua$l )  " &
"                     from baandb.tcisli941" + Parameters!Table.Value + " sli,  " &
"                          baandb.twhwmd400" + Parameters!Table.Value + " wmd  " &
"                    where sli.t$fire$l = cisli940.t$fire$l  " &
"                      and wmd.t$item = sli.t$item$l), 0 )  " &
"                                           VOLUME_CUBICO,  " &
"  " &
"            cisli940.t$amnt$l              VLR_TOTAL_NF,  " &
"            znfmd630.t$vlfr$c              VLR_FRETE_CLIENTE,  " &
"  " &
"            cisli943.t$rate$l              ALIQUOTA,  " &
"            cisli943.t$amnt$l              VLR_ICMS,  " &
"  " &
"            znfmd630.t$vlfc$c              PESO_VOLUME,  " &
"            znfmd068.t$adva$c *  " &
"            ( cisli940.t$amnt$l / 100 )    AD_VALOREM,  " &
"            znfmd068.t$peda$c              PEDAGIO,  " &
"            NVL(znfmd660.valor_adic,0)     ADICIONAIS,  " &
"            TCCOM130T.T$FOVN$L             CNPJ_TRANS,  " &
"            tcmcs080.t$seak                APELIDO,  " &
"            znfmd630.t$ncte$c              ID_CONHECIMENTO,  " &
"            cisli940.t$fire$l              ID_NR,  " &
"  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_DEV_EMISS_NR,  " &
"  " &
"            tccom130.t$fovn$l              CPF_DESTINATARIO,  " &
"            tccom130.t$pstc                CEP,  " &
"            tccom130.t$dsca                MUNICIPIO,  " &
"            tccom130.t$cste                UF,  " &
"  " &
"            ( select znfmd061.t$dzon$c  " &
"                from baandb.tznfmd062" + Parameters!Table.Value + " znfmd062,  " &
"                     baandb.tznfmd061" + Parameters!Table.Value + " znfmd061  " &
"               where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"                 and znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"                 and znfmd062.t$cepd$c <= tccom130.t$pstc  " &
"                 and znfmd062.t$cepa$c >= tccom130.t$pstc  " &
"                 and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c  " &
"                 and znfmd061.t$cono$c = znfmd062.t$cono$c  " &
"                 and znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"                 and rownum = 1 )          REGIAO,  " &
"  " &
"            ( select max(znfmd640.t$coci$c)  " &
"                from BAANDB.tznfmd640" + Parameters!Table.Value + " znfmd640  " &
"               where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c)  " &
"                                             from BAANDB.tznfmd640" + Parameters!Table.Value + " znfmd640b  " &
"                                            where znfmd640b.t$fili$c = znfmd640.t$fili$c  " &
"                                              and znfmd640b.t$etiq$c = znfmd640.t$etiq$c )  " &
"                 and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           ID_OCORRENCIA,  " &
"  " &
"            ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                from baandb.tznfmd640" + Parameters!Table.Value + " znfmd640  " &
"               where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           DATA_OCORRENCIA,  " &
"  " &
"            cisli940.t$fdty$l              TIPO_DOCUMENTO_FIS,  " &
"            TIPO_DOC_FIS.                  DESCR_TIPO_DOC_FIS,  " &
"  " &
"            CASE WHEN cisli940.t$fdty$l = 14  " &
"                   THEN 'NFE'  " &
"                 ELSE   'NFS'  " &
"             END AS                        TIPO_NF,  " &
"  " &
"            cisli940.t$doty$l              CODE_TIPO_DOC,  " &
"            TIPO_DOC.                      DESCR_TIPO_DOC,  " &
"            cisli940.t$ccfo$l              CFO_ENTREGA,  " &
"            tcmcs940.t$dsca$l              DESC_CFO_ENTREGA,  " &
"            NVL(tcmcs031.t$dsca,                  " &   
"             'Pedido Interno')             MARCA  " &
"  " &
"       FROM BAANDB.tznfmd630" + Parameters!Table.Value + " znfmd630  " &
"  " &
" INNER JOIN BAANDB.tznfmd610" + Parameters!Table.Value + " znfmd610  " &
"         ON znfmd610.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd610.t$fili$c = znfmd630.t$fili$c  " &
"        AND znfmd610.t$ngai$c = znfmd630.t$ngai$c  " &
"        AND znfmd610.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
" INNER JOIN BAANDB.tcisli942" + Parameters!Table.Value + " cisli943  " &
"         ON cisli943.t$fire$l = znfmd630.t$fire$c  " &
"        AND cisli943.t$brty$l = 1  " &
"  " &
" INNER JOIN BAANDB.ttcmcs080" + Parameters!Table.Value + " tcmcs080  " &
"         ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
" INNER JOIN BAANDB.TTCCOM130" + Parameters!Table.Value + " TCCOM130T  " &
"         ON TCCOM130T.T$CADR = TCMCS080.T$CADR$L  " &
"  " &
"  LEFT JOIN BAANDB.tcisli940" + Parameters!Table.Value + " cisli940  " &
"         ON cisli940.t$fire$l = znfmd630.t$fire$c  " &
"  " &
" INNER JOIN baandb.ttcmcs031301  tcmcs031 " &
"         ON tcmcs031.t$cbrn =  cisli940.t$cbrn$c " &
"  " &
"  LEFT JOIN BAANDB.tznfmd060" + Parameters!Table.Value + " znfmd060  " &
"         ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd060.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN ( select a.t$adva$c,  " &
"                     a.t$peda$c,  " &
"                     a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     max(a.t$nlis$c) t$nlis$c  " &
"                from baandb.tznfmd068" + Parameters!Table.Value + " a  " &
"               where a.t$ativ$c = 1  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$adva$c,  " &
"                     a.t$peda$c ) znfmd068  " &
"         ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd068.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN BAANDB.ttcmcs940" + Parameters!Table.Value + " tcmcs940  " &
"         ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l  " &
"  " &
"  LEFT JOIN BAANDB.ttccom130" + Parameters!Table.Value + " tccom130  " &
"         ON tccom130.t$cadr = cisli940.t$stoa$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC_FIS,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'ci'  " &
"                 and d.t$cdom = 'sli.tdff.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'ci'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FIS  " &
"         ON TIPO_DOC_FIS.t$cnst = cisli940.t$fdty$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'tc'  " &
"                 and d.t$cdom = 'doty.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'tc'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC  " &
"      ON TIPO_DOC.t$cnst = cisli940.t$doty$l  " &
"  " &
"  LEFT JOIN ( select a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c,  " &
"                     sum(a.t$vafr$c) valor_adic  " &
"                from baandb.tznfmd660" + Parameters!Table.Value + " a  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c ) znfmd660  " &
"         ON ZNFMD660.t$cfrw$c = ZNFMD630.t$cfrw$c  " &
"        AND ZNFMD660.t$cono$c = ZNFMD630.t$cono$c  " &
"        AND ZNFMD660.t$fili$c = ZNFMD630.t$fili$c  " &
"        AND ZNFMD660.t$ngai$c = ZNFMD630.t$ngai$c  " &
"        AND ZNFMD660.t$etiq$c = ZNFMD630.t$etiq$c  " &
"  " &
" WHERE ( select max(znfmd640.t$coci$c)  " &
"           from BAANDB.tznfmd640" + Parameters!Table.Value + " znfmd640  " &
"          where znfmd640.t$coci$c IN ('ETR', 'COL','CTR', 'POS')  " &
"            and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"            and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) IS NOT NULL )  Q1  " &
"  " &
" WHERE Q1.TIPO_NF IN (:TipoNF)  " &
"   AND TRUNC(Q1.DATA_EMISSAO)  " &
"      Between :DataDe  " &
"          And :DataAte  " &
"   AND ( (regexp_replace(Q1.CNPJ_TRANS, '[^0-9]', '')  like '%' || Trim(:CNPJ)  || '%' ) OR (Trim(:CNPJ) is null) )  " &
"  " &
" GROUP BY Q1.DATA_EMISSAO,  " &
"          Q1.FILIAL,  " &
"          Q1.ENTREGA,  " &
"          Q1.CONTRATO,  " &
"          Q1.DESCR_CONTRATO,  " &
"          Q1.NOTA,  " &
"          Q1.SERIE,  " &
"          Q1.VLR_TOTAL_NF,  " &
"          Q1.VLR_FRETE_CLIENTE,  " &
"          Q1.ALIQUOTA,  " &
"          Q1.VLR_ICMS,  " &
"          Q1.CNPJ_TRANS,  " &
"          Q1.APELIDO,  " &
"          Q1.ID_CONHECIMENTO,  " &
"          Q1.ID_NR,  " &
"          Q1.DATA_DEV_EMISS_NR,  " &
"          Q1.CPF_DESTINATARIO,  " &
"          Q1.CEP,  " &
"          Q1.MUNICIPIO,  " &
"          Q1.UF,  " &
"          Q1.REGIAO,  " &
"          Q1.ID_OCORRENCIA,  " &
"          Q1.DATA_OCORRENCIA,  " &
"          Q1.TIPO_DOCUMENTO_FIS,  " &
"          Q1.DESCR_TIPO_DOC_FIS,  " &
"          Q1.TIPO_NF,  " &
"          Q1.CODE_TIPO_DOC,  " &
"          Q1.DESCR_TIPO_DOC,  " &
"          Q1.CFO_ENTREGA,  " &
"          Q1.DESC_CFO_ENTREGA,  " &
"          Q1.ETIQUETA,  " &
"          Q1.MARCA   " &
"  "&
"	ORDER BY Q1.DATA_EMISSAO, "&
"			 Q1.ENTREGA "

,

" select Q1.DATA_EMISSAO,  " &
"        Q1.FILIAL,  " &
"        Q1.ENTREGA,  " &
"        Q1.CONTRATO,  " &
"        Q1.DESCR_CONTRATO,  " &
"        Q1.NOTA,  " &
"        Q1.SERIE,  " &
"        max(Q1.PESO) PESO,  " &
"        sum(Q1.VOLUME_M3) VOLUME_M3,  " &
"        sum(Q1.VOLUME_CUBICO) VOLUME_CUBICO,  " &
"        Q1.VLR_TOTAL_NF,  " &
"        Q1.VLR_FRETE_CLIENTE,  " &
"        Q1.ALIQUOTA,  " &
"        Q1.CNPJ_TRANS,  " &
"        Q1.APELIDO,  " &
"        Q1.ID_CONHECIMENTO,  " &
"        Q1.ID_NR,  " &
"        Q1.DATA_DEV_EMISS_NR,  " &
"        Q1.CPF_DESTINATARIO,  " &
"        Q1.CEP,  " &
"        Q1.MUNICIPIO,  " &
"        Q1.UF,  " &
"        Q1.REGIAO,  " &
"        Q1.ID_OCORRENCIA,  " &
"        Q1.DATA_OCORRENCIA,  " &
"        Q1.TIPO_DOCUMENTO_FIS,  " &
"        Q1.DESCR_TIPO_DOC_FIS,  " &
"        Q1.TIPO_NF,  " &
"        Q1.CODE_TIPO_DOC,  " &
"        Q1.DESCR_TIPO_DOC,  " &
"        Q1.CFO_ENTREGA,  " &
"        DESC_CFO_ENTREGA,  " &
"  " &
"        Q1.VLR_ICMS,  " &
"        sum(Q1.PESO_VOLUME)              FRETE_TOTAL,  " &
"        Q1.ETIQUETA,  " &
"        Q1.MARCA  " &
"  " &
" from ( SELECT  " &
"          DISTINCT  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"               AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_EMISSAO,  " &
"            znfmd630.t$fili$c              FILIAL,  " &
"            znfmd630.t$pecl$c              ENTREGA,  " &
"            znfmd630.t$cono$c              CONTRATO,  " &
"            znfmd060.t$cdes$c              DESCR_CONTRATO,  " &
"            znfmd630.t$docn$c              NOTA,  " &
"            znfmd630.t$seri$c              SERIE,  " &
"            znfmd610.t$wght$c              PESO,  " &
"            znfmd610.t$pcub$c              VOLUME_M3,  " &
"            znfmd630.t$etiq$c              ETIQUETA,  " &
"  " &
"            nvl( ( select sum(wmd.t$hght   *  " &
"                              wmd.t$wdth   *  " &
"                              wmd.t$dpth   *  " &
"                              sli.t$dqua$l )  " &
"                     from baandb.tcisli941601 sli,  " &
"                          baandb.twhwmd400601 wmd  " &
"                    where sli.t$fire$l = cisli940.t$fire$l  " &
"                      and wmd.t$item = sli.t$item$l), 0 )  " &
"                                           VOLUME_CUBICO,  " &
"  " &
"            cisli940.t$amnt$l              VLR_TOTAL_NF,  " &
"            znfmd630.t$vlfr$c              VLR_FRETE_CLIENTE,  " &
"  " &
"            cisli943.t$rate$l              ALIQUOTA,  " &
"            cisli943.t$amnt$l              VLR_ICMS,  " &
"  " &
"            znfmd630.t$vlfc$c              PESO_VOLUME,  " &
"            znfmd068.t$adva$c *  " &
"            ( cisli940.t$amnt$l / 100 )    AD_VALOREM,  " &
"            znfmd068.t$peda$c              PEDAGIO,  " &
"            NVL(znfmd660.valor_adic,0)     ADICIONAIS,  " &
"            TCCOM130T.T$FOVN$L             CNPJ_TRANS,  " &
"            tcmcs080.t$seak                APELIDO,  " &
"            znfmd630.t$ncte$c              ID_CONHECIMENTO,  " &
"            cisli940.t$fire$l              ID_NR,  " &
"  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_DEV_EMISS_NR,  " &
"  " &
"            tccom130.t$fovn$l              CPF_DESTINATARIO,  " &
"            tccom130.t$pstc                CEP,  " &
"            tccom130.t$dsca                MUNICIPIO,  " &
"            tccom130.t$cste                UF,  " &
"  " &
"            ( select znfmd061.t$dzon$c  " &
"                from baandb.tznfmd062601 znfmd062,  " &
"                     baandb.tznfmd061601 znfmd061  " &
"               where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"                 and znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"                 and znfmd062.t$cepd$c <= tccom130.t$pstc  " &
"                 and znfmd062.t$cepa$c >= tccom130.t$pstc  " &
"                 and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c  " &
"                 and znfmd061.t$cono$c = znfmd062.t$cono$c  " &
"                 and znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"                 and rownum = 1 )          REGIAO,  " &
"  " &
"            ( select max(znfmd640.t$coci$c)  " &
"                from BAANDB.tznfmd640601 znfmd640  " &
"               where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c)  " &
"                                             from BAANDB.tznfmd640601 znfmd640b  " &
"                                            where znfmd640b.t$fili$c = znfmd640.t$fili$c  " &
"                                              and znfmd640b.t$etiq$c = znfmd640.t$etiq$c )  " &
"                 and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           ID_OCORRENCIA,  " &
"  " &
"            ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                from baandb.tznfmd640601 znfmd640  " &
"               where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           DATA_OCORRENCIA,  " &
"  " &
"            cisli940.t$fdty$l              TIPO_DOCUMENTO_FIS,  " &
"            TIPO_DOC_FIS.                  DESCR_TIPO_DOC_FIS,  " &
"  " &
"            CASE WHEN cisli940.t$fdty$l = 14  " &
"                   THEN 'NFE'  " &
"                 ELSE   'NFS'  " &
"             END AS                        TIPO_NF,  " &
"  " &
"            cisli940.t$doty$l              CODE_TIPO_DOC,  " &
"            TIPO_DOC.                      DESCR_TIPO_DOC,  " &
"            cisli940.t$ccfo$l              CFO_ENTREGA,  " &
"            tcmcs940.t$dsca$l              DESC_CFO_ENTREGA,  " &
"            NVL(tcmcs031.t$dsca,                  " &   
"               'Pedido Interno')           MARCA " &
"  " &
"       FROM BAANDB.tznfmd630601 znfmd630  " &
"  " &
" INNER JOIN BAANDB.tznfmd610601 znfmd610  " &
"         ON znfmd610.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd610.t$fili$c = znfmd630.t$fili$c  " &
"        AND znfmd610.t$ngai$c = znfmd630.t$ngai$c  " &
"        AND znfmd610.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
" INNER JOIN BAANDB.tcisli942601 cisli943  " &
"         ON cisli943.t$fire$l = znfmd630.t$fire$c  " &
"        AND cisli943.t$brty$l = 1  " &
"  " &
" INNER JOIN BAANDB.ttcmcs080601 tcmcs080  " &
"         ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
" INNER JOIN BAANDB.TTCCOM130601 TCCOM130T  " &
"         ON TCCOM130T.T$CADR = TCMCS080.T$CADR$L  " &
"  " &
"  LEFT JOIN BAANDB.tcisli940601 cisli940  " &
"         ON cisli940.t$fire$l = znfmd630.t$fire$c  " &
"  " &
" INNER JOIN baandb.ttcmcs031301  tcmcs031 " &
"         ON tcmcs031.t$cbrn =  cisli940.t$cbrn$c " &
"  " &
"  LEFT JOIN BAANDB.tznfmd060601 znfmd060  " &
"         ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd060.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN ( select a.t$adva$c,  " &
"                     a.t$peda$c,  " &
"                     a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     max(a.t$nlis$c) t$nlis$c  " &
"                from baandb.tznfmd068601 a  " &
"               where a.t$ativ$c = 1  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$adva$c,  " &
"                     a.t$peda$c ) znfmd068  " &
"         ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd068.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN BAANDB.ttcmcs940601 tcmcs940  " &
"         ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l  " &
"  " &
"  LEFT JOIN BAANDB.ttccom130601 tccom130  " &
"         ON tccom130.t$cadr = cisli940.t$stoa$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC_FIS,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'ci'  " &
"                 and d.t$cdom = 'sli.tdff.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'ci'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FIS  " &
"         ON TIPO_DOC_FIS.t$cnst = cisli940.t$fdty$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'tc'  " &
"                 and d.t$cdom = 'doty.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'tc'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC  " &
"      ON TIPO_DOC.t$cnst = cisli940.t$doty$l  " &
"  " &
"  LEFT JOIN ( select a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c,  " &
"                     sum(a.t$vafr$c) valor_adic  " &
"                from baandb.tznfmd660601 a  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c ) znfmd660  " &
"         ON ZNFMD660.t$cfrw$c = ZNFMD630.t$cfrw$c  " &
"        AND ZNFMD660.t$cono$c = ZNFMD630.t$cono$c  " &
"        AND ZNFMD660.t$fili$c = ZNFMD630.t$fili$c  " &
"        AND ZNFMD660.t$ngai$c = ZNFMD630.t$ngai$c  " &
"        AND ZNFMD660.t$etiq$c = ZNFMD630.t$etiq$c  " &
"  " &
" WHERE ( select max(znfmd640.t$coci$c)  " &
"           from BAANDB.tznfmd640601 znfmd640  " &
"          where znfmd640.t$coci$c IN ('ETR', 'COL','CTR', 'POS')  " &
"            and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"            and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) IS NOT NULL )  Q1  " &
"  " &
" WHERE Q1.TIPO_NF IN (:TipoNF)  " &
"   AND TRUNC(Q1.DATA_EMISSAO)  " &
"      Between :DataDe  " &
"          And :DataAte  " &
"   AND ( (regexp_replace(Q1.CNPJ_TRANS, '[^0-9]', '')  like '%' || Trim(:CNPJ)  || '%' ) OR (Trim(:CNPJ) is null) )  " &
"  " &
" GROUP BY Q1.DATA_EMISSAO,  " &
"          Q1.FILIAL,  " &
"          Q1.ENTREGA,  " &
"          Q1.CONTRATO,  " &
"          Q1.DESCR_CONTRATO,  " &
"          Q1.NOTA,  " &
"          Q1.SERIE,  " &
"          Q1.VLR_TOTAL_NF,  " &
"          Q1.VLR_FRETE_CLIENTE,  " &
"          Q1.ALIQUOTA,  " &
"          Q1.VLR_ICMS,  " &
"          Q1.CNPJ_TRANS,  " &
"          Q1.APELIDO,  " &
"          Q1.ID_CONHECIMENTO,  " &
"          Q1.ID_NR,  " &
"          Q1.DATA_DEV_EMISS_NR,  " &
"          Q1.CPF_DESTINATARIO,  " &
"          Q1.CEP,  " &
"          Q1.MUNICIPIO,  " &
"          Q1.UF,  " &
"          Q1.REGIAO,  " &
"          Q1.ID_OCORRENCIA,  " &
"          Q1.DATA_OCORRENCIA,  " &
"          Q1.TIPO_DOCUMENTO_FIS,  " &
"          Q1.DESCR_TIPO_DOC_FIS,  " &
"          Q1.TIPO_NF,  " &
"          Q1.CODE_TIPO_DOC,  " &
"          Q1.DESCR_TIPO_DOC,  " &
"          Q1.CFO_ENTREGA,  " &
"          Q1.DESC_CFO_ENTREGA,  " &
"          Q1.ETIQUETA,  " &
"          Q1.MARCA      " &
"  " &
"Union  " &
"  " &
" select Q1.DATA_EMISSAO,  " &
"        Q1.FILIAL,  " &
"        Q1.ENTREGA,  " &
"        Q1.CONTRATO,  " &
"        Q1.DESCR_CONTRATO,  " &
"        Q1.NOTA,  " &
"        Q1.SERIE,  " &
"        max(Q1.PESO) PESO,  " &
"        sum(Q1.VOLUME_M3) VOLUME_M3,  " &
"        sum(Q1.VOLUME_CUBICO) VOLUME_CUBICO,  " &
"        Q1.VLR_TOTAL_NF,  " &
"        Q1.VLR_FRETE_CLIENTE,  " &
"        Q1.ALIQUOTA,  " &
"        Q1.CNPJ_TRANS,  " &
"        Q1.APELIDO,  " &
"        Q1.ID_CONHECIMENTO,  " &
"        Q1.ID_NR,  " &
"        Q1.DATA_DEV_EMISS_NR,  " &
"        Q1.CPF_DESTINATARIO,  " &
"        Q1.CEP,  " &
"        Q1.MUNICIPIO,  " &
"        Q1.UF,  " &
"        Q1.REGIAO,  " &
"        Q1.ID_OCORRENCIA,  " &
"        Q1.DATA_OCORRENCIA,  " &
"        Q1.TIPO_DOCUMENTO_FIS,  " &
"        Q1.DESCR_TIPO_DOC_FIS,  " &
"        Q1.TIPO_NF,  " &
"        Q1.CODE_TIPO_DOC,  " &
"        Q1.DESCR_TIPO_DOC,  " &
"        Q1.CFO_ENTREGA,  " &
"        DESC_CFO_ENTREGA,  " &
"  " &
"        Q1.VLR_ICMS,  " &
"        sum(Q1.PESO_VOLUME)              FRETE_TOTAL,  " &
"        Q1.ETIQUETA,  " &
"        Q1.MARCA      " &
"  " &
" from ( SELECT  " &
"          DISTINCT  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"               AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_EMISSAO,  " &
"            znfmd630.t$fili$c              FILIAL,  " &
"            znfmd630.t$pecl$c              ENTREGA,  " &
"            znfmd630.t$cono$c              CONTRATO,  " &
"            znfmd060.t$cdes$c              DESCR_CONTRATO,  " &
"            znfmd630.t$docn$c              NOTA,  " &
"            znfmd630.t$seri$c              SERIE,  " &
"            znfmd610.t$wght$c              PESO,  " &
"            znfmd610.t$pcub$c              VOLUME_M3,  " &
"            znfmd630.t$etiq$c              ETIQUETA,  " &
"  " &
"            nvl( ( select sum(wmd.t$hght   *  " &
"                              wmd.t$wdth   *  " &
"                              wmd.t$dpth   *  " &
"                              sli.t$dqua$l )  " &
"                     from baandb.tcisli941602 sli,  " &
"                          baandb.twhwmd400602 wmd  " &
"                    where sli.t$fire$l = cisli940.t$fire$l  " &
"                      and wmd.t$item = sli.t$item$l), 0 )  " &
"                                           VOLUME_CUBICO,  " &
"  " &
"            cisli940.t$amnt$l              VLR_TOTAL_NF,  " &
"            znfmd630.t$vlfr$c              VLR_FRETE_CLIENTE,  " &
"  " &
"            cisli943.t$rate$l              ALIQUOTA,  " &
"            cisli943.t$amnt$l              VLR_ICMS,  " &
"  " &
"            znfmd630.t$vlfc$c              PESO_VOLUME,  " &
"            znfmd068.t$adva$c *  " &
"            ( cisli940.t$amnt$l / 100 )    AD_VALOREM,  " &
"            znfmd068.t$peda$c              PEDAGIO,  " &
"            NVL(znfmd660.valor_adic,0)     ADICIONAIS,  " &
"            TCCOM130T.T$FOVN$L             CNPJ_TRANS,  " &
"            tcmcs080.t$seak                APELIDO,  " &
"            znfmd630.t$ncte$c              ID_CONHECIMENTO,  " &
"            cisli940.t$fire$l              ID_NR,  " &
"  " &
"            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                           DATA_DEV_EMISS_NR,  " &
"  " &
"            tccom130.t$fovn$l              CPF_DESTINATARIO,  " &
"            tccom130.t$pstc                CEP,  " &
"            tccom130.t$dsca                MUNICIPIO,  " &
"            tccom130.t$cste                UF,  " &
"  " &
"            ( select znfmd061.t$dzon$c  " &
"                from baandb.tznfmd062602 znfmd062,  " &
"                     baandb.tznfmd061602 znfmd061  " &
"               where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"                 and znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"                 and znfmd062.t$cepd$c <= tccom130.t$pstc  " &
"                 and znfmd062.t$cepa$c >= tccom130.t$pstc  " &
"                 and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c  " &
"                 and znfmd061.t$cono$c = znfmd062.t$cono$c  " &
"                 and znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"                 and rownum = 1 )          REGIAO,  " &
"  " &
"            ( select max(znfmd640.t$coci$c)  " &
"                from BAANDB.tznfmd640602 znfmd640  " &
"               where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c)  " &
"                                             from BAANDB.tznfmd640602 znfmd640b  " &
"                                            where znfmd640b.t$fili$c = znfmd640.t$fili$c  " &
"                                              and znfmd640b.t$etiq$c = znfmd640.t$etiq$c )  " &
"                 and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           ID_OCORRENCIA,  " &
"  " &
"            ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                from baandb.tznfmd640602 znfmd640  " &
"               where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"                 and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                           DATA_OCORRENCIA,  " &
"  " &
"            cisli940.t$fdty$l              TIPO_DOCUMENTO_FIS,  " &
"            TIPO_DOC_FIS.                  DESCR_TIPO_DOC_FIS,  " &
"  " &
"            CASE WHEN cisli940.t$fdty$l = 14  " &
"                   THEN 'NFE'  " &
"                 ELSE   'NFS'  " &
"             END AS                        TIPO_NF,  " &
"  " &
"            cisli940.t$doty$l              CODE_TIPO_DOC,  " &
"            TIPO_DOC.                      DESCR_TIPO_DOC,  " &
"            cisli940.t$ccfo$l              CFO_ENTREGA,  " &
"            tcmcs940.t$dsca$l              DESC_CFO_ENTREGA,  " &
"            NVL(tcmcs031.t$dsca,                    " &  
"              'Pedido Interno')            MARCA   " &
"  " &
"       FROM BAANDB.tznfmd630602 znfmd630  " &
"  " &
" INNER JOIN BAANDB.tznfmd610602 znfmd610  " &
"         ON znfmd610.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd610.t$fili$c = znfmd630.t$fili$c  " &
"        AND znfmd610.t$ngai$c = znfmd630.t$ngai$c  " &
"        AND znfmd610.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
" INNER JOIN BAANDB.tcisli942602 cisli943  " &
"         ON cisli943.t$fire$l = znfmd630.t$fire$c  " &
"        AND cisli943.t$brty$l = 1  " &
"  " &
" INNER JOIN BAANDB.ttcmcs080602 tcmcs080  " &
"         ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
" INNER JOIN BAANDB.TTCCOM130602 TCCOM130T  " &
"         ON TCCOM130T.T$CADR = TCMCS080.T$CADR$L  " &
"  " &
"  LEFT JOIN BAANDB.tcisli940602 cisli940  " &
"         ON cisli940.t$fire$l = znfmd630.t$fire$c  " &
"  " &
" INNER JOIN baandb.ttcmcs031301  tcmcs031 " &
"         ON tcmcs031.t$cbrn =  cisli940.t$cbrn$c " &
"  " &
"  LEFT JOIN BAANDB.tznfmd060602 znfmd060  " &
"         ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd060.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN ( select a.t$adva$c,  " &
"                     a.t$peda$c,  " &
"                     a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     max(a.t$nlis$c) t$nlis$c  " &
"                from baandb.tznfmd068602 a  " &
"               where a.t$ativ$c = 1  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$adva$c,  " &
"                     a.t$peda$c ) znfmd068  " &
"         ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd068.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"  LEFT JOIN BAANDB.ttcmcs940602 tcmcs940  " &
"         ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l  " &
"  " &
"  LEFT JOIN BAANDB.ttccom130602 tccom130  " &
"         ON tccom130.t$cadr = cisli940.t$stoa$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC_FIS,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'ci'  " &
"                 and d.t$cdom = 'sli.tdff.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'ci'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FIS  " &
"         ON TIPO_DOC_FIS.t$cnst = cisli940.t$fdty$l  " &
"  " &
"  LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'tc'  " &
"                 and d.t$cdom = 'doty.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'tc'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                 rpad(l1.t$rele,2) ||  " &
"                                                 rpad(l1.t$cust,4) )  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_DOC  " &
"      ON TIPO_DOC.t$cnst = cisli940.t$doty$l  " &
"  " &
"  LEFT JOIN ( select a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c,  " &
"                     sum(a.t$vafr$c) valor_adic  " &
"                from baandb.tznfmd660602 a  " &
"            group by a.t$cfrw$c,  " &
"                     a.t$cono$c,  " &
"                     a.t$fili$c,  " &
"                     a.t$ngai$c,  " &
"                     a.t$etiq$c ) znfmd660  " &
"         ON ZNFMD660.t$cfrw$c = ZNFMD630.t$cfrw$c  " &
"        AND ZNFMD660.t$cono$c = ZNFMD630.t$cono$c  " &
"        AND ZNFMD660.t$fili$c = ZNFMD630.t$fili$c  " &
"        AND ZNFMD660.t$ngai$c = ZNFMD630.t$ngai$c  " &
"        AND ZNFMD660.t$etiq$c = ZNFMD630.t$etiq$c  " &
"  " &
" WHERE ( select max(znfmd640.t$coci$c)  " &
"           from BAANDB.tznfmd640602 znfmd640  " &
"          where znfmd640.t$coci$c IN ('ETR', 'COL','CTR', 'POS')  " &
"            and znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"            and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) IS NOT NULL )  Q1  " &
"  " &
" WHERE Q1.TIPO_NF IN (:TipoNF)  " &
"   AND TRUNC(Q1.DATA_EMISSAO)  " &
"      Between :DataDe  " &
"          And :DataAte  " &
"   AND ( (regexp_replace(Q1.CNPJ_TRANS, '[^0-9]', '')  like '%' || Trim(:CNPJ)  || '%' ) OR (Trim(:CNPJ) is null) )  " &
"  " &
" GROUP BY Q1.DATA_EMISSAO,  " &
"          Q1.FILIAL,  " &
"          Q1.ENTREGA,  " &
"          Q1.CONTRATO,  " &
"          Q1.DESCR_CONTRATO,  " &
"          Q1.NOTA,  " &
"          Q1.SERIE,  " &
"          Q1.VLR_TOTAL_NF,  " &
"          Q1.VLR_FRETE_CLIENTE,  " &
"          Q1.ALIQUOTA,  " &
"          Q1.VLR_ICMS,  " &
"          Q1.CNPJ_TRANS,  " &
"          Q1.APELIDO,  " &
"          Q1.ID_CONHECIMENTO,  " &
"          Q1.ID_NR,  " &
"          Q1.DATA_DEV_EMISS_NR,  " &
"          Q1.CPF_DESTINATARIO,  " &
"          Q1.CEP,  " &
"          Q1.MUNICIPIO,  " &
"          Q1.UF,  " &
"          Q1.REGIAO,  " &
"          Q1.ID_OCORRENCIA,  " &
"          Q1.DATA_OCORRENCIA,  " &
"          Q1.TIPO_DOCUMENTO_FIS,  " &
"          Q1.DESCR_TIPO_DOC_FIS,  " &
"          Q1.TIPO_NF,  " &
"          Q1.CODE_TIPO_DOC,  " &
"          Q1.DESCR_TIPO_DOC,  " &
"          Q1.CFO_ENTREGA,  " &
"          Q1.DESC_CFO_ENTREGA,  " &
"          Q1.ETIQUETA,  " &
"          Q1.MARCA  " &
"	ORDER BY 1, 3 "

)