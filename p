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
            // Используем LINQ для поиска элемента по слову
            var existingItem = Items.Cast<Predmet>().FirstOrDefault(item => item.Word == word);
            if (existingItem != null)
            {
                // Если слово найдено, добавляем страницу, если ее еще нет, и если количество страниц меньше 10
                if (!existingItem.Pages.Contains(page) && existingItem.Pages.Count < 10)
                    existingItem.Pages.Add(page);
            }
            else
            {
                // Если слово не найдено, добавляем новый элемент
                Items.Add(new Predmet(word, page));
            }
        }

        // Метод для редактирования существующего слова и страниц
        public void Edit(string oldWord, string newWord, ArrayList newPages)
        {
            var item = Items.Cast<Predmet>().FirstOrDefault(i => i.Word == oldWord);
            if (item != null)
            {
                item.Word = newWord;
                item.Pages = newPages;
            }
        }

        // Метод для удаления слова из указателя
        public void Delete(string word)
        {
            var itemToRemove = Items.Cast<Predmet>().FirstOrDefault(item => item.Word == word);
            if (itemToRemove != null)
            {
                Items.Remove(itemToRemove);
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
            var lines = Items.Cast<Predmet>().Select(item => item.Word + ":" + string.Join(",", item.Pages.Cast<int>())).ToList();
            File.WriteAllLines(path, lines);
        }
    }
}
