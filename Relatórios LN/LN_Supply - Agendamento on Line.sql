SELECT 
      '@'||znpsc014.t$nage$c      NR_AGENDAMENTO,
      znpsc014.t$cwoc$c           FILIAL,
      tcmcs065.t$dsca             DESC_FILIAL,
      znpsc014.t$doca$c           DOCA,
      znpsc014.t$ftyp$c           TIPO_IDENT_FISCAL,
      znpsc014.t$fovn$c           CNPJ_FORNECEDOR,
      tccom130.t$nama             RAZAO_SOCIAL,
      znpsc014.t$docn$c           NOTA_FISCAL,
      znpsc014.t$seri$c           SERIE_NF,
      '@'||znpsc013.t$pswd$c      SENHA,
      znpsc013.t$qcar$c           QTDE_CARROS,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znpsc013.t$data$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                  DATA_AGENDAMENTO,
      STATUS.DSC                  STATUS_AGENDAMENTO,
      znpsc014.t$line$c           LINHA_AGENDAMENTO,
      tcmcs023.t$dsca             DEPARTAMENTO,
      case when znpsc013.t$envi$c = 1 then
            'Sim' 
      else  'Não' end             ENVIADO_FORNECEDOR,
      znpsc014.t$orno$c           ORDEM_COMPRA,
      znpsc014.t$cean$c           EAN,
      trim(znpsc014.t$item$c)     ITEM,
      tcibd001.t$dscb$c           DESCRICAO,
      znpsc014.t$qtde$c           QTDE_AGENDADO,
      znpsc014.t$pric$c           PRECO_UNITARIO,
      tdpur400.t$cotp             COD_TIPO_ORDEM_COMPRA,
      tdpur094.t$dsca             TIPO_ORDEM_COMPRA,
      znpsc014.t$bpid$c           PARCEIRO,
      znpsc014.t$pono$c           LINHA_ORDEM_COMPRA,
      znpsc013.t$arqu$c           NOME_ARQUIVO,
      znpsc013.t$agru$c           AGRUPADOR,
      znpsc012.t$seqn$c           SEQUENCIAL,
      TIPO_ALT.DSC                TIPO_ALTERACAO,
      znpsc012.t$datl$c           DATA_ATUALIZACAO,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znpsc012.t$dtlg$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)                                  
                                  DATA_LOG,
      znpsc012.t$logn$c           LOGIN,
      ( select a.t$name
          from   baandb.tttaad200000 a
          where  a.t$user = znpsc012.t$logn$c )      
                                  NOME,
      znpsc012.t$flch$c           CAMPO_ALTERADO,
      znpsc012.t$vlra$c           VALOR_ANTIGO,
      znpsc012.t$nvlr$c           NOVO_VALOR
      
FROM baandb.tznpsc014201 znpsc014

  INNER JOIN baandb.tznpsc013201 znpsc013
          ON znpsc013.t$nage$c = znpsc014.t$nage$c
  
  LEFT JOIN baandb.tznpsc012201 znpsc012
         ON znpsc012.t$nage$c = znpsc014.t$nage$c
        AND znpsc012.t$line$c = znpsc014.t$line$c
--        AND znpsc012.t$tpch$c = 10                  --Inclusao
        
  LEFT JOIN baandb.ttcibd001201 tcibd001
          ON tcibd001.t$item = znpsc014.t$item$c
          
  LEFT JOIN baandb.ttcmcs023201 tcmcs023
         ON tcmcs023.t$citg = tcibd001.t$citg
         
  LEFT JOIN baandb.ttdpur400201 tdpur400
         ON tdpur400.t$orno = znpsc014.t$orno$c
         
  LEFT JOIN baandb.ttdpur094201 tdpur094
         ON tdpur094.t$potp = tdpur400.t$cotp
 
  LEFT JOIN baandb.ttccom130201 tccom130
         ON tccom130.t$cadr = znpsc014.t$cadr$c
         
  LEFT JOIN ( select l.t$desc DSC,   
                     d.t$cnst COD   
                from baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               where d.t$cpac = 'zn'   
                 and d.t$cdom = 'nfe.stpr.c'   
                 and l.t$clan = 'p'   
                 and l.t$cpac = 'zn'   
                 and l.t$clab = d.t$za_clab   
                 and rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 and rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac ) ) STATUS
         ON STATUS.COD = znpsc013.t$stat$c           

  LEFT JOIN baandb.ttcmcs065201 tcmcs065
         ON tcmcs065.t$cwoc = znpsc014.t$cwoc$c

  LEFT JOIN ( select l.t$desc DSC,   
                     d.t$cnst COD   
                from baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               where d.t$cpac = 'zn'   
                 and d.t$cdom = 'psc.tpch.c'   
                 and l.t$clan = 'p'   
                 and l.t$cpac = 'zn'   
                 and l.t$clab = d.t$za_clab   
                 and rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 and rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac ) ) TIPO_ALT
         ON TIPO_ALT.COD = znpsc012.t$tpch$c           
         
WHERE   trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znpsc013.t$data$c,
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) 
        between :data_de and :data_ate
  AND ((:senha Is Null) OR (znpsc013.t$pswd$c like '%' || Trim(:senha) || '%'))
  AND STATUS.COD in (:status)
  AND tcibd001.t$citg in (:depto)
  AND znpsc014.t$cwoc$c in (:filial)
  AND ((:cnpj Is Null) OR (znpsc014.t$fovn$c like '%' || Trim(:cnpj) || '%'))
  AND ((:cod_pn Is Null) OR (znpsc014.t$bpid$c like '%' || Trim(:cod_pn) || '%'))
