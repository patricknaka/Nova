select
        LOC.LOC                       LOCAL,
        LOC.LOGICALLOCATION           SEQUENCIA_ROTAS,
        Trim(PZ.DESCR)                ZONA,
        LOC.LOCATIONTYPE              TIPO_COLETA,
        LOC.LOCATIONCATEGORY          CATEGORIA_LOCAL,
        ' '                           PROCESS_LOCAL,    -- Aguardando retorno
        LOC.ABC                       ABC,
        LOC.SECTION                   SECAO,
        LOC.WEIGHTCAPACITY            CAPACIDADE_PESO,
        LOC.STATUS                    STATUS,
        LOC.STACKLIMIT                LIMITE_EMILHAMENTO,
        LOC.CUBICCAPACITY             CAPACIDADE_CUBICA,
        LOC.HEIGHT                    ALTURA,
        LOC.WIDTH                     LARGURA,
        LOC.LENGTH                    COMPRIMENTO,
        LOC.LOCBARCODE                LOC_BARCODE,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LOC.ADDDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
                                      DATA_CRIACAO_LOCAL,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LOC.EDITDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
                                      DATA_ULTIMA_UTILIZACAO,
        cast(LOC.EDITDATE -
             LOC.ADDDATE as int)      DIAS_UTILIZADOS

from    WMWHSE8.LOC

left join WMWHSE5.PUTAWAYZONE PZ
       on PZ.PUTAWAYZONE = LOC.PUTAWAYZONE

where   cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LOC.ADDDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
              between :DATA_CRIACAO_DE and :DATA_CRIACAO_ATE
and     cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LOC.EDITDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
              between :DATA_UTILIZ_DE and :DATA_UTILIZ_ATE
and     Trim(PZ.DESCR) in (:ZONA)
