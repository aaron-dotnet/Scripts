Console.WriteLine("=== System Information ===");
Console.WriteLine();

Console.WriteLine($"Machine Name:    {Environment.MachineName}");
Console.WriteLine($"User Name:       {Environment.UserName}");
Console.WriteLine($"OS:              {Environment.OSVersion}");
Console.WriteLine($"Dotnet version:  {Environment.Version}");
Console.WriteLine($"64-bit OS:       {Environment.Is64BitOperatingSystem}");
Console.WriteLine($"64-bit Process:  {Environment.Is64BitProcess}");
Console.WriteLine($"Processor Count: {Environment.ProcessorCount}");
Console.WriteLine($"Current Dir:     {Environment.CurrentDirectory}");
Console.WriteLine();
