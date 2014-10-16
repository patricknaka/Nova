-- #FAF.087 - 29-mai-2014, Fabio Ferreira, 	Correções de informações que estavam pendente do fiscal
-- #FAF.098 - 02-jun-2014, Fabio Ferreira, 	Alterações
-- #FAF.109 - 07-jun-2014, Fabio Ferreira, 	Inclusão do campo ref.fiscal
-- #FAF.248 - 29-jul-2014, Fabio Ferreira, 	Inclusão do tipo doc fiscal
-- #MAT.001 - 31-jul-2014, Marcia A. Torres, Correção do campo DT_ATUALIZACAO_NF
-- #FAF.286 - 29-jul-2014, Fabio Ferreira, 	Ajuste do campo DT_ATUALIZACAO_NF
-- #MAT.308 - 28-ago-2014, Marcia A. Torres, Inclusão do campo TIPO_ORDEM_VENDA.
-- #FAF.314 - 01-sep-2014, Fabio Ferreira, 	Correção impostos importação
-- #FAF.322 - 11-sep-2014, Fabio Ferreira, 	Correção relacionamento
-- #FAF.328 - 22-sep-2014, Fabio Ferreira, 	Correção relacionamento com a ordem de venda
-- #FAF.328 - 25-sep-2014, Fabio Ferreira, 	Correção relacionamento com a ordem de venda
--**********************************************************************************************************************************************************
SELECT
    201 CD_CIA,
    case when (SELECT tcemm030.t$euca FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=201
    AND rownum=1) = ' ' then
    (SELECT substr(tcemm124.t$grid,-2,2) FROM baandb.ttcemm124201 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=201
    AND rownum=1)else 
    (SELECT tcemm030.t$euca FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=201
    AND rownum=1) end as CD_FILIAL, 
		cisli940.t$docn$l NR_NF,
		cisli940.t$seri$l NR_SERIE_NF,
		cisli940.t$ccfo$l CD_NATUREZA_OPERACAO,
		cisli940.t$opor$l SQ_NATUREZA_OPERACAO,
		cisli940.t$fdty$l CD_TIPO_NF,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE) DT_EMISSAO_NF,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE) HR_EMISSAO_NF,

		cisli940.t$itbp$l CD_CLIENTE_FATURA,
		cisli940.t$stbp$l CD_CLIENTE_ENTREGA,
		entr.t$pecl$c NR_PEDIDO,
		TO_CHAR(entr.t$entr$c) NR_ENTREGA,																	--#FAF.098.n
		entr.t$orno$c NR_ORDEM,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=1) VL_ICMS,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=2) VL_ICMS_ST,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=3) VL_IPI,
		cisli940.t$gamt$l VL_PRODUTO,
		cisli940.t$fght$l VL_FRETE,
		cisli940.t$insr$l VL_SEGURO,
		cisli940.t$gexp$l VL_DESPESA,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
		(SELECT sum(cisli941.t$ldam$l) FROM baandb.tcisli941201 cisli941
		WHERE cisli941.t$fire$l=cisli940.t$fire$l) VL_DESCONTO,
<<<<<<< HEAD
		cisli940.t$amnt$l VL_TOTAL_NF,        
    CASE WHEN cisli940.t$fdty$l=15 then
=======
		cisli940.t$amnt$l VL_TOTAL_NF,
        CASE WHEN cisli940.t$fdty$l=15 then
>>>>>>> parent of 1dcdbcf... #336 VW_NFV_CAB Ajuste
          (select a.t$docn$l from baandb.tcisli940201 a, baandb.tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l
          and rownum=1
          group by a.t$docn$l
          ) else 0
       end  NR_NF_FATURA,
       CASE WHEN cisli940.t$fdty$l=15 then
          (select a.t$seri$l from baandb.tcisli940201 a, baandb.tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l
          and rownum=1
          group by a.t$seri$l)
          else ' '
          end  NR_SERIE_NF_FATURA, 
        CASE WHEN cisli940.t$fdty$l=16 then
          (select a.t$docn$l from baandb.tcisli940201 a, baandb.tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l
          and rownum=1
          group by a.t$docn$l)
          else 0
          end NR_NF_REMESSA,
        CASE WHEN cisli940.t$fdty$l=16 then
          (select a.t$seri$l from baandb.tcisli940201 a, baandb.tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l
          and rownum=1
          group by a.t$seri$l
          )
          else ' '
          end NR_SERIE_NF_REMESSA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE) DT_SITUACAO_NF,
		cisli940.t$stat$l CD_SITUACAO_NF,
		cisli940.t$amfi$l VL_DESPESA_FINANCEIRA,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=5) VL_PIS,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=6) VL_COFINS,
        Nvl((SELECT sum(cisli943.t$amnt$l) from baandb.tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli940.t$fire$l
             AND    cisli943.t$brty$l=13),0) VL_CSLL,
		entr.t$vldi$c VL_DESCONTO_INCONDICIONAL,
		cisli940.t$cchr$l VL_DESPESA_ADUANEIRA,
		nvl((select sum(l.t$gexp$l) from baandb.tcisli941201 l
		where	l.t$fire$l = cisli940.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)),0) VL_ADICIONAL_IMPORTACAO,
		nvl((select sum(li.t$amnt$l) from baandb.tcisli943201 li, baandb.tcisli941201 l
		where	l.t$fire$l = cisli940.t$fire$l
		and li.t$fire$l=li.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)
		and li.t$brty$l=5),0) VL_PIS_IMPORTACAO, 
		nvl((select sum(li.t$amnt$l) from baandb.tcisli943201 li, baandb.tcisli941201 l
		where	l.t$fire$l = cisli940.t$fire$l
		and li.t$fire$l=li.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)
		and li.t$brty$l=6),0) VL_COFINS_IMPORTACAO,
		nvl((select sum(l.t$fght$l) from baandb.tcisli941201 l
		where	l.t$fire$l = cisli940.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)),0) VL_CIF_IMPORTACAO,
	GREATEST(																									--#FAF.286.sn
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE),
	nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c1.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE) from baandb.tcisli941201 c1 
			where c1.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
	nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c2.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE) from baandb.tcisli943201 c2 
			where c2.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY'))) DT_ULT_ATUALIZACAO,		--#FAF.286.en
   (SELECT tcemm124.t$grid FROM baandb.ttcemm124201 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=201
    AND rownum=1) CD_UNIDADE_EMPRESARIAL,
	entr.t$uneg$c CD_UNIDADE_NEGOCIO,																	--#FAF.098.n
	cisli940.t$fire$l NR_REFERENCIA_FISCAL,																		--#FAF.109.n
	cisli940.t$fdtc$l CD_TIPO_DOCUMENTO_FISCAL,
	cisli940.t$nfes$l CD_STATUS_SEFAZ,																	--#FAF.248.n

  (SELECT tdsls400.t$sotp                                        --#MAT.308.sn
   FROM baandb.ttdsls400201 tdsls400            
   WHERE tdsls400.t$orno=entr.t$orno$c
   group by tdsls400.t$sotp)        CD_TIPO_ORDEM_VENDA,        --#MAT.308.en 

    CASE WHEN cisli940.t$fdty$l=15 then
      (select distinct a.t$fire$l from baandb.tcisli940201 a, baandb.tcisli941201 b
      where b.t$fire$l=cisli940.t$fire$l
      and a.t$fire$l=b.t$refr$l) else NULL
   end  NR_REFERENCIA_FISCAL_FATURA
FROM
		baandb.tcisli940201 cisli940
		LEFT JOIN (SELECT 	znsls401.t$entr$c, 
							cisli245.t$fire$l, 
							znsls401.t$pecl$c, 
							cisli245.t$slso t$orno$c, 
							znsls401.t$uneg$c, 
							SUM(znsls401.t$vldi$c) t$vldi$c 
					FROM
					 baandb.tcisli245201 cisli245
					 LEFT JOIN (select	r.t$ncia$c, 
										r.t$uneg$c,
										r.t$pecl$c,
										r.t$sqpd$c,
										r.t$entr$c,
										r.t$sequ$c,
										r.t$orno$c,
										r.t$pono$c
								 from baandb.tznsls004301  r
								 where r.t$entr$c=( select  r0.t$entr$c 
                                    from baandb.tznsls004301  r0
                                    where r0.t$orno$c=r.t$orno$c
                                    and rownum=1
                                    and r0.t$date$c=  (select max(r1.t$date$c)
                                                         from baandb.tznsls004301  r1
                                                         where r1.t$orno$c=r0.t$orno$c))) znsls004 
															ON	znsls004.t$orno$c=cisli245.t$slso
					                                        AND znsls004.t$pono$c=cisli245.t$pono
					 LEFT JOIN baandb.tznsls401201 znsls401 ON   znsls401.t$ncia$c=znsls004.t$ncia$c
					                                        AND   znsls401.t$uneg$c=znsls004.t$uneg$c
					                                        AND   znsls401.t$pecl$c=znsls004.t$pecl$c
					                                        AND   znsls401.t$sqpd$c=znsls004.t$sqpd$c
					                                        AND   znsls401.t$entr$c=znsls004.t$entr$c
					                                        AND   znsls401.t$sequ$c=znsls004.t$sequ$c
					group by
							znsls401.t$entr$c, 
							cisli245.t$fire$l, 
							znsls401.t$pecl$c ,
							cisli245.t$slso, 
							znsls401.t$uneg$c) entr ON entr.t$fire$l=cisli940.t$fire$l,
    baandb.ttcemm124201 tcemm124,
    baandb.ttcemm030201 tcemm030
WHERE tcemm124.t$loco=201
AND   tcemm124.t$dtyp=1
AND   tcemm124.t$cwoc=cisli940.t$cofc$l
AND   tcemm030.t$eunt=tcemm124.t$grid;