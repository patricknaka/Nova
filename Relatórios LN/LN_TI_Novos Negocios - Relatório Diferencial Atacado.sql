SELECT
	CISLI940.T$DOCN$L							    NOTA_FISCAL,
	CISLI940.T$SERI$L							    SERIE,
	DESC_DOMAIN_STAT.DESCR						SATAUS,
	TCCOM130.T$FOVN$L							    CNPJ_CLIENTE,
	CISLI940.T$FIDS$L							    RAZAO_SOSCIAL,
	NVL(ICMS_ST.T$NMRG$L,0)						MVA,
	NVL(PIS.T$SRAT$L,0)							  PIS,
	NVL(COFINS.T$SRAT$L,0)						COFINS,
	NVL(ICMS_ST.T$SRAT$L,0)						ST,
	NVL(ICMS.T$SRAT$L,0)							ALIQ_ICMS,	
	TRIM(CISLI941.T$ITEM$L)						ID_SKU,
	CISLI941.T$DQUA$L							    QTD,
	CISLI941.T$PRIC$L							    PRECO_UNIT,
	CISLI941.T$DESC$L							    DESCRICAO,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATG$L, 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) DATA_PEDIDO,
	CAST(CISLI941.T$AMNT$L/CISLI941.T$DQUA$L AS NUMERIC(16,2))			PRECO_VENDA,
	NVL(MAUC.MAUC,0)							    PRECO_CUSTO,                                       
	CISLI941.T$FGHT$L							    FRETE,
	CISLI941.T$AMNT$L							    VL_TOTAL,
	CISLI941.T$LINE$L								LINHA


FROM		BAANDB.TCISLI940301 CISLI940

INNER JOIN	BAANDB.TCISLI941301 CISLI941
				ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L

LEFT JOIN	BAANDB.TTCCOM130301	TCCOM130
				ON	TCCOM130.T$CADR	=	CISLI940.T$ITOA$L

LEFT  JOIN 	BAANDB.TCISLI943301 ICMS_ST  
				ON 	ICMS_ST.T$FIRE$L = CISLI941.T$FIRE$L 
				AND ICMS_ST.T$LINE$L = CISLI941.T$LINE$L 
				AND ICMS_ST.T$BRTY$L = 2

LEFT  JOIN 	BAANDB.TCISLI943301 PIS  
				ON 	PIS.T$FIRE$L = CISLI941.T$FIRE$L 
				AND PIS.T$LINE$L = CISLI941.T$LINE$L 
				AND PIS.T$BRTY$L = 5				
				
LEFT  JOIN 	BAANDB.TCISLI943301 COFINS  
				ON 	COFINS.T$FIRE$L = CISLI941.T$FIRE$L 
				AND COFINS.T$LINE$L = CISLI941.T$LINE$L 
				AND COFINS.T$BRTY$L = 6					

LEFT  JOIN 	BAANDB.TCISLI943301 ICMS  
				ON 	ICMS.T$FIRE$L = CISLI941.T$FIRE$L 
				AND ICMS.T$LINE$L = CISLI941.T$LINE$L 
				AND ICMS.T$BRTY$L = 1					

 LEFT JOIN ( select whwmd217.t$item item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                          then sum(whwmd217.t$ftpa$1)                                              
                    else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
            from baandb.twhwmd217301 whwmd217                      
            left join baandb.twhinr140301 a                             
              on a.t$cwar = whwmd217.t$cwar                              
              and a.t$item = whwmd217.t$item                              
            group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) mauc                                
				ON 	mauc.cwar = CISLI941.T$CWAR$L                         
				AND mauc.item = CISLI941.T$ITEM$L 

				
 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) 
                 || rpad(d.t$rele,2) 
                 || rpad(d.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele, 2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           AND l1.t$cdom = d.t$cdom)
                AND rpad(l.t$vers,4) 
                 || rpad(l.t$rele,2) 
                 || rpad(l.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele,2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           AND l1.t$clan = l.t$clan 
                                           AND l1.t$cpac = l.t$cpac)) DESC_DOMAIN_STAT
					ON 	DESC_DOMAIN_STAT.CODE = cisli940.t$stat$l

WHERE CISLI940.T$CBRN$C='107'
    AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATG$L, 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)) BETWEEN :DataPedidoDe AND :DataPedidoAte
	AND ((:SKUTodos = 1) or (TRIM(CISLI941.T$ITEM$L) in (:SKU) and (:SKUTodos = 0)))