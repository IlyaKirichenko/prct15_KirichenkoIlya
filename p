using System;
using System.Collections;
using System.IO;
using System.Linq;

namespace prct15
{
    public class Predmet
    {
        public string Word { get; set; }
        public ArrayList Pages { get; set; }

        public Predmet(string word, int page)
        {
            Word = word;
            Pages = new ArrayList() { page };
        }
    }

    public class PredUkaz
    {
        public ArrayList Items { get; private set; } = new ArrayList();

        public void Add(string word, int page)
        {
            foreach (Predmet item in Items)
            {
                if (item.Word == word)
                {
                    if (!item.Pages.Contains(page) && item.Pages.Count < 10)
                        item.Pages.Add(page);
                    return;
                }
            }
            Items.Add(new Predmet(word, page));
        }

        public void Edit(string oldWord, string newWord, ArrayList newPages)
        {
            foreach (Predmet item in Items)
            {
                if (item.Word == oldWord)
                {
                    item.Word = newWord;
                    item.Pages = newPages;
                    return;
                }
            }
        }

        public void Delete(string word)
        {
            for (int i = 0; i < Items.Count; i++)
            {
                Predmet item = (Predmet)Items[i];
                if (item.Word == word)
                {
                    Items.RemoveAt(i);
                    return;
                }
            }
        }

        public void LoadFromFile(string path)
        {
            if (!File.Exists(path)) return;

            Items.Clear();
            foreach (var line in File.ReadAllLines(path))
            {
                var parts = line.Split(':');
                if (parts.Length != 2) continue;

                var word = parts[0].Trim();
                var pages = parts[1].Split(',').Select(p => int.Parse(p.Trim())).ToArray();

                var item = new Predmet(word, pages[0]);
                for (int i = 1; i < pages.Length && i < 10; i++)
                    item.Pages.Add(pages[i]);

                Items.Add(item);
            }
        }

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
