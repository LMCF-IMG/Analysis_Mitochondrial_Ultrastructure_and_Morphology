// Parameters
var patch_size = 512;
var overlap_required = 0.5;			// 0.5 = 50%, 0.2 = 20% etc. - minimal required overlap!
// Parameters

var num_patches_in_x = 0;
var num_patches_in_y = 0;
var step_x = 0;
var step_y = 0;

dir = getDirectory("Folder where sub-folders 'images' and 'masks' are placed...");

setBatchMode(true);

run("Set Measurements...", "min redirect=None decimal=3");

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
		rename("image");
		width = getWidth();
		height = getHeight();
		name = substring(soubory_images[ind], 0, lastIndexOf(soubory_images[ind], "."));		
		// masks
		path = dir_masks + File.separator + soubory_masks[ind];	
		open(path);
		rename("mask");
		width2 = getWidth();
		height2 = getHeight();
		
		// compare image sizes
		if ((width != width2) || (height != height2)) {
			print(soubory_images[ind] + ", " soubory_masks[ind]);
			continue;
		}
		
		find_num_patches_and_steps(width, height);
			
		y = 0;
		for (indy = 1; indy <= num_patches_in_y; indy++) {
			x = 0;
			for (indx = 1; indx <= num_patches_in_x; indx++) {	
				// mask first, since we need to analyse its content
				selectImage("mask");
				makeRectangle(x, y, patch_size, patch_size);
				//debug roiManager("Add");
				run("Duplicate...", "title=patchMask");
				selectImage("patchMask");
				run("Measure");
				max = getValue("Max");
				//debug print("maxVal = " + max);
				// closing zero patch, will not be saved
				if (max == 0)
					close("patchMask");
				// saving both patches only if the mask patch is not empty to reduce data for training
				if (max > 0) {
					selectWindow("patchMask");
					pathMask = dir_masks + File.separator + name + "_patch_X" + indx + "_Y" + indy + ".tif";
					save(pathMask);
					close();
					// now image as well
					selectImage("image");
					makeRectangle(x, y, patch_size, patch_size);	
					run("Duplicate...", "title=patchImg");
					selectImage("patchImg");
					pathImg = dir_images + File.separator + name + "_patch_X" + indx + "_Y" + indy + ".tif";
					save(pathImg);
					close();					
				}
				x = x + step_x;
			}
			y = y + step_y;
		}
		run("Close All");
		close("Results");
	}
}

setBatchMode(false);

////////////////////////////////////////////////////////////////////////////////////////////////////////
function find_num_patches_and_steps(width, height) { 
	// kolik patches pokryje daný rozměr
	num_patches_in_x = Math.ceil(1.0 * width / (patch_size * (1.0 - overlap_required / 2.0)));
	num_patches_in_y = Math.ceil(1.0 * height / (patch_size * (1.0 - overlap_required / 2.0)));
	
	rozdil_x = num_patches_in_x * patch_size - width;
	rozdil_x_na_patch = Math.ceil(rozdil_x / (num_patches_in_x - 1));
	rozdil_y = num_patches_in_y * patch_size - height;
	rozdil_y_na_patch = Math.ceil(rozdil_y / (num_patches_in_y - 1));
	
	step_x = patch_size - rozdil_x_na_patch;
	step_y = patch_size - rozdil_y_na_patch;
	
	overlap_in_pixels_x = (num_patches_in_x * patch_size - width) / (num_patches_in_x / 2.0);
	overlap_in_pixels_y = (num_patches_in_y * patch_size - height) / (num_patches_in_y / 2.0);
	
	overlap_in_percents_x = (overlap_in_pixels_x / patch_size) * 100;
	overlap_in_percents_y = (overlap_in_pixels_y / patch_size) * 100;
	//debug print("Overlap in x in %: " + overlap_in_percents_x);
	//debug print("Overlap in y in %: " + overlap_in_percents_y);
}
