// Apply to MASKS only!!!
dir = getDirectory("Vyber adresar s obrázky MASKS");
list = getFileList(dir);

setBatchMode(true);

print("\\Clear");
print("=== Invertovane soubory ===");

for (i = 0; i < list.length; i++) {
    path = dir + list[i];
    
    // Otevření obrázku
    open(path);
    title = getTitle();

    // Přeskočit, pokud není 8-bit
    if (bitDepth != 8) {
        close();
        continue;
    }
    
    // Získání histogramu
    getHistogram(values, counts, 256);
    
    // Zjištění počtu pixelů s hodnotou 0 a 255
    count0   = counts[0];
    count255 = counts[255];
    
    // Pokud převládají pixely s hodnotou 255 → invertovat
    if (count255 > count0) {
        run("Invert");
        saveAs("Tiff", path); // přepíše původní soubor
        print(list[i]); // výpis názvu invertovaného souboru
    }
    
    close();
}

print("=== Kontrola dokoncena ===");

setBatchMode(false);
