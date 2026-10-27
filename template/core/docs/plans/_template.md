# <id>: <título>

- **Status:** Rascunho | Em crítica | Aprovado (AAAA-MM-DD) | Implementado | Verificado
- **Roadmap:** item <id>
- **ADRs relacionados:** <links>

## Objetivo

O que muda para o dono quando isto estiver pronto, do ponto de vista de uso, em 1 a 3 frases.

## Fora de escopo

O que **não** entra nesta fatia, mesmo que pareça natural fazer junto.

## Desenho

- Módulos/arquivos novos ou alterados.
- Tipos, funções e interfaces públicas (nomes, entrada, saída).
- Fluxo principal e fluxos de erro.
- Dependências novas, com justificativa.
- Decisão nova de arquitetura → ADR antes (link aqui).

Pense em testabilidade: o que puder ficar fora da camada de plataforma/UI, em código puro testável, vira critério **A** em vez de **M**.

## Passos

1. <passo> (cada passo termina com a verificação padrão verde e um commit)
2. …

## Critérios de aceite

Regras para todo critério:

- Tem id (`A1`, `I1`, `M1`) e é **observável**. Se alguém sem contexto perguntaria "o que isso quer dizer?", reescreva.
- Cobre também o caminho de erro, não só o caminho feliz.
- Inclui os **Critérios obrigatórios** do `AGENTS.md` que se aplicam a esta fatia.
- Depois da aprovação, **não se edita**. Mudança só em *Emendas*.

### A: Automáticos (o verificador executa)

- **A1:** <critério>.
  Comando: `<comando exato>`
  Esperado: <saída / código de saída / teste específico passando>

### I: Inspeção (o verificador lê o código)

- **I1:** <critério>.
  Onde: `<arquivo ou padrão de busca>`

### M: Manuais (o dono executa no ambiente manual, vira checklist)

Antes: <preparação comum a todos os M: build, config, o que fechar/abrir>.

- **M1:** <critério>.
  Passos: 1. … 2. …
  Esperado: <o que o dono deve ver>

## Riscos

- <o que pode dar errado e como o plano lida com isso>

## Emendas

Mudanças nos critérios depois da aprovação. Cada uma com id (`E1`), data, motivo e "aprovado por <dono>".

- _nenhuma_
