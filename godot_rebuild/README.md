# Pascal VR Study — reconstrução editável

Este diretório contém uma primeira base reconstruída em Godot, com cenário procedural editável e tentativa de suporte a OpenXR (Quest) e WebXR (navegador).

## O que já existe
- Projeto Godot com cena principal e script de construção do ambiente.
- Sala histórica de dois níveis, vigas, piso, escada, estantes, livros, mesa, manuscritos, lareira, luzes quentes e tapeçaria.
- Câmera XR e controladores.
- Botão para solicitar entrada em VR durante uma interação do usuário.
- Movimento de teste por WASD fora do VR.

## Importante
Esta é uma reconstrução inicial feita por geometria procedural, não uma cópia exata dos modelos originais. Ainda não foi compilada nem testada num Quest 3. A versão Android/OpenXR exige configurar o export preset e validar o suporte OpenXR no editor Godot. A versão WebXR precisa ser exportada pelo Godot para Web com o módulo WebXR disponível e publicada em HTTPS.

## Abrir
1. Baixe ou clone o repositório e abra a pasta godot_rebuild no Godot 4.x.
2. Execute main.tscn.
3. Para testar em tela, use WASD.
4. Para VR, configure a exportação apropriada (WebXR para navegador ou Android/OpenXR para Quest).

## Próximas etapas
1. Abrir no Godot e corrigir qualquer erro de parser/versão.
2. Adicionar locomoção confortável por controle e teletransporte.
3. Ajustar geometria, escala, colisões, iluminação e desempenho no headset.
4. Gerar builds separados para Web e Android.
