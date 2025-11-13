# Analysis_Mitochondrial_Ultrastructure_and_Morphology

**Macros for [ImageJ/Fiji](https://fiji.sc/) and models for [napari](https://napari.org/).**

**Nikol Volfová, M.Sc.**, from the [Department of Paediatrics and Adolescent Medicine, First Faculty of Medicine, Charles University and General University Hospital in Prague, Prague, Czech Republic](https://mitolab.lf1.cuni.cz/) cooperated with the analyses and kindly annotated and provided the training image datasets for creation of the models.

## Overview

The project presents a study focused on analyzing mitochondrial ultrastructure and cristae morphology in relation to various types of mitochondrial dysfunction. Mitochondria play a key role in cellular energy metabolism through oxidative phosphorylation (OXPHOS), and alterations in cristae structure are closely associated with impaired ATP production and mitochondrial diseases. To objectively characterize these structural changes, we developed a two-step deep learning pipeline for image analysis of electron microscopy data.

In the first step, **instance segmentation** of mitochondria was performed on original EM images using a retrained *MitoNet_v1* model. The new model, trained in [napari](https://napari.org/), achieved an **IoU of 0.798 (IoU₀.₅ = 0.876)** compared to the original model’s IoU of 0.596, demonstrating improved accuracy in mitochondrial detection. In the second step, **panoptic segmentation** of cristae within the segmented mitochondria was carried out using a retrained *CEM* model, again using **napari**, allowing classification into **12 morphological categories**. This model reached an **IoU of 0.518 (IoU₀.₅ = 0.672)**, providing detailed and automated mapping of cristae organization.

Electron microscopy examples showed distinct ultrastructural differences between healthy fibroblasts and those with a **TMEM70 gene mutation**, such as rounded mitochondria and reduced cristae density. The approach effectively identifies structural abnormalities like cristae loss and “onion ring” formations associated with specific dysfunctions. Overall, the proposed deep learning workflow enables scalable, reproducible, and quantitative assessment of mitochondrial morphology, enhancing diagnostic and mechanistic understanding of mitochondrial pathologies.

Fig. 1: **A two-step approach to classify morphology or cristae** using new deep learning models created in **napari**:

<img width="1361" height="893" alt="two-step-approach-to-classification" src="https://github.com/user-attachments/assets/84dc6aa9-6dcf-4ffd-b193-f76edf19bfb8" />

See also **a PDF poster in the file repository above**. The poster was presented at [CzechBioImaging conference: Imaging Principles of Life 2025, September 17-19, Rozdrojovice, Brno, Czech Republic](https://www.czech-bioimaging.cz/activities/conference/).

### Protocols for training in napari and models

### Evaluation of quality of trained models by segmentation metrics

I used the following [umetrix](https://pypi.org/project/umetrix/) project to evaluate the quality of the resulting trained models. It allows us to calculate basic segmentation metrics, e.g. IoU, and confusion matrix, based on which the popular F1 score can be easily calculated. The project also allows us to evaluate a set of images in a directory in batch mode. The inputs to the algorithm are masks found by the trained model and those drawn manually in Labkit.

### Preparation of image data for training

Images were labeled for masks of both mitochondria and cristae by using [Labkit](https://imagej.net/plugins/labkit/) plugin in ImageJ/Fiji.

During the preparation of data for training (valid for both "images" and "masks"), it was necessary to monitor the following issues:
1. Replace spaces in names with underscores. napari does not read it. [Macro: "01_Replace_Spaces_in_Names_with_Underscores.ijm"]
2. Labeled images created in Labkit were stored with suffix "_mask" to distinguish the names. But for training both "images" and "names" must have the same name to link them. String "_mask" has to be removed. [02_Remove_String_mask_from Names.ijm]
3. Compare whether the final file names in both directories for training ("images" and "masks") are the same and unique to each other. [03_Check_Names_Equality_images_masks.ijm]
4. For some unknown reason Labkit slightly changes sizes (x,y) of exported images when compared with the original images to be labeled. Mostly it adds several pixels to both axes of the matrix size. Compare whether images with the same name are the same size. [04_Compare_Sizes_images_masks.ijm]
5. If problems found in the previous step, adjust the size of masks relative to images [05_Adjust_Image_Matrice_Sizes.ijm]
6. Some 8-bit "masks" exported from Labkit were inverted in intensity, i.e., invert them back to a black background (intensity 0). [06_All_masks_to_Black_Background.ijm]
7. Some masks were in 32-bit, and even contained small holes. [07_Masks_Converting_to_8bit_and_Filling_Holes.ijm]
8. Final visual check to ensure that the drawn masks correctly correspond to the objects (mitochondria/crystals) in the images and visualization of the quality of the objects to ensure they have good contrast. The images have different sizes in pixels. To load them into the stack for convenient checking in Imagej/Fiji, they must be copied to the largest image matrix that has been applied. [08_Visual_Checking_mask_Alignment_with_image_Objects.ijm]
9. Splitting both images and masks into train and test sets for using in empanada-napari. [Python: 09_Splitting_Images_Into_Train_Test_Sets.py]
10. Creating patches 512x512 for training in empanada **from train set only** with defined high overlap. [10_Create_Patches_from_images_and_masks.ijm]


**Supported by research projects [CzBI2024-2 NV](https://www.czech-bioimaging.cz/activities/open-calls/) and RVO-VFN64165.
We also acknowledge the [Light Microscopy Core Facility, IMG, Prague, Czech Republic](https://www.img.cas.cz/group/light-microscopy/), supported by MEYS – LM2023050 Czech-BioImaging, MEYS – CZ.02.1.01/0.0/0.0/18_046/0016045 and MEYS – CZ.02.01.01/00/23_015/0008205, for their support with the image analysis presented herein.**

