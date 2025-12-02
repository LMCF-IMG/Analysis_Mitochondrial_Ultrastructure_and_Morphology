// Vyber adresář
dir = getDirectory("Vyber složku s obrázky");
list = getFileList(dir);

setBatchMode(true);

for (i = 0; i < list.length; i++) {
    oldName = list[i];
    
    // Přeskoč složky
    if (File.isDirectory(dir + oldName))
        continue;
    
    // Pokud název obsahuje mezeru, přejmenuj
    if (indexOf(oldName, " ") != -1) {
        newName = replace(oldName, " ", "_");
        
        // Přejmenuj soubor
        File.rename(dir + oldName, dir + newName);
    }
}

setBatchMode(false);
