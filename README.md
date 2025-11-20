# Analysis_Mitochondrial_Ultrastructure_and_Morphology

**Macros for [ImageJ/Fiji](https://fiji.sc/), scripts for Python and models for [empanada-napari](https://empanada.readthedocs.io/en/latest/).**

**Nikol Volfová, M.Sc.**, from the [Department of Paediatrics and Adolescent Medicine, First Faculty of Medicine, Charles University and General University Hospital in Prague, Prague, Czech Republic](https://mitolab.lf1.cuni.cz/) cooperated with the analyses and kindly annotated and provided the training image datasets for creation of the models.

## Overview

The project presents a study focused on analyzing mitochondrial ultrastructure and cristae morphology in relation to various types of mitochondrial dysfunction. Mitochondria play a key role in cellular energy metabolism through oxidative phosphorylation (OXPHOS), and alterations in cristae structure are closely associated with impaired ATP production and mitochondrial diseases. To objectively characterize these structural changes, we developed a two-step deep learning pipeline for image analysis of electron microscopy data.

In the first step, **instance segmentation** of mitochondria was performed on original EM images using a retrained *MitoNet_v1* model. The new model, trained in [empanada-napari](https://empanada.readthedocs.io/en/latest/), achieved an **IoU of 0.798 (IoU₀.₅ = 0.876)** compared to the original model’s IoU of 0.596, demonstrating improved accuracy in mitochondrial detection. In the second step, **panoptic segmentation** of cristae within the segmented mitochondria was carried out using a retrained *CEM* model, again using **empanada-napari**, allowing classification into **12 morphological categories**. This model reached an **IoU of 0.518 (IoU₀.₅ = 0.672)**, providing detailed and automated mapping of cristae organization.

Electron microscopy examples showed distinct ultrastructural differences between healthy fibroblasts and those with a **TMEM70 gene mutation**, such as rounded mitochondria and reduced cristae density. The approach effectively identifies structural abnormalities like cristae loss and “onion ring” formations associated with specific dysfunctions. Overall, the proposed deep learning workflow enables scalable, reproducible, and quantitative assessment of mitochondrial morphology, enhancing diagnostic and mechanistic understanding of mitochondrial pathologies.

Fig. 1: **A two-step approach to classify morphology or cristae** using new deep learning models created in **empanada-napari**:

<img width="1361" height="893" alt="two-step-approach-to-classification" src="https://github.com/user-attachments/assets/84dc6aa9-6dcf-4ffd-b193-f76edf19bfb8" />

See also **a PDF poster in the file repository above**. The poster was presented at [CzechBioImaging conference: Imaging Principles of Life 2025, September 17-19, Rozdrojovice, Brno, Czech Republic](https://www.czech-bioimaging.cz/activities/conference/).

### Protocols for training in empanada-napari and models

... zmínit nutnost pospojování vysegmentovaných fragmentů v napari
... export dat s použitím empanada do správné struktury
... komentář Avishek?

### Evaluation of quality of trained models by segmentation metrics

I used [umetrix](https://pypi.org/project/umetrix/) project to evaluate the quality of the resulting trained models. It allows us to calculate basic segmentation metrics, e.g. IoU, and confusion matrix, based on which the popular F1 score can be easily calculated. The project also allows us to evaluate a set of images in a directory in batch mode. The inputs to the algorithm are masks found by the trained model and those drawn manually in Labkit.

### Preparation of image data for training

Images were labeled for masks of both mitochondria and cristae by using [Labkit](https://imagej.net/plugins/labkit/) plugin in ImageJ/Fiji.

During the preparation of data for training (valid for both "images" and "masks"), it was necessary to monitor the following issues:
1. Replace spaces in names with underscores. napari does not read it. [Macro: "01_Replace_Spaces_in_Names_with_Underscores.ijm"]
2. Labeled images created in Labkit were stored with suffix "_mask" to distinguish the names. But for training both "images" and "names" must have the same name to link them. String "_mask" has to be removed. [02_Remove_String_mask_from Names.ijm]
3. Compare whether the final file names in both directories for training ("images" and "masks") are the same and unique to each other. [03_Check_Names_Equality_images_masks.ijm]
4. For some unknown reason Labkit slightly changes sizes (x,y) of exported masks when compared with the original images to be labeled. Mostly it adds several pixels to both axes of the matrix size. Compare whether images with the same name are the same size. [04_Compare_Sizes_images_masks.ijm]
5. If problems found in the previous step, adjust the size of masks relative to images [05_Adjust_Image_Matrice_Sizes.ijm]
6. Some 8-bit "masks" exported from Labkit were inverted in intensity, i.e., invert them back to a black background (intensity 0). [06_All_masks_to_Black_Background.ijm]
7. Some exported masks were in 32-bit, and even contained small holes. [07_Masks_Converting_to_8bit_and_Filling_Holes.ijm]
8. Final visual check to ensure that the drawn masks correctly correspond to the objects (mitochondria/crystals) in the images and visualization of the quality of the objects to ensure they have good contrast. The images have different sizes in pixels. To load them into the stack for convenient checking in Imagej/Fiji, they must be copied to the largest image matrix that has been applied. [08_Visual_Checking_mask_Alignment_with_image_Objects.ijm]
9. Splitting both images and masks into train and test sets for using in empanada-napari. [Python: 09_Splitting_into_Train_Test_Sets.py]
10. Creating patches 512x512 for training in empanada **from train set only** with defined high overlap. [10_Create_Patches_from_images_and_masks.ijm]

### Additional comments to cristae image data prep

In the case of mitochondria, their masks were drawn in Labkit in the standard way, i.e., each mitochondrion had its own mask, and the results were masks with instance segmentations of individual mitochondria, since there was one class here only - mitochondria.

In the case of **cristae, however, it is different**. We defined twelve different basic morphological shapes of crists, see the accompanyed poster. In Labkit, we therefore consistently used twelve different labels, see Fig. 2. Three problems here arose:

1. If not all classes are represented in the image we are annotating, the resulting image exported from Labkit to TIF does not adhere to the intensities of individual classes, i.e., class 1 = intensity 1, class 2 = intensity 2, etc., but randomly shifts the resulting intensities in the image. We solved this by first drawing dots for all classes in each annotation and then drawing individual cristae. This way, the resulting exported images contained the correct intensities for all classes, but also additionally the spots (Fig. 2). 

2. Approximately 300 annotated label images of crists were created in Labkit in the previous step. All the images, however, contained additional label dots for all classes, which would negatively affect the quality of training (Fig. 2). Therefore, these dots had to be manually removed from all images. We used the attached macro for this, which automatically opens all individual cristae images together with their corresponding label images in Labkit in a loop, allows us to manually export the mask image to Fiji, manually delete the dots, and automatically save the final mask image to disk in the same directory as original data. [11_Save_Labels_from_Labkit.ijm]

3. All images currently stored on disk have masks according to the individual classes. However, in order to train the model for panoptic segmentation, the masks used for training must also be recalculated accordingly. This means that, for example, class 1 with an intensity of 1 may have multiple objects in the mask image. These are recalculated to intensities starting at 1000, with 1 added for each object. This means that, for example, the 10th object of class 1 occurring in the image will have a value of 1009. For other classes it was solved similarly. For more information, see [Python: 12_Recompute_Labels_for_Panoptic_Segmentation.ipynb]

Fig. 2: Segmented cristae image (left), labeling in Labkit using 12 labels and spots (middle), exported mask with the spots that had to be removed (right).

<img width="1781" height="551" alt="Fig_2_Label_with_Spots" src="https://github.com/user-attachments/assets/9aa75616-521b-4ddd-829b-0c964a873d79" />

**Supported by research projects [CzBI2024-2 NV](https://www.czech-bioimaging.cz/activities/open-calls/) and RVO-VFN64165.
We also acknowledge the [Light Microscopy Core Facility, IMG, Prague, Czech Republic](https://www.img.cas.cz/group/light-microscopy/), supported by MEYS – LM2023050 Czech-BioImaging, MEYS – CZ.02.1.01/0.0/0.0/18_046/0016045 and MEYS – CZ.02.01.01/00/23_015/0008205, for their support with the image analysis presented herein.**

