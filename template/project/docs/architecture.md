# Arquitetura

<Visão geral em 1 a 2 parágrafos: as peças, como conversam e onde fica cada responsabilidade.>

## Peças

| Peça | Responsabilidade | Depende de |
|---|---|---|
| <módulo/crate/pacote> | <o que faz> | <o quê> |

## Fluxos principais

<O caminho de uma operação típica, do gatilho ao efeito. Um diagrama ASCII ajuda.>

## Fronteiras

- <Onde fica o código que fala com o mundo externo (SO, rede, UI), e por que ele é fino.>
- <O que é código puro e testável.>

## Decisões

As decisões e o porquê estão nos [ADRs](adr/README.md). Este documento descreve o estado atual; quando o desenho mudar, atualize-o na mesma fatia.
