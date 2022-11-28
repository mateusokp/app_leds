# app_leds

Aplicativo para controle de leds utilizado no artigo "Adjustable lighting system based on circadian rhythm for human 
comfort" 
Disponivel em: https://link.springer.com/article/10.1007/s12596-022-00874-4

Ele consta de algumas telas onde o usuário pode controlar tanto a luminosidade quanto a temperatura de cor dos leds, contando com um modo automático que modifica estas variáveis conforme de forma a se adequar da melhor forma com o ciclo circadiano.

![image](https://user-images.githubusercontent.com/32492663/184215016-49983abf-dbb2-41a3-856e-c28366627c22.png)

A conexão do aplicativo é feita via Wi-Fi com um microcontrolador (um ESP32 foi utilizado nos testes) e o código-fonte se encontra na pasta ESP deste mesmo repositório. Um diagrama esquemático do sistema pode ser analisado na imagem a seguir.

![image](https://user-images.githubusercontent.com/32492663/184215795-1611c1ff-b04b-437f-ae20-e3df75abba5e.png)
