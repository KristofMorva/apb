using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication2
{
    class Program
    {     
        static void Main(string[] args)
        {
            char[] items = { 'U', 'B', 'W', '9', 'C', 'E', '3', 'L', 'H', '7', 'S', 'Q', 'J', 'G', 'Z', '5', 'I', 'N', 'K', 'Y', 'T', '4', 'M', 'P', '0', 'R', 'F', '1', 'V', 'A', '8', '2', 'X', 'O', 'D', '6', 'd', 'i', 'w', 'o', 'g', 'u', 'v', 'b', 'y', 'r', 'l', 'h', 'z', 'm', 'k', 'p', 'a', 'n', 't', 'q', 'e', 'c', 'x', 'j', 's', 'f' };
            do
            {
                Console.Write("Code [A-Z0-9]: ");
                string code = Console.ReadLine();

                // Encrypt
                Random r = new Random();
                int r1 = r.Next(1, 27);
                int r2 = r.Next(1, 27);
                int[] shift = { Math.Abs(r1 - r2), ((r2 + r1) / 2), Math.Abs(26 - (r2 + r1)) };
                string ed = "";
                for (int i = 0; i < code.Length; i++)
                {
                    ed += items[Array.IndexOf(items, code[i]) + shift[i % 3]];
                }
                ed = items[r1].ToString() + ed + items[r2].ToString();
                Console.WriteLine("Encrypt: " + ed);

                // Decrypt
                code = "";
                r1 = Array.IndexOf(items, ed[0]);
                r2 = Array.IndexOf(items, ed[ed.Length - 1]);
                Console.WriteLine("r1: " + r1 + ", r2: " + r2);
                int[] backshift = { Math.Abs(r1 - r2), ((r2 + r1) / 2), Math.Abs(26 - (r2 + r1)) };
                for (int i = 1; i <= ed.Length - 2; i++)
                {
                    code += items[Array.IndexOf(items, ed[i]) - backshift[(i - 1) % 3]];
                }
                Console.WriteLine("Decrypt: " + code + "\r\n---------------------");
            }
            while (true);
        }
    }
}
