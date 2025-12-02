// Vyber adresář
dir = getDirectory("Vyber složku s obrázky");
list = getFileList(dir);

setBatchMode(true);

for (i = 0; i < list.length; i++) {
    oldName = list[i];
    
    // Přeskoč složky
    if (File.isDirectory(dir + oldName))
        continue;
    
    // Pokud název obsahuje "_mask", přejmenuj
    if (indexOf(oldName, "_mask") != -1) {
        newName = replace(oldName, "_mask", "");
        
        // Přejmenuj soubor
        File.rename(dir + oldName, dir + newName);
    }
}

setBatchMode(false);
