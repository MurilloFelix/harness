# Quadro

<!-- Arquivo do Harness (genérico). Não edite aqui: mude no Harness e atualize com `install.ps1 -Update`. O que é do projeto fica no AGENTS.md. -->

O trabalho do projeto é um quadro de **cards** agrupados em **épicos**. Não há fases nem uma ordem global: o que bloqueia é o `depende` de cada card. Como o quadro anda está em [`docs/workflow.md`](../workflow.md#quadro); aqui está o formato dos arquivos e como cada coluna é calculada.

```
docs/board/
  README.md          este arquivo
  _card.md           modelo de card
  _epic.md           modelo de épico
  cards/<id>-<slug>.md
  epics/<slug>.md
```

## Card

Um arquivo por card, `cards/<id>-<slug>.md`, a partir de [`_card.md`](_card.md). Um arquivo por card é o que deixa várias branches andarem ao mesmo tempo sem conflito no quadro.

- **`id`** é um número inteiro: o maior `id` existente + 1 (o primeiro é 1, a não ser que o `AGENTS.md` diga outro começo). Ele só identifica: não diz ordem nem fase. Card novo **só nasce na integração local, com push logo em seguida**, para dois cards nunca pegarem o mesmo número; se o push falhar porque outro card com o mesmo `id` chegou antes, renumere o seu.
- **`epico`** é o slug de **um** épico, ou vazio. Um card pertence a um épico só (é o épico que diz quando aquilo está pronto); para ligar a outros, use `tags` e `depende`.
- **`depende`** lista os `id` que precisam estar **mergeados** antes de este card começar. Só bloqueio de verdade; "tem a ver com" vai no texto ou nas `tags`. Depender de um card descartado bloqueia para sempre: o tech lead avisa no resumo, e o dono corrige o `depende`.
- **`tags`**: módulos, áreas ou assuntos que o card toca, quantas precisar.
- **`tipo`**: `fatia` (o padrão: passa pelo fluxo de plano), `correcao` (pequena, sem plano, ver *Quando pular plano e crítica* no workflow) ou `release` (leva a integração para a estável).
- **`prioridade`** (opcional): número. Ordem em que o Start é puxado: primeiro os cards com `prioridade`, do menor para o maior; depois os sem, por `id`. A ordem dos cards no épico não entra aqui: ela orienta o dono ao liberar e priorizar.
- **`coluna`**: só as colunas que **o dono** decide (tabela abaixo). As outras são calculadas.

O corpo diz **o que entrega**, do ponto de vista de uso, e o que fica **fora**. É daí que o plano parte, e o crítico confere o plano contra o card. Depois que o plano é aprovado, o card fica congelado: só a `coluna` muda.

## Épico

Um arquivo por épico, `epics/<slug>.md`, a partir de [`_epic.md`](_epic.md): o objetivo, o **pronto quando** (o critério de uso real que diz que o épico chegou lá) e a lista dos cards, em ordem se a ordem importa. Atingir o *pronto quando* é um marco, não um fechamento: card novo num épico atingido é normal.

## Colunas

| Coluna | Quem decide | Como se sabe |
|---|---|---|
| **Ideias** | dono | `coluna: ideias`. Rascunho; pode nem ter épico. |
| **Backlog** | dono | `coluna: backlog`. Escrito, mas não liberado. |
| **Start** | dono | `coluna: start`, sem branch e sem dependência aberta. Liberado: o tech lead pode puxar. |
| **Bloqueado** | calculado | `coluna: start`, sem branch, com algum card de `depende` ainda não mergeado. |
| **Com o agente** | calculado | Tem branch (ou PR de release), e a tabela abaixo diz que é a vez do agente. |
| **Com você** | calculado | Tem branch (ou PR de release), e a tabela abaixo diz que é a vez do dono, com o motivo. |
| **Feito** | calculado | `coluna: feito` na integração, sem branch aberta. |
| **Descartado** | dono | `coluna: descartado`. Fica como histórico. |

**Fonte da verdade:** a integração vale para o card **sem** branch; para o card **com** branch, valem os arquivos da fatia (no worktree dela, inclusive o que ainda não foi commitado; sem worktree, na branch). Enquanto a branch existe, o campo `coluna` do card não é lido.

### Com branch: de quem é a vez

Para card `fatia`. A primeira linha que vale decide. "Branch" é `slice/<id>-<slug>` (o prefixo vem dos **Parâmetros do fluxo** do `AGENTS.md`); os arquivos citados ficam em `docs/plans/<id>-<slug>/`.

| # | Condição | Coluna |
|---|---|---|
| 1 | PR da branch mergeado | Feito (o tech lead apaga a branch e o worktree) |
| 2 | PR da branch fechado sem merge | Com você: **decisão** (descartar o card ou voltar com o PR) |
| 3 | `pendencias.md` com item aberto em *Para o dono* | Com você: **decisão** |
| 4 | `pendencias.md` com item aberto em *Para o agente* | Com o agente |
| 5 | `plan.md` com uma *Emenda* sem "aprovado por" | Com você: **emenda** |
| 6 | PR aberto, última `verification-rN.md` `APROVADO`, checklist manual toda marcada | Com você: **merge** |
| 7 | PR aberto, última `verification-rN.md` `APROVADO`, checklist com item aberto | Com você: **teste** |
| 8 | `Status` do `plan.md` é `Aprovado`, `Em implementação` ou `Implementado` | Com o agente (esperando trilha, implementando, verificando ou abrindo o PR) |
| 9 | Última `critique-rN.md` `APROVADO` ou `APROVADO COM RESSALVAS`, plano ainda não aprovado | Com você: **plano** |
| 10 | Qualquer outro caso (rascunho, crítica pedindo revisão) | Com o agente (planejando) |

Card `correcao` não tem plano: a branch é `fix/<id>-<slug>`, e valem as linhas 1 a 4 (o `pendencias.md` fica na mesma pasta `docs/plans/<id>-<slug>/`, se for preciso); depois, **Com você: merge** com o PR aberto, e **Com o agente** no resto.

Card `release` não tem branch própria: está **Com você: release** enquanto o PR da integração para a estável (título com `[<id>]`) estiver aberto, **Com o agente** em Start sem esse PR, e vira Feito quando o PR é mergeado.

## Regras

1. **Card com branch só é editado na branch.** Mexer nele também na integração dá conflito no merge.
2. **O card vira Feito pelo próprio PR.** Antes de abrir o PR, o tech lead muda `coluna: feito` no card, dentro da branch. Com o squash, a integração recebe o card já feito.
3. **Card novo só nasce na integração** (ver `id`). Trabalho descoberto no meio de uma fatia vira card novo na integração, nunca na branch, e entra em Ideias.
4. **Commit direto na integração só para o quadro:** arquivos de `docs/board/`, com `chore(quadro): ...`, pelo dono ou pelo tech lead, seguido de push. Código e todo o resto continuam só por PR.
