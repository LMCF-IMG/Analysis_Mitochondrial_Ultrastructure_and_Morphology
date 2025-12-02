saveSettings;

setOption("ScaleConversions", false);
dir = getDirectory("Folder with cristae images and labeling files...");

soubory = getFileList(dir);
Array.sort(soubory);

for (ind = 0; ind < soubory.length; ind++) {
	if (endsWith(soubory[ind], ".tif")) {
		path = dir + soubory[ind];
		open(path);
		title = getTitle();
		name = substring(title, 0, lastIndexOf(title, "."));

		run("Open Current Image With Labkit", "dataset=" + title);

		waitForUser("Create Labeling Image; Delete Points; then Press OK.");
		
		run("8-bit");
		run("Enhance Contrast", "saturated=0.35");
		run("Histogram");
		
		Table.showHistogramTable;
		selectWindow("Histogram of Labeling");
		path = dir + File.separator + name + "_Int.txt";
		save(path);
		run("Close");
		
		selectImage("Labeling");
		path = dir + File.separator + name + "_mask.tif";
		save(path);
		run("Close All");
		
		waitForUser("Close Labkit. Press OK.");
	}
}

restoreSettings;
