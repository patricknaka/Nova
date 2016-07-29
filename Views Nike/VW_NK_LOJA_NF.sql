CREATE OR REPLACE VIEW VW_NK_LOJA_NF AS
SELECT DISTINCT
  'NIKE.COM'                FILIAL,                                 --02
  tccom130r.t$fovn$l        CGC_FILIAL_DESTINO,                     --03
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            EMISSAO,                                --04
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    0.0
  ELSE TDREC941.QTDE END    QTDE_TOTAL,                             --05
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
      0.0
  ELSE tdrec940.t$tfda$l END        VALOR_TOTAL,                            --06
  tdrec940.t$fovn$l         CGC_CPF,                                --07
  tdrec940.t$fovn$l         COD_CLIFOR,                             --08
  cast(NVL(tttxt010r.t$text,' ') as varchar(100))        OBS,                --09
  tdrec940.t$seri$l         SERIE_NF,                               --10
  tdrec940.t$docn$l         NF_NUMERO,                              --11
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$odat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_NF,                          --12
  tdrec940.t$opfc$l         CODIGO_FISCAL_OPERACAO,                 --13
  1                         RECEBIMENTO,                            --14
  tdrec940.t$nwgt$l         PESO_LIQUIDO,                           --15
  tdrec940.t$gwgt$l         PESO_BRUTO,                             --16
  0                         VOLUMES,                                --17
  ''                       TIPO_VOLUME,                            --18
  ''                       MARCA_VOLUME,                           --19
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
      0.0
  ELSE tdrec940.t$fght$l END         FRETE,                         --20
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
      0.0
  ELSE tdrec940.t$insr$l END         SEGURO,                               --21
  0                         FRETE_A_PAGAR,                          --22
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
      0.0
   ELSE tdrec940.t$gtam$l + TDREC940.T$ADDC$L + TDREC940.T$GEXP$L + TDREC940.T$CCHR$L END        VALOR_TOTAL_ITENS,               --23
  0.00                      DESCONTO,                               --24
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
      0.0
  ELSE 0.0 END              ENCARGO,   --Obs.: Zerar o campo até a Infor corrigir o mesmo. Está vindo o valor do Desconto.
  CASE WHEN tdrec940.t$stat$l = 4 or tdrec940.t$stat$l = 5 THEN
        '1'       -- NF impressa
  ELSE  '0' END                  NOTA_IMPRESSA,                     --26
--  tdrec940.t$cfrn$l              TRANSP_RAZAO_SOCIAL,               --27
  tcmcs080.t$dsca                 TRANSP_RAZAO_SOCIAL,               --27
  NVL(tccom130t.t$cste,'')      TRANSP_UF,                         --28
  NVL(tccom139r.t$dsca,'')      TRANSP_CIDADE,                     --29
  NVL(tccom130t.t$fovn$l,'')    TRANSP_CGC,                        --30
  NVL(tccom966r.t$stin$d,'')    TRANSP_INSCRICAO,                  --31
  tccom130t.t$namc || ' ' ||
  tccom130t.t$hono || ' ' ||
  tccom130t.t$namd               TRANSP_ENDERECO,                   --32
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(DATA_REC.ESTORNO, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                          AT time zone 'America/Sao_Paulo') AS DATE)
  ELSE  NULL END            DATA_CANCELAMENTO,                      --33
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    TDREC941.QTDE
  ELSE 0.00 END             QTDE_CANCELADA,                         --34
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    tdrec940.t$tfda$l
  ELSE 0.00 END             VALOR_CANCELADO,                        --35
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    '1'
  ELSE '0' END              NOTA_CANCELADA,                          --36
  ''                       INDICA_CONSUMIDOR_FINAL,                 --37
  ''                       TIPO_ORIGEM,                             --38
  NVL(tdrec949.t$amnt$l,0)  VALOR_IMPOSTO_AGREGAR,                   --39
  ''                       EMPRESA,                                 --40
  tdrec940.t$cnfe$l         CHAVE_NFE,                               --41
  tdrec940.t$prot$c         PROTOCOLO_AUTORIZACAO_NFE,               --42
  CASE WHEN tdrec940.t$sadt$c = TO_DATE('01-01-1970','DD-MM-YYYY') THEN
      NULL
  ELSE
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$sadt$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE) END
                            DATA_AUTORIZACAO_NFE,                    --43
  ''                       GERAR_AUTOMATICO,                        --44
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    '49'
  ELSE '5' END              STATUS_NFE,                              --45

  CASE WHEN tdrec940.t$nfel$l = 1 THEN
    '0'
  ELSE '99' END             LOG_STATUS_NFE,                          --46
  ''                  MOTIVO_CANCELAMENTO_NFE,                 --47
  ''                       PRIORIZACAO,                             --48
  SUBSTR(tdrec940.t$cnfe$l,35,1) TIPO_EMISSAO_NFE,                   --49
  CASE WHEN tdrec940.t$rfdt$l IN (6,7)
    THEN  2
  WHEN tdrec940.t$rfdt$l = 8
    THEN 3
  ELSE 1 END         FIN_EMISSAO_NFE,                         --50  CONSIDERANDO NOTAS FISCAIS DE DEVOLUÇÃO COMO "TIPO NORMAL"
  ''              REGISTRO_DPEC,                           --51  HOJE É EXPORTADO COMO NULL
  ''                       PIN,                                     --52
  NULL                      DATA_REGISTRO_DPEC,                      --53   NO RECEBIMENTO NÃO TEMOS ESTA DATA
  ''                       PROTOCOLO_CANCELAMENTO_NFE,              --54
  NULL                      DATA_CONTINGENCIA,                       --55   NO RECEBIMENTO NÃO TEMOS ESTA DATA
  ''    JUSTIFICATIVA_CONTINGENCIA,              --56
  ''                       OBS_INTERESSE_FISCO,                     --57
  '0'                       TRANSP_PF_PJ,                            --58
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$odat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_ETR,                          --59
  tccom130fat.t$namc        ENTREGA_ENDERECO,                        --60
  tccom130fat.t$hono        ENTREGA_NUMERO,                          --61
  tccom130fat.t$bldg        ENTREGA_COMPLEMENTO,                     --62
  tccom130fat.t$cste        ENTREGA_UF,                              --63
  tccom139fat.t$dscb$c      ENTREGA_CIDADE,                          --64
  tccom130fat.t$dist$l      ENTREGA_BAIRRO,                          --65
  tccom130fat.t$pstc        ENTREGA_CEP,                             --66
  SUBSTR(tccom130fat.t$telp,3,9)        ENTREGA_TELEFONE,            --67
  SUBSTR(tccom130fat.t$telp,1,2)        ENTREGA_DDD,                 --68
  SUBSTR(tccom130fat.t$telx,1,2)        ENTREGA_DDD_CELULAR,         --69
  SUBSTR(tccom130fat.t$telx,3,9)        ENTREGA_CELULAR,             --70
  tccom130fat.t$nama          ENTREGA_NOME_DESTINATARIO,             --71
  '0'                       ENTREGA_DEST_COMPR,                      --72
  TO_CHAR(tdrec940.t$docn$l) ||
  tdrec940.t$seri$l         NUMERO_PEDIDO_VENDA,                     --73
  'E'                       TP_MOVTO,                                --74 Criado para separar na tabela as entradas e saídas
  tdrec940.t$fdtc$l         COD_TIPO_DOC_FISCAL,                     --75 Criado para ser combinado junto com o CFOP
  tcmcs966.t$dsca$l         DESCR_COD_TIPO_DOC_FISCAL,               --76
  tdrec940.t$fire$l         REF_FISCAL,                              --77
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DT_ULT_ALTERACAO,                        --78
  tccom139fat.t$ibge$l         COD_IBGE                              --79

FROM  baandb.ttdrec940601  tdrec940

    LEFT JOIN baandb.ttccom130601 tccom130r
           ON tccom130r.t$cadr=tdrec940.t$sfra$l

    LEFT JOIN baandb.ttccom100601 tccom100fat
           ON tccom100fat.t$bpid = tdrec940.t$bpid$l

    LEFT JOIN baandb.ttccom130601 tccom130fat           --PN
--           ON tccom130fat.t$cadr = tdrec940.t$ifad$l
           ON tccom130fat.t$cadr = tccom100fat.t$cadr

    LEFT JOIN ( select  sum(a.t$qnty$l)  QTDE,
                        a.t$fire$l
                from    baandb.ttdrec941601 a,
                        baandb.tznsls000601 b
                where a.t$item$l != b.t$itmf$c      --ITEM FRETE
                  and a.t$item$l != b.t$itmd$c      --ITEM DESPESAS
                  and a.t$item$l != b.t$itjl$c      --ITEM JUROS
                  and b.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                group by a.t$fire$l ) TDREC941
           ON TDREC941.t$fire$l=tdrec940.t$fire$l

    LEFT JOIN baandb.ttcmcs080601 tcmcs080
           ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l

    LEFT JOIN baandb.ttccom130601 tccom130t         --transportadora
--           ON tccom130t.t$cadr=tdrec940.t$cfra$l
             ON tccom130t.t$cadr = tcmcs080.t$cadr$l

    LEFT JOIN baandb.ttccom966601 tccom966r
           ON tccom966r.t$comp$d = tccom130t.t$comp$d

    LEFT JOIN baandb.ttccom139301 tccom139r
           ON tccom139r.t$ccty = tccom130t.t$ccty
          AND tccom139r.t$cste = tccom130t.t$cste
          AND tccom139r.t$city = tccom130t.t$ccit

    LEFT JOIN baandb.ttccom139301 tccom139fat
           ON tccom139fat.t$ccty = tccom130fat.t$ccty
          AND tccom139fat.t$cste = tccom130fat.t$cste
          AND tccom139fat.t$city = tccom130fat.t$ccit

    LEFT JOIN ( select  a.t$oper$c,
                        a.t$fire$c,
                        a.t$stre$c,
                        MIN(a.t$data$c) ESTORNO
                from    baandb.tznnfe011601 a
                where   a.t$stre$c = 6          --estornado
                group by a.t$oper$c, a.t$fire$c, a.t$stre$c ) DATA_REC
           ON DATA_REC.t$oper$c = 2
          AND DATA_REC.t$fire$c = tdrec940.t$fire$l

    LEFT JOIN baandb.ttdrec949601 tdrec949
           ON tdrec949.t$fire$l = tdrec940.t$fire$l
          AND tdrec949.t$brty$l = 3   -- IPI

    LEFT JOIN ( select  MIN(brnfe020.t$date$l)  AUTORIZADA,
                        brnfe020.t$ncmp$l,
                        brnfe020.t$refi$l
                from    baandb.tbrnfe020601 brnfe020
                where   brnfe020.t$stat$l = 1
                group by brnfe020.t$ncmp$l, brnfe020.t$refi$l) DT_NFE_REC
           ON DT_NFE_REC.t$ncmp$l = 601
          AND DT_NFE_REC.t$refi$l = tdrec940.t$fire$l

LEFT JOIN baandb.ttttxt010301 tttxt010r
       ON tttxt010r.t$ctxt = tdrec940.t$obse$l
      AND tttxt010r.t$clan = 'p'
      AND tttxt010r.t$seqe = 1

    LEFT JOIN baandb.ttcmcs966601 tcmcs966
           ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l


    WHERE tdrec940.t$stat$l IN (4,5,6)
    AND    tdrec940.t$cnfe$l != ' '
    AND tdrec940.t$doty$l != 8    --8-conhecimento de frete
    AND tdrec940.t$rfdt$l != 14    --Nota de Débito-14
UNION

SELECT DISTINCT
  'NIKE.COM'                FILIAL,                                 --02
  tccom130f.t$fovn$l        CGC_FILIAL_DESTINO,                     --03
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            EMISSAO,                                --04
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
        0.0
  ELSE  SLI941.QTDE END     QTDE_TOTAL,                             --05
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
        0.0
  ELSE cisli940.t$amnt$l END  VALOR_TOTAL,                            --06
  /*
  CASE WHEN cisli940.t$fdty$l = 1 or        --Venda com pedido
            cisli940.t$fdty$l = 14 or       --Retorno de mercadoria cliente
            cisli940.t$fdty$l = 15 or       --Remessa triangular
            cisli940.t$fdty$l = 16 THEN     --Fatura triangular
    tccom130c.t$fovn$l
  ELSE '' END               CGC_CPF,                                --07
   */
  tccom130c.t$fovn$l        CGC_CPF,                                 --07
  tccom130c.t$fovn$l        COD_CLIFOR,                             --08
  cast(NVL(tttxt010f.t$text,'') as varchar(100))         OBS,      --09
  cisli940.t$seri$l         SERIE_NF,                               --10
  cisli940.t$docn$l         NF_NUMERO,                              --11
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_NF,                          --12
  cisli940.t$ccfo$l         CODIGO_FISCAL_OPERACAO,                 --13
  0                         RECEBIMENTO,                            --14
  cisli940.t$nwgt$l         PESO_LIQUIDO,                           --15
  cisli940.t$gwgt$l         PESO_BRUTO,                             --16
  NVL(FMD630.VOLUMES,SLI941.QTDE)     VOLUMES,                      --17
  ''                       TIPO_VOLUME,                            --18
  ''                       MARCA_VOLUME,                           --19
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
        0.0
  ELSE cisli940.t$fght$l END                          FRETE,                          --20
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
        0.0
  ELSE cisli940.t$insr$l END                          SEGURO,                         --21
  0                                                   FRETE_A_PAGAR,                  --22
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
        0.0
  ELSE cisli940.t$gamt$l - SLI941.DESCONTO END        VALOR_TOTAL_ITENS,              --23
  0.00                                                DESCONTO,                       --24
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
      0.0
  ELSE cisli940.t$gexp$l END                          ENCARGO,                        --25
  CASE WHEN cisli940.t$stat$l >= 5  THEN
        '1'       -- NF impressa
  ELSE  '0' END                                       NOTA_IMPRESSA,                  --26
  CASE WHEN cisli940.t$fdty$l = 16 THEN   --Fatura Operação Triangular
        tccom130rem.t$nama
  ELSE cisli940.t$cfrn$l END                          TRANSP_RAZAO_SOCIAL,            --27
  CASE WHEN cisli940.t$fdty$l = 16 THEN   --Fatura Operação Triangular
        tccom130rem.t$cste
  ELSE  tccom130ft.t$cste END                         TRANSP_UF,                      --28
  CASE WHEN cisli940.t$fdty$l = 16 THEN
        tccom139rem.t$dsca
  ELSE  tccom139ft.t$dsca   END                       TRANSP_CIDADE,                  --29
  CASE WHEN cisli940.t$fdty$l = 16 THEN
        tccom130rem.t$fovn$l
  ELSE  tccom130ft.t$fovn$l END                       TRANSP_CGC,                     --30
  CASE WHEN cisli940.t$fdty$l = 16 THEN
        tccom966rem.t$stin$d
  ELSE tccom966f.t$stin$d END                         TRANSP_INSCRICAO,               --31
  CASE WHEN cisli940.t$fdty$l = 16 THEN
        tccom130rem.t$namc || ' ' ||
        tccom130rem.t$hono || ' ' ||
        tccom130rem.t$namd
  ELSE
        tccom130ft.t$namc || ' ' ||
        tccom130ft.t$hono || ' ' ||
        tccom130ft.t$namd               END           TRANSP_ENDERECO,                --32
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
    DATA_FAT.ESTORNADO
  ELSE  NULL END            DATA_CANCELAMENTO,                      --33
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
    SLI941.QTDE
  ELSE 0.00 END             QTDE_CANCELADA,                         --34
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
    cisli940.t$amnt$l
  ELSE 0.00 END             VALOR_CANCELADO,                        --35
  CASE WHEN cisli940.t$stat$l = 2 THEN  --CANCELAR
    '1'
  ELSE '0' END              NOTA_CANCELADA,                          --36
  ''                       INDICA_CONSUMIDOR_FINAL,                 --37
  ''                       TIPO_ORIGEM,                             --38
  NVL(cisli942.t$amnt$l,0)  VALOR_IMPOSTO_AGREGAR,                   --39
  ''                       EMPRESA,                                 --40
  cisli940.t$cnfe$l         CHAVE_NFE,                               --41
  cisli940.t$prot$l         PROTOCOLO_AUTORIZACAO_NFE,               --42
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(DT_NFE_FAT.AUTORIZADA, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_AUTORIZACAO_NFE,                    --43
  ''                       GERAR_AUTOMATICO,                        --44
  CASE WHEN cisli940.t$stat$l = 2 THEN    --CANCELADO
    '49'
  ELSE '5' END              STATUS_NFE,                              --45

  CASE WHEN cisli940.t$nfel$l = 1 THEN
    '0'
  ELSE '99' END             LOG_STATUS_NFE,                          --46
  cisli959.t$rsds$l         MOTIVO_CANCELAMENTO_NFE,                 --47
  ''                       PRIORIZACAO,                             --48
  SUBSTR(cisli940.t$cnfe$l,35,1)    TIPO_EMISSAO_NFE,                --49
    CASE WHEN cisli940.t$fdty$l IN (6,7)
    THEN  2
  WHEN cisli940.t$fdty$l = 8
    THEN 3
  ELSE 1 END                 FIN_EMISSAO_NFE,                         --50
  ''    REGISTRO_DPEC,                           --51
  ''                       PIN,                                     --52
  CASE WHEN SUBSTR(cisli940.t$cnfe$l,35,1) != '1' THEN
        DPEC.DT
  ELSE  NULL END           DATA_REGISTRO_DPEC,                       --53
  CASE WHEN cisli940.t$nfes$l = 3 THEN    --Pedido Cancelamento
        cisli940.t$prot$l
  ELSE '' END              PROTOCOLO_CANCELAMENTO_NFE,              --54
  (SELECT
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(A.t$date$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
   FROM baandb.tbrnfe020601 A
   WHERE A.t$ncmp$l = cisli940.t$sfcp$l
   AND A.t$refi$l = cisli940.t$fire$l
   AND A.t$ioin$l=1
   AND A.t$actn$l='IN')      DATA_CONTINGENCIA,                       --55
  ''                        JUSTIFICATIVA_CONTINGENCIA,              --56  É ENVIADO COMO BRANCO
  ''                       OBS_INTERESSE_FISCO,                     --57
  '0'                       TRANSP_PF_PJ,                            --58
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS410.DT_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_ETR,                          --59
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
    tccom130entr.t$namc
  ELSE tccom130fat.t$namc  END                            ENTREGA_ENDERECO,                        --60
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$hono
  ELSE tccom130fat.t$hono END                             ENTREGA_NUMERO,                          --61
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
       tccom130entr.t$bldg
  ELSE tccom130fat.t$bldg END                             ENTREGA_COMPLEMENTO,                     --62
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$cste
  ELSE tccom130fat.t$cste END                             ENTREGA_UF,                              --63
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom139entr.t$dscb$c
  ELSE tccom139fat.t$dscb$c END                           ENTREGA_CIDADE,                          --64
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$dist$l
  ELSE tccom130fat.t$dist$l END                           ENTREGA_BAIRRO,                          --65
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$pstc
  ELSE tccom130fat.t$pstc END                             ENTREGA_CEP,                             --66
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telp,3,9)
  ELSE SUBSTR(tccom130fat.t$telp,3,9) END                 ENTREGA_TELEFONE,                        --67
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telp,1,2)
  ELSE SUBSTR(tccom130fat.t$telp,1,2) END                 ENTREGA_DDD,                             --68
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telx,1,2)
  ELSE SUBSTR(tccom130fat.t$telx,1,2) END                 ENTREGA_DDD_CELULAR,                     --69
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telx,3,9)
  ELSE SUBSTR(tccom130fat.t$telx,3,9) END                 ENTREGA_CELULAR,                         --70
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$nama
  ELSE tccom130fat.t$nama END                             ENTREGA_NOME_DESTINATARIO,               --71
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      '1'
  ELSE '0' END                                            ENTREGA_DEST_COMPR,                      --72
  CASE WHEN SLS004.ENTREGA IS NULL THEN
      CASE WHEN (cisli940.t$fdty$l = 16 and SLS004_REM.ENTREGA is not null) THEN   --Fatura Triangular e nota não cancelada
            TO_CHAR(SLS004_REM.ENTREGA)
      ELSE TO_CHAR(cisli940.t$docn$l) || cisli940.t$seri$l END
  ELSE TO_CHAR(SLS004.ENTREGA) END
                            NUMERO_PEDIDO_VENDA,                    --73
  'S'                       TP_MOVTO,                                --74 Criado para separar na tabela as entradas e saídas
  cisli940.t$fdtc$l         COD_TIPO_DOC_FISCAL,                     --75 Criado para ser combinado junto com o CFOP
  tcmcs966.t$dsca$l         DESCR_COD_TIPO_DOC_FISCAL,               --76
  cisli940.t$fire$l         REF_FISCAL,                              --77
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$sadt$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DT_ULT_ALTERACAO,                        --78
  tccom139entr.t$ibge$l        COD_IBGE                                  --79

FROM  baandb.tcisli940601  cisli940

    LEFT JOIN baandb.ttccom130601 tccom130f           --filial emitente
           ON tccom130f.t$cadr=cisli940.t$sfra$l

    LEFT JOIN baandb.ttccom100601 tccom100f
           ON tccom100f.t$bpid = cisli940.t$bpid$l

    LEFT JOIN baandb.ttccom130601 tccom130c
           ON tccom130c.t$cadr = tccom100f.t$cadr

    LEFT JOIN ( select sum(a.t$tldm$l) DESCONTO,
                       sum(a.t$dqua$l) QTDE,
                        a.t$fire$l
                from  baandb.tcisli941601 a,
                      baandb.tznsls000601 b
                where b.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                and   a.t$item$l != b.t$itmf$c      --ITEM FRETE
                and   a.t$item$l != b.t$itmd$c      --ITEM DESPESAS
                and   a.t$item$l != b.t$itjl$c      --ITEM JUROS
                group by a.t$fire$l ) SLI941
           ON SLI941.t$fire$l = cisli940.t$fire$l


    LEFT JOIN baandb.ttccom130601 tccom130ft         --transportadora faturamento
           ON tccom130ft.t$cadr=cisli940.t$cfra$l

    LEFT JOIN baandb.ttccom966601 tccom966f
           ON tccom966f.t$comp$d = tccom130ft.t$comp$d

    LEFT JOIN baandb.ttccom139301 tccom139ft
           ON tccom139ft.t$ccty = tccom130ft.t$ccty
          AND tccom139ft.t$cste = tccom130ft.t$cste
          AND tccom139ft.t$city = tccom130ft.t$ccit

    LEFT JOIN baandb.ttccom139301 tccom139f
           ON tccom139f.t$ccty = tccom130f.t$ccty
          AND tccom139f.t$cste = tccom130f.t$cste
          AND tccom139f.t$city = tccom130f.t$ccit

   LEFT JOIN baandb.ttccom139301 tccom139c
           ON tccom139c.t$ccty = tccom130c.t$ccty
          AND tccom139c.t$cste = tccom130c.t$cste
          AND tccom139c.t$city = tccom130c.t$ccit

    LEFT JOIN ( select  a.t$oper$c,
                        a.t$fire$c,
                        a.t$stfa$c,
                        MIN(a.t$data$c) ESTORNADO
                from    baandb.tznnfe011601 a
                where   a.t$stfa$c = 2  --CANCELAR
                group by a.t$oper$c, a.t$fire$c, a.t$stfa$c ) DATA_FAT
           ON DATA_FAT.t$oper$c = 1
          AND DATA_FAT.t$fire$c = cisli940.t$fire$l

    LEFT JOIN baandb.tcisli942601 cisli942
           ON cisli942.t$fire$l = cisli940.t$fire$l
          AND cisli942.t$brty$l = 3   -- IPI

    LEFT JOIN ( select  MIN(brnfe020.t$date$l)  AUTORIZADA,
                        brnfe020.t$ncmp$l,
                        brnfe020.t$refi$l
                from    baandb.tbrnfe020601 brnfe020
                where   brnfe020.t$stat$l = 1
                group by brnfe020.t$ncmp$l, brnfe020.t$refi$l) DT_NFE_FAT
           ON DT_NFE_FAT.t$ncmp$l = 601
          AND DT_NFE_FAT.t$refi$l = cisli940.t$fire$l

    LEFT JOIN baandb.tcisli959601 cisli959
           ON cisli959.t$rscd$l = cisli940.t$rscd$l

    LEFT JOIN baandb.ttccom130601 tccom130entr
           ON tccom130entr.t$cadr = cisli940.t$itoa$l

    LEFT JOIN baandb.ttccom130601 tccom130fat
           ON tccom130fat.t$cadr = cisli940.t$stoa$l

    LEFT JOIN baandb.ttccom139301  tccom139entr
           ON tccom139entr.t$ccty = tccom130entr.t$ccty
          AND tccom139entr.t$cste = tccom130entr.t$cste
          AND tccom139entr.t$city = tccom130entr.t$ccit

    LEFT JOIN baandb.ttccom139301  tccom139fat
           ON tccom139fat.t$ccty = tccom130fat.t$ccty
          AND tccom139fat.t$cste = tccom130fat.t$cste
          AND tccom139fat.t$city = tccom130fat.t$ccit

    LEFT JOIN ( select  MIN(cisli245.t$slso)  OV,
                        cisli245.t$fire$l
                from    baandb.tcisli245601 cisli245
                group by cisli245.t$fire$l )  SLI245
           ON SLI245.t$fire$l = cisli940.t$fire$l

    LEFT JOIN ( select  MIN(znsls004.t$entr$c)  ENTREGA,
                        znsls004.t$orno$c OV
                from    baandb.tznsls004601 znsls004
                group by znsls004.t$orno$c ) SLS004
           ON   SLS004.OV = SLI245.OV

    LEFT JOIN ( select  MAX(a.t$dtoc$c)  DT_OCORR,
                        a.t$entr$c
                from    baandb.tznsls410601 a
                where a.t$poco$c = 'ETR'
                group by a.t$entr$c ) SLS410
           ON   SLS410.t$entr$c = SLS004.ENTREGA

    LEFT JOIN ( select  COUNT(a.t$etiq$c)  VOLUMES,
                        a.t$fire$c
                from    baandb.tznfmd630601 a
                group by a.t$fire$c )  FMD630
           ON   FMD630.t$fire$c = cisli940.t$fire$l

LEFT JOIN baandb.ttttxt010301 tttxt010f
           ON tttxt010f.t$ctxt = cisli940.t$obse$l
          AND tttxt010f.t$clan = 'p'
          AND tttxt010f.t$seqe = 1

    LEFT JOIN baandb.ttcmcs966601 tcmcs966
           ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l

    LEFT JOIN (SELECT A.t$ncmp$l,
                      A.t$refi$l,
                      A.t$ioin$l,
                        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(A.t$date$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE) DT
              FROM    baandb.tbrnfe020601 A
              GROUP BY A.t$ncmp$l,
                       A.t$refi$l,
                       A.t$ioin$l ) DPEC
            ON DPEC.t$ncmp$l = cisli940.t$sfcp$l
           AND DPEC.t$refi$l = cisli940.t$fire$l
           AND DPEC.t$ioin$l = 2  --retorno

    LEFT JOIN ( select  a.t$refr$l,
                        a.t$fire$l
                from    baandb.tcisli941601 a
                group by a.t$refr$l, a.t$fire$l ) SLI941
           ON SLI941.t$fire$l = cisli940.t$fire$l

    LEFT JOIN ( select a.t$fire$l,
                       a.t$cfrw$l,
                       a.t$cfra$l,
                       a.t$docn$l,
                       a.t$seri$l
                from   baandb.tcisli940601 a
                where    a.t$fdty$l = 15) REF_REM    --REFERÊNCIA RELATIVA de Remessa
           ON REF_REM.t$fire$l = SLI941.t$refr$l

    LEFT JOIN baandb.ttccom130601 tccom130rem         --Endereço da Remessa Operação Triangular
           ON tccom130rem.t$cadr = REF_REM.t$cfra$l

    LEFT JOIN baandb.ttccom139301  tccom139rem
           ON tccom139rem.t$ccty = tccom130rem.t$ccty
          AND tccom139rem.t$cste = tccom130rem.t$cste
          AND tccom139rem.t$city = tccom130rem.t$ccit

    LEFT JOIN baandb.ttccom966601 tccom966rem
           ON tccom966rem.t$comp$d = tccom130rem.t$comp$d

    LEFT JOIN ( select  MIN(cisli245.t$slso)  OV,
                        cisli245.t$fire$l
                from    baandb.tcisli245601 cisli245
                group by cisli245.t$fire$l )  SLI245_REM
           ON SLI245_REM.t$fire$l = REF_REM.t$fire$l

    LEFT JOIN ( select  MIN(znsls004.t$entr$c)  ENTREGA,
                        znsls004.t$orno$c OV
                from    baandb.tznsls004601 znsls004
                group by znsls004.t$orno$c ) SLS004_REM
           ON   SLS004_REM.OV = SLI245_REM.OV

    LEFT JOIN ( select  MAX(a.t$dtoc$c)  DT_OCORR,
                        a.t$entr$c
                from    baandb.tznsls410601 a
                where a.t$poco$c = 'ETR'
                group by a.t$entr$c ) SLS410_REM
           ON   SLS410_REM.t$entr$c = SLS004_REM.ENTREGA

    WHERE cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND   cisli940.t$cnfe$l != ' '
    AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --status nota impressa
                  and   znnfe011.t$nfes$c = 5)  --status nfe processada
   AND      cisli940.t$fdty$l NOT IN (2,14)     --venda sem pedido, retorno mercadoria cliente
order by REF_FISCAL;
