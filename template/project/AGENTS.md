# AGENTS.md

Instruções para qualquer agente de IA (Claude, Codex...) e para humanos trabalhando no **<nome do projeto>**. **Leia isto, [`docs/workflow.md`](docs/workflow.md) e [`docs/architecture.md`](docs/architecture.md) antes de escrever código.**

O fluxo de trabalho (quadro de cards, tech lead, plano → crítica → implementação → verificação, branches, PR, definição de pronto) é o do Harness e está em [`docs/workflow.md`](docs/workflow.md). Este arquivo guarda só o que é **deste projeto**. Os agentes em `.claude/agents/` procuram as seções abaixo pelo nome: não as renomeie.

## O que é

<1 parágrafo: o que o projeto faz, para quem, as peças principais e a stack.> Decisões em [`docs/adr/`](docs/adr/), trabalho no [quadro](docs/board/README.md).

## Mapa do repo

```
<pasta>        <o que mora nela>
docs/          arquitetura, ADRs, workflow
docs/board/    o quadro: cards/<id>-<slug>.md e epics/<slug>.md
docs/plans/    um plano por fatia: plan.md, critique-rN.md, verification-rN.md (e spike.md, pendencias.md, se houver)
.claude/agents/ subagentes do fluxo: plan-critic, slice-implementer, plan-verifier
.claude/commands/ /ciclo (o tech lead avança o quadro) e /quadro (só mostra)
```

## Regras

Regras do projeto, além dos princípios do [`docs/workflow.md`](docs/workflow.md). Numeradas, para o plano e a crítica poderem citá-las ("regra 3").

1. <regra de arquitetura. Ex.: "Módulos não dependem uns dos outros.">
2. <regra de erro. Ex.: "Sem `unwrap`/`panic` fora de teste: erro vira `Result`.">
3. <regra de código perigoso/plataforma. Ex.: "Acesso ao SO só na camada `x`.">
4. <regra de documentação. Ex.: "Toda função pública tem doc comment.">

## Verificação

Rode antes de dizer que terminou. O CI roda exatamente isto. O implementador roda a cada passo e o verificador, no fim.

```sh
<comando de formatação em modo check>
<comando de lint com avisos como erro>
<comando de testes>
<outros: build, doc, testes de outra linguagem...>
```

<Requisitos de ambiente, se houver. Ex.: "exige Node 22+".>

## Formatação

Corrige a formatação antes de cada commit:

```sh
<comando de formatação que escreve>
```

## Ambiente manual

Onde e como o dono executa os critérios **M** (o que a IA não consegue ver):

- <Ex.: "Windows 11, com o app rodando elevado", "navegador real no celular", "dispositivo físico X".>
- <Preparação padrão. Ex.: "saia da instância do dia a dia antes de testar o build da branch".>

## Critérios obrigatórios

O autor do plano inclui, e o crítico cobra, estes critérios sempre que a fatia se encaixar:

- <Ex.: "Fatia que muda a API pública → critério de atualizar a documentação da API e o fixture de referência.">
- <Ex.: "Fatia que instala hook/recurso global → critério de que desligar o módulo o remove de verdade.">
- Fatia com decisão de arquitetura nova → ADR em `docs/adr/` com critério I conferindo que está `Aceito` e no índice.

## Parâmetros do fluxo

| Parâmetro | Valor |
|---|---|
| Branch de integração | `dev` |
| Branch estável | `main` |
| Prefixo de fatia | `slice/<id>-<slug>` |
| Prefixo de correção | `fix/<id>-<slug>` |
| Pasta dos worktrees | `.worktrees/` <(no `.gitignore`, para as buscas e o git ignorarem as cópias)> |
| Trilhas (fatias implementando, até o merge) | 1 <(ou mais: só fatias que não mexem nos mesmos módulos nem pastas)> |
| Planos abertos (planejando, em crítica ou esperando o dono) | 2 |
| Rodadas de crítica antes de chamar o dono | 4 |
| Rodadas de verificação antes de chamar o dono | 3 |
| Arquivos comuns entre trilhas | <arquivos que toda fatia costuma tocar: arquitetura, índice de ADRs, `AGENTS.md`, arquivos gerados e como regenerá-los> |
| Dono (aprova e faz merge) | <nome> |

Testes esperando o dono nunca passam do número de trilhas: a trilha só é liberada no merge.

## Definição de pronto (extras do projeto)

Além da [definição de pronto do workflow](docs/workflow.md#definição-de-pronto):

- [ ] <Ex.: "Todo campo de ação nova tem doc comment.">

## Idioma e estilo

- Código, identificadores, mensagens de erro e logs em **<idioma>**.
- Comentários, docs, ADRs e commits em **<idioma>**.
- Formatação: <formatador padrão>.
