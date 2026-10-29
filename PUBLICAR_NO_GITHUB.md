# Como publicar esta versão no GitHub Pages

Este pacote já contém os três itens que precisam ficar na raiz do site:

```text
index.html
assets/PASCAL_QUARTO_PARIS_1650.glb
assets/paris_1650_panorama_cubo.jpg
```

## Atualizar o site atual

1. Baixe e extraia `PASCAL_WEBXR_CENARIO_ORIGINAL.zip` no computador.
2. Abra o repositório `danilorabayoli/pascal-webxr-2` no GitHub Desktop (ou no editor Git que você já usa).
3. Copie o `index.html` extraído para a raiz do repositório e copie a pasta `assets` inteira, mantendo os nomes e caminhos exatamente como estão.
4. Faça commit e push para a branch `main`.
5. Quando o GitHub Pages terminar a publicação, abra `https://danilorabayoli.github.io/pascal-webxr-2/` no navegador do Meta Quest 3 e pressione **Entrar em VR**.

**Importante:** o arquivo GLB tem cerca de 20 MB, por isso precisa ser enviado junto com o site. Não publique somente `index.html`; sem o GLB, a página não terá o cenário histórico. Não apague a pasta `assets` nem mude o nome do modelo.

Esta versão usa o modelo original enviado no ZIP. Ela não foi publicada automaticamente neste pacote, para preservar a página online atual até você decidir substituir os arquivos.
