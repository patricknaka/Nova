select Q1.* from ( SELECT 
                     DISTINCT
                       ' '                     COMPRADOR,                     --01
                       tfacr200.t$docd         DT_EMISSAO,                    --02
                       ' '                     TP_CONTRATO,                   --03
                       znrec007.t$cvpc$c       ID_CONTRATO,                   --04
                       znrec007.t$cvpc$c       COD_CONTRATO,                  --05
                       znrec007.t$logn$c       USUARIO,                       --06
                       znrec007.t$fovn$c       CNPJ,                          --07
                       tccom100.t$nama         RAZAO_SOCIAL,                  --08
                       znrec007.t$amnt$c       VALOR_CONTRATO,                --09
                       znrec007.t$dept$c       ID_DEPTO,                      --10
                       tcmcs023.t$dsca         NOME_DEPTO,                    --11
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE)
                                               DT_ASSINATURA,                 --12
                       ' '                     ASSINATURA_FORNEC,             --13
                       ' '                     ASSINATURA_CIA,                --14
                       VPC.STATUS              SITUACAO,                      --15
                       znrec007.t$paym$c       TIPO_PAGAMENTO,                --16
                       znrec007.t$mvpc$c       ID_MODALIDADE,                 --17
                       ' '                     DESC_MODALIDADE,               --18
                       ' '                     DOCUMENTO,                     --19
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$datf$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE)
                                              INICIO_VIGENCIA,                --20
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$datp$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE)
                                              DT_VENCIMENTO,                  --21
                       ' '                    DT_CONTRATO,                    --22
                       VPC.STATUS             APURACAO_GERADA,                --23
                       ' '                    DT_APURACAO,                    --24
                       znrec007.t$amnt$c      VL_APURADO,                     --25
                       ' '                    COBRANCA_GERADA,                --26
                       tfacr200.t$docd        DT_COBRANCA,                    --27
                       ' '                    VL_COBRADO,                     --28
                       ' '                    VL_AJUSTADO,                    --29
                       tfacr200.t$ttyp ||
                       tfacr200.t$ninv        TITULO_CAR,                     --30
                       ' '                    FILIAL_CAR,                     --31
                       
                       CASE WHEN sum(tfacr200.t$balc) = 0 
                            THEN 'Liquidado' 
                            ELSE   'Aberto' 
                        END                   SITUACAO_CAR,                   --32
                        
                                             
                       CASE WHEN sum(tfacr200.t$balc) = 0 
                              THEN ( select max(a.t$docd) 
                                       from baandb.ttfacr200201 a 
                                      where a.t$ttyp = tfacr200.t$ttyp 
                                        and a.t$ninv = tfacr200.t$ninv )
                        ELSE NULL END         DATA_LIQUIDACAO_CAR,            --33
                        
                       tfacr200.t$docd        EMISSAO_TITULO_CAR,             --34
                             
                       tfacr200.t$dued        DT_VENCIMENTO_CAR,              --35
                                             
                       tfacp200t.t$ttyp  ||
                       tfacp200t.t$ninv         TITULO_CAP,                   --36
                       
                       CASE WHEN sum(tfacp200t.t$balc) = 0 
                            THEN 'Liquidado' 
                            ELSE   'Aberto' 
                        END                     SITUACAO_CAP,                 --37 
                     
                        ' '                     FILIAL_CAP,                   --38
                        
                       CASE WHEN sum(tfacp200t.t$balc) = 0 
                              THEN ( select max(a.t$docd) 
                                       from baandb.ttfacp200201 a 
                                      where a.t$ttyp = tfacp200t.t$ttyp 
                                        and a.t$ninv = tfacp200t.t$ninv )
                        ELSE NULL END           DATA_LIQUIDACAO_CAP,          --39
                        tfacp200t.t$docd        EMISSAO_TITULO_CAP,           --40
                        tfacp200t.t$dued        DT_VENCIMENTO_CAP             --41
                         
                   FROM baandb.ttfacr200201 tfacr200

             INNER JOIN baandb.ttfacr200201 tfacr200t
                     ON tfacr200t.t$ttyp = tfacr200.t$ttyp
                    AND tfacr200t.t$ninv = tfacr200.t$ninv				   
			 
                 
             INNER JOIN baandb.tznrec007201 znrec007
                     ON znrec007.t$ttyp$c = tfacr200.t$ttyp 
                    AND znrec007.t$docn$c = tfacr200.t$ninv   
             
             INNER JOIN baandb.ttccom100201 tccom100
                     ON tccom100.t$bpid = tfacr200.t$itbp

             LEFT JOIN baandb.ttcmcs023201  tcmcs023
                    ON tcmcs023.t$citg=znrec007.t$dept$c
             
             INNER JOIN baandb.ttfacp200201 tfacp200
                     ON tfacp200.t$tdoc = tfacr200.t$tdoc
                    AND tfacp200.t$docn = tfacr200.t$docn
             
             INNER JOIN baandb.ttfacp200201 tfacp200t
                     ON tfacp200t.t$ttyp = tfacp200.t$ttyp
                    AND tfacp200t.t$ninv = tfacp200.t$ninv
             
             
              LEFT JOIN ( select l.t$desc STATUS,
                                 d.t$cnst
                            from baandb.tttadv401000 d,
                                 baandb.tttadv140000 l
                           where d.t$cpac = 'zn'        
                             and d.t$cdom = 'rec.svpc.c'       
                             and l.t$clan = 'p'
                             and l.t$cpac = 'zn' 
                             and l.t$clab = d.t$za_clab
                             and rpad(d.t$vers,4) ||
                                 rpad(d.t$rele,2) ||
                                 rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                                 rpad(l1.t$rele,2) ||
                                                                 rpad(l1.t$cust,4)) 
                                                        from baandb.tttadv401000 l1 
                                                       where l1.t$cpac = d.t$cpac 
                                                         and l1.t$cdom = d.t$cdom )
                             and rpad(l.t$vers,4) ||
                                 rpad(l.t$rele,2) ||
                                 rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                                 rpad(l1.t$rele,2) ||
                                                                 rpad(l1.t$cust,4)) 
                                                        from baandb.tttadv140000 l1 
                                                       where l1.t$clab = l.t$clab 
                                                         and l1.t$clan = l.t$clan 
                                                         and l1.t$cpac = l.t$cpac )) VPC
                     ON VPC.t$cnst = znrec007.t$svpc$c
                   
                  WHERE tfacr200.t$tdoc = 'ENC'
                    AND tfacr200.t$amnt < 0
                    AND tfacp200t.t$lino = 0
                    AND tfacr200t.t$lino = 0
                    
                 HAVING SUM(tfacr200t.t$balc) = 0 

               GROUP BY
                       znrec007.t$logn$c,
                       tfacr200.t$docd,
                       znrec007.t$cvpc$c,
                       znrec007.t$fovn$c,
                       tccom100.t$nama,
                       znrec007.t$dept$c,
                       tcmcs023.t$dsca,
                        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE),
                       znrec007.t$svpc$c,
                       znrec007.t$paym$c,
                       znrec007.t$mvpc$c,
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$datf$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE),
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znrec007.t$datp$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE),
                        VPC.STATUS,
                        znrec007.t$amnt$c,
                        tfacr200.t$docd,
                        tfacr200.t$ttyp, 
                        tfacr200.t$ninv, 
                        tfacr200.t$tdoc,
                        tfacr200.t$dued,
                        tfacr200.t$docn,                         
                        tfacr200.t$itbp,
                        tfacp200t.t$ttyp, 
                        tfacp200t.t$ninv,
                        tfacp200t.t$docn$l, 
                        tfacp200t.t$seri$l,
                        tfacp200t.t$tpay,
                        tfacp200t.t$docd,
                        tfacp200t.t$dued,
                        tfacr200.t$docd, 
                        tfacr200.t$amnt,
                        znrec007.t$cvpc$c,
                        znrec007.t$amnt$c,
                        tfacp200t.t$balc,
                        tfacp200.t$schn		) Q1
                 
