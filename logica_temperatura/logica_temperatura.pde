/**
 ****************Termomemtro Virtual****************
 * Codigo,que contiene toda la logica sobre un termometro 
 * virtual, usando un sensor LM35 y Arduino. 
 * Aqui se sentra toda la interfaz de usuario asi como la 
 * obtencion de los datos de arduino
 *******************************************************
 */
 
 // Se importantan toda las librerias que se usaran en el proyecto
import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

// Se crea un espacio de memoria, para el puerto serial
private Serial puerto;

// Lugar donde se guardara el valor del sensor devuelto en grados centrigados
private int valorTemp;
// Lugarda donde se guardara una imagen, que servira de fondo
private PImage img;

// Se crea una variable para la fecha
private Date fecha;

// Se crean dos variables, para los diferente formatos de la fecha
private SimpleDateFormat formatoFecha;
private SimpleDateFormat formatoHora;

// La fuente que se usara en el proyecto
private PFont fuente;


void setup() {
  size(300, 300);

  printArray(Serial.list());

  String nombrePuerto = Serial.list()[1];

  puerto = new Serial(this, nombrePuerto, 9600);

  puerto.bufferUntil('\n');
}

void draw() {

  thread();

  fecha = new Date();
  formatoFecha = new SimpleDateFormat("EEE, d MMM yyyy");
  formatoHora = new SimpleDateFormat("h:mm:ss a");

  String horaActualFormato = formatoHora.format(fecha);
  String fechaActualFormato = formatoFecha.format(fecha); 

  transicionFondo();

  graficoTermometro(valorTemp);

  fuente = loadFont("Chalkboard-Bold-48.vlw");
  textFont(fuente);
  text(valorTemp + "\u00b0", width / 2 - 30, height / 2 + 40);

  fill(0);
  fuente = loadFont("Chalkboard-16.vlw");
  textFont(fuente);
  text(horaActualFormato, 200, height - 5);

  text(fechaActualFormato, 10, 20);
}

void thread() {
  lecturaPuertoSerial();
}

void lecturaPuertoSerial() {
  if (puerto.available() > 0) {
    String inPuerto = puerto.readStringUntil('\n');

    if (inPuerto != null) {
      inPuerto = trim(inPuerto);

      String dato = inPuerto;
      try {
        valorTemp = Integer.parseInt(dato);
        if (valorTemp > 60 || valorTemp < 0) {
          valorTemp = 0;
        }
      } 
      catch(NumberFormatException e) {
        println(e);
      }
    }
  }
  println("El valor de la temperatura es: " + valorTemp);
}

void transicionFondo() {
  if (valorTemp >= 0 && valorTemp < 16 ) {
    img = loadImage("data/frio.png");
    image(img, 0, 0, width, height);
    delay(100);
  } else if (valorTemp >= 16 && valorTemp < 30) {
    img = loadImage("data/agradable.jpg");
    image(img, 0, 0, width, height);
    delay(100);
  } else {
    img = loadImage("data/caluroso.jpg");
    image(img, 0, 0, width, height);
    delay(100);
  }
}

void graficoTermometro(int temperatura) {
  int alturaVariable = temperatura;
  noFill();
  rect(width / 2 - 25, height / 2 + 50, 50, 150, 7);

  if (temperatura < 0 || temperatura > 60) {
    temperatura = 0;
    alturaVariable = 0;
  } else {
    alturaVariable = ((temperatura * 100) / 60);
    alturaVariable = alturaVariable * (-1);
  }
  colorRectangulo(temperatura);
  rect(width / 2 - 25, height, 50, alturaVariable);
  noFill();
}

void colorRectangulo(int temperatura) {
  float temp = map(temperatura, 10, 40, 0, 255);
  fill(temp + 3, temp * -1 + 255, temp * -1 + 255);
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    exit();
  }
}