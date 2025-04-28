using System;
using System.Collections;
using System.Linq;
using System.Windows.Forms;

namespace prct15
{
    public partial class Form1 : Form
    {
        // Создание экземпляра класса PredUkaz
        PredUkaz ukaz = new PredUkaz();

        public Form1()
        {
            InitializeComponent();

            // Настройка контекстного меню для ListView
            listViewIndex.ContextMenuStrip = contextMenu;
            contextMenu.Items.Add("Редактировать", null, EditItem_Click);
            contextMenu.Items.Add("Удалить", null, DeleteItem_Click);
        }

        // Обработчик клика по кнопке "Добавить"
        private void btnAdd_Click(object sender, EventArgs e)
        {
            // Проверка, что оба поля (слово и страница) не пустые
            if (txtWord.Text == "" || txtPage.Text == "")
            {
                MessageBox.Show("Введите слово и страницу!");
                return;
            }

            // Проверка, что введенная страница - это число
            if (int.TryParse(txtPage.Text, out int page))
            {
                ukaz.Add(txtWord.Text, page); // Добавление слова и страницы в указатель
                RefreshList(); // Обновление списка в ListView
            }
            else
            {
                MessageBox.Show("Неверный номер страницы."); // Если страница не является числом
            }
        }

        // Метод для обновления списка в ListView
        private void RefreshList()
        {
            listViewIndex.Items.Clear(); // Очистить текущие элементы
            foreach (Predmet item in ukaz.Items) // Перебор всех элементов в указателе
            {
                var listItem = new ListViewItem(item.Word); // Создание нового элемента для ListView
                listItem.SubItems.Add(string.Join(", ", item.Pages.Cast<int>())); // Добавление страниц к слову
                listViewIndex.Items.Add(listItem); // Добавление элемента в ListView
            }
        }

        // Обработчик клика по пункту "Редактировать" в контекстном меню
        private void EditItem_Click(object sender, EventArgs e)
        {
            if (listViewIndex.SelectedItems.Count == 0) return; // Если ничего не выбрано, выход

            var selected = listViewIndex.SelectedItems[0]; // Выбранный элемент
            string oldWord = selected.Text; // Старое слово

            // Окно для ввода нового слова
            string newWord = Microsoft.VisualBasic.Interaction.InputBox("Новое слово:", "Редактировать", oldWord);
            string newPages = Microsoft.VisualBasic.Interaction.InputBox("Новые страницы через запятую:", "Редактировать", selected.SubItems[1].Text);

            if (!string.IsNullOrEmpty(newWord))
            {
                var pagesArray = new ArrayList();
                foreach (var p in newPages.Split(','))
                {
                    if (int.TryParse(p.Trim(), out int num)) // Проверка, что каждая страница - число
                        pagesArray.Add(num);
                    else
                    {
                        MessageBox.Show("Некорректный номер страницы. Попробуйте снова."); // Если есть некорректный ввод
                        return;
                    }
                }

                ukaz.Edit(oldWord, newWord, pagesArray); // Редактирование слова
                RefreshList(); // Обновление списка
            }
        }

        // Обработчик клика по пункту "Удалить" в контекстном меню
        private void DeleteItem_Click(object sender, EventArgs e)
        {
            if (listViewIndex.SelectedItems.Count == 0) return; // Если ничего не выбрано, выход

            var selected = listViewIndex.SelectedItems[0]; // Выбранный элемент
            string word = selected.Text; // Слово для удаления

            // Подтверждение удаления
            if (MessageBox.Show($"Удалить '{word}'?", "Подтверждение", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                ukaz.Delete(word); // Удаление слова из указателя
                RefreshList(); // Обновление списка
            }
        }
    }
}
