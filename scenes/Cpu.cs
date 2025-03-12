using Godot;
using System;
using System.IO.Ports;
using System.Text;

namespace Pong_tut
{
    public partial class CPU : StaticBody2D
    {
        SerialPort serialPort;
        private int winHeight;
        private int pHeight;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
            GD.Print("Entering _Ready method.");
            try
            {
                if (serialPort == null)
                {
                    GD.Print("Initializing serial port1.");
                    serialPort = new SerialPort();
                    serialPort.PortName = "COM14"; // Ensure this matches your actual port name
                    serialPort.BaudRate = 115200; // Make sure this is the same in Arduino as it is in Godot.
                    serialPort.Encoding = Encoding.ASCII; // Ensure the encoding matches
                    serialPort.Open();

                    if (serialPort.IsOpen)
                    {
                        GD.Print("Serial port opened successfully1.");
                    }
                    else
                    {
                        GD.Print("Failed to open serial port1.");
                    }
                }
            }
            catch (UnauthorizedAccessException ex)
            {
                GD.PrintErr("Access to the port is denied: " + ex.Message);
            }
            catch (Exception ex)
            {
                GD.PrintErr("Exception in _Ready: " + ex.Message);
            }
            winHeight = (int)GetViewportRect().Size.Y;
            pHeight = (int)GetNode<ColorRect>("ColorRect").Size.Y;
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void _Process(double delta)
        {
            if (serialPort == null)
            {
                GD.Print("Serial port is not initialized.");
                return;
            }

            if (!serialPort.IsOpen)
            {
                GD.Print("Serial port is not open1.");
                return;
            }

            try
            {
                // Check if there's data available to read
                if (serialPort.BytesToRead > 0)
                {
                    string serialMessage = serialPort.ReadLine(); // Non-blocking read
                    if (!string.IsNullOrEmpty(serialMessage))
                    {
                        GD.Print("Received message: " + serialMessage);
                        if (serialMessage.Contains("Button1Pressed"))
                        {
                            Position += new Vector2(0, -GetParent().Get("PADDLE_SPEED").As<float>() * (float)delta);
                        }
                        else if (serialMessage.Contains("Button2Pressed"))
                        {
                            Position += new Vector2(0, GetParent().Get("PADDLE_SPEED").As<float>() * (float)delta);
                        }

                        // Limit paddle movement to window
                         Position = new Vector2(Position.X, Mathf.Clamp(Position.Y, 85 + pHeight / 2, 630 - pHeight / 2));
                    }
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr("Exception in _Process: " + ex.Message);
            }
        }
    }
}