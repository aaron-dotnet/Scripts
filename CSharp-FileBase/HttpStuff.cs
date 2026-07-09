#!/usr/bin/env dotnet
using System;
using System.Web;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.Threading;
using System.Collections.Generic;

// Diccionario para mostrar el nombre legible de la opción seleccionada
var nombresOpciones = new Dictionary<string, string>
{
    { "1", "URL Decode" },
    { "2", "URL Encode" },
    { "3", "HTML Decode" },
    { "4", "HTML Encode" },
    { "5", "Base64 Decode" },
    { "6", "Base64 Encode" },
    { "7", "Extraer Parámetros de URL" },
    { "8", "Limpiar Espacios y Saltos Línea" },
    { "9", "Eliminar Etiquetas HTML" }
};

while (true)
{
    Console.Clear();
    Console.ForegroundColor = ConsoleColor.Cyan;
    Console.WriteLine("=======================================");
    Console.WriteLine("             HERRAMIENTAS");
    Console.WriteLine("=======================================");
    Console.ResetColor();

    Console.WriteLine("Selecciona una opción:");
    Console.WriteLine("1. URL Decode                 6. Base64 Encode");
    Console.WriteLine("2. URL Encode                 7. Extraer Parámetros de URL");
    Console.WriteLine("3. HTML Decode                8. Limpiar Espacios y Saltos Línea");
    Console.WriteLine("4. HTML Encode                9. Eliminar Etiquetas HTML");
    Console.WriteLine("5. Base64 Decode              q. Salir");
    Console.Write("\nOpción elegida: ");

    ConsoleKeyInfo tecla = Console.ReadKey();
    string opcion = tecla.KeyChar.ToString();

    if (opcion.Equals("q", StringComparison.OrdinalIgnoreCase))
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.Clear();
        Console.WriteLine("""
             _______
            < nggyu >
             -------
                    \   ^__^
                     \  (oo)\_______
                        (__)\       )\/\
                            ||----w |
                            ||     ||
            """);
        Console.ResetColor();
        break;
    }

    if (!nombresOpciones.ContainsKey(opcion))
    {
        Console.Clear();
        MostrarError($"\nError: '{opcion}' no es una opción válida del menú.");
        PresionarParaContinuar();
        continue;
    }

    Console.Clear();
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine($"[ Opción activa: {nombresOpciones[opcion]} ]");
    Console.ResetColor();
    Console.WriteLine();

    Console.WriteLine("Pega tu texto aquí (se detecta automáticamente al terminar de pegar):");
    Console.WriteLine(new string('─', 50));

    string input = LeerTextoMultilinea();

    Console.Clear();

    if (string.IsNullOrWhiteSpace(input))
    {
        MostrarError("Error: El contenido ingresado está vacío.");
        PresionarParaContinuar();
        continue;
    }

    string resultado = string.Empty;
    string titulo = string.Empty;

    try
    {
        (titulo, resultado) = opcion switch
        {
            "1" => ("Resultado de URL Decode:", WebUtility.UrlDecode(input)),
            "2" => ("Resultado de URL Encode:", Uri.EscapeDataString(input)),
            "3" => ("Resultado de HTML Decode:", WebUtility.HtmlDecode(input)),
            "4" => ("Resultado de HTML Encode:", WebUtility.HtmlEncode(input)),
            "5" => ("Resultado de Base64 Decode:", DecodificarBase64(input)),
            "6" => ("Resultado de Base64 Encode:", Convert.ToBase64String(Encoding.UTF8.GetBytes(input))),
            "7" => ("Parámetros extraídos de la URL:", ProcesarParametrosUrl(input)),
            "8" => ("Texto con espacios y saltos limpios:", LimpiarEspaciosYSaltos(input)),
            "9" => ("Texto sin etiquetas HTML:", RegexPatrones.Html.Replace(input, string.Empty).Trim()),
            _ => ("Resultado:", string.Empty)
        };

        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine(titulo);
        Console.WriteLine(new string('─', Math.Min(titulo.Length, 50)));
        Console.ResetColor();

        Console.WriteLine(resultado);

        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine(new string('─', Math.Min(titulo.Length, 50)));
        Console.ResetColor();
    }
    catch (Exception ex)
    {
        MostrarError($"Ocurrió un error inesperado: {ex.Message}");
        PresionarParaContinuar();
        continue;
    }

    // Menú post-resultado: copiar o continuar
    Console.WriteLine();
    Console.ForegroundColor = ConsoleColor.DarkCyan;
    Console.WriteLine("[ C ] Copiar resultado al portapapeles    [ cualquier tecla ] Volver al menú");
    Console.ResetColor();

    ConsoleKeyInfo accion = Console.ReadKey(true);
    if (accion.KeyChar.ToString().Equals("c", StringComparison.OrdinalIgnoreCase))
    {
        CopiarAlPortapapeles(resultado);
    }
}

// ==========================================
// MÉTODOS AUXILIARES
// ==========================================

/// <summary>
/// Lee texto multilínea carácter a carácter.
/// Detecta el fin del pegado por ausencia de nuevos caracteres durante
/// un umbral de tiempo (pausaMs). Distingue entre saltos de línea del
/// propio texto pegado y el silencio real que indica que el clipboard
/// terminó de "escribir".
///
/// Flujo:
///   1. Espera el primer carácter (bloquea hasta que el usuario pegue algo).
///   2. Una vez recibido el primer carácter, pasa a modo "drenaje":
///      sigue leyendo mientras haya teclas disponibles o lleguen en menos de pausaMs.
///   3. Cuando transcurre pausaMs sin nuevos caracteres → fin de entrada.
/// </summary>
string LeerTextoMultilinea(int pausaMs = 200)
{
    var sb = new StringBuilder();

    // — Fase 1: esperar el primer carácter (bloqueante) —
    ConsoleKeyInfo primera = Console.ReadKey(intercept: true);
    if (primera.Key == ConsoleKey.Enter)
        sb.Append(Environment.NewLine);
    else if (primera.KeyChar != '\0')
        sb.Append(primera.KeyChar);

    // — Fase 2: drenar el resto del pegado con ventana de timeout —
    while (true)
    {
        long inicio = Environment.TickCount64;
        while (!Console.KeyAvailable)
        {
            if (Environment.TickCount64 - inicio >= pausaMs)
                goto FinLectura; // Silencio prolongado = fin del pegado
            Thread.Sleep(10);
        }

        ConsoleKeyInfo k = Console.ReadKey(intercept: true);

        if (k.Key == ConsoleKey.Enter)
            sb.Append(Environment.NewLine);
        else if (k.KeyChar != '\0')
            sb.Append(k.KeyChar);
    }

FinLectura:
    // Mostrar en consola lo que se capturó (feedback visual)
    Console.WriteLine(sb.ToString());
    Console.WriteLine(new string('─', 50));

    return sb.ToString().TrimEnd(Environment.NewLine.ToCharArray());
}

/// <summary>
/// Decodifica Base64 con validación previa del formato.
/// </summary>
string DecodificarBase64(string input)
{
    // Limpiar espacios y saltos que puedan haberse pegado accidentalmente
    string limpio = RegexPatrones.EspaciosYSaltos.Replace(input, string.Empty);

    // Validar que solo contenga caracteres Base64 válidos
    if (!RegexPatrones.Base64Valido.IsMatch(limpio))
        throw new FormatException("El texto no contiene un formato Base64 válido (caracteres no permitidos detectados).");

    // Corregir padding si falta
    int padding = limpio.Length % 4;
    if (padding == 2) limpio += "==";
    else if (padding == 3) limpio += "=";

    byte[] bytes = Convert.FromBase64String(limpio);
    return Encoding.UTF8.GetString(bytes);
}

/// <summary>
/// Extrae y decodifica los parámetros clave=valor de una query string o URL completa.
/// </summary>
string ProcesarParametrosUrl(string input)
{
    string queryString = input.Contains('?') ? input[(input.IndexOf('?') + 1)..] : input;
    // Ignorar fragmento (#) si existe
    int fragmento = queryString.IndexOf('#');
    if (fragmento >= 0) queryString = queryString[..fragmento];

    string[] pares = queryString.Split('&', StringSplitOptions.RemoveEmptyEntries);
    var sb = new StringBuilder();

    foreach (string par in pares)
    {
        int indiceIgual = par.IndexOf('=');
        if (indiceIgual > 0)
        {
            string llave = WebUtility.UrlDecode(par[..indiceIgual]);
            string valor = WebUtility.UrlDecode(par[(indiceIgual + 1)..]);
            sb.AppendLine($"{llave}: {valor}");
        }
        else if (par.Length > 0)
        {
            sb.AppendLine($"{WebUtility.UrlDecode(par)}: (sin valor)");
        }
    }

    string resultado = sb.ToString().TrimEnd();
    return string.IsNullOrEmpty(resultado)
        ? "No se logró extraer ningún parámetro. Verifica que la cadena contenga un formato llave=valor."
        : resultado;
}

/// <summary>
/// Elimina espacios/tabs múltiples y saltos de línea repetidos.
/// </summary>
string LimpiarEspaciosYSaltos(string input)
{
    string sinEspaciosExtra = RegexPatrones.EspaciosMultiples.Replace(input, " ");
    return RegexPatrones.SaltosMultiples.Replace(sinEspaciosExtra, Environment.NewLine).Trim();
}

void MostrarError(string mensaje)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.WriteLine(mensaje);
    Console.ResetColor();
}

void PresionarParaContinuar()
{
    Console.WriteLine("\nPresiona cualquier tecla para volver al menú principal...");
    Console.ReadKey(true);
}

/// <summary>
/// Copia texto al portapapeles de forma multiplataforma.
/// Usa clip (Windows), xclip/xsel (Linux) o pbcopy (macOS).
/// </summary>
void CopiarAlPortapapeles(string texto)
{
    try
    {
        string os = Environment.OSVersion.Platform.ToString();
        System.Diagnostics.ProcessStartInfo psi;

        if (OperatingSystem.IsWindows())
        {
            psi = new("cmd", "/c clip") { RedirectStandardInput = true, UseShellExecute = false };
        }
        else if (OperatingSystem.IsMacOS())
        {
            psi = new("pbcopy") { RedirectStandardInput = true, UseShellExecute = false };
        }
        else
        {
            // Linux: intenta xclip, si no xsel
            psi = new("xclip", "-selection clipboard") { RedirectStandardInput = true, UseShellExecute = false };
        }

        using var proceso = System.Diagnostics.Process.Start(psi)
            ?? throw new Exception("No se pudo iniciar el proceso del portapapeles.");

        proceso.StandardInput.Write(texto);
        proceso.StandardInput.Close();
        proceso.WaitForExit();

        Console.ForegroundColor = ConsoleColor.Cyan;
        Console.WriteLine("\n✓ Resultado copiado al portapapeles.");
        Console.ResetColor();
        Thread.Sleep(800);
    }
    catch (Exception ex)
    {
        MostrarError($"\nNo se pudo copiar al portapapeles: {ex.Message}");
        PresionarParaContinuar();
    }
}

// ==========================================
// REGEX ESTÁTICAS COMPILADAS (instancia única, no se recrean en cada llamada)
// ==========================================
static class RegexPatrones
{
    /// <summary>Uno o más espacios/tabs consecutivos.</summary>
    public static readonly Regex EspaciosMultiples = new(@"[ \t]+", RegexOptions.Compiled);

    /// <summary>Dos o más saltos de línea consecutivos.</summary>
    public static readonly Regex SaltosMultiples = new(@"(\r?\n){2,}", RegexOptions.Compiled);

    /// <summary>Etiquetas HTML (incluyendo comentarios <!-- --> y CDATA).</summary>
    public static readonly Regex Html = new(@"<!--.*?-->|<!\[CDATA\[.*?\]\]>|<.*?>", RegexOptions.Compiled | RegexOptions.Singleline);

    /// <summary>Espacios y saltos — usado para limpiar input Base64 antes de validar.</summary>
    public static readonly Regex EspaciosYSaltos = new(@"\s+", RegexOptions.Compiled);

    /// <summary>Valida que un string solo contenga caracteres Base64 legítimos.</summary>
    public static readonly Regex Base64Valido = new(@"^[A-Za-z0-9+/]*={0,2}$", RegexOptions.Compiled);
}
