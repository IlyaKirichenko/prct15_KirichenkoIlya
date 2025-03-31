
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace prct15
{
    class PredUkaz
    {
        public class PredmetUkaz
        {
            //слово и список страниц
            private Dictionary<string, List<int>> entries = new Dictionary<string, List<int>>();

            public void AddEntry(string word, int pageNumber)
            {
                //есть ли слово в словаре
                if (entries.ContainsKey(word))
                {
                    //есть ли уже такая страница
                    if (!entries[word].Contains(pageNumber))
                    {
                        entries[word].Add(pageNumber);
                        entries[word].Sort();
                    }
                }
                else
                {
                    //если слова нет, создаем новую запись
                    entries[word] = new List<int> { pageNumber };
                }
            }
            public void RemoveEntry(string word)
            {
                entries.Remove(word);
            }
            //возвращет страницы для указанного слова
            public string GetPages(string word)
            {
                if (entries.ContainsKey(word))
                {
                    return string.Join(", ", entries[word]);
                }
                return "Слово не найдено";
            }
            //Возвращает все записи для отображения
            public List<string> GetAllEntries()
            {
                List<string> result = new List<string>();
                foreach (var entry in entries)
                {
                    result.Add($"{entry.Key} - страницы: {string.Join(", ", entry.Value)}");
                }
                return result;
            }
            //сохрание данных в файл
            public void SaveToFile(string fileName)
            {
                using (StreamWriter writer = new StreamWriter(fileName))
                {
                    foreach (var entry in entries)
                    {
                        writer.WriteLine($"{entry.Key}|{string.Join(",", entry.Value)}");
                    }
                }
            }
            //загрузка данных из файла
            public void LoadFromFile(string fileName)
            {
                // Очищаем текущие данные
                entries.Clear();

                // Читаем все строки из файла
                string[] lines = File.ReadAllLines(fileName);

                // Обрабатываем каждую строку
                foreach (string line in lines)
                {
                    // Разделяем строку на части по символу |
                    string[] parts = line.Split('|');

                    // Проверяем что строка содержит 2 части (слово и страницы)
                    if (parts.Length == 2)
                    {
                        string word = parts[0]; // Получаем слово
                        string[] pages = parts[1].Split(','); // Разделяем страницы

                        // Добавляем каждую страницу
                        foreach (string page in pages)
                        {
                            if (int.TryParse(page, out int pageNumber))
                            {
                                AddEntry(word, pageNumber);
                            }
                        }
                    }
                }
            }
        }
    }
}