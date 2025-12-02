dir = getDirectory("Folder where sub-folders 'images' and 'masks' are placed...");

setBatchMode(true);

dir_images = dir + "images";
soubory_images = getFileList(dir_images);
Array.sort(soubory_images);

dir_masks = dir + "masks";
soubory_masks = getFileList(dir_masks);
Array.sort(soubory_masks);

print("\\Clear");
for (ind = 0; ind < soubory_images.length; ind++) {
	if ( endsWith(soubory_images[ind], ".TIF") || endsWith(soubory_images[ind], ".tif")) {
		// images
		path = dir_images + File.separator + soubory_images[ind];	
		open(path);
		width = getWidth();
		height = getHeight();
		// masks
		path = dir_masks + File.separator + soubory_masks[ind];	
		open(path);
		width2 = getWidth();
		height2 = getHeight();
		
		// compare image sizes
		if ( (width != width2) || (height != height2) )
			print(soubory_images[ind] + "(" + width + "," + height + "), " + soubory_masks[ind] + "(" + width2 + "," + height2 + ")");
	
		run("Close All");
	}
}

setBatchMode(false);
