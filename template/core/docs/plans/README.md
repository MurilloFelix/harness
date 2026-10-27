# Planos de implementação

<!-- Arquivo do Harness (genérico). -->

Cada fatia do [roadmap](../roadmap/README.md) ganha uma pasta aqui. O fluxo completo está em [`docs/workflow.md`](../workflow.md#fluxo-de-uma-fatia). Em resumo:

```
plano ──► crítico (sem contexto) ──► dono aprova ──► implementação ──► verificador (sem contexto) ──► checklist do dono ──► merge
            │ bloqueantes? volta                                         │ reprovado? corrige e roda um verificador novo
```

## Estrutura

```
docs/plans/
  _template.md
  1.2-exemplo/
    plan.md           # objetivo, desenho, passos, critérios A/I/M (congelado após aprovação)
    critique.md       # escrito pelo plan-critic (cada rodada substitui a anterior)
    verification.md   # escrito pelo plan-verifier + checklist manual que o dono marca
```

Uma emenda que muda critérios depois da aprovação pode ganhar a própria crítica (`critique-e1.md`).

## Por que assim

- **Critérios antes do código.** Quem implementa não decide o que é "pronto" depois de ver o próprio código. Se o critério estiver errado, isso vira uma emenda explícita, aprovada pelo dono.
- **Crítico e verificador sem contexto.** Eles só sabem o que está escrito. Se o verificador não entende um critério, o problema é do critério, e é melhor descobrir isso cedo (é para isso que serve o crítico).
- **Três tipos de critério.** O que a IA executa (A), o que a IA lê (I) e o que só o dono consegue ver no ambiente real (M, ver **Ambiente manual** no `AGENTS.md`). O verificador nunca marca M como aprovado: transforma esses critérios na checklist do dono.
- **Resultados possíveis:** `PASSOU`, `FALHOU` ou `NÃO VERIFICADO` (por exemplo, sem rede ou fora do ambiente certo). "Não consegui checar" nunca vira "passou".
