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
        LOC.ADDDATE                   DATA_CRIACAO_LOCAL,
        LOC.EDITDATE                  DATA_ULTIMA_UTILIZACAO,
        cast(LOC.EDITDATE -
             LOC.ADDDATE as int)      DIAS_UTILIZADOS

from    WMWHSE8.LOC

left join WMWHSE5.PUTAWAYZONE PZ
       on PZ.PUTAWAYZONE = LOC.PUTAWAYZONE
