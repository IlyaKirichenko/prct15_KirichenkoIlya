using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace prct15
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void listViewIndex_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtWord.Text))
            {
                MessageBox.Show("Введите слово", "Ошибка");
            }
            if (string.IsNullOrWhiteSpace(txtPage.Text))
            {
                MessageBox.Show("Введите страницу", "Ошибка");
            }
        }
    }
}
