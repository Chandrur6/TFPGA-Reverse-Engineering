#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "TFPGA_DAY4";
const char* password = "12345678";

WebServer server(80);

// T-FPGA communication lines
#define FPGA_D0 3
#define FPGA_D1 5
#define FPGA_D2 6
#define FPGA_D3 4

void handleRoot()
{
  int d0 = digitalRead(FPGA_D0);
  int d1 = digitalRead(FPGA_D1);
  int d2 = digitalRead(FPGA_D2);
  int d3 = digitalRead(FPGA_D3);

  int fpga_value =
      (d3 << 3) |
      (d2 << 2) |
      (d1 << 1) |
      d0;

  String page = "";

  page += "<html>";
  page += "<head><title>T-FPGA Status</title></head>";
  page += "<body>";
  page += "<h1>T-FPGA Day 4</h1>";

  page += "<h2>ESP32-S3 Wi-Fi</h2>";
  page += "<p>Status: CONNECTED</p>";

  page += "<h2>FPGA Communication</h2>";
  page += "<p>D0 = " + String(d0) + "</p>";
  page += "<p>D1 = " + String(d1) + "</p>";
  page += "<p>D2 = " + String(d2) + "</p>";
  page += "<p>D3 = " + String(d3) + "</p>";

  page += "<h2>FPGA Value = ";
  page += String(fpga_value);
  page += "</h2>";

  page += "</body>";
  page += "</html>";

  server.send(200, "text/html", page);
}

void setup()
{
  Serial.begin(115200);

  pinMode(FPGA_D0, INPUT);
  pinMode(FPGA_D1, INPUT);
  pinMode(FPGA_D2, INPUT);
  pinMode(FPGA_D3, INPUT);

  WiFi.softAP(ssid, password);

  Serial.println("Wi-Fi Access Point Started");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());

  server.on("/", handleRoot);
  server.begin();
}

void loop()
{
  server.handleClient();
}