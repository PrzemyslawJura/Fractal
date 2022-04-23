using System.Runtime.InteropServices;


namespace IFS_Fractals
{
    static class IFS_FractalsLib
    {
        private const string libName = "IFS_FractalsLib.DLL";



        [DllImport(libName, CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        public static extern void square(ref double a, ref double b);

        [DllImport(libName, CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        public static extern void add_dod(ref double ax, ref double bx, ref double ay, ref double by);

        [DllImport(libName, CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        public static extern double magnitude(double a, double b, ref double mag);


    }
}
