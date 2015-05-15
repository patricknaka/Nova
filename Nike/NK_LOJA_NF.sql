SELECT DISTINCT
  'NIKE.COM'                FILIAL,                                 --02
  tccom130r.t$fovn$l        CGC_FILIAL_DESTINO,                     --03
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            EMISSAO,                                --04
  TDREC941.QTDE             QTDE_TOTAL,                             --05
  tdrec940.t$tfda$l         VALOR_TOTAL,                            --06
  ' '                       CGC_CPF,                                --07
  tdrec940.t$fovn$l         COD_CLIFOR,                             --08
  tttxt010r.t$text          OBS,                                    --09
  tdrec940.t$seri$l         SERIE_NF,                               --10
  tdrec940.t$docn$l         NF_NUMERO,                              --11
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$odat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_NF,                          --12
  tdrec940.t$opor$l         NATUREZA_OPERACAO_CODIGO,               --13
  '1'                       RECEBIMENTO,                            --14
  tdrec940.t$nwgt$l         PESO_LIQUIDO,                           --15
  tdrec940.t$gwgt$l         PESO_BRUTO,                             --16
  0                         VOLUMES,                                --17
  ' '                       TIPO_VOLUME,                            --18
  ' '                       MARCA_VOLUME,                           --19
  tdrec940.t$fght$l         FRETE,                                  --20
  tdrec940.t$insr$l         SEGURO,                                 --21
  'AGUARDANDO CONSULTOR'    FRETE_A_PAGAR,                          --22
  tdrec940.t$gtam$l         VALOR_TOTAL_ITENS,                      --23
  tdrec940.t$addc$l         DESCONTO,                               --24
  tdrec940.t$gexp$l         ENCARGO,                                --25
  CASE WHEN tdrec940.t$stat$l = 4 or tdrec940.t$stat$l = 5 THEN
        '1'       -- NF impressa
  ELSE  '0' END                  NOTA_IMPRESSA,                     --26
  tdrec940.t$cfrn$l              TRANSP_RAZAO_SOCIAL,               --27
  NVL(tccom130t.t$cste,' ')      TRANSP_UF,                         --28
  NVL(tccom139r.t$dsca,' ')      TRANSP_CIDADE,                     --29
  NVL(tccom130t.t$fovn$l,' ')    TRANSP_CGC,                        --30
  NVL(tccom966r.t$stin$d,' ')    TRANSP_INSCRICAO,                  --31
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
  ' '                       INDICA_CONSUMIDOR_FINAL,                 --37
  ' '                       TIPO_ORIGEM,                             --38
  NVL(tdrec949.t$amnt$l,0)  VALOR_IMPOSTO_AGREGAR,                   --39
  ' '                       EMPRESA,                                 --40
  tdrec940.t$cnfe$l         CHAVE_NFE,                               --41
  ' '                       PROTOCOLO_AUTORIZACAO_NFE,               --42
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(DT_NFE_REC.AUTORIZADA, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_AUTORIZACAO_NFE,                    --43
  ' '                       GERAR_AUTOMATICO,                        --44
  CASE WHEN tdrec940.t$stat$l = 6 THEN    -- ESTORNADO
    '49'
  ELSE '5' END              STATUS_NFE,                              --45
                       
  CASE WHEN tdrec940.t$nfel$l = 1 THEN
    '0'
  ELSE '99' END             LOG_STATUS_NFE,                          --46      
  '      '                  MOTIVO_CANCELAMENTO_NFE,                 --47
  ' '                       PRIORIZACAO,                             --48
  'AGUARDANDO CONSULTOR'    TIPO_EMISSAO_NFE,                        --49
  'AGUARDANDO CONSULTOR'    FIN_EMISSAO_NFE,                         --50
  'AGUARDANDO CONSULTOR'    REGISTRO_DPEC,                           --51
  ' '                       PIN,                                     --52
  'AGUARDANDO CONSULTOR'    DATA_REGISTRO_DPEC,                      --53
  ' '                       PROTOCOLO_CANCELAMENTO_NFE,              --54
  'AGUARDANDO CONSULTOR'    DATA_CONTINGENCIA,                       --55
  'AGUARDANDO CONSULTOR'    JUSTIFICATIVA_CONTINGENCIA,              --56
  ' '                       OBS_INTERESSE_FISCO,                     --57
  '0'                       TRANSP_PF_PJ,                            --58
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$odat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_ETR,                              --59
  ' '                       ENTREGA_ENDERECO,                        --60
  ' '                       ENTREGA_NUMERO,                          --61
  ' '                       ENTREGA_COMPLEMENTO,                     --62
  ' '                       ENTREGA_UF,                              --63
  ' '                       ENTREGA_CIDADE,                          --64
  ' '                       ENTREGA_BAIRRO,                          --65
  ' '                       ENTREGA_CEP,                             --66
  ' '                       ENTREGA_TELEFONE,                        --67
  ' '                       ENTREGA_DDD,                             --68
  ' '                       ENTREGA_DDD_CELULAR,                     --69
  ' '                       ENTREGA_CELULAR,                         --70
  ' '                       ENTREGA_NOME_DESTINATARIO,               --71
  '0'                       ENTREGA_DEST_COMPR,                      --72
  ' '                       NUMERO_PEDIDO_VENDA                      --73
  
FROM  baandb.ttdrec940201  tdrec940

    LEFT JOIN baandb.ttccom130201 tccom130r
           ON tccom130r.t$cadr=tdrec940.t$sfra$l
           
    LEFT JOIN ( select  sum(a.t$qnty$l)  QTDE,
                        a.t$fire$l
                from    baandb.ttdrec941201 a
                group by a.t$fire$l ) TDREC941
           ON TDREC941.t$fire$l=tdrec940.t$fire$l
           
    LEFT JOIN baandb.ttccom130201 tccom130t         --transportadora
           ON tccom130t.t$cadr=tdrec940.t$cfra$l
           
    LEFT JOIN baandb.ttccom966201 tccom966r       
           ON tccom966r.t$comp$d = tccom130t.t$comp$d
    
    LEFT JOIN baandb.ttccom139201 tccom139r
           ON tccom139r.t$ccty = tccom130t.t$ccty
          AND tccom139r.t$cste = tccom130t.t$cste
          AND tccom139r.t$city = tccom130t.t$ccit
          
    LEFT JOIN ( select  a.t$oper$c,
                        a.t$fire$c,
                        a.t$stre$c,
                        MIN(a.t$data$c) ESTORNO
                from    baandb.tznnfe011201 a
                where   a.t$stre$c = 6          --estornado
                group by a.t$oper$c, a.t$fire$c, a.t$stre$c ) DATA_REC       
           ON DATA_REC.t$oper$c = 2
          AND DATA_REC.t$fire$c = tdrec940.t$fire$l
          
    LEFT JOIN baandb.ttdrec949201 tdrec949
           ON tdrec949.t$fire$l = tdrec940.t$fire$l
          AND tdrec949.t$brty$l = 3   -- IPI
           
    LEFT JOIN ( select  MIN(brnfe020.t$date$l)  AUTORIZADA,
                        brnfe020.t$ncmp$l,
                        brnfe020.t$refi$l
                from    baandb.tbrnfe020201 brnfe020
                where   brnfe020.t$stat$l = 1 
                group by brnfe020.t$ncmp$l, brnfe020.t$refi$l) DT_NFE_REC
           ON DT_NFE_REC.t$ncmp$l = 301
          AND DT_NFE_REC.t$refi$l = tdrec940.t$fire$l
          
     LEFT JOIN baandb.ttttxt010201 tttxt010r 
       ON tttxt010r.t$ctxt = tdrec940.t$obse$l
      AND tttxt010r.t$clan = 'p'
	    AND tttxt010r.t$seqe = 1
    
    WHERE tdrec940.t$stat$l IN (4,5,6)      
    
UNION

SELECT DISTINCT
  'NIKE.COM'                FILIAL,                                 --02
  tccom130f.t$fovn$l        CGC_FILIAL_DESTINO,                     --03
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            EMISSAO,                                --04
  SLI941.QTDE               QTDE_TOTAL,                             --05
  cisli940.t$amnt$l         VALOR_TOTAL,                            --06
  CASE WHEN cisli940.t$fdty$l = 1 or cisli940.t$fdty$l = 14 THEN
    tccom130c.t$fovn$l
  ELSE ' ' END              CGC_CPF,                                --07
  tccom130c.t$fovn$l        COD_CLIFOR,                             --08
  tttxt010f.t$text          OBS,                                    --09
  cisli940.t$seri$l         SERIE_NF,                               --10
  cisli940.t$docn$l         NF_NUMERO,                              --11
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_NF,                             --12
  cisli940.t$ccfo$l         NATUREZA_OPERACAO_CODIGO,               --13
  '0'                       RECEBIMENTO,                            --14
  cisli940.t$nwgt$l         PESO_LIQUIDO,                           --15
  cisli940.t$gwgt$l         PESO_BRUTO,                             --16
  NVL(FMD630.VOLUMES,SLI941.QTDE)     VOLUMES,                      --17
  ' '                       TIPO_VOLUME,                            --18
  ' '                       MARCA_VOLUME,                           --19
  cisli940.t$fght$l         FRETE,                                  --20
  cisli940.t$insr$l         SEGURO,                                 --21
  'AGUARDANDO CONSULTOR'    FRETE_A_PAGAR,                          --22
  cisli940.t$amnt$l         VALOR_TOTAL_ITENS,                      --23
  SLI941.DESCONTO           DESCONTO,                               --24
  cisli940.t$gexp$l         ENCARGO,                                --25
  CASE WHEN cisli940.t$stat$l >= 5  THEN
        '1'       -- NF impressa
  ELSE  '0' END             NOTA_IMPRESSA,                          --26
  cisli940.t$cfrn$l         TRANSP_RAZAO_SOCIAL,                    --27
  tccom130ft.t$cste         TRANSP_UF,                              --28
  tccom139f.t$dsca          TRANSP_CIDADE,                          --29
  tccom130ft.t$fovn$l       TRANSP_CGC,                             --30
  tccom966f.t$stin$d        TRANSP_INSCRICAO,                       --31
  tccom130ft.t$namc || ' ' ||
  tccom130ft.t$hono || ' ' ||
  tccom130ft.t$namd         TRANSP_ENDERECO,                        --32
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
  ' '                       INDICA_CONSUMIDOR_FINAL,                 --37
  ' '                       TIPO_ORIGEM,                             --38
  NVL(cisli942.t$amnt$l,0)  VALOR_IMPOSTO_AGREGAR,                   --39
  ' '                       EMPRESA,                                 --40
  cisli940.t$cnfe$l         CHAVE_NFE,                               --41
  cisli940.t$prot$l         PROTOCOLO_AUTORIZACAO_NFE,               --42
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(DT_NFE_FAT.AUTORIZADA, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_AUTORIZACAO_NFE,                    --43
  ' '                       GERAR_AUTOMATICO,                        --44
  CASE WHEN cisli940.t$stat$l = 2 THEN    --CANCELADO
    '49'
  ELSE '5' END              STATUS_NFE,                              --45
                       
  CASE WHEN cisli940.t$nfel$l = 1 THEN
    '0'
  ELSE '99' END             LOG_STATUS_NFE,                          --46      
  cisli959.t$rsds$l         MOTIVO_CANCELAMENTO_NFE,                 --47
  ' '                       PRIORIZACAO,                             --48
  'AGUARDANDO CONSULTOR'    TIPO_EMISSAO_NFE,                        --49
  'AGUARDANDO CONSULTOR'    FIN_EMISSAO_NFE,                         --50
  'AGUARDANDO CONSULTOR'    REGISTRO_DPEC,                           --51
  ' '                       PIN,                                     --52
  'AGUARDANDO CONSULTOR'    DATA_REGISTRO_DPEC,                      --53
  CASE WHEN cisli940.t$nfes$l = 3 THEN    --Pedido Cancelamento
        cisli940.t$prot$l         
  ELSE ' ' END              PROTOCOLO_CANCELAMENTO_NFE,              --54
  'AGUARDANDO CONSULTOR'    DATA_CONTINGENCIA,                       --55
  'AGUARDANDO CONSULTOR'    JUSTIFICATIVA_CONTINGENCIA,              --56
  ' '                       OBS_INTERESSE_FISCO,                     --57
  '0'                       TRANSP_PF_PJ,                            --58
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS410.DT_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                            DATA_SAIDA_ETR,                          --59
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
    tccom130entr.t$namc
  ELSE  ' ' END             ENTREGA_ENDERECO,                        --60
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$hono 
  ELSE ' ' END              ENTREGA_NUMERO,                          --61
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
       tccom130entr.t$bldg
  ELSE ' ' END              ENTREGA_COMPLEMENTO,                     --62
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$cste
  ELSE ' ' END              ENTREGA_UF,                              --63
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom139entr.t$dscb$c
  ELSE ' ' END              ENTREGA_CIDADE,                          --64
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$dist$l
  ELSE ' ' END              ENTREGA_BAIRRO,                          --65
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$pstc
  ELSE ' ' END              ENTREGA_CEP,                             --66
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telp,3,9)
  ELSE ' ' END              ENTREGA_TELEFONE,                        --67
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telp,1,2)
  ELSE ' ' END              ENTREGA_DDD,                             --68
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telx,1,2)
  ELSE ' ' END              ENTREGA_DDD_CELULAR,                     --69
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      SUBSTR(tccom130entr.t$telx,3,9)
  ELSE ' ' END              ENTREGA_CELULAR,                         --70
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      tccom130entr.t$nama
  ELSE ' ' END              ENTREGA_NOME_DESTINATARIO,               --71
  CASE WHEN cisli940.t$itoa$l != cisli940.t$stoa$l THEN
      '1'
  ELSE '0' END              ENTREGA_DEST_COMPR,                      --72
  CASE WHEN SLS004.ENTREGA = 0 THEN
      TO_CHAR(cisli940.t$docn$l) || cisli940.t$seri$l
  ELSE TO_CHAR(SLS004.ENTREGA) END   
                            NUMERO_PEDIDO_VENDA                      --73
  
FROM  baandb.tcisli940201  cisli940

    LEFT JOIN baandb.ttccom130201 tccom130f           --filial emitente
           ON tccom130f.t$cadr=cisli940.t$sfra$l

    LEFT JOIN baandb.ttccom100201 tccom100f
           ON tccom100f.t$bpid = cisli940.t$bpid$l
           
    LEFT JOIN baandb.ttccom130201 tccom130c
           ON tccom130c.t$cadr = tccom100f.t$cadr
                  
    LEFT JOIN ( select sum(a.t$ldam$l) DESCONTO,
                       sum(a.t$dqua$l) QTDE,
                        a.t$fire$l
                from  baandb.tcisli941201 a,
                      baandb.tznsls000201 b
                where b.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                and   a.t$item$l != b.t$itmf$c      --ITEM FRETE
                and   a.t$item$l != b.t$itmd$c      --ITEM DESPESAS
                and   a.t$item$l != b.t$itjl$c      --ITEM JUROS
                group by a.t$fire$l ) SLI941
           ON SLI941.t$fire$l = cisli940.t$fire$l
  
    
    LEFT JOIN baandb.ttccom130201 tccom130ft         --transportadora faturamento
           ON tccom130ft.t$cadr=cisli940.t$cfra$l
           
    LEFT JOIN baandb.ttccom966201 tccom966f       
           ON tccom966f.t$comp$d = tccom130ft.t$comp$d
    
    LEFT JOIN baandb.ttccom139201 tccom139f
           ON tccom139f.t$ccty = tccom130ft.t$ccty
          AND tccom139f.t$cste = tccom130ft.t$cste
          AND tccom139f.t$city = tccom130ft.t$ccit
          
    LEFT JOIN ( select  a.t$oper$c,
                        a.t$fire$c,
                        a.t$stfa$c,
                        MIN(a.t$data$c) ESTORNADO
                from    baandb.tznnfe011201 a
                where   a.t$stfa$c = 101  --ESTORNADO
                group by a.t$oper$c, a.t$fire$c, a.t$stfa$c ) DATA_FAT       
           ON DATA_FAT.t$oper$c = 1
          AND DATA_FAT.t$fire$c = cisli940.t$fire$l
          
    LEFT JOIN baandb.tcisli942201 cisli942
           ON cisli942.t$fire$l = cisli940.t$fire$l
          AND cisli942.t$brty$l = 3   -- IPI
           
    LEFT JOIN ( select  MIN(brnfe020.t$date$l)  AUTORIZADA,
                        brnfe020.t$ncmp$l,
                        brnfe020.t$refi$l
                from    baandb.tbrnfe020201 brnfe020
                where   brnfe020.t$stat$l = 1 
                group by brnfe020.t$ncmp$l, brnfe020.t$refi$l) DT_NFE_FAT
           ON DT_NFE_FAT.t$ncmp$l = 301
          AND DT_NFE_FAT.t$refi$l = cisli940.t$fire$l
          
    LEFT JOIN baandb.tcisli959201 cisli959
           ON cisli959.t$rscd$l = cisli940.t$rscd$l
           
    LEFT JOIN baandb.ttccom130201 tccom130entr
           ON tccom130entr.t$cadr = cisli940.t$stoa$l
           
    LEFT JOIN baandb.ttccom139201  tccom139entr
           ON tccom139entr.t$ccty = tccom130entr.t$ccty
          AND tccom139entr.t$cste = tccom130entr.t$cste
          AND tccom139entr.t$city = tccom130entr.t$ccit
           
    LEFT JOIN ( select  MIN(cisli245.t$slso)  OV,
                        cisli245.t$fire$l
                from    baandb.tcisli245201 cisli245
                group by cisli245.t$fire$l )  SLI245
           ON SLI245.t$fire$l = cisli940.t$fire$l
           
    LEFT JOIN ( select  MIN(znsls004.t$entr$c)  ENTREGA,
                        znsls004.t$orno$c OV
                from    baandb.tznsls004201 znsls004
                group by znsls004.t$orno$c ) SLS004
           ON   SLS004.OV = SLI245.OV
    
    LEFT JOIN ( select  MAX(a.t$dtoc$c)  DT_OCORR,
                        a.t$entr$c
                from    baandb.tznsls410201 a
                where a.t$poco$c = 'ETR'  
                group by a.t$entr$c ) SLS410
           ON   SLS410.t$entr$c = SLS004.ENTREGA
           
    LEFT JOIN ( select  COUNT(a.t$etiq$c)  VOLUMES,
                        a.t$fire$c
                from    baandb.tznfmd630201 a
                group by a.t$fire$c )  FMD630
           ON   FMD630.t$fire$c = cisli940.t$fire$l
           
    LEFT JOIN baandb.ttttxt010201 tttxt010f 
           ON tttxt010f.t$ctxt = cisli940.t$obse$l
          AND tttxt010f.t$clan = 'p'
          AND tttxt010f.t$seqe = 1
      
    WHERE cisli940.t$stat$l IN (5,6,101)

    AND CISLI940.T$FIRE$L = 'F20000746'
