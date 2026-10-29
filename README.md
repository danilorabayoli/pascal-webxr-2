# Quarto de Blaise Pascal — WebXR com cenário original

Esta pasta usa o modelo `PASCAL_QUARTO_PARIS_1650.glb` enviado pelo usuário, em vez de uma sala recriada com formas simples. Também inclui o panorama de Paris e um personagem interativo de Blaise Pascal criado proceduralmente para o navegador.

## Testar no PC

O navegador precisa carregar o módulo Three.js pela internet. Por causa dos módulos JavaScript e das permissões WebXR, não abra o arquivo `index.html` diretamente como `file://`. Sirva esta pasta por HTTPS ou por um servidor local, por exemplo:

```bash
python -m http.server 8000
```

Depois abra `http://localhost:8000` no navegador do PC. No PC, clique na cena para capturar o mouse, use **W/A/S/D** para caminhar e mova o mouse para olhar. `Esc` libera o cursor.

## Meta Quest 3

Hospede os arquivos em um site HTTPS (por exemplo, GitHub Pages) e abra o endereço no navegador do Quest 3. Clique em **Entrar em VR** quando o navegador pedir permissão. O analógico esquerdo move; o direito faz giro em passos de 30°. Aponte o controle direito para Pascal ou para a Pascalina e aperte o gatilho para iniciar a conversa. Durante a conversa, o gatilho esquerdo avança e o direito fecha.

O código tenta primeiro a referência `local-floor` e tem uma segunda tentativa com `local` para navegadores com suporte diferente. O modo de fallback posiciona a câmera com uma altura-base.

## Observações

- O modelo GLB tem aproximadamente 20 MB sem compactação; o ZIP de distribuição é menor.
- As colisões do navegador são simplificadas: as paredes, o contorno da sala, a mesa, estantes e alguns móveis bloqueiam a caminhada; a rampa da escada ajusta a altura entre os andares.
- O desempenho e o comportamento dos controladores precisam ser confirmados no Meta Quest 3 real. O ambiente disponível aqui não tem o headset nem o runtime WebXR para validar uma sessão real.
- Esta pasta WebXR não substitui a variante Godot/OpenXR. A variante Godot é destinada à exportação como APK Android; esta é para navegador WebXR.
