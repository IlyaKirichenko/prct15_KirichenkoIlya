using System;
using System.Collections;
using System.IO;
using System.Linq;

namespace prct15
{
    // Класс для хранения слова и его страниц
    public class Predmet
    {
        public string Word { get; set; } // Слово
        public ArrayList Pages { get; set; } // Страницы

        public Predmet(string word, int page)
        {
            Word = word;
            Pages = new ArrayList() { page };
        }
    }

    // Класс для работы с указателем
    public class PredUkaz
    {
        public ArrayList Items { get; private set; } = new ArrayList(); // Список всех элементов в указателе

        // Метод для добавления нового слова и страницы
        public void Add(string word, int page)
        {
            foreach (Predmet item in Items)
            {
                if (item.Word == word)
                {
                    if (!item.Pages.Contains(page) && item.Pages.Count < 10)
                        item.Pages.Add(page); // Если слово уже есть, добавляем страницу
                    return;
                }
            }
            Items.Add(new Predmet(word, page)); // Если слова нет, добавляем его
        }

        // Метод для редактирования существующего слова и страниц
        public void Edit(string oldWord, string newWord, ArrayList newPages)
        {
            foreach (Predmet item in Items)
            {
                if (item.Word == oldWord)
                {
                    item.Word = newWord; // Изменяем слово
                    item.Pages = newPages; // Изменяем страницы
                    return;
                }
            }
        }

        // Метод для удаления слова из указателя
        public void Delete(string word)
        {
            for (int i = 0; i < Items.Count; i++)
            {
                Predmet item = (Predmet)Items[i];
                if (item.Word == word)
                {
                    Items.RemoveAt(i); // Удаляем слово
                    return;
                }
            }
        }

        // Метод для загрузки данных из файла
        public void LoadFromFile(string path)
        {
            if (!File.Exists(path)) return;

            Items.Clear(); // Очищаем текущие элементы
            foreach (var line in File.ReadAllLines(path))
            {
                var parts = line.Split(':');
                if (parts.Length != 2) continue;

                var word = parts[0].Trim();
                var pages = parts[1].Split(',').Select(p => int.Parse(p.Trim())).ToArray();

                var item = new Predmet(word, pages[0]);
                for (int i = 1; i < pages.Length && i < 10; i++)
                    item.Pages.Add(pages[i]);

                Items.Add(item); // Добавляем в коллекцию
            }
        }

        // Метод для сохранения данных в файл
        public void SaveToFile(string path)
        {
            var lines = new ArrayList();
            foreach (Predmet item in Items)
            {
                string line = item.Word + ":" + string.Join(",", item.Pages.Cast<int>());
                lines.Add(line);
            }
            File.WriteAllLines(path, lines.Cast<string>().ToArray());
        }
    }
}
