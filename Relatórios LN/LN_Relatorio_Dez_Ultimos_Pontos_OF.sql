
with ponto_por_ult_atlz as
(select /*+ USE_CONCAT NO_CPU_COSTING  */
       znfmd640.t$coci$c              OCORRENCIA,
       znmcs002.t$desc$c              DESC_OCORRENCIA,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE)
                                      DATA_OCORRENCIA,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE)              
                                      DATA_ULT_ATLZ,
       znfmd630.t$pecl$c              ENTREGA,
       row_number () over (partition by znfmd630.t$pecl$c order by znfmd640.t$udat$c desc) 
                                      NR_LINHA
from baandb.tznfmd630301 znfmd630

inner join baandb.tznfmd640301 znfmd640
        on znfmd640.t$fili$c = znfmd630.t$fili$c
       and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       
inner join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znfmd640.t$coci$c
       
where znfmd630.t$pecl$c in (:entrega))

select entregas.entrega             ENTREGA,
       ocorr_1.ocorrencia           PONTO_1,
       ocorr_1.data_ocorrencia      DATA_OCORR_1,
       ocorr_1.data_ult_atlz        DATA_PROCES_1,
       ocorr_2.ocorrencia           PONTO_2,
       ocorr_2.data_ocorrencia      DATA_OCORR_2,
       ocorr_2.data_ult_atlz        DATA_PROCES_2,
       ocorr_3.ocorrencia           PONTO_3,
       ocorr_3.data_ocorrencia      DATA_OCORR_3,
       ocorr_3.data_ult_atlz        DATA_PROCES_3,
       ocorr_4.ocorrencia           PONTO_4,
       ocorr_4.data_ocorrencia      DATA_OCORR_4,
       ocorr_4.data_ult_atlz        DATA_PROCES_4,
       ocorr_5.ocorrencia           PONTO_5,
       ocorr_5.data_ocorrencia      DATA_OCORR_5,
       ocorr_5.data_ult_atlz        DATA_PROCES_5,
       ocorr_6.ocorrencia           PONTO_6,
       ocorr_6.data_ocorrencia      DATA_OCORR_6,
       ocorr_6.data_ult_atlz        DATA_PROCES_6,
       ocorr_7.ocorrencia           PONTO_7,
       ocorr_7.data_ocorrencia      DATA_OCORR_7,
       ocorr_7.data_ult_atlz        DATA_PROCES_7,
       ocorr_8.ocorrencia           PONTO_8,
       ocorr_8.data_ocorrencia      DATA_OCORR_8,
       ocorr_8.data_ult_atlz        DATA_PROCES_8,
       ocorr_9.ocorrencia           PONTO_9,
       ocorr_9.data_ocorrencia      DATA_OCORR_9,
       ocorr_9.data_ult_atlz        DATA_PROCES_9,
       ocorr_10.ocorrencia          PONTO_10,
       ocorr_10.data_ocorrencia     DATA_OCORR_10,
       ocorr_10.data_ult_atlz       DATA_PROCES_10,
       
       case when (select a.t$pecl$c     
                    from baandb.tznfmd630301 a
                  
                   inner join baandb.tznfmd640301 b
                           on b.t$fili$c = a.t$fili$c
                          and b.t$etiq$c = a.t$etiq$c
            where a.t$pecl$c = entregas.entrega
              and b.t$coci$c in ('VAL','RTD','ROU','RIE','RDV','PZE','NFT','NFC','EXT','EXP','EXL','EXF','ETL','ENT','EFO',
                                 'DTR','CPL','CPC','CMS','CAN','AVP','AVA','ARL') 
    and rownum = 1) is null then 'Não'
             else 'Sim' end          PONTO_FINALIZADOR
from 
(select distinct znfmd630.t$pecl$c     ENTREGA
 from baandb.tznfmd630301 znfmd630

 inner join baandb.tznfmd640301 znfmd640
         on znfmd640.t$fili$c = znfmd630.t$fili$c
        and znfmd640.t$etiq$c = znfmd630.t$etiq$c
 where znfmd630.t$pecl$c in (:entrega)) entregas

left join ponto_por_ult_atlz ocorr_1
       on ocorr_1.entrega = entregas.entrega
      and ocorr_1.nr_linha = 1
      
left join ponto_por_ult_atlz ocorr_2
       on ocorr_2.entrega = entregas.entrega
      and ocorr_2.nr_linha = 2
      
left join ponto_por_ult_atlz ocorr_3
       on ocorr_3.entrega = entregas.entrega
      and ocorr_3.nr_linha = 3

left join ponto_por_ult_atlz ocorr_4
       on ocorr_4.entrega = entregas.entrega
      and ocorr_4.nr_linha = 4

left join ponto_por_ult_atlz ocorr_5
       on ocorr_5.entrega = entregas.entrega
      and ocorr_5.nr_linha = 5
      
left join ponto_por_ult_atlz ocorr_6
       on ocorr_6.entrega = entregas.entrega
      and ocorr_6.nr_linha = 6
      
left join ponto_por_ult_atlz ocorr_7
       on ocorr_7.entrega = entregas.entrega
      and ocorr_7.nr_linha = 7
      
left join ponto_por_ult_atlz ocorr_8
       on ocorr_8.entrega = entregas.entrega
      and ocorr_8.nr_linha = 8
      
left join ponto_por_ult_atlz ocorr_9
       on ocorr_9.entrega = entregas.entrega
      and ocorr_9.nr_linha = 9
      
left join ponto_por_ult_atlz ocorr_10
       on ocorr_10.entrega = entregas.entrega
      and ocorr_10.nr_linha = 10
