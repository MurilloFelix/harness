# Harness

Meu jeito de trabalhar com agentes de IA (Claude Code, Codex...) empacotado para reaproveitar em qualquer projeto. Nasceu no [Deckify](../deckify), que continua sendo o projeto de referência.

A ideia em uma frase: **critérios antes do código, e quem julga nunca é quem escreveu.** Cada entrega é uma *fatia vertical* com um plano cujos critérios de aceite são verificáveis (A automático, I inspeção, M manual). Um crítico sem contexto revisa o plano, o dono aprova e congela, um implementador segue o plano, e um verificador sem contexto confere com evidência. O que a IA não consegue ver vira checklist do dono, e o merge é só dele.

O trabalho é um **quadro de cards** agrupados em épicos, não uma lista de fases. O dono monta os cards (com o agente) e move para **Start** os que libera; o **tech lead** (a sessão principal) puxa o que dá para fazer, leva cada card pelo fluxo e para em cada ponto que é do dono. Quando o dono libera, o tech lead segue sozinho. O objetivo é que, quando o dono quiser trabalhar, já exista algo esperando só por ele.

```
Ideias ─► Backlog ─► Start ─► Com o agente ⇄ Com você ─► Feito
 (dono)    (dono)   (dono)       (calculado dos arquivos da branch)

card ──► (spike) ──► plano ──► crítico (sem contexto) ──► dono aprova ──► implementação ──► verificador (sem contexto) ──► PR ──► dono testa ──► merge
                                 │ bloqueantes? revisa, nova rodada                          │ reprovado? corrige, nova rodada com um verificador novo
```

Um card é um `.md` (`docs/board/cards/<id>-<slug>.md`), então várias branches andam ao mesmo tempo sem conflito no quadro. A integração diz o estado dos cards sem branch; a branch de cada fatia diz o estado do seu card, calculado dos arquivos do fluxo. Cada rodada de crítica e de verificação é um arquivo novo (`critique-rN.md`, `verification-rN.md`), nunca sobrescrito. Um spike opcional responde, rodando, o que a documentação não responde antes de o plano depender disso.

O fluxo completo está em [`template/core/docs/workflow.md`](template/core/docs/workflow.md).

## Estrutura

```
install.ps1          instala/atualiza o Harness num projeto
template/
  core/              GENÉRICO: igual em todo projeto. Atualizado com `-Update`.
    .claude/agents/  plan-critic, slice-implementer, plan-verifier
    .claude/commands/ /ciclo (o tech lead avança o quadro) e /quadro (só mostra)
    .github/         template de PR
    docs/workflow.md quadro, tech lead e ciclo, fluxo de fatia, spike, trilhas, branches, PR, release, definição de pronto
    docs/board/      README (formato e colunas) + _card.md e _epic.md
    docs/plans/      README + _template.md do plano
    docs/adr/        0000-template.md
  project/           DO PROJETO: criado uma vez, depois é seu. Nunca sobrescrito.
    AGENTS.md        regras, verificação, ambiente manual, critérios obrigatórios
    CLAUDE.md        só importa o AGENTS.md
    docs/architecture.md
    docs/adr/README.md     índice de ADRs
    docs/board/cards/      os cards do projeto (um .md por card)
    docs/board/epics/      os épicos do projeto
```

**A regra que mantém isto genérico:** nada em `core/` cita linguagem, ferramenta, SO ou comando do projeto (git, `gh` e os arquivos `.claude/` são a exceção: são do fluxo, não do projeto). Tudo que é específico (comandos de verificação, onde o dono roda os testes manuais, regras de código, critérios que o crítico deve cobrar) mora no `AGENTS.md` do projeto, em seções com nomes fixos que os agentes procuram:

| Seção do `AGENTS.md` | Quem usa | Exemplo (Deckify) |
|---|---|---|
| **Verificação** | implementador, verificador, CI | `cargo fmt --check`, `clippy -D warnings`, `cargo test`, `node --test ...` |
| **Formatação** | implementador (antes de cada commit) | `cargo fmt --all` |
| **Ambiente manual** | plano (critérios M), crítico, verificador | "no Windows 11, com o agente rodando elevado" |
| **Critérios obrigatórios** | autor do plano, crítico | "fatia que muda a API atualiza o explorer" |
| **Regras** | todos | "sem `unwrap` fora de teste", "`unsafe` só em `deckify-win`" |
| **Parâmetros do fluxo** | todos, em especial o tech lead | branch de integração `dev`, estável `main`, pasta dos worktrees, 2 trilhas, 2 planos esperando o dono, rodadas de crítica, arquivos comuns entre trilhas |

## Instalar num projeto

```powershell
pwsh ./install.ps1 -Target C:\caminho\do\projeto -WhatIf   # mostra o que faria
pwsh ./install.ps1 -Target C:\caminho\do\projeto
```

- Arquivos que não existem são criados.
- Arquivos de `project/` que já existem são **mantidos** (nunca sobrescritos).
- Arquivos de `core/` que já existem e diferem são mantidos e listados como `difere`; use `-Update` para sobrescrevê-los.

Depois, abra uma sessão no projeto e peça para adaptar (prompt abaixo).

### Prompt de adoção

> Instalei o Harness neste projeto. Leia `docs/workflow.md`, `docs/board/README.md` e os arquivos que têm marcadores `<...>`: `AGENTS.md`, `docs/architecture.md` e `docs/adr/README.md`. Explore o código e me proponha o preenchimento: mapa do repo, comandos de **Verificação** e **Formatação** (os mesmos do CI, se houver), **Ambiente manual**, **Regras** que o código já segue, **Critérios obrigatórios** e **Parâmetros do fluxo**. Pergunte o que não der para deduzir. Não invente comandos: rode cada um antes de escrever. Se o projeto já tem um `AGENTS.md`/`CLAUDE.md`, mescle sem perder nada. Se ele tem um roadmap, proponha os épicos e os cards a partir dele (o que já foi feito fica como histórico, sem virar card).

## Atualizar os projetos

1. Mude o fluxo **aqui** no Harness (em `template/core/`), não direto num projeto, e commite aqui primeiro (o Harness é um repositório git: o histórico dele é o changelog do fluxo).
2. Rode `install.ps1 -Target <projeto> -Update -WhatIf`, confira, rode sem `-WhatIf`.
3. Revise o diff no projeto e commite como `chore(harness): ...`.

**Projeto que ainda usa `docs/roadmap/`** (versão do Harness anterior ao quadro): o `-Update` traz o quadro, mas não apaga o roadmap, que é do projeto. Na mesma mudança, peça ao agente para: transformar o que falta fazer em épicos e cards (`docs/board/`), deixar o que já foi feito como histórico (o roadmap antigo vira um arquivo só de leitura, ou é apagado), revisar o `AGENTS.md` (as linhas novas dos **Parâmetros do fluxo**, o prefixo `fix/<id>-<slug>`, e os links e menções ao roadmap em *O que é*, no mapa do repo e nos arquivos comuns) e pôr a pasta dos worktrees no `.gitignore`. Faça a migração sem fatia em andamento: uma branch `slice/1.3-...` aberta termina no fluxo antigo antes. Como mexe em mais do que o quadro, a migração vai por PR.

Se uma melhoria nasceu num projeto (por exemplo, uma regra nova no crítico do Deckify), traga-a de volta para o `core/` tirando o que for específico, e mova a parte específica para a seção certa do `AGENTS.md` daquele projeto.

**O que é genérico e o que não é:** se a mudança faz sentido em um projeto que não tem nada a ver (outra linguagem, outro SO), ela vai para o `core/`. Se não, ela vai para o `AGENTS.md` do projeto.
