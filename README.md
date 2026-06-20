# moodle-terraform

Projeto Codex para planejar uma infraestrutura Terraform para Moodle.

## Objetivo

Construir, de forma incremental, um laboratorio de infraestrutura como codigo para hospedar Moodle com boas praticas de rede, banco de dados, storage e observabilidade.

## Ideias iniciais

- VPC e subnets separadas por camada.
- Banco de dados gerenciado para a aplicacao.
- Storage persistente para arquivos do Moodle.
- Load balancer para acesso HTTP/HTTPS.
- Variaveis e outputs claros para facilitar reuso.

## Status

Em planejamento.

## Proximos passos

1. Definir o provedor cloud alvo.
2. Escolher arquitetura inicial: VM, ECS, EKS ou Kubernetes local.
3. Criar os primeiros modulos Terraform.
4. Adicionar validacao com `terraform fmt` e `terraform validate`.
5. Documentar custos, premissas e limites do laboratorio.
