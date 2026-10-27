# Harness

Meu jeito de trabalhar com agentes de IA (Claude Code, Codex...) empacotado para reaproveitar em qualquer projeto. Nasceu no [Deckify](../deckify), que continua sendo o projeto de referência.

A ideia em uma frase: **critérios antes do código, e quem julga nunca é quem escreveu.** Cada entrega é uma *fatia vertical* com um plano cujos critérios de aceite são verificáveis (A automático, I inspeção, M manual). Um crítico sem contexto revisa o plano, o dono aprova e congela, um implementador segue o plano, e um verificador sem contexto confere com evidência. O que a IA não consegue ver vira checklist do dono, e o merge é só dele.

```
plano ──► crítico (sem contexto) ──► dono aprova ──► implementação ──► verificador (sem contexto) ──► checklist do dono ──► PR / merge
            │ bloqueantes? volta                                         │ reprovado? corrige e roda um verificador novo
```

O fluxo completo está em [`template/core/docs/workflow.md`](template/core/docs/workflow.md).

## Estrutura

```
install.ps1          instala/atualiza o Harness num projeto
template/
  core/              GENÉRICO: igual em todo projeto. Atualizado com `-Update`.
    .claude/agents/  plan-critic, slice-implementer, plan-verifier
    .github/         template de PR
    docs/workflow.md fluxo de fatia, branches, PR, definição de pronto
    docs/plans/      README + _template.md do plano
    docs/adr/        0000-template.md
  project/           DO PROJETO: criado uma vez, depois é seu. Nunca sobrescrito.
    AGENTS.md        regras, verificação, ambiente manual, critérios obrigatórios
    CLAUDE.md        só importa o AGENTS.md
    docs/architecture.md
    docs/adr/README.md     índice de ADRs
    docs/roadmap/          README (Agora / A seguir) + um arquivo de escopo
```

**A regra que mantém isto genérico:** nada em `core/` cita linguagem, ferramenta, SO ou comando. Tudo que é específico (comandos de verificação, onde o dono roda os testes manuais, regras de código, critérios que o crítico deve cobrar) mora no `AGENTS.md` do projeto, em seções com nomes fixos que os agentes procuram:

| Seção do `AGENTS.md` | Quem usa | Exemplo (Deckify) |
|---|---|---|
| **Verificação** | implementador, verificador, CI | `cargo fmt --check`, `clippy -D warnings`, `cargo test`, `node --test ...` |
| **Formatação** | implementador (antes de cada commit) | `cargo fmt --all` |
| **Ambiente manual** | plano (critérios M), crítico, verificador | "no Windows 11, com o agente rodando elevado" |
| **Critérios obrigatórios** | autor do plano, crítico | "fatia que muda a API atualiza o explorer" |
| **Regras** | todos | "sem `unwrap` fora de teste", "`unsafe` só em `deckify-win`" |
| **Parâmetros do fluxo** | todos | branch de integração `dev`, estável `main` |

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

> Instalei o Harness neste projeto. Leia `docs/workflow.md` e os arquivos que têm marcadores `<...>`: `AGENTS.md`, `docs/architecture.md`, `docs/roadmap/` e `docs/adr/README.md`. Explore o código e me proponha o preenchimento: mapa do repo, comandos de **Verificação** e **Formatação** (os mesmos do CI, se houver), **Ambiente manual**, **Regras** que o código já segue, **Critérios obrigatórios** e **Parâmetros do fluxo**. Pergunte o que não der para deduzir. Não invente comandos: rode cada um antes de escrever. Se o projeto já tem um `AGENTS.md`/`CLAUDE.md`, mescle sem perder nada.

## Atualizar os projetos

1. Mude o fluxo **aqui** no Harness (em `template/core/`), não direto num projeto.
2. Rode `install.ps1 -Target <projeto> -Update -WhatIf`, confira, rode sem `-WhatIf`.
3. Revise o diff no projeto e commite como `chore(harness): ...`.

Se uma melhoria nasceu num projeto (por exemplo, uma regra nova no crítico do Deckify), traga-a de volta para o `core/` tirando o que for específico, e mova a parte específica para a seção certa do `AGENTS.md` daquele projeto.

**O que é genérico e o que não é:** se a mudança faz sentido em um projeto que não tem nada a ver (outra linguagem, outro SO), ela vai para o `core/`. Se não, ela vai para o `AGENTS.md` do projeto.
