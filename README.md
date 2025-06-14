# 🎯 Análise RFM com Identificação de Produtos por Segmento

Este script SQL realiza uma **análise RFM (Recência, Frequência, Valor Monetário)** completa para segmentação de clientes e identifica automaticamente **qual produto é mais comprado por cada categoria de cliente**, oferecendo insights valiosos para estratégias de marketing direcionado.

---

## 💼 Valor para o Negócio

- **Segmentação Inteligente de Clientes**: Classifique automaticamente clientes em categorias estratégicas (VIP, Leais, Inativos, Novos).
- **Personalização de Ofertas**: Descubra qual produto tem maior afinidade com cada segmento para campanhas direcionadas.
- **Retenção e Reativação**: Identifique clientes em risco e os produtos que podem reconectá-los à marca.
- **Maximização de ROI**: Direcione investimentos em marketing para os produtos certos, nos clientes certos.
- **Cross-selling Estratégico**: Use os produtos mais populares por segmento para sugerir compras complementares.

---

## 📊 Fundamento Analítico: Metodologia RFM

A **Análise RFM** é uma técnica comprovada de segmentação que avalia clientes em três dimensões:

- **🕒 Recência (R)**: Há quanto tempo o cliente fez a última compra?
- **🔄 Frequência (F)**: Com que frequência o cliente compra?
- **💰 Valor Monetário (M)**: Quanto o cliente gastou no total?

### Sistema de Pontuação
- Cada métrica recebe uma **nota de 1 a 5** usando quartis (NTILE)
- Clientes são classificados automaticamente com base na combinação dos scores
- **Maior score = Melhor desempenho** (exceto para Recência, onde menor é melhor)

---

## 🔢 Lógica e Estrutura do Script

O código utiliza **CTEs (Common Table Expressions)** para garantir modularidade e facilitar manutenção:

### 1. `RFM`  
Calcula as métricas fundamentais por cliente:
- **Recência**: Dias desde a última compra
- **Frequência**: Número total de transações
- **Valor Monetário**: Soma total gasta

### 2. `SCORED`  
Aplica scores de 1-5 para cada métrica usando NTILE:
- Score R: Ordenado por recência (DESC - menor recência = melhor score)
- Score F: Ordenado por frequência (ASC - maior frequência = melhor score)  
- Score M: Ordenado por valor (ASC - maior valor = melhor score)

### 3. `SEGMENTACAO`  
Classifica clientes em categorias estratégicas baseadas nos scores:
- **🌟 Clientes VIP**: Alta recência, frequência e valor (4-5 em todas)
- **💎 Clientes Leais**: Moderadamente alto em todas as métricas (3+ em todas)
- **🆕 Novos Clientes**: Baixa recência, alta frequência (R≤2, F≥4)
- **😴 Clientes Inativos**: Baixo desempenho geral (≤2 em todas)
- **❓ Outros**: Demais combinações

### 4. `PRODUTOS_POR_SEGMENTO`  
Agrega produtos por segmento, somando quantidades vendidas.

### 5. `RANKING_PRODUTOS`  
Ranqueia produtos dentro de cada segmento por quantidade vendida.

### 6. `SELECT FINAL`  
Retorna o produto mais vendido (#1 no ranking) por categoria de cliente.

---

## ✅ Exemplo de Saída

| SEGMENTO_RFM        | PRODUTO_ID | TOTAL_QUANTIDADE | RANK_PRODUTO |
|---------------------|------------|------------------|--------------|
| Clientes VIP        | P001       | 2,847           | 1            |
| Clientes Leais      | P023       | 1,456           | 1            |
| Novos Clientes      | P087       | 892             | 1            |
| Clientes Inativos   | P045       | 234             | 1            |

---

## ⚙️ Requisitos

Este script espera as seguintes tabelas:

### `vendas_rfm_simulada`
- `cliente_id`: Identificador único do cliente
- `data_venda`: Data da transação
- `valor_total`: Valor total da venda

### `plan1`
- `cliente_id`: Identificador do cliente (FK)
- `produto_id`: Identificador do produto
- `quantidade`: Quantidade vendida

---

## 🎯 Casos de Uso Práticos

### 📧 **Email Marketing Segmentado**
- Envie ofertas do produto mais popular para cada segmento
- Personalize campanhas baseadas no comportamento de compra

### 🛒 **Recomendações de Produto**
- Sugira produtos baseados no que outros clientes similares mais compram
- Implemente "Clientes como você também compraram..."

### 📈 **Estratégia de Pricing**
- Ajuste preços dos produtos mais vendidos por segmento
- Crie bundles específicos para cada categoria

### 🎁 **Programas de Fidelidade**
- Ofereça recompensas nos produtos de maior afinidade
- Crie níveis de programa baseados na segmentação RFM

---

## ✍️ Autor

## Gustavo Barbosa 
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/gustavo-barbosa-868976236/) [![Email](https://img.shields.io/badge/Email-gustavobarbosa7744@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:gustavobarbosa7744@gmail.com)

---

## 🧠 Dica Final

> **Este script pode ser expandido para incluir análises temporais, sazonalidade de produtos por segmento, ou integração com ferramentas de CRM.** Sua estrutura modular com CTEs permite fácil adaptação para diferentes necessidades de negócio, desde e-commerce até varejo tradicional.

### 🔄 Próximos Passos Sugeridos
- Adicionar análise temporal (produtos por segmento ao longo do tempo)
- Incluir margem de lucro para priorizar produtos mais rentáveis
- Integrar com dados de estoque para otimizar reposição segmentada
