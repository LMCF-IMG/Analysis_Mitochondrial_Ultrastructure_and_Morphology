/*
Porovnáme rozměry image a mask.
Najdeme menší šířku a menší výšku z obou.
Ořízneme oba obrázky od levého horního rohu (0,0) na tyto menší rozměry.
Oba uložíme zpět pod původními názvy (přepíší se).
 */

// === Úprava velikosti obou obrázků na rozměr menšího z nich ===

// Výběr adresářů
dirImages = getDirectory("Vyber adresar s IMAGES");
dirMasks  = getDirectory("Vyber adresar s MASKS");

// Načtení seznamů souborů
listImages = getFileList(dirImages);
listMasks  = getFileList(dirMasks);

setBatchMode(true);

print("\\Clear");
print("=== Oriznute dvojice obrazu ===");

for (i = 0; i < listImages.length; i++) {
    name = listImages[i];
    
    // Kontrola, zda maska existuje
    if (!arrayContains(listMasks, name)) {
        continue;
    }
    
    // --- Načíst image ---
    open(dirImages + name);
    getDimensions(wImg, hImg, c1, s1, f1);
    close();
    
    // --- Načíst mask ---
    open(dirMasks + name);
    getDimensions(wMask, hMask, c2, s2, f2);
    close();
    
    // Pokud jsou stejné, nic se nedělá
    if (wImg == wMask && hImg == hMask) {
        continue;
    }
    
	// Určení cílové velikosti (menší rozměry)
	if (wImg < wMask) {
	    targetW = wImg;
	} else {
	    targetW = wMask;
	}
	
	if (hImg < hMask) {
	    targetH = hImg;
	} else {
	    targetH = hMask;
	}    
	
    // --- Oříznutí image ---
    open(dirImages + name);
    makeRectangle(0, 0, targetW, targetH);
    run("Crop");
    saveAs("Tiff", dirImages + name);
    close();
    
    // --- Oříznutí mask ---
    open(dirMasks + name);
    makeRectangle(0, 0, targetW, targetH);
    run("Crop");
    saveAs("Tiff", dirMasks + name);
    close();
    
    print(name);
}

print("=== Hotovo ===");

setBatchMode(false);

// Pomocná funkce
function arrayContains(arr, val) {
    for (j = 0; j < arr.length; j++) {
        if (arr[j] == val) return true;
    }
    return false;
}
