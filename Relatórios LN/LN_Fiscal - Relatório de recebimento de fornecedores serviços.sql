 SELECT
   ZNFMD001.T$FILI$C                                ID_FILIAL,
   ZNFMD001.T$DSCA$C                                DESCR_FILIAL,
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L,
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)   DATA_ORDEM,
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC943.T$ICAD$L,
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)   DATA_VENCTO,
   TDPUR400.T$COTP                                  TIPO_OC,
   TDPUR094.T$DSCA                                  DESC_TIPO_OC,
   TDREC940.T$FIRE$L                                NR,
   TDREC940.T$DOCN$L                                NOTA,
   TDREC940.T$SERI$L                                SERIE,
   SITUACAO_NF.CODE                                 COD_SITUACAO_NF,
   SITUACAO_NF.DESCR                                DSC_SITUACAO_NF,
   TDREC940.T$FOVN$L                                CNPJ,
   TCCOM100.T$NAMA                                  FORNECEDOR,
   TDREC940.T$OPFC$L                                CFOP,
   TDREC940.T$TFDA$L                                VL_TOTAL,
   USER_NAME.T$NAME                                 APROVADOR_FICAL

 FROM       BAANDB.TTDPUR400301 TDPUR400

 INNER JOIN BAANDB.TTCMCS065301 TCMCS065
         ON TCMCS065.T$CWOC  = TDPUR400.T$COFC
 		
 INNER JOIN BAANDB.TTCCOM130301 TCCOM130
         ON TCCOM130.T$CADR  = TCMCS065.T$CADR
 		
 INNER JOIN BAANDB.TZNFMD001301 ZNFMD001
         ON ZNFMD001.T$FOVN$C = TCCOM130.T$FOVN$L
 		
 INNER JOIN BAANDB.TTDPUR094301 TDPUR094
         ON TDPUR094.T$POTP = TDPUR400.T$COTP

 INNER JOIN ( SELECT A.T$NCMP$L,
                     A.T$OORG$L,
                     A.T$ORNO$L,
                     A.T$FIRE$L
                FROM BAANDB.TTDREC947301 A
            GROUP BY A.T$NCMP$L,
                     A.T$OORG$L,
                     A.T$ORNO$L,
                     A.T$FIRE$L ) TDREC947
         ON TDREC947.T$NCMP$L = 301 
        AND TDREC947.T$OORG$L = 80
        AND TDREC947.T$ORNO$L = TDPUR400.T$ORNO

 INNER JOIN BAANDB.TTDREC940301 TDREC940
         ON TDREC940.T$FIRE$L = TDREC947.T$FIRE$L

  LEFT JOIN BAANDB.TTCCOM100301 TCCOM100
         ON TCCOM100.T$BPID = TDPUR400.T$OTBP
 		
  LEFT JOIN BAANDB.TTDREC943301 TDREC943
         ON TDREC943.T$FIRE$L = TDREC940.T$FIRE$L

  LEFT JOIN ( SELECT TTAAD200.T$USER,
                     TTAAD200.T$NAME
                FROM BAANDB.TTTAAD200000 TTAAD200 ) USER_NAME
         ON USER_NAME.T$USER = TDREC940.T$LOGN$L
 		
  LEFT JOIN ( select d.t$cnst CODE, l.t$desc DESCR
                from baandb.tttadv401000 d,
                     baandb.tttadv140000 l
               where d.t$cpac = 'td'
                 and d.t$cdom = 'rec.stat.l'
                 and l.t$clan = 'p'
                 and l.t$cpac = 'td'
                 and l.t$clab = d.t$za_clab
                 and rpad(d.t$vers,4) ||
                     rpad(d.t$rele,2) ||
                     rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                     rpad(l1.t$rele,2) ||
                                                     rpad(l1.t$cust,4))
                                            FROM baandb.tttadv401000 l1
                                           WHERE l1.t$cpac = d.t$cpac
                                             AND l1.t$cdom = d.t$cdom )
                 and rpad(l.t$vers,4) ||
                     rpad(l.t$rele,2) ||
                     rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                     rpad(l1.t$rele,2) ||
                                                     rpad(l1.t$cust,4))
                                            FROM baandb.tttadv140000 l1
                                           WHERE l1.t$clab = l.t$clab
                                             AND l1.t$clan = l.t$clan
                                             AND l1.t$cpac = l.t$cpac ) ) SITUACAO_NF
         ON SITUACAO_NF.CODE = TDREC940.T$STAT$L

 WHERE (   TDPUR400.T$COTP   IN ('A01', 'A02', 'A03', 'A04', 'A05', 'A06')
        OR TDREC940.T$OPFC$L IN ('1102', '1300', '1303', '1253','1551', '1556', '1403', '1406', '1407', '1922', '1933', '2102', '2253', '2303', '2551', '2556', '2407', '2406', '2922') )

   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE))
       BETWEEN :DataFiscalDe
           AND :DataFiscalAte
   AND TDPUR400.T$COTP IN (:TipoOrdem)
   AND SITUACAO_NF.CODE IN (:SituacaoNF)  