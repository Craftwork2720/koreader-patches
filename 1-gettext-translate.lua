-- 1-gettext-translate.lua
-- Translates only strings wrapped in _("...") calls across patches and plugins.
-- Injected after official .po files load, so it only fills in missing strings
-- without overwriting existing official translations.
--
-- HOW TO ADD TRANSLATIONS:
--   1. Find the string in the source file — it will look like _("Some text") and _([[Some text]])
--   2. Add a line below:  ["Some text"] = "Your translation",
--   3. Set LANGUAGE to your language code (e.g. "de", "fr", "es", "pl") etc.
--   4. Set the same language in KOReader.

-- ============================================================
-- CONFIGURATION — set your language code here
-- ============================================================
local LANGUAGE = "pl"

-- ============================================================

local GetText = require("gettext")

local translations = {
    
    -- =========================================================
    -- ADD YOUR TRANSLATIONS HERE
    -- Format:  ["Original english text"] = "Translated text",
    -- =========================================================

    -- 5. Remove the my private translations below and add your own:


-- ============================================  START  ============================================= --

    -- === 2-incognito.lua / incognito.koplugin ===
    ["Open Incognito"]                           = "Otwórz incognito",
    ["Incognito"] = "Incognito",
    ["Opens books in incognito mode — no reading history, no progress saved, no document settings written to disk, no reading statistics recorded."] = "Otwiera książki w trybie incognito — bez historii czytania, bez zapisu postępu, bez ustawień dokumentu i bez rejestrowania statystyk.",

    -- === 2-exclude-folders.lua ===
    ["History"]                                                                                    = "Historia",
    ["Statistics"]                                                                                 = "Statystyki",
    ["Remove from exclusion list?"]                                                                = "Usunąć z listy wykluczeń?",
    ["Remove"]                                                                                     = "Usuń",
    ["(nothing excluded yet)"]                                                                     = "(brak wykluczeń)",
    ["＋ Add folder path…"]                                                                        = "＋ Dodaj ścieżkę folderu…",
    ["Exclude folder"]                                                                             = "Wyklucz folder",
    ["Any path fragment will match — e.g. 'Comics' excludes all folders and files containing that name."] = "Dowolny fragment ścieżki — np. 'Komiksy' wyklucza wszystkie foldery i pliki zawierające tę nazwę.",
    ["/path/to/folder"]                                                                            = "/ścieżka/do/folderu",
    ["Cancel"]                                                                                     = "Anuluj",
    ["Add"]                                                                                        = "Dodaj",
    ["Already in the list."]                                                                       = "Już na liście.",
    ["file"]                                                                                       = "plik",
    ["folder"]                                                                                     = "folder",
    ["✓ Ignored in History"]                                                                       = "✓ Ignorowany w historii",
    ["Ignore in History"]                                                                          = "Ignoruj w historii",
    [" added to exclusion list. Existing entries will be removed on next History open."]           = " dodano do listy wykluczeń. Istniejące wpisy zostaną usunięte przy następnym otwarciu historii.",
    ["✓ Ignored in Statistics"]                                                                    = "✓ Ignorowany w statystykach",
    ["Ignore in Statistics"]                                                                       = "Ignoruj w statystykach",
    ["Exclude from History & Statistics"]                                                          = "Wyklucz z historii i statystyk",
    ["Excluded from History"]                                                                      = "Wykluczone z historii",
    ["Excluded from Statistics"]                                                                   = "Wykluczone ze statystyk",
    ["Exclude this book…"]                                                                         = "Wyklucz tę książkę…",
    ["Change will take effect after reopening the book."]                                          = "Zmiana zostanie zastosowana po ponownym otwarciu książki.",

    
    -- === 2-hide-status-bar.lua ===
    ["Hide status bar"]              = "Ukryj pasek stanu",
    ["Show status bar"]              = "Pokaż pasek stanu",
    ["Toggle status bar visibility"] = "Przełącz widoczność paska stanu",
    ["Hide status bar in night mode"] = "Ukryj pasek stanu w trybie nocnym",


-- ============================================  OTHER  ============================================= --

    -- === 2-browser-up-folder.lua ===
    ["Hide empty folders"]                          = "Ukryj puste foldery",
    ["Hide up folders"]                             = "Ukryj folder nadrzędny",

    -- === 2-automatic-book-series.lua ===
    ["Group book series into folders"]              = "Grupuj serie w foldery",
    ["Group series"]                                = "Grupuj serie",
    ["Group even if folder has one series"]         = "Grupuj nawet gdy folder ma jedną serię",

    -- === 2-browser-folder-cover.lua ===
    ["Crop folder custom image"]                    = "Przytnij własny obraz folderu",
    ["Folder name centered"]                        = "Wyśrodkuj nazwę folderu",
    ["Show folder name"]                            = "Pokaż nazwę folderu",

    -- === 2-browser-hide-underline.lua ===
    ["Hide last visited underline"]                 = "Ukryj podkreślenie ostatnio odwiedzonego",
    ["Mosaic and detailed list settings"]           = "Ustawienia mozaiki i listy szczegółowej",

    -- === 2-custom-navbar.lua ===
    ["Manga"]                                       = "Manga",
    ["News"]                                        = "Wiadomości",
    ["Continue"]                                    = "Kontynuuj",
    ["History"]                                     = "Historia",
    ["Favorites"]                                   = "Ulubione",
    ["Collections"]                                 = "Kolekcje",
    ["OPDS"]                                        = "OPDS",
    ["Exit"]                                        = "Wyjście",
    ["Manga folder not found: "]                    = "Nie znaleziono folderu manga: ",
    ["Rakuyomi plugin is not installed."]           = "Wtyczka Rakuyomi nie jest zainstalowana.",
    ["News folder not found: "]                     = "Nie znaleziono folderu wiadomości: ",
    ["QuickRSS plugin is not installed."]           = "Wtyczka QuickRSS nie jest zainstalowana.",
    ["Cannot open last document"]                   = "Nie można otworzyć ostatniego dokumentu",
    ["OPDS Browser plugin is not installed or not enabled."] = "Wtyczka OPDS Browser nie jest zainstalowana lub wyłączona.",
    ["Navbar settings"]                             = "Ustawienia paska nawigacji",
    ["Show labels"]                                 = "Pokaż etykiety",
    ["Show top border"]                             = "Pokaż górną ramkę",
    ["Active tab"]                                  = "Aktywna karta",
    ["Enable active tab styling"]                   = "Włącz styl aktywnej karty",
    ["Bold active tab"]                             = "Pogrub aktywną kartę",
    ["Active tab underline"]                        = "Podkreśl aktywną kartę",
    ["Underline location: "]                        = "Położenie podkreślenia: ",
    ["above"]                                       = "powyżej",
    ["below"]                                       = "poniżej",
    ["Colored active tab"]                          = "Kolorowa aktywna karta",
    ["Tabs"]                                        = "Karty",
    ["Arrange tabs"]                                = "Ułóż karty",
    ["Arrange navbar tabs"]                         = "Ułóż karty paska nawigacji",
    ["Books tab label: "]                           = "Etykieta karty Książki: ",
    ["Books"]                                       = "Książki",
    ["Home"]                                        = "Strona główna",
    ["Library"]                                     = "Biblioteka",
    ["Custom"]                                      = "Własna",
    ["Custom: "]                                    = "Własna: ",
    ["Books tab label"]                             = "Etykieta karty Książki",
    ["Cancel"]                                      = "Anuluj",
    ["Set"]                                         = "Ustaw",
    ["Manga tab action: "]                          = "Akcja karty Manga: ",
    ["Folder"]                                      = "Folder",
    ["Rakuyomi"]                                    = "Rakuyomi",
    ["Open Rakuyomi"]                               = "Otwórz Rakuyomi",
    ["Open folder: "]                               = "Otwórz folder: ",
    ["Open folder"]                                 = "Otwórz folder",
    ["News tab action: "]                           = "Akcja karty Wiadomości: ",
    ["QuickRSS"]                                    = "QuickRSS",
    ["Open QuickRSS"]                               = "Otwórz QuickRSS",
    ["Advanced"]                                    = "Zaawansowane",
    ["Show navbar in standalone views"]             = "Pokaż pasek nawigacji w widokach samodzielnych",
    ["Show the navbar in History, Favorites, Collections, Rakuyomi, QuickRSS, and OPDS views."] = "Pokazuje pasek nawigacji w widokach Historia, Ulubione, Kolekcje, Rakuyomi, QuickRSS i OPDS.",
    ["Show top gap"]                                = "Pokaż górny odstęp",
    ["Add spacing above the navbar to separate it from the content above."] = "Dodaje odstęp powyżej paska nawigacji oddzielający go od treści.",
    ["Refresh navbar"]                              = "Odśwież pasek nawigacji",

    -- === 2-browser-double-tap.lua ===
    ["Double-tap to open books"]                    = "Podwójne dotknięcie do otwierania książek",
    ["Require double-tap to open"]                  = "Wymagaj podwójnego dotknięcia do otwarcia",
    ["Double-tap timeout (ms)"]                     = "Limit czasu podwójnego dotknięcia (ms)",
    ["Double-tap timeout (milliseconds)"]           = "Limit czasu podwójnego dotknięcia (milisekundy)",
    ["Maximum time between taps to register as double-tap"] = "Maksymalny czas między dotknięciami rejestrowany jako podwójne dotknięcie",

    -- === 2-quick-settings.lua ===
    ["Are you sure you want to restart KOReader?"] = "Czy na pewno chcesz ponownie uruchomić KOReader?",
    ["Restart"]                                    = "Uruchom ponownie",
    ["Are you sure you want to exit KOReader?"]    = "Czy na pewno chcesz wyjść z KOReader?",
    ["Calibre plugin is not available."]           = "Wtyczka Calibre nie jest dostępna.",
    ["Frontlight"]                                 = "Podświetlenie",
    ["Max"]                                        = "Maks",
    ["Warmth"]                                     = "Ciepło",
    ["Wi-Fi"]                                      = "Wi-Fi",
    ["Night mode"]                                 = "Tryb nocny",
    ["SSH"]                                        = "SSH",
    ["FileBrowser"]                                = "Przeglądarka plików",
    ["KODashboard"]                                = "KODashboard",
    ["Rotate"]                                     = "Obróć",
    ["USB"]                                        = "USB",
    ["File search"]                                = "Szukaj pliku",
    ["Cloud storage"]                              = "Chmura",
    ["Z-Library"]                                  = "Z-Library",
    ["Calibre"]                                    = "Calibre",
    ["Sleep"]                                      = "Uśpij",
    ["Arrange buttons"]                            = "Ułóż przyciski",
    ["Arrange quick settings buttons"]             = "Ułóż przyciski szybkich ustawień",
    ["Quick settings"]                             = "Szybkie ustawienia",
    ["Buttons"]                                    = "Przyciski",
    ["Show frontlight slider"]                     = "Pokaż suwak podświetlenia",
    ["Show warmth slider"]                         = "Pokaż suwak ciepła",
    ["Always open on this tab"]                    = "Zawsze otwieraj tę kartę",

    -- === 2-invert-document.lua ===
    ["Invert Document"]                            = "Odwróć dokument",
    ["off"]                                        = "wył.",
    ["on"]                                         = "wł.",
    ["Invert document in night mode. Useful for image heavy documents such as comics or manga."] =
        "Odwraca dokument w trybie nocnym. Przydatne dla dokumentów z dużą ilością obrazów, takich jak komiksy lub manga.",

    -- === 2-statusbar-thin-chapter.lua ===
    ["Progress bar"]                               = "Pasek postępu",
    ["Thickness and height: thin"]                 = "Grubość i wysokość: cienki",
    ["Thickness and height: thick"]                = "Grubość i wysokość: gruby",
    ["Thin"]                                       = "Cienki",
    ["Show chapter markers"]                       = "Pokaż znaczniki rozdziałów",

    -- === 2-turn-off-frontlight-during-refresh.lua ===
    ["Frontlight refresh"]                         = "Odświeżanie podświetlenia",
    ["Enable turning off frontlight on refresh"]   = "Włącz wyłączanie podświetlenia przy odświeżaniu",
    ["Force frontlight off every page turn"]       = "Wymuś wyłączanie podświetlenia przy każdej stronie",
    ["Turn off frontlight on UI refreshes"]        = "Wyłącz podświetlenie przy odświeżaniu UI",
    ["Turn off frontlight in reader only"]         = "Wyłącz podświetlenie tylko w trybie czytania",
    ["Dim relative to current brightness"]         = "Przyciemnij względem bieżącej jasności",
    ["Dim level: "]                                = "Poziom przyciemnienia: ",
    ["Dim level"]                                  = "Poziom przyciemnienia",
    ["Frontlight brightness on refresh. (Lower ⇛ Darker)"] = "Jasność podświetlenia przy odświeżaniu. (Niżej ⇛ Ciemniej)",
    ["Toggle turning off frontlight on refresh"]   = "Przełącz wyłączanie podświetlenia przy odświeżaniu",
    ["Toggle force frontlight off every page turn"] = "Przełącz wymuszanie wyłączania podświetlenia przy przekręceniu strony",
    ["Toggle turning off frontlight in UI refreshes"] = "Przełącz wyłączanie podświetlenia przy odświeżaniu UI",
    ["Toggle turning off frontlight in reader only"] = "Przełącz wyłączanie podświetlenia tylko w trybie czytania",

    -- === 2--ui-font.lua ===
    ["UI font: %1"]                                = "Czcionka UI: %1",
    ["Restart to apply the UI font change"]        = "Uruchom ponownie, aby zastosować zmianę czcionki UI",

    -- === 2-redacted-screensaver.lua ===
    ["Use redacted screensaver when reading"]      = "Używaj wygaszacza z zamazaniem podczas czytania",
    ["When enabled, shows the current page with random words blacked out like a redacted document while reading a book. This overrides the wallpaper setting above when in reader mode."] =
        "Po włączeniu pokazuje bieżącą stronę z losowo zamazanymi słowami podczas czytania książki. Zastępuje ustawienie tapety powyżej w trybie czytania.",

    -- === 2-filemanager-titlebar.lua ===
    ["Title bar"]                                          = "Pasek tytułu",
    ["Configure title bar"]                                = "Konfiguruj pasek tytułu",
    ["Arrange title bar items"]                            = "Ułóż elementy paska tytułu",
    ["Wifi"]                                               = "Wi-Fi",
    ["Memory"]                                             = "Pamięć",
    ["Storage"]                                            = "Miejsce",
    ["Clock"]                                              = "Zegar",
    ["Battery"]                                            = "Bateria",
    ["Brightness level"]                                   = "Poziom jasności",
    ["Warmth level"]                                       = "Poziom ciepła",
    ["Up time"]                                            = "Czas działania",
    ["Time spent awake"]                                   = "Czas aktywności",
    ["Time in suspend"]                                    = "Czas uśpienia",
    ["Custom text"]                                        = "Własny tekst",
    ["Custom text (long-press to edit): '%1'"]             = "Własny tekst (przytrzymaj, aby edytować): '%1'",
    ["RAM used, MiB"]                                      = "Zajęta pamięć RAM, MiB",
    ["Free storage, requires SystemStat plugin"]           = "Wolne miejsce, wymaga wtyczki SystemStat",
    ["Enter a custom text"]                                = "Wpisz własny tekst",
    ["Enter a custom separator"]                           = "Wpisz własny separator",
    ["Dot"]                                                = "Kropka",
    ["Bullet"]                                             = "Punktor",
    ["En dash"]                                            = "Półpauza",
    ["Em dash"]                                            = "Pauza",
    ["Vertical bar"]                                       = "Kreska pionowa",
    ["No separator"]                                       = "Bez separatora",
    ["Custom separator"]                                   = "Własny separator",
    ["Custom separator (long-press to edit)"]              = "Własny separator (przytrzymaj, aby edytować)",
    ["Number of spaces around separator"]                  = "Liczba spacji wokół separatora",
    ["Number of spaces around separator: %1"]              = "Liczba spacji wokół separatora: %1",
    ["Item separator: %1"]                                 = "Separator elementów: %1",
    ["Custom text: '%1'"]                                  = "Własny tekst: '%1'",
    ["Auto refresh clock"]                                 = "Automatyczne odświeżanie zegara",
    ["Show file browser path"]                             = "Pokaż ścieżkę przeglądarki plików",
    ["Show wifi status even when disabled"]                = "Pokaż status Wi-Fi nawet gdy wyłączone",
    ["Show frontlight when off"]                           = "Pokaż podświetlenie gdy wyłączone",
    ["Bold font"]                                          = "Pogrubiona czcionka",
    ["Font size"]                                          = "Rozmiar czcionki",
    ["Font size (0 = default): %1"]                        = "Rozmiar czcionki (0 = domyślny): %1",
    ["Title bar font size (0 = default)"]                  = "Rozmiar czcionki paska tytułu (0 = domyślny)",
    ["%1Off"]                                              = "%1Wył.",

    -- === 2-reading-insights-popup.lua ===
    ["Reading statistics: reading insights"]       = "Statystyki czytania: analizy",
    ["Reload streaks?"]                            = "Przeładować serie?",
    ["Reload"]                                     = "Przeładuj",
    ["Reload all insights?"]                       = "Przeładować wszystkie analizy?",
    ["No books read"]                              = "Brak przeczytanych książek",
    ["No books read in %1"]                        = "Brak przeczytanych książek w %1",
    ["Unknown"]                                    = "Nieznane",

    -- === hardcoverapp.koplugin / _meta.lua ===
    ["Hardcover"]                                       = "Hardcover",
    ["Synchronize reading progress to Hardcover.app"]   = "Synchronizuj postęp czytania z Hardcover.app",

    -- === hardcoverapp.koplugin / main.lua ===
    ["Hardcover: Link book"]                            = "Hardcover: Połącz książkę",
    ["Hardcover: Track progress"]                       = "Hardcover: Śledź postęp",
    ["Hardcover: Stop tracking progress"]               = "Hardcover: Zatrzymaj śledzenie postępu",
    ["Hardcover: Update progress"]                      = "Hardcover: Aktualizuj postęp",
    ["Hardcover: Suggest a book"]                       = "Hardcover: Zaproponuj książkę",
    ["Progress tracking enabled"]                       = "Śledzenie postępu włączone",
    ["Progress tracking disabled"]                      = "Śledzenie postępu wyłączone",
    ["Progress updated"]                                = "Postęp zaktualizowany",
    ["Hardcover status saved"]                          = "Status Hardcover zapisany",
    ["Failed to fetch book information from Hardcover"] = "Nie udało się pobrać informacji o książce z Hardcover",
    ["Hardcover quote"]                                 = "Cytat Hardcover",
    -- Uwaga: _("Linked to: " .. book.title) to błąd w pluginie —
    -- dynamiczny string niemożliwy do przetłumaczenia przez gettext.

    -- === hardcoverapp.koplugin / hardcover/lib/hardcover.lua ===
    ["Error fetching to-read list"]                     = "Błąd pobierania listy do przeczytania",

    -- === hardcoverapp.koplugin / hardcover/lib/ui/hardcover_menu.lua ===
    ["Link book"]                                       = "Połącz książkę",
    ["Automatically track progress"]                    = "Automatycznie śledź postęp",
    ["Update status"]                                   = "Aktualizuj status",
    ["Suggest a book"]                                  = "Zaproponuj książkę",
    ["Settings"]                                        = "Ustawienia",
    ["About"]                                           = "O wtyczce",
    ["Set page"]                                        = "Ustaw stronę",
    ["Set current page"]                                = "Ustaw bieżącą stronę",
    ["Add a note"]                                      = "Dodaj notatkę",
    ["Save"]                                            = "Zapisz",
    ["Set Rating"]                                      = "Ustaw ocenę",
    ["Set status visibility"]                           = "Ustaw widoczność statusu",
    ["Set track frequency"]                             = "Ustaw częstotliwość śledzenia",
    ["Set track progress"]                              = "Ustaw postęp śledzenia",

    -- === hardcoverapp.koplugin / hardcover/lib/ui/journal_dialog.lua ===
    ["Note"]                                            = "Notatka",
    ["Quote"]                                           = "Cytat",
    ["Public"]                                          = "Publiczny",
    ["Follows"]                                         = "Obserwujący",
    ["Private"]                                         = "Prywatny",
    ["Tags (comma separated)"]                          = "Tagi (oddzielone przecinkami)",
    ["Hidden tags (comma separated)"]                   = "Ukryte tagi (oddzielone przecinkami)",

    -- === hardcoverapp.koplugin / hardcover/lib/ui/search_dialog.lua ===
    ["Cancel"]                                          = "Anuluj",
    ["Search"]                                          = "Szukaj",

    -- === hardcoverapp.koplugin / hardcover/vendor/covermenu.lua ===
    ["Unignore cover"]                                  = "Przestań ignorować okładkę",
    ["Ignore cover"]                                    = "Ignoruj okładkę",
    ["Unignore metadata"]                               = "Przestań ignorować metadane",
    ["Ignore metadata"]                                 = "Ignoruj metadane",
    ["Refresh cached book information"]                 = "Odśwież zapisane informacje o książce",
    ["Extract and cache book information"]              = "Pobierz i zapisz informacje o książce",

    -- === hardcoverapp.koplugin / hardcover/vendor/listmenu.lua ===
    ["Finished"]                                        = "Przeczytana",
    ["On hold"]                                         = "Wstrzymana",
    ["(deleted)"]                                       = "(usunięta)",

    -- === koinsight ===
    ["KoInsight"]                                       = "KoInsight",
    ["Synchronize data"]                                = "Synchronizuj dane",
    ["KoInsight server URL is not configured."]         = "Adres serwera KoInsight nie jest skonfigurowany.",
    ["KoInsight sync finished."]                        = "Synchronizacja KoInsight zakończona.",
    ["KoInsight sync failed."]                          = "Synchronizacja KoInsight nie powiodła się.",
    ["Sync on suspend"]                                 = "Synchronizuj przy uśpieniu",
    ["Aggressive sync on suspend (auto Wi-Fi)"]         = "Agresywna synchronizacja przy uśpieniu (auto Wi-Fi)",
    ["Set suspend connect timeout…"]                    = "Ustaw limit czasu połączenia przy uśpieniu…",
    ["Set server URL"]                                  = "Ustaw adres serwera",
    ["About KoInsight"]                                 = "O KoInsight",
    ["KoInsight: Sync stats"]                           = "KoInsight: Synchronizuj statystyki",


-- ============================================  END  ============================================= --

}

local function inject()
    for msgid, msgstr in pairs(translations) do
        if not GetText.translation[msgid] then
            GetText.translation[msgid] = { [0] = msgstr } -- skips strings already translated by official .mo files
        end
    end
end

local orig = GetText.changeLang
GetText.changeLang = function(lang, ...)
    local result = orig(lang, ...)
    if lang and lang:sub(1, #LANGUAGE) == LANGUAGE then
        inject()
    end
    return result
end
