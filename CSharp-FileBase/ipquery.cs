using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

class Program {
    static async Task Main(string[] args) {
        if (args.Length == 0) {
            Console.WriteLine("Usage: ipquery <ip> [ip2] ...");
            return;
        }
        using HttpClient client = new HttpClient();
        foreach (string ip in args) {
            if (!IPAddress.TryParse(ip, out _)) {
                Console.WriteLine($"Invalid IP address: {ip}");
                continue;
            }
            string response = await client.GetStringAsync($"https://api.ipquery.io/{ip}");
            Console.WriteLine(response);
        }
    }
}