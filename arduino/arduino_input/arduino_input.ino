const int buttonPin1 = 4;  
const int buttonPin2 = 5;  
const int buttonPin3 = 6; 
const int buttonPin4 = 7;  

// Button states and debounce variables for Button1 and Button2
int buttonState1 = 0;
int lastButtonState1 = 0;
int buttonState2 = 0;
int lastButtonState2 = 0;
unsigned long lastDebounceTime1 = 0;
unsigned long lastDebounceTime2 = 0;

// Button states and debounce variables for Button3 and Button4
int buttonState3 = 0;
int lastButtonState3 = 0;
int buttonState4 = 0;
int lastButtonState4 = 0;
unsigned long lastDebounceTime3 = 0;
unsigned long lastDebounceTime4 = 0;

unsigned long debounceDelay = 10; // Debounce delay in milliseconds

void setup() {
  // Initialize serial communication
  Serial.begin(115200); // Ensure this matches the baud rate in Godot.

  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  pinMode(buttonPin3, INPUT);
  pinMode(buttonPin4, INPUT);
}

void loop() {
  // Read the current state of all buttons
  int reading1 = digitalRead(buttonPin1);
  int reading2 = digitalRead(buttonPin2);
  int reading3 = digitalRead(buttonPin3);
  int reading4 = digitalRead(buttonPin4);

  // Handle debouncing for Button 1
  if (reading1 != lastButtonState1) {
    lastDebounceTime1 = millis(); // Reset debounce timer for Button1
  }

  if (reading2 != lastButtonState2) {
    lastDebounceTime2 = millis(); 
  }

  if (reading3 != lastButtonState3) {
    lastDebounceTime3 = millis(); 
  }

  if (reading4 != lastButtonState4) {
    lastDebounceTime4 = millis(); 
  }

  // Process Button1 if the debounce delay has passed
  if ((millis() - lastDebounceTime1) > debounceDelay) {
    if (reading1 != buttonState1) {
      buttonState1 = reading1;
      if (buttonState1 == HIGH) {
        Serial.println("Button1Pressed"); // Send signal to Godot
      }
    }
  }

  if ((millis() - lastDebounceTime2) > debounceDelay) {
    if (reading2 != buttonState2) {
      buttonState2 = reading2;
      if (buttonState2 == HIGH) {
        Serial.println("Button2Pressed"); 
      }
    }
  }

  if ((millis() - lastDebounceTime3) > debounceDelay) {
    if (reading3 != buttonState3) {
      buttonState3 = reading3;
      if (buttonState3 == HIGH) {
        Serial.println("Button3Pressed"); // Send signal to Godot for Player2
      }
    }
  }

  if ((millis() - lastDebounceTime4) > debounceDelay) {
    if (reading4 != buttonState4) {
      buttonState4 = reading4;
      if (buttonState4 == HIGH) {
        Serial.println("Button4Pressed");
      }
    }
  }

  // Save the current button states for the next loop iteration
  lastButtonState1 = reading1;
  lastButtonState2 = reading2;
  lastButtonState3 = reading3;
  lastButtonState4 = reading4;
}
