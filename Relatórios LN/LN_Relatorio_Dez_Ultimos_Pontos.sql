with ponto_por_seq as
(select /*+ USE_CONCAT NO_CPU_COSTING  */
       a.t$poco$c CODE_OCORRENCIA,
       znmcs002.t$desc$c DESC_OCORRENCIA,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( a.t$dtoc$c,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE) DATA_OCORRENCIA,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( a.t$date$c,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE) DATA_PROCESSAMENTO,
       a.t$pecl$c,
       a.t$sqpd$c,
       a.t$entr$c,
       row_number () over (partition by a.t$pecl$c, a.t$entr$c order by a.t$seqn$c desc) nr_linha
from baandb.tznsls410301 a
inner join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = a.t$poco$c
where a.t$entr$c in (:entrega))

select distinct 
--       znsls410.t$pecl$c      pedido,
       znsls410.t$entr$c      entrega,
       ocor_1.code_ocorrencia                  ponto_1,
       ocor_1.desc_ocorrencia                  desc_ocorr_1,
       ocor_1.data_ocorrencia                  data_ocorr_1,
       ocor_1.data_processamento               data_proces_1,
       ocor_2.code_ocorrencia                  ponto_2,
       ocor_2.desc_ocorrencia                  desc_ocorr_2,
       ocor_2.data_ocorrencia                  data_ocorr_2,
       ocor_2.data_processamento               data_proces_2,
       ocor_3.code_ocorrencia                  ponto_3,
       ocor_3.desc_ocorrencia                  desc_ocorr_3,
       ocor_3.data_ocorrencia                  data_ocorr_3,
       ocor_3.data_processamento               data_proces_3,
       ocor_4.code_ocorrencia                  ponto_4,
       ocor_4.desc_ocorrencia                  desc_ocorr_4,
       ocor_4.data_ocorrencia                  data_ocorr_4,
       ocor_4.data_processamento               data_proces_4,
       ocor_5.code_ocorrencia                  ponto_5,
       ocor_5.desc_ocorrencia                  desc_ocorr_5,
       ocor_5.data_ocorrencia                  data_ocorr_5,
       ocor_5.data_processamento               data_proces_5,
       ocor_6.code_ocorrencia                  ponto_6,
       ocor_6.desc_ocorrencia                  desc_ocorr_6,
       ocor_6.data_ocorrencia                  data_ocorr_6,
       ocor_6.data_processamento               data_proces_6,
       ocor_7.code_ocorrencia                  ponto_7,
       ocor_7.desc_ocorrencia                  desc_ocorr_7,
       ocor_7.data_ocorrencia                  data_ocorr_7,
       ocor_7.data_processamento               data_proces_7,
       ocor_8.code_ocorrencia                  ponto_8,
       ocor_8.desc_ocorrencia                  desc_ocorr_8,
       ocor_8.data_ocorrencia                  data_ocorr_8,
       ocor_8.data_processamento               data_proces_8,
       ocor_9.code_ocorrencia                  ponto_9,
       ocor_9.desc_ocorrencia                  desc_ocorr_9,
       ocor_9.data_ocorrencia                  data_ocorr_9,
       ocor_9.data_processamento               data_proces_9,
       ocor_10.code_ocorrencia                 ponto_10,
       ocor_10.desc_ocorrencia                 desc_ocorr_10,
       ocor_10.data_ocorrencia                 data_ocorr_10,
       ocor_10.data_processamento              data_proces_10,
       case when (select a.t$entr$c  
             from baandb.tznsls410301 a
            where a.t$entr$c = znsls410.t$entr$c
              and a.t$poco$c in ('VAL','RTD','ROU','RIE','RDV','PZE','NFT','NFC','EXT','EXP','EXL','EXF','ETL','ENT','EFO',
                                 'DTR','CPL','CPC','CMS','CAN','AVP','AVA','ARL') 
    and rownum = 1) is null then 'Não'
             else 'Sim' end                    ponto_finalizador
from baandb.tznsls410301 znsls410 
left join ponto_por_seq ocor_1
        on ocor_1.t$entr$c = znsls410.t$entr$c
       and ocor_1.nr_linha = 1
       
left join ponto_por_seq ocor_2
        on ocor_2.t$entr$c = znsls410.t$entr$c
       and ocor_2.nr_linha = 2
       
left join ponto_por_seq ocor_3
        on ocor_3.t$entr$c = znsls410.t$entr$c
       and ocor_3.nr_linha = 3
       
left join ponto_por_seq ocor_4
        on ocor_4.t$entr$c = znsls410.t$entr$c
       and ocor_4.nr_linha = 4
       
left join ponto_por_seq ocor_5
        on ocor_5.t$entr$c = znsls410.t$entr$c
       and ocor_5.nr_linha = 5
       
left join ponto_por_seq ocor_6
        on ocor_6.t$entr$c = znsls410.t$entr$c
       and ocor_6.nr_linha = 6
       
left join ponto_por_seq ocor_7
        on ocor_7.t$entr$c = znsls410.t$entr$c
       and ocor_7.nr_linha = 7

left join ponto_por_seq ocor_8
        on ocor_8.t$entr$c = znsls410.t$entr$c
       and ocor_8.nr_linha = 8

left join ponto_por_seq ocor_9
        on ocor_9.t$entr$c = znsls410.t$entr$c
       and ocor_9.nr_linha = 9
       
left join ponto_por_seq ocor_10
        on ocor_10.t$entr$c = znsls410.t$entr$c
       and ocor_10.nr_linha = 10
       
where znsls410.t$entr$c in (:entrega)
