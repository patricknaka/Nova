-- 06-jan-2014, Fabio Ferreira, Correção timezone
--	FAF.001 - 07-jan-2014, Fabio Ferreira, 	Retirada conversão de timezone para campos somente data
--											Corrigido campos Taxa Juros, Taxa Mora
--	FAF.003 - 12-jan-2014, Fabio Ferreira, 	Retirada conversão de timezone para campo DATA_LIQUIDACAO_TITULO
--											O campo taxa multa foi alterado apara ler o valor da tabela tfacp201
--	FAF.007 - 12-jan-2014, Fabio Ferreira, 	Alteração valor original do título
--****************************************************************************************************************************************************************
SELECT DISTINCT
  tfacp200.t$ttyp || tfacp200.t$ninv CHAVE,
  tfacp200.t$ttyp TIPO_TRANSACAO,
  tfacp200.t$ninv NUMERO_TITULO,
  tfacp200.t$pcom CODIGO_CIA,
  --tfacp200.t$dim2 CODIGO_FILIAL,
	CASE WHEN tfacp200.t$ttyp IN ('AGA', 'GA1')
	THEN 3
	ELSE 2
	END CODIGO_FILIAL,
  (Select u.t$eunt From ttcemm030201 u
   where u.t$euca!=' '
   AND TO_NUMBER(u.t$euca)=CASE WHEN tfacp200.t$dim2=' ' then 999
   WHEN tfacp200.t$dim2>to_char(0) then 999 
   else TO_NUMBER(tfacp200.t$dim2) END
   and rownum = 1
   ) UNID_EMPRESARIAL,
  tfacp200.t$tpay CODIGO_DOCUMENTO,
  tfacp200.t$ifbp CODIGO_FORNECEDOR_CLIENTE,
  tdrec947.t$rcno$l NUMERO_NOTA_RECEBIMENTO,
  tfacp200.t$docn$l NUMERO_NOTA_FISCAL,
  tfacp200.t$seri$l NUMERO_SERIE_NOTA_FISCAL,
  tfacp200.t$line$l SEQUENCIA_NOTA_FISCAL,
--	CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$docd, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.001.o
--		AT time zone sessiontimezone) AS DATE) DATA_EMISSAO_TITULO,									--#FAF.001.o
	tfacp200.t$docd DATA_EMISSAO_TITULO,															--#FAF.001.n
	tfacp200.t$dued DATA_VENCIMENTO_TITULO,															--#FAF.001.n
--	CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$dued, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.001.o
--		AT time zone sessiontimezone) AS DATE)  DATA_VENCIMENTO_TITULO,								--#FAF.001.o
	tfacp201.t$odue$l DATA_VENC_ORIG_TITULO,														--#FAF.001.n
--	CAST((FROM_TZ(CAST(TO_CHAR(tfacp201.t$odue$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.001.o
--		AT time zone sessiontimezone) AS DATE) DATA_VENC_ORIG_TITULO,								--#FAF.001.o
	(select 																						--#FAF.003.sn
		max(p.t$docd) 
	from ttfacp200201 p
	where p.t$ttyp=tfacp200.t$ttyp
	and p.t$ninv=tfacp200.t$ninv
	and p.t$tpay=2) DATA_LIQUIDACAO_TITULO,															--#FAF.003.en
--  (select 																						--#FAF.001.so
--	CAST((FROM_TZ(CAST(TO_CHAR(max(p.t$docd), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
--		AT time zone sessiontimezone) AS DATE)  
--   from ttfacp200201 p
--  where p.t$ttyp=tfacp200.t$ttyp
--  and p.t$ninv=tfacp200.t$ninv
--  and p.t$tpay=2) DATA_LIQUIDACAO_TITULO,															--#FAF.001.eo
  tfacp200.t$amnt VALOR_TITULO,
--  tfacp200.t$amth$1 VALOR_ORIGINAL_TITULO,														--#FAF.007.o
	nvl(tdrec940.t$tfda$l, tfacp200.t$amnt)  VALOR_ORIGINAL_TITULO,									--#FAF.007.o	
  CASE WHEN tfacp200.t$afpy=2 THEN 1
  ELSE 2
  END FLAG_TITULO_BLOQUEADO,
  tfacp201.t$pyst$l FLAG_PREPARADO_PARA_PAGAMENTO,
  tfacp200.t$stap SITUACAO_TITULO,
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DATA_SITUACAO_TITULO,
  tfacp200.t$doty$l TIPO_NOTA_FISCAL,
  tfacp200.t$balh$1 VALOR_SALDO_TITULO,
  tdrec947.t$orno$l NUMERO_PEDIDO_VENDA,
  tfcmg011f.t$baoc$l NUMERO_BANCO_DESTINO,
  tfcmg011f.t$agcd$l NUMERO_AGENCIA_DESTINO,
  tfcmg011f.t$agdg$l DIGITO_AGENCIA_DESTINO,
  tfcmg001f.t$bano NUMERO_CONTA_DESTINO,
  tfcmg001f.t$ofdg$l DIGITO_CONTA_DESTINO,
  -- tfacp201.t$inta$l TAXA_MORA,																	--#FAF.001.o
  tfacp200.t$lapa TAXA_MORA,																		--#FAF.001.n
  -- tfacp201.t$inta$l TAXA_MULTA,																	--#FAF.001.o
  -- tfacp200.t$inam$l TAXA_MULTA,																	--#FAF.001.n --#FAF.003.o
  nvl((select p.t$inra$l from ttfacp201201 p														--#FAF.003.sn 
   where p.t$ttyp=tfacp200.t$ttyp
   and p.t$ninv=tfacp200.t$ninv
   and ROWNUM=1),0) TAXA_MULTA,																		--#FAF.003.en
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE) DATA_HORA_ATUALIZACAO,
  'CAP' COD_MODULO,
  tdrec940.t$fire$l REFERENCIA_FICAL
FROM
  ttfacp200201 tfacp200
  LEFT JOIN ttdrec940201 tdrec940
  ON tdrec940.t$docn$l=tfacp200.t$docn$l
  AND tdrec940.t$seri$l=tfacp200.t$seri$l
  AND tdrec940.t$ttyp$l=tfacp200.t$ttyp
  AND tdrec940.t$invn$l=tfacp200.t$ninv
  LEFT JOIN ttdrec947201 tdrec947
  ON tdrec947.t$fire$l=tdrec940.t$fire$l
  LEFT JOIN ttccom125201 tccom125
  ON  tccom125.t$ptbp=tfacp200.t$otbp
  AND tccom125.t$cban=tfacp200.t$bank
  LEFT JOIN ttfcmg011201 tfcmg011
  ON  tfcmg011.t$bank=tccom125.t$brch,
  (SELECT a.t$ttyp,
      a.t$ninv,
      MIN(a.t$odue$l) t$odue$l,
      MIN(a.t$liqd)   t$liqd,
      SUM(a.t$amnt)   t$amnt,
      MIN(a.t$pyst$l) t$pyst$l,
      MAX(a.t$inta$l) t$inta$l,
	  MAX(a.t$bank) t$bank
  FROM ttfacp201201 a
  GROUP BY a.t$ttyp,
       a.t$ninv) tfacp201
  LEFT JOIN ttfcmg001201 tfcmg001f
	ON tfcmg001f.t$bank=tfacp201.t$bank
  LEFT JOIN ttfcmg011201 tfcmg011f
	ON tfcmg011f.t$bank=tfcmg001f.t$brch
WHERE
  tfacp201.t$ttyp=tfacp200.t$ttyp
AND  tfacp201.t$ninv=tfacp200.t$ninv
AND tfacp200.t$docn=0