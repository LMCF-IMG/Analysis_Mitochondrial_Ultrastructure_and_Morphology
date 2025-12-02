// === Kontrola shody názvů souborů mezi "images" a "masks" ===

// Nastavení adresářů
dirImages = getDirectory("Vyber adresar s IMAGES");
dirMasks  = getDirectory("Vyber adresar s MASKS");

// Načtení seznamů souborů
listImages = getFileList(dirImages);
listMasks  = getFileList(dirMasks);

// Odstranění nepodporovaných souborů (např. adresáře, skryté soubory)
listImages = filterFiles(listImages);
listMasks  = filterFiles(listMasks);

// Vytvoření setů pro rychlé hledání
setBatchMode(true); // rychlejší běh
print("\\Clear"); // vyčistit Log okno
print("=== Kontrola shody nazvu ===");

// Kontrola, zda všechny soubory z IMAGES jsou i v MASKS
for (i = 0; i < listImages.length; i++) {
    if (!arrayContains(listMasks, listImages[i])) {
        print("Chybí v MASKS: " + listImages[i]);
    }
}

// Kontrola, zda všechny soubory z MASKS jsou i v IMAGES
for (i = 0; i < listMasks.length; i++) {
    if (!arrayContains(listImages, listMasks[i])) {
        print("Chybí v IMAGES: " + listMasks[i]);
    }
}

print("=== Kontrola dokoncena ===");
setBatchMode(false);

// ---- Pomocné funkce ----
function filterFiles(list) {
    valid = newArray();
    for (i = 0; i < list.length; i++) {
        if (endsWith(list[i], ".tif")) {
            valid = Array.concat(valid, list[i]);
        }
    }
    return valid;
}

function arrayContains(arr, val) {
    for (j = 0; j < arr.length; j++) {
        if (arr[j] == val) return true;
    }
    return false;
}
