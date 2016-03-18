select rn_afa.Cliente
        , rn_afa.CPF_CNPJ
        , rn_afa.NProtocolo
        , rn_afa.Unidade_Negocio
        , rn_afa.Pedido
        , rn_afa.Entrega
        , rn_afa.Data_Criacao
        , rn_afa.Vencimento
        , rn_afa.StatusSLA
        , ln_ree.Item
        , rn_afa.Classificacao
        , rn_afa.Acao_Necessaria
        , rn_afa.Categoria_Acao_Necessaria
        , rn_afa.Ultima_Atualizacao
        , rn_afa.Agendamento
        , rn_afa.Criado_Por
        , rn_afa.Conta_Atribuida
        , rn_afa.Fila
        , rn_afa.Area
        , Coalesce(ln_ree.Code_PN, 'Indevido')              Code_PN
        , Case when ln_ree.Code_PN is null and ln_ree.Desc_PN is null
                 then 'Indevido'
               else   ln_ree.Desc_PN
          End                                               Desc_PN
        , Case when ln_ree.Code_PN is null and ln_ree.Transacao is null
                 then 'Indevido'
               else   ln_ree.Transacao
          End                                               Transacao
        , Case when ln_ree.Code_PN is null and ln_ree.CNPJ_Fornecedor is null
                 then 'Indevido'
               else   ln_ree.CNPJ_Fornecedor
          End                                               CNPJ_Fornecedor
        , Case when ln_ree.Code_PN is null and ln_ree.Cod_Status_Pagto is null
                 then 'Indevido'
               else   Cast(ln_ree.Cod_Status_Pagto as varchar(20))
          End                                               Cod_Status_Pagto
        , Case when ln_ree.Code_PN is null and ln_ree.Dsc_Status_Pagto is null
                 then 'Indevido'
               else   ln_ree.Dsc_Status_Pagto
          End                                               Dsc_Status_Pagto
        , Case when ln_ree.Code_PN is null and ln_ree.TENTATIVA_PAGTO is null
                 then 'Indevido'
               else   ln_ree.TENTATIVA_PAGTO
          End                                               TENTATIVA_PAGTO
        , Case when ln_ree.Code_PN is null and ln_ree.DATA_TENTATIVA_PAGTO is null
                 then 'Indevido'
               else   Cast(ln_ree.DATA_TENTATIVA_PAGTO as varchar(20))
          End                                               DATA_TENTATIVA_PAGTO
        , Case when ln_ree.Code_PN is null and ln_ree.TENTATIVA_MOD_PAGTO is null
                 then 'Indevido'
               else   ln_ree.TENTATIVA_MOD_PAGTO
          End                                               TENTATIVA_MOD_PAGTO
        , Case when ln_ree.Code_PN is null and ln_ree.DESC_MOD_PAGTO is null
                 then 'Indevido'
               else   ln_ree.DESC_MOD_PAGTO
          End                                               DESC_MOD_PAGTO

        , Case when ln_ree.Code_PN is null and ln_ree.Nume_CONTA is null
                 then 'Indevido'
               else   ln_ree.Desc_AGENCIA + 
                      ' AG. '             + 
                      ln_ree.Nume_AGENCIA + 
                      '-'                 + 
                      ln_ree.Digi_AGENCIA +
                      ' CC '              + 
                      ln_ree.Nume_CONTA   + 
                      '-'                 + 
                      ln_ree.Digi_CONTA 
          End                                               Banco_Cliente
        , Case when ln_ree.Code_PN is null and ln_ree.Banco_PARCEIRO is null
                 then 'Indevido'
               else   ln_ree.Banco_PARCEIRO
          End                                               Banco_PARCEIRO
        , Case when ln_ree.Code_PN is null and ln_ree.Nume_AGENCIA is null
                 then 'Indevido'
               else   ln_ree.Nume_AGENCIA
          End                                               Nume_AGENCIA
        , Case when ln_ree.Code_PN is null and ln_ree.Digi_AGENCIA is null
                 then 'Indevido'
               else   ln_ree.Digi_AGENCIA
          End                                               Digi_AGENCIA
        , Case when ln_ree.Code_PN is null and ln_ree.Desc_AGENCIA is null
                 then 'Indevido'
               else   ln_ree.Desc_AGENCIA
          End                                               Desc_AGENCIA
        , Case when ln_ree.Code_PN is null and ln_ree.Nume_CONTA is null
                 then 'Indevido'
               else   ln_ree.Nume_CONTA
          End                                               Nume_CONTA
        , Case when ln_ree.Code_PN is null and ln_ree.Digi_CONTA is null
                 then 'Indevido'
               else   ln_ree.Digi_CONTA
          End                                               Digi_CONTA
        , Case when ln_ree.Code_PN is null and ln_ree.TENTATIVA_LOTE_PAGTO is null
                 then 'Indevido'
               else   ln_ree.TENTATIVA_LOTE_PAGTO
          End                                               TENTATIVA_LOTE_PAGTO
        , Case when ln_ree.Code_PN is null and ln_ree.Cod_Meio_Pagto is null
                 then 'Indevido'
               else   Cast(ln_ree.Cod_Meio_Pagto as varchar(20))
          End                                               Cod_Meio_Pagto
        , Case when ln_ree.Code_PN is null and ln_ree.Dsc_Meio_Pagto is null
                 then 'Indevido'
               else   ln_ree.Dsc_Meio_Pagto
          End                                               Dsc_Meio_Pagto

     from RPT.RN_ATENDIMENTOS_FINANCEIRO_ABERTO rn_afa
left join RPT.LN_REEMBOLSO_ABERTO ln_ree
       on ln_ree.Entrega = rn_afa.Entrega
       
where rn_afa.Id_Unidade_Negocio in (@UnidadeNegocio)
  and rn_afa.LogonCA in (@ContaAtribuida)
  and ((@PedidoTodos = 1) or (rn_afa.Pedido in (@Pedido) and (@PedidoTodos = 0)))
  
Order By NProtocolo, Pedido, Entrega, Item