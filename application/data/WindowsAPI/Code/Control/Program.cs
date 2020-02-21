using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading;
using Newtonsoft.Json.Linq;
using Quobject.SocketIoClientDotNet.Client;

namespace Control
{
    class Program
    {
        [StructLayout(LayoutKind.Explicit)]
        internal struct INPUT
        {
            [FieldOffset(0)]
            internal int type;
            [FieldOffset(4)]
            internal MOUSEINPUT mi;
            [FieldOffset(4)]
            internal KEYBDINPUT ki;
            [FieldOffset(4)]
            internal HARDWAREINPUT hi;
        }
        [StructLayout(LayoutKind.Sequential)]
        internal struct KEYBDINPUT
        {
            internal ushort wVk;
            internal ushort wScan;
            internal uint dwFlags;
            internal uint time;
            internal IntPtr dwExtraInfo;
        }
        [StructLayout(LayoutKind.Sequential)]
        internal struct HARDWAREINPUT
        {
            internal int uMsg;
            internal short wParamL;
            internal short wParamH;
        }
        [StructLayout(LayoutKind.Sequential)]
        internal struct MOUSEINPUT
        {
            internal int dx;
            internal int dy;
            internal int mouseData;
            internal int dwFlags;
            internal int time;
            internal IntPtr dwExtraInfo;
        }
        [DllImport("user32.dll", SetLastError = true)]
        internal static extern uint SendInput(uint nInput, ref INPUT pInput, int cbSize);
        [DllImport("user32.dll", EntryPoint = "keybd_event")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, uint dwExtraInfo);
        [DllImport("user32.dll", EntryPoint = "mouse_event")]
        private static extern int mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);
        [DllImport("user32.dll", EntryPoint = "SetCursorPos")]
        private static extern int SetCursorPos(int x, int y);
        [DllImport("user32.dll", EntryPoint = "GetCursorPos")]
        internal extern static bool GetCursorPos(out MousePoint point);
        internal struct MousePoint
        {
            public int x;
            public int y;
        };

        // main
        static int Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("未輸入ip");
                Console.ReadLine();
                return 0;
            }

            string connectUrl = args[0];

            Dictionary<String, String> query = new Dictionary<String, String>();
            query.Add("type", "controller");

            var options = new IO.Options();
                options.Query = query;

            var socket = IO.Socket(connectUrl, options);
            socket.On(Socket.EVENT_CONNECT, () =>
            {
                Console.WriteLine("");
                Console.WriteLine("==================================");
                Console.WriteLine("Controller Connect Success.");
                Console.WriteLine("SocketIo On \"GetMousePos\" Channel.");
                Console.WriteLine("SocketIo On \"Controller\" Channel.");
                Console.WriteLine("{ type: KeyDown     , value: int }");
                Console.WriteLine("{ type: KeyUp       , value: int }");
                Console.WriteLine("{ type: DirectInput , value: int }");
                Console.WriteLine("{ type: MouseTo     , value: [int, int] }");
                Console.WriteLine("{ type: MouseMove   , value: [int, int] }");
                Console.WriteLine("{ type: MouseWheel  , value: int }");
                Console.WriteLine("{ type: MouseEvent  , value: int }");
                Console.WriteLine("==================================");
                Console.WriteLine("");
            });
            socket.On("GetMousePos", () =>
            {
                Array mousePos = GetMousePoint();
                socket.Emit("MousePos", "[" + mousePos.GetValue(0) + "," + mousePos.GetValue(1) + "]");
            });
            socket.On("Controller", (data) =>
            {
                JObject jo = JObject.Parse(data.ToString());
                string type = jo["type"].ToString();
                if (type == "KeyDown")
                {
                    byte value = byte.Parse(jo["value"].ToString());
                    KeyDown(value);
                    return;
                }
                if (type == "KeyUp")
                {
                    byte value = byte.Parse(jo["value"].ToString());
                    KeyUp(value);
                    return;
                }
                if (type == "DirectInput")
                {
                    ushort value = ushort.Parse(jo["value"].ToString());
                    DirectInput(value);
                    return;
                }
                if (type == "MouseMove")
                {
                    int x = int.Parse(jo["value"][0].ToString());
                    int y = int.Parse(jo["value"][1].ToString());
                    MouseMove(x, y);
                    return;
                }
                if (type == "MouseWheel")
                {
                    int value = int.Parse(jo["value"].ToString());
                    MouseWheel(value);
                    return;
                }
                if (type == "MouseTo")
                {
                    int x = int.Parse(jo["value"][0].ToString());
                    int y = int.Parse(jo["value"][1].ToString());
                    MouseTo(x, y);
                    return;
                }
                if (type == "MouseEvent")
                {
                    int value = int.Parse(jo["value"].ToString());
                    MouseEvent(value);
                    return;
                }
            });
            Console.ReadLine();
            return 0;
        }
        static void KeyDown(byte key) {
            keybd_event(key, 0, 0, 0);
        }
        static void KeyUp(byte key)
        {
            keybd_event(key, 0, 2, 0);
        }
        static void DirectInput(ushort key)
        {
            INPUT Input = new INPUT();
            Input.type = 1;
            Input.ki.wScan = key;
            Input.ki.dwFlags = 0x0008;
            SendInput(1, ref Input, Marshal.SizeOf(Input));
        }
        static void MouseMove(int x, int y)
        {
            mouse_event(0x0001, x, y, 0, 0);
        }
        static void MouseWheel(int scroll)
        {
            mouse_event(0x0800, 0, 0, scroll, 0);
        }
        static void MouseTo(int x, int y)
        {
            SetCursorPos(x, y);
        }
        static void MouseEvent(int code)
        {
            mouse_event(code, 0, 0, 0, 0);
        }
        static Array GetMousePoint()
        {
            MousePoint point;
            GetCursorPos(out point);
            int[] array = new int[2];
            array[0] = point.x;
            array[1] = point.y;
            return array;
        }
    }
}
