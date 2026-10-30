# Planos de implementação

<!-- Arquivo do Harness (genérico). -->

Cada card de fatia do [quadro](../board/README.md) ganha uma pasta aqui, com o mesmo `<id>-<slug>` do card e da branch. O fluxo completo está em [`docs/workflow.md`](../workflow.md#fluxo-de-uma-fatia). Em resumo:

```
card ──► (spike) ──► plano ──► crítico (sem contexto) ──► dono aprova ──► implementação ──► verificador (sem contexto) ──► PR ──► dono testa ──► merge
                                 │ bloqueantes? revisa e nova rodada                          │ reprovado? corrige e nova rodada, com um verificador novo
```

## Estrutura

```
docs/plans/
  _template.md
  31-exemplo/
    spike.md              # (opcional) o que o spike descobriu, com evidência
    spike/                # (opcional) programa descartável, fora do build e da Verificação
    plan.md               # objetivo, desenho, passos, critérios A/I/M (congelado após aprovação)
    pendencias.md         # (opcional) perguntas para o dono e pedidos do dono, fora da conversa
    critique-r1.md        # uma por rodada do plan-critic; nunca sobrescritas
    critique-r2.md
    critique-e1-r1.md     # crítica da emenda E1, se ela mudar critérios
    verification-r1.md    # uma por rodada do plan-verifier; nunca sobrescritas
    verification-r2.md    # a última é a APROVADO, onde o dono marca a checklist manual
```

Cada rodada é um arquivo novo, numerado. O histórico mostra como o plano chegou até a aprovação e por que uma verificação reprovou, e nenhum agente apaga o trabalho de outro. O `Status` do `plan.md` cita a revisão do plano e a última crítica. Os arquivos desta pasta são também o estado do card no quadro: a coluna é calculada a partir deles ([`board/README.md`](../board/README.md#com-branch-de-quem-é-a-vez)). O formato do `pendencias.md` está no [`workflow.md`](../workflow.md#pendenciasmd).

## Por que assim

- **Critérios antes do código.** Quem implementa não decide o que é "pronto" depois de ver o próprio código. Se o critério estiver errado, isso vira uma emenda explícita, aprovada pelo dono.
- **Crítico e verificador sem contexto.** Eles só sabem o que está escrito. Se o verificador não entende um critério, o problema é do critério, e é melhor descobrir isso cedo (é para isso que serve o crítico).
- **O card manda no escopo.** O plano parte do *O que entrega* e do *Fora* do card, e o crítico confere os dois. Como o card só é editado na branch depois que ela existe, ele fica congelado junto com o plano.
- **Três tipos de critério.** O que a IA executa (A), o que a IA lê (I) e o que só o dono consegue ver no ambiente real (M, ver **Ambiente manual** no `AGENTS.md`). O verificador nunca marca M como aprovado: transforma esses critérios na checklist do dono.
- **Resultados possíveis:** `PASSOU`, `FALHOU` ou `NÃO VERIFICADO` (por exemplo, sem rede ou fora do ambiente certo). "Não consegui checar" nunca vira "passou".
- **Spike antes de supor.** Se o desenho depende de um comportamento que a documentação não responde, roda-se um programa descartável primeiro e o plano cita o que foi observado, em vez de um palpite.
