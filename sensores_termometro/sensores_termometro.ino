const int pinLM35 = A0;
const int pinBuzzer = 5;

int valorTemp = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  valorTemp = analogRead(pinLM35);

  valorTemp = (5.0f * valorTemp * 100) / 1023.0f;

  if (valorTemp == 20 || valorTemp == 30) {
    beep(200);
  }

  Serial.println(valorTemp);
  delay(200);
}

void beep(unsigned char pausa) {
  analogWrite(pinBuzzer, 200);
  delay(pausa);
  analogWrite(pinBuzzer, 0);
  delay(pausa);
}
