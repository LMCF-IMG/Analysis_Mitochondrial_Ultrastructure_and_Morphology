// Apply to MASKS only!

setOption("BlackBackground", true);

dir = getDirectory("Folder with label pictures...");

setBatchMode(true);
soubory = getFileList(dir);
Array.sort(soubory);

for (ind = 0; ind < soubory.length; ind++) {
	if ( endsWith(soubory[ind], ".TIF") || endsWith(soubory[ind], ".tif")) {
		path = dir + soubory[ind];
		open(path);
		name = substring(soubory[ind], 0, lastIndexOf(soubory[ind],"."));

		run("Remove Overlay");
		run("Select None");
		
		run("8-bit");

		setThreshold(1, 255, "raw");
		run("Convert to Mask");
				
		run("Erode");
		run("Fill Holes");
		run("Dilate");
		run("Connected Components Labeling", "connectivity=4 type=[8 bits]");
		
		selectImage(name + "-lbl");
		path = dir + soubory[ind];
		save(path);
		run("Close All");
	}
}
setBatchMode(false);