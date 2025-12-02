// IJM macro: resize originální obrazy a maskované obrazy na max rozměr

dir = getDirectory("Folder where sub-folders 'images' and 'masks' are placed...");

dir_images = dir + "images";
dir_masks  = dir + "masks";
dir_out    = dir;

// --- Najdi maximální velikost originálů ---
list = getFileList(dir_images);
maxWidth = 0;
maxHeight = 0;

for (i=0; i<list.length; i++) {
    if (endsWith(list[i], ".tif"))
        path = dir_images + File.separator + list[i];
        open(path);
        w = getWidth();
        h = getHeight();
        if (w>maxWidth)  maxWidth  = w;
        if (h>maxHeight) maxHeight = h;
        close();
    }

print("\\Clear");
print("Max rozmery: "+maxWidth+" x "+maxHeight);

// --- Zpracuj všechny páry ---
for (i=0; i<list.length; i++) {
    if (endsWith(list[i], ".tif")) {
        
        // Jméno bez přípony
        name = substring(list[i], 0, lastIndexOf(list[i], "."));		

        // --- Originál ---
        open(dir_images + File.separator + list[i]);
        origTitle = getTitle();
        oriID = getImageID();

        // vytvoř bílý podklad
        newImage("blank", "8-bit White", maxWidth, maxHeight, 1);
        blankID = getImageID();

        // vlož originál vlevo nahoře
        selectImage(oriID);
        run("Select All");
        run("Copy");
        
        selectImage(blankID);
		run("Restore Selection");
		run("Paste");
		run("Select None");
		
        saveAs("Tiff", dir_out + File.separator + name + "_image_resized.tif");
        close();

        // --- Maskovaný originál ---
        // otevři příslušnou masku
        maskFile = dir_masks + File.separator + name + ".tif"; // <- přizpůsob název masky
        if (!File.exists(maskFile)) {
            print("Maska pro "+name+" nenalezena.");
            close(oriID);
            continue;
        }
        open(maskFile);
        maskID = getImageID();
        maskTitle = getTitle();

        // naprahování: >=1 -> 255
        setThreshold(1, 255);
        run("Convert to Mask");

        run("Divide...", "value=255");

        // vynásob s originálem
        imageCalculator("Multiply create", origTitle, maskTitle);
        mulID = getImageID();

        // ulož s bílým podkladem
        newImage("blank2", "8-bit White", maxWidth, maxHeight, 1);
        blank2ID = getImageID();
        selectImage(mulID);
        run("Select All");
        run("Copy");
        
        selectImage(blank2ID);
		run("Restore Selection");
		run("Paste");
		run("Select None");
        
        saveAs("Tiff", dir_out + File.separator + name+"_mask_resized.tif");
        
        // zavři vše
        close("*");
    }
}

