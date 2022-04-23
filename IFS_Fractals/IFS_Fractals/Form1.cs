using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace IFS_Fractals
{
    public partial class Form1 : Form
    {
        Bitmap bm;
        double x_min = -2.1, x_max = 0.5;
        double y_min = -1.2, y_max = 1.2;
        double a = -2.1, b = 1.2, pom_b;
        double pom_wysokosc = 600, pom_szerokosc = 800;
        double mag = 0, liczba = 0;


        Rectangle rect;
        Point LocationXY;
        Point LocationX1Y1;
        bool IsMouseDown = false;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Shown(object sender, EventArgs e)
        {
            rysuj();
        }

        private void rysuj()
        {
            double xe = 0, ye = 0;

            double wysokosc = (Math.Abs(y_min - y_max)) / pom_wysokosc;
            double szerokosc = (Math.Abs(x_min - x_max)) / pom_szerokosc;

            xe = x_min - szerokosc;
            ye = y_max + wysokosc;
            pom_b = ye;

            bm = new Bitmap(pictureBox1.Width, pictureBox1.Height);
            for (int x = 0; x < pictureBox1.Width; x++)
            {

                xe = a + (szerokosc * x);
                ye = pom_b;

                for (int y = 0; y < pictureBox1.Height; y++)
                {
                    ye = b - (wysokosc * y);

                    double[] c = { xe, ye };
                    double[] z = { 0, 0 };
                    int it = 0;
                    do
                    {
                        liczba = 0;
                        it++;
                        IFS_Fractals.IFS_FractalsLib.square(ref z[0], ref z[1]);
                        IFS_Fractals.IFS_FractalsLib.add_dod(ref z[0], ref c[0], ref z[1], ref c[1]);
                        IFS_Fractals.IFS_FractalsLib.magnitude(z[0], z[1], ref mag);
                        liczba = mag;
                        if ( liczba > 2.0) break;
                        
                    }
                    while (it < 100);

                    bm.SetPixel(x, y, it < 100 ? Color.White : Color.Black);
                }
            }
            pictureBox1.Image = bm;
        }

        private void policz(Rectangle reg)
        {
            double wysokosc = (Math.Abs(y_min - y_max)) / pom_wysokosc;
            double szerokosc = (Math.Abs(x_min - x_max)) / pom_szerokosc;

            double xe = a + (szerokosc * reg.X);
            double ye = b - (wysokosc * reg.Y);
            x_min = xe;
            x_max = a + (szerokosc * (reg.X + reg.Width)); ;
            y_min = b - (wysokosc * (reg.Y + reg.Height));
            y_max = ye;
            a = xe;
            b = ye;
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            IsMouseDown = true;
            LocationXY = e.Location;
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            if (IsMouseDown == true)
            {
                LocationX1Y1 = e.Location;
                Refresh();
            }
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
        {
            if (IsMouseDown == true)
            {
                LocationX1Y1 = e.Location;
                IsMouseDown = false;
            }

            policz(rect);
            rysuj();
            LocationXY.X = 0;
            LocationX1Y1.X = 0;
            LocationXY.Y = 0;
            LocationX1Y1.Y = 0;

        }

        private void pictureBox1_Paint(object sender, PaintEventArgs e)
        {
            if (rect != null)
            {
                Brush brush = new SolidBrush(Color.FromArgb(80, 0, 0, 255));
                e.Graphics.FillRectangle(brush, GetRect());
                e.Graphics.DrawRectangle(Pens.Blue, GetRect());
            }
        }

        private Rectangle GetRect()
        {
            rect = new Rectangle();

            rect.X = Math.Min(LocationXY.X, LocationX1Y1.X);
            rect.Y = Math.Min(LocationXY.Y, LocationX1Y1.Y);

            rect.Width = Math.Abs(LocationXY.X - LocationX1Y1.X);
            rect.Height = ((Math.Abs(LocationXY.X - LocationX1Y1.X)) * 3) / 4;

            return rect;
        }
    }
}
