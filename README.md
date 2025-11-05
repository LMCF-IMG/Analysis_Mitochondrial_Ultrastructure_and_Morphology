# Analysis_Mitochondrial_Ultrastructure_and_Morphology

**Macros for [ImageJ/Fiji](https://fiji.sc/) and models for [napari](https://napari.org/).**

**Nikol Volfová, M.Sc.**, from the [Department of Paediatrics and Adolescent Medicine, First Faculty of Medicine, Charles University and General University Hospital in Prague, Prague, Czech Republic](https://mitolab.lf1.cuni.cz/) cooperated with the analyses and kindly provided the training image datasets for creation of the models.

## Overview

The project presents a study focused on analyzing mitochondrial ultrastructure and cristae morphology in relation to various types of mitochondrial dysfunction. Mitochondria play a key role in cellular energy metabolism through oxidative phosphorylation (OXPHOS), and alterations in cristae structure are closely associated with impaired ATP production and mitochondrial diseases. To objectively characterize these structural changes, the authors developed a two-step deep learning pipeline for image analysis of electron microscopy data.

In the first step, **instance segmentation** of mitochondria was performed on original EM images using a retrained *MitoNet_v1* model. The new model, trained in [napari](https://napari.org/), achieved an **IoU of 0.798 (IoU₀.₅ = 0.876)** compared to the original model’s IoU of 0.596, demonstrating improved accuracy in mitochondrial detection. In the second step, **panoptic segmentation** of cristae within the segmented mitochondria was carried out using a retrained *CEM* model, again using **napari**, allowing classification into **12 morphological categories**. This model reached an **IoU of 0.518 (IoU₀.₅ = 0.672)**, providing detailed and automated mapping of cristae organization.

Electron microscopy examples showed distinct ultrastructural differences between healthy fibroblasts and those with a **TMEM70 gene mutation**, such as rounded mitochondria and reduced cristae density. The approach effectively identifies structural abnormalities like cristae loss and “onion ring” formations associated with specific dysfunctions. Overall, the proposed deep learning workflow enables scalable, reproducible, and quantitative assessment of mitochondrial morphology, enhancing diagnostic and mechanistic understanding of mitochondrial pathologies.

Fig. 1: **A two-step approach to classify morphology or cristae** using techniques of deep learning in **napari**:

<img width="1361" height="893" alt="two-step-approach-to-classification" src="https://github.com/user-attachments/assets/84dc6aa9-6dcf-4ffd-b193-f76edf19bfb8" />

## Protocols for training in napari and models

## Preparation of image data for training

## Supported... s odkazem na CzechBioImg
