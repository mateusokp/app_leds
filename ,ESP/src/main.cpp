#include <WiFi.h>
#include <EEPROM.h>



WiFiServer sv(555);//Cria o objeto servidor na porta 555
WiFiClient cl;//Cria o objeto cliente.

int LED_BUILTIN = 2; //Setup do led de aviso

String getValue(String data, char separator, int index) //Separa string recebida em partes
{
  int found = 0;
  int strIndex[] = {0, -1};
  int maxIndex = data.length()-1;

  for(int i=0; i<=maxIndex && found<=index; i++){
    if(data.charAt(i)==separator || i==maxIndex){
        found++;
        strIndex[0] = strIndex[1]+1;
        strIndex[1] = (i == maxIndex) ? i+1 : i;
    }
  }
  return found>index ? data.substring(strIndex[0], strIndex[1]) : "";
}

int Temp = 4100, Luz = 250;//Declaração de variaveis
bool Mode = false; 
String ssid = "aaaa",senha = "aaaa",hora;


void WritetoMemory(){//Escreve dados na memoria de longo prazo do ESP
    byte lenid = ssid.length(),lenpw = senha.length();
    EEPROM.write(10,lenid);
    EEPROM.write(100,lenpw);
    
    for (int i = 0; i < lenid; i++){
        EEPROM.write(10 + 1 + i, ssid[i]);
    }
    
    for (int i = 0; i < lenpw; i++){
        EEPROM.write(100 + 1 + i, senha[i]);
    }

    EEPROM.commit();//Grava dados
    Serial.print("\nGravado na memoria com sucesso\n");
}

void ReadfromMemory(){//Extrai dados da memoria do ESP
    int newidlen = EEPROM.read(10), newpwlen = EEPROM.read(100);
    char dadosi[newidlen + 1], dadosp[newpwlen + 1];

    for (int i = 0; i < newidlen; i++){
        dadosi[i] = EEPROM.read(10 + 1 + i);
    }
    dadosi[newidlen] = '\0';
    ssid = String(dadosi);

    for (int i = 0; i < newpwlen; i++){
        dadosp[i] = EEPROM.read(100 + 1 + i);
    }
    dadosp[newpwlen] = '\0';
    senha = String(dadosp);

    Serial.print("\nLido da memoria com sucesso, variaveis: ");
    Serial.print("\nssid: ");
    Serial.print(ssid);
    Serial.print("\nsenha: ");
    Serial.print(senha);
}



void setup()
{
    
    Serial.begin(115200);//Habilita a comm serial.
    EEPROM.begin(512); //Habilita memoria ROM
    WiFi.mode(WIFI_STA);//Define WiFi como Station

    pinMode (LED_BUILTIN, OUTPUT);//Setup do led de aviso

    ReadfromMemory();
    char ssidf[ssid.length()+1], senhaf[senha.length()+1];
    ssid.toCharArray(ssidf, ssid.length()+1); 
    senha.toCharArray(senhaf, senha.length()+1); 
    WiFi.begin(ssidf,senhaf);
    Serial.print("\nTentando conectar-se as credenciais salvas...");


    for (int i = 0; i<20; i++){
        if(WiFi.status() != WL_CONNECTED){
            Serial.print(" .");
            delay(500);
        }
    }
    if (WiFi.status() != WL_CONNECTED){

        IPAddress local_IP(192, 168, 0, 218);//Define endereço IP fixo
        IPAddress gateway(192, 168, 0, 1);
        IPAddress subnet(255, 255, 0, 0);

        Serial.print("\nERRO. Iniciando modo AP...");
        digitalWrite(LED_BUILTIN, HIGH);
        WiFi.mode(WIFI_AP);//Define o WiFi como Acess_Point.
        WiFi.softAP("NodeMCU", "");//Cria a rede de Acess_Point.
        delay(500);
        WiFi.softAPConfig(local_IP,gateway,subnet);
        delay(50);
        sv.begin();//Inicia o servidor TCP na porta declarada no começo.
        Serial.print(local_IP);
        //Disponabiliza o servidor para o cliente se conectar.
        
        uint32_t periodo = 90000L;//Inicia timer 90 segundos

            for (uint32_t tStart = millis(); (millis() - tStart) < periodo; ){//ativo enquanto o timer nao chega a zero
                cl = sv.available();
                if (cl.connected()){
                    //caso detecte conexao
                    Serial.print("\nCliente detectado!");
                    delay(1);
                    goto bypass;
                }
            }
            Serial.print("\nNenhum cliente conectado, reiniciando...");
            delay(1000);
            ESP.restart();

            bypass:
                delay(500);
        }else if (WiFi.status() == WL_CONNECTED){
            Serial.print(" Conectado!");
            String gtwy = WiFi.gatewayIP().toString();
            int gtwy_n = getValue(gtwy,'.',2).toInt();
            IPAddress local_IP(192, 168, gtwy_n, 218);
            delay(100);
            sv.begin();
            Serial.print("\nIniciando servidor TCP...\nIP local: ");
            Serial.print(local_IP);
            delay(150);
        }
}



void tcp()
{
    if (cl.connected())//Detecta se há clientes conectados no servidor.
    {
        if (cl.available() > 0)//Verifica se o cliente conectado tem dados para serem lidos.
        {
            String req = "";
            while (cl.available() > 0)//Armazena cada Byte (letra/char) na String para formar a mensagem recebida.
            {
                char z = cl.read();
                req += z;
            }
            String parte01 = getValue(req,',',0);
            if (parte01[0] == '0'){

                Temp = getValue(req,',',1).toInt();
                Luz = getValue(req,',',2).toInt();
                hora = getValue(req,',',3);

                String parte04 = getValue(req,',',4);
                if(parte04[0] == 't'){
                    Mode = true;
                }else{
                    Mode = false;
                }
            Serial.print("\n--------------- DADOS --------------");
            Serial.print("\nTemp = ");
            Serial.print(Temp);
            Serial.print("\nLuz = ");
            Serial.print(Luz);
            Serial.print("\nModo = ");
            if(Mode == false){
                Serial.print("Manual");
            }else{
                Serial.print("Automatico");
            }
            Serial.print("\nHorario: ");
            Serial.print(hora);
            

            }else if (parte01[0] == '1'){
                ssid = getValue(req,',',1);
                senha = getValue(req,',',2);
                Serial.print("\n--------------- Credenciais Recebidas --------------");
                Serial.print("\nSSID: ");
                Serial.print(ssid);
                Serial.print("\nSenha: ");
                Serial.print(senha);
                WritetoMemory();
                ESP.restart();
            }      
        }
    }
    else//Se nao houver cliente conectado,
    {
        cl = sv.available();//Disponabiliza o servidor para o cliente se conectar.
        delay(1);
    }
}

void loop()
{
    tcp();//Funçao que gerencia os pacotes e clientes TCP.
}
