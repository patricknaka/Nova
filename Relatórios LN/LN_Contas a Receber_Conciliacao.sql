SELECT Q1.*
  FROM ( SELECT
             301                                                CIA,

             CASE WHEN nvl( ( FILIAL.t$styp), 0 ) = 0 
                    THEN 2 
                  ELSE 3 
             END                                                FILIAL, 
            
             prg_mov.t$ninv                                     TITULO,
             prg_mov.t$rpst$l                                   SITUACAO_TITULO, 
             SIT_TIT.                                           DESCR_SIT_TIT,
             prg_mov.t$ttyp                                     DOC,
             tccom130.t$fovn$l                                  CNPJ,
             tccom100.t$nama                                    NOME,
             prg_mov.t$docd                                     DT_EMISSAO,
             prg_mov.t$amnt                                     VL_TITULO,
             prg_mov.t$balc                                     VL_SALDO_TITULO,
             prg_mov.t$paym                                     CARTEIRA,
             tfcmg011.t$baoc$l                                  CD_BANCO,
             tfcmg011.t$agcd$l                                  NR_AGENCIA,
             tfcmg001.t$bano                                    NR_CONTA_CORRENTE,
             prg_mov.t$schn                                     NR_DOCUMENTO,
             titulo.t$leac                                      CENTRO_CUSTO,
             prg_mov.t$recd                                     DT_VENCIMENTO,
             prg_mov.t$dued$l                                   DT_VENCIMENTO_ORIGINAL,
             
             CASE WHEN titulo.t$balc = 0 
                    THEN ( SELECT MAX(p.t$docd) 
                             FROM baandb.ttfacr200301 p
                            WHERE p.t$ttyp = titulo.t$ttyp 
                           AND p.t$ninv = titulo.t$ninv ) 
                  ELSE NULL 
              END                                               DT_LIQUIDACAO_TITULO,
            
             tfcmg401.t$btno                                    REMESSA,
             tfcmg409.t$date                                    DT_REMESSA,
             cisli940.t$docn$l                                  NOTA,
             cisli940.t$seri$l                                  SERIE,
             cisli940.t$fire$l                                  REF_FISCAL,
             prg_mov.t$brel                                     NR_BANCARIO,
             znsls412.t$uneg$c                                  UNID_NEGOCIO,
             znint002.t$desc$c                                  DESC_UNID_NEGOCIO,
             nvl( (t.t$text),' ' )                              OBSERVACAO,
             znrec007.t$logn$c                                  USUARIO,
             znsls400.t$idcp$c                                  CAMPANHA,
             znrec007.t$cvpc$c                                  CONTRATO_VPC,
             prg_mov.t$tdoc                                     ID_TRANSACAO,
             gld011.t$desc                                      TRANSACAO, 
             prg_mov.t$docd                                     DATA_TRANSACAO,
             
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.t$ttyp$c, tref.t$ttyp) 
                  ELSE NULL 
              END                                               TITULO_REFERENCIA,
             
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.t$ninv$c, tref.t$ninv) 
                  ELSE NULL 
              END                                               DOCUMENTO_REFERENCIA,
             
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.DT_VENC, tref.DT_VENC) 
                  ELSE NULL 
              END                                               DATA_VENCTO_TIT_REFM,
                  
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.DT_LIQ, tref.DT_LIQ) 
                  ELSE NULL 
              END                                               DATA_LIQUID_TIT_REF,
             
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.t$docd, tref.t$docd) 
                  ELSE NULL 
              END                                               DATA_TRANSACAO_TIT_REF,
             
             CASE WHEN prg_mov.t$docn ! =  0 
                    THEN nvl(agrup.t$amnt, tref.t$amnt) 
                  ELSE NULL 
              END                                               VALOR_TRANSACAO_TIT_REF,
             
             znsls400.t$logf$c                                  ENDERECO,
             znsls400.t$numf$c                                  NUMERO,
             znsls400.t$baif$c                                  BAIRRO,
             znsls400.t$cidf$c                                  CIDADE,
             znsls400.t$uffa$c                                  UF,
             znsls400.t$cepf$c                                  CEP,
             znsls400.t$telf$c                                  TELEFONE,
             znsls412.t$orno$c                                  ENTREGA,
             znsls400.t$peex$c                                  PEDIDO_EXTERNO,
             tfcmg409.t$stdd                                    SITUACAO_REMESSA,
             SIT_REM.                                           DESCR_SIT_REM,
             znsls402.t$idmp$c                                  MEIO_PAGAMENTO,
             zncmg007.t$desc$c                                  DESCR_MEIO_PGTO, 
             znsls410.t$poco$c                                  ULTIMO_PONTO,
             znmcs002.t$desc$c                                  DESCR_ULT_PONTO, 
			 
             CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                                                DATA_EMISSAO_NF,
			 
             cisli940.t$stat$l                                  SITUACAO_NF,
             SITUACAO_NF.                                       DESCR_SITUACAO_NF,

             CASE WHEN ( prg_mov.t$rpst$l ! =  4 AND prg_mov.t$recd < Trunc(SYSDATE) )
                    THEN Trunc(SYSDATE) - prg_mov.t$recd
                  ELSE NULL 
              END                                               TEMPO_ATRASO,
       
             titulo.t$itbp                                      COD_PARCEIRO,
             prg_mov.t$amnt                                     VALOR_TRANSACAO,
             tccom130.t$info                                    EMAIL

         
        FROM    ( select nvl(tfacr201.t$ttyp, tfacr200.t$ttyp) t$ttyp,
                         nvl(tfacr201.t$ninv, tfacr200.t$ninv) t$ninv,
                         nvl(tfacr201.t$schn, tfacr200.t$schn) t$schn,
                         tfacr201.t$rpst$l,
                         nvl(tfacr201.t$docd, tfacr200.t$docd) t$docd,
                         tfacr201.t$amnt,
                         tfacr201.t$balc,
                         tfacr201.t$paym,
                         tfacr201.t$brel,
                         tfacr200.t$tdoc,
                         tfacr200.t$docn,
                         tfacr201.t$recd,
                         tfacr201.t$dued$l,
                         nvl(tfacr200.t$itbp, tfacr200.t$itbp) t$itbp
                    from baandb.ttfacr201301 tfacr201
         
        FULL OUTER JOIN ( select sq.* 
                            from baandb.ttfacr200301 sq 
                           where sq.t$docn ! =  0 ) tfacr200 
                     ON tfacr200.t$ttyp = tfacr201.t$ttyp 
                    AND tfacr200.t$ninv = tfacr201.t$ninv
                    AND tfacr200.t$schn = tfacr201.t$schn ) prg_mov
            
        INNER JOIN baandb.ttfacr200301 titulo 
                ON titulo.t$ttyp = prg_mov.t$ttyp 
               AND titulo.t$ninv = prg_mov.t$ninv 
               AND titulo.t$docn = 0
            
        INNER JOIN baandb.ttccom100301 tccom100 
                ON tccom100.t$bpid = titulo.t$itbp 
          
        INNER JOIN baandb.ttccom130301 tccom130 
                ON tccom130.t$cadr = tccom100.t$cadr
          
         LEFT JOIN baandb.ttfcmg001301 tfcmg001 
                ON tfcmg001.t$bank = prg_mov.t$brel
          
         LEFT JOIN baandb.ttfcmg011301 tfcmg011 
                ON tfcmg011.t$bank = tfcmg001.t$brch
          
         LEFT JOIN baandb.ttfcmg401301 tfcmg401  
                ON tfcmg401.t$ttyp = prg_mov.t$ttyp 
               AND tfcmg401.t$ninv = prg_mov.t$ninv
               AND tfcmg401.t$schn = prg_mov.t$schn
            
         LEFT JOIN baandb.ttfcmg409301 tfcmg409 
                ON tfcmg409.t$btno = tfcmg401.t$btno
          
         LEFT JOIN baandb.tcisli940301 cisli940 
                ON cisli940.t$ityp$l = titulo.t$ttyp
               AND cisli940.t$idoc$l = titulo.t$ninv
               AND cisli940.t$docn$l = titulo.t$docn$l
            
         LEFT JOIN baandb.tznrec007301 znrec007  
                ON znrec007.t$ttyp$c = titulo.t$ttyp
               AND znrec007.t$docn$c = titulo.t$ninv
            
         LEFT JOIN baandb.tznsls412301 znsls412  
                ON znsls412.t$ttyp$c = titulo.t$ttyp 
               AND znsls412.t$ninv$c = titulo.t$ninv    
            
         LEFT JOIN baandb.tznsls400301 znsls400 
                ON znsls412.t$ncia$c = znsls400.t$ncia$c
               AND znsls412.t$uneg$c = znsls400.t$uneg$c
               AND znsls412.t$pecl$c = znsls400.t$pecl$c
               AND znsls412.t$sqpd$c = znsls400.t$sqpd$c
            
         LEFT JOIN baandb.tznsls402301 znsls402  
                ON znsls402.t$ncia$c = znsls412.t$ncia$c
               AND znsls402.t$uneg$c = znsls412.t$uneg$c
               AND znsls402.t$pecl$c = znsls412.t$pecl$c
               AND znsls402.t$sqpd$c = znsls412.t$sqpd$c
            
         LEFT JOIN baandb.tznsls410301 znsls410  
                ON znsls410.t$ncia$c = znsls412.t$ncia$c
               AND znsls410.t$uneg$c = znsls412.t$uneg$c
               AND znsls410.t$pecl$c = znsls412.t$pecl$c
               AND znsls410.t$sqpd$c = znsls412.t$sqpd$c
               AND znsls410.t$entr$c = znsls412.t$entr$c            
                  
         LEFT JOIN ( select znacr005.t$tty1$c,
                            znacr005.t$nin1$c,
                            znacr005.t$tty2$c,
                            znacr005.t$nin2$c,
                            znacr005.t$ttyp$c, -- titulo ref
                            znacr005.t$ninv$c, -- num ref
                            t.t$docd,          -- data titulo
                            t.t$amnt,          -- valor tito
                            ( select min(a.t$recd) 
                                from baandb.ttfacr201301 a
                               where a.t$ttyp = znacr005.t$ttyp$c
                                 and a.t$ninv = znacr005.t$ninv$c ) DT_VENC,
                            CASE WHEN max(t.t$balc) = 0 
                                   THEN max(m.t$docd) 
                                 ELSE NULL 
                             END DT_LIQ        -- data liquidação
            
                       from BAANDB.tznacr005301 znacr005, 
                            BAANDB.ttfacr200301 t,
                            BAANDB.ttfacr200301 m
                      where t.t$ttyp = znacr005.t$ttyp$c
                        and t.t$ninv = znacr005.t$ninv$c
                        and m.t$ttyp = t.t$ttyp
                        and m.t$ninv = t.t$ninv
                        and znacr005.T$FLAG$C = 1              
                        and t.t$lino = 0
                        and m.t$lino ! =  0
                   group by znacr005.t$tty1$c,
                            znacr005.t$nin1$c,
                            znacr005.t$tty2$c,
                            znacr005.t$nin2$c,
                            znacr005.t$ttyp$c, --titulo ref
                            znacr005.t$ninv$c, --num ref
                            t.t$amnt,
                            t.t$docd ) agrup
                ON  agrup.t$tty1$c = prg_mov.t$ttyp
               AND agrup.t$nin1$c = prg_mov.t$ninv        
               AND agrup.t$tty2$c = prg_mov.t$tdoc        
               AND agrup.t$nin2$c = prg_mov.t$docn          
                   
         LEFT JOIN ( select rs.t$ttyp,
                            rs.t$ninv,
                            rs.t$tdoc,
                            rs.t$docn,
                            t.t$docd,      -- data titulo
                            t.t$amnt,      -- valor tito
                            ( select min(a.t$recd) 
                                from baandb.ttfacr201301 a
                               where a.t$ttyp = rs.t$ttyp
                                 and a.t$ninv = rs.t$ninv ) DT_VENC,
                            CASE WHEN max(t.t$balc) = 0 
                                   THEN max(m.t$docd) 
                                 ELSE NULL 
                             END DT_LIQ    -- data liquidação
                       from baandb.ttfacr200301 rs, 
                            baandb.ttfacr200301 t, 
                            baandb.ttfacr200301 m    
                      where t.T$TTYP = rs.t$ttyp
                        and t.T$NINV = rs.t$ninv
                        and m.t$ttyp = t.t$ttyp
                        and m.t$ninv = t.t$ninv
                        and t.t$lino = 0
                        and m.t$lino ! =  0
                   group by rs.t$ttyp,
                            rs.t$ninv,
                            rs.t$tdoc,
                            rs.t$docn,
                            t.t$docd,
                            t.t$amnt ) tref
                ON  tref.t$tdoc = prg_mov.t$tdoc 
               AND tref.t$docn = prg_mov.t$docn 
               AND tref.t$ttyp || tref.t$ninv ! =  prg_mov.t$ttyp || prg_mov.t$ninv
               AND tref.t$amnt = prg_mov.t$amnt*-1 
            
         LEFT JOIN ( select c.t$styp,
                            c.T$ITYP,
                            c.t$idoc
                       from baandb.tcisli205301 c
                      where c.t$styp = 'BL ATC') FILIAL
                ON FILIAL.T$ITYP = titulo.t$ttyp
               AND FILIAL.t$idoc = titulo.t$ninv
            
         LEFT JOIN ( select l.t$desc DESCR_SIT_TIT,
                            d.t$cnst
                       from baandb.tttadv401000 d,
                            baandb.tttadv140000 l
                      where d.t$cpac = 'tf'
                        and d.t$cdom = 'acr.strp.l'
                        and l.t$clan = 'p'
                        and l.t$cpac = 'tf'
                        and l.t$zc_cont = 3
                        and l.t$clab = d.t$za_clab
                        and rpad(d.t$vers,4) ||
                            rpad(d.t$rele,2) ||
                            rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                            rpad(l1.t$rele,2) ||
                                                            rpad(l1.t$cust,4)) 
                                                   from baandb.tttadv401000 l1 
                                                  where l1.t$cpac = d.t$cpac 
                                                    AND l1.t$cdom = d.t$cdom )
                        and rpad(l.t$vers,4) ||
                            rpad(l.t$rele,2) ||
                            rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                            rpad(l1.t$rele,2) ||
                                                            rpad(l1.t$cust,4)) 
                                                   from baandb.tttadv140000 l1 
                                                  where l1.t$clab = l.t$clab 
                                                    and l1.t$clan = l.t$clan 
                                                    and l1.t$cpac = l.t$cpac ) ) SIT_TIT
                ON SIT_TIT.t$cnst = prg_mov.t$rpst$l
         
         LEFT JOIN baandb.tznint002301 znint002
                ON znint002.t$uneg$c = znsls412.t$uneg$c
         
         LEFT JOIN baandb.ttttxt010301 t 
                ON t.t$ctxt = titulo.t$text  
               AND t.t$clan = 'p' 
            
         LEFT JOIN baandb.ttfgld011301 gld011
                ON gld011.t$ttyp = titulo.t$tdoc
          
         LEFT JOIN ( select l.t$desc DESCR_SIT_REM,
                            d.t$cnst
                       from baandb.tttadv401000 d,
                            baandb.tttadv140000 l
                      where d.t$cpac = 'tf'
                        and d.t$cdom = 'cmg.stdd'
                        and l.t$clan = 'p'
                        and l.t$cpac = 'tf'
                        and l.t$clab = d.t$za_clab
                        and rpad(d.t$vers,4) ||
                            rpad(d.t$rele,2) ||
                            rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                            rpad(l1.t$rele,2) ||
                                                            rpad(l1.t$cust,4)) 
                                                   from baandb.tttadv401000 l1 
                                                  where l1.t$cpac = d.t$cpac 
                                                    and l1.t$cdom = d.t$cdom )
                        AND rpad(l.t$vers,4) ||
                            rpad(l.t$rele,2) ||
                            rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                            rpad(l1.t$rele,2) ||
                                                            rpad(l1.t$cust,4)) 
                                                   from baandb.tttadv140000 l1 
                                                  where l1.t$clab = l.t$clab 
                                                    and l1.t$clan = l.t$clan 
                                                    and l1.t$cpac = l.t$cpac ) ) SIT_REM
                ON SIT_REM.t$cnst = tfcmg409.t$stdd
         
         LEFT JOIN baandb.tzncmg007301 zncmg007
                ON zncmg007.t$mpgt$c = znsls402.t$idmp$c
          
         LEFT JOIN baandb.tznmcs002301 znmcs002
                ON znmcs002.t$poco$c = znsls410.t$poco$c
         
         LEFT JOIN ( SELECT l.t$desc DESCR_SITUACAO_NF,
                            d.t$cnst
                       FROM baandb.tttadv401000 d,
                            baandb.tttadv140000 l
                      WHERE d.t$cpac = 'ci'
                        AND d.t$cdom = 'sli.stat'
                        AND l.t$clan = 'p'
                        AND l.t$cpac = 'ci'
                        AND l.t$clab = d.t$za_clab
                        AND rpad(d.t$vers,4) || 
                            rpad(d.t$rele,2) || 
                            rpad(d.t$cust,4) =  ( select max(rpad(l1.t$vers,4) || 
                                                             rpad(l1.t$rele,2) || 
                                                             rpad(l1.t$cust,4) ) 
                                                    from baandb.tttadv401000 l1 
                                                   where l1.t$cpac = d.t$cpac 
                                                     and l1.t$cdom = d.t$cdom )
                        AND rpad(l.t$vers,4) || 
                            rpad(l.t$rele,2) || 
                            rpad(l.t$cust,4) =  ( select max(rpad(l1.t$vers,4) || 
                                                             rpad(l1.t$rele,2) || 
                                                             rpad(l1.t$cust,4)) 
                                                    from baandb.tttadv140000 l1 
                                                   where l1.t$clab = l.t$clab 
                                                     and l1.t$clan = l.t$clan 
                                                     and l1.t$cpac = l.t$cpac )) SITUACAO_NF
                ON SITUACAO_NF.t$cnst = cisli940.t$stat$l) Q1
           
WHERE Trunc(DT_EMISSAO) BETWEEN :DataEmissaoDe AND :DataEmissaoAte
  AND Trunc(DT_VENCIMENTO) BETWEEN NVL(:DataVenctoDe, DT_VENCIMENTO) AND NVL(:DataVenctoAte, DT_VENCIMENTO)
  AND Trunc(DATA_TRANSACAO) BETWEEN NVL(:DataTransacaoDe, DATA_TRANSACAO) AND NVL(:DataTransacaoAte, DATA_TRANSACAO)
  AND FILIAL IN (:Filial)
  AND DOC IN (:TipoTransacao)
  AND NVL(UNID_NEGOCIO, 0) IN (:UniNegocio)
  AND NVL(SITUACAO_NF, 0) IN (:SituacaoNF)
  AND SITUACAO_TITULO IN (:StatusTitulo)
  AND ( (ID_TRANSACAO = Trim(:Transacao)) OR (Trim(:Transacao) is null) )
  AND ( (regexp_replace(CNPJ, '[^0-9]', '') = Trim(:CNPJ)) OR (Trim(:CNPJ) is null) )