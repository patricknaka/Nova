SELECT
  CISLI940.T$DOCN$L         NF,
  CISLI940.T$SERI$L         SERIE,
  ZNFMD001.T$FILI$C         ID_FILIAL,
  ZNFMD001.T$DSCA$C         DESCR_FILIAL,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE) 
                            DATA_GER,
  TCCOM130F.T$FOVN$L        CNPJ,
  CISLI940.T$ITBN$L         FORNECEDOR,
  CISLI940.T$CCFO$L         CFOP,
  CISLI940.T$OPOR$L         SEQ_CFOP,
  STATUS.DESCR              STATUS,
  CISLI941.T$LINE$L         LINHA_NF,  -- CAMPO ADICIONADO POIS PODE ACOTECER DE EXISTIR MAIS DE UMA LINHA COM O MESMO ITEM
  Trim(CISLI941.T$ITEM$L)   ID_ITEM,
  CISLI941.T$DESC$L         DESCR_ITEM,
  CISLI941.T$DQUA$L         QTD,
  CISLI941.T$PRIC$L         PRECO_UNIT,
  CISLI941.T$AMNT$L         VL_TOTAL,
  WHINH010.T$DSCA           TIPO_ORDEM,
  CISLI940.T$FIRE$L         REFERENCIA,
  TCMCS966.T$DSCA$L         TIPO_DOC_FICAL

FROM BAANDB.TCISLI940301 CISLI940
   
INNER JOIN BAANDB.TTCMCS065301 TCMCS065 
        ON TCMCS065.T$CWOC  = CISLI940.T$COFC$L
		
INNER JOIN BAANDB.TTCCOM130301 TCCOM130 
        ON TCCOM130.T$CADR  = TCMCS065.T$CADR
		
INNER JOIN BAANDB.TZNFMD001301 ZNFMD001 
        ON ZNFMD001.T$FOVN$C = TCCOM130.T$FOVN$L
		
INNER JOIN BAANDB.TTCCOM130301 TCCOM130F 
        ON TCCOM130F.T$CADR = CISLI940.T$ITOA$L
		
INNER JOIN BAANDB.TCISLI941301 CISLI941 
        ON CISLI941.T$FIRE$L = CISLI940.T$FIRE$L
		
INNER JOIN BAANDB.TCISLI245301 CISLI245 
        ON CISLI245.T$FIRE$L = CISLI941.T$FIRE$L
       AND CISLI245.T$LINE$L = CISLI941.T$LINE$L

INNER JOIN BAANDB.TTCMCS966301 TCMCS966 
        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L
		
 LEFT JOIN(       Select  3 koor,  1 oorg From DUAL
            Union Select  7 koor,  2 oorg From DUAL
            Union Select 34 koor,  3 oorg From DUAL
            Union Select  2 koor, 80 oorg From DUAL
            Union Select  6 koor, 81 oorg From DUAL
            Union Select 33 koor, 82 oorg From DUAL
            Union Select 17 koor, 11 oorg From DUAL
            Union Select 35 koor, 12 oorg From DUAL
            Union Select 37 koor, 31 oorg From DUAL
            Union Select 39 koor, 32 oorg From DUAL
            Union Select 38 koor, 33 oorg From DUAL
            Union Select 42 koor, 34 oorg From DUAL
            Union Select  1 koor, 50 oorg From DUAL
            Union Select 32 koor, 51 oorg From DUAL
            Union Select 56 koor, 53 oorg From DUAL
            Union Select  9 koor, 55 oorg From DUAL
            Union Select 46 koor, 56 oorg From DUAL
            Union Select 57 koor, 58 oorg From DUAL
            Union Select 22 koor, 71 oorg From DUAL
            Union Select 36 koor, 72 oorg From DUAL
            Union Select 58 koor, 75 oorg From DUAL
            Union Select 59 koor, 76 oorg From DUAL
            Union Select 60 koor, 90 oorg From DUAL
            Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG
        ON KOOR2OORG.KOOR = CISLI245.T$KOOR

 LEFT JOIN BAANDB.TWHINH200301 WHINH200 
        ON WHINH200.T$OORG =  KOOR2OORG.OORG
       AND WHINH200.T$ORNO = CISLI245.T$SLSO
           
 LEFT JOIN BAANDB.TWHINH010301 WHINH010 
        ON WHINH010.T$OTYP = WHINH200.T$OTYP

 LEFT JOIN ( SELECT d.t$cnst CNST, 
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
        ON CISLI940.t$stat$l = STATUS.CNST
           
WHERE CISLI940.T$FDTY$L = 17
  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE)
      Between :DataGeracaoDe
          And :DataGeracaoAte
  AND ZNFMD001.T$FILI$C IN (:Filial)
ORDER BY NF, SERIE, LINHA_NF