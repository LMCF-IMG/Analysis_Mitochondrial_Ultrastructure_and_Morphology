# %%
import os
import shutil
from sklearn.model_selection import train_test_split

# Funkce pro rozdělení datasetu na tréninkovou, validační a testovací množinu
# Validační množina je nastavena na 0%, protože ji empanada nevyužívá efektivně
def split_dataset(image_dir, mask_dir, output_dir, train_size=0.90, val_size=0.00, test_size=0.10):
    # Získání seznamu obrazových souborů
    image_files = [f for f in os.listdir(image_dir) if os.path.isfile(os.path.join(image_dir, f))]
    
    # Rozdělení datasetu na tréninkovou, (validační) a testovací množinu
    train_files, test_files = train_test_split(image_files, test_size=test_size, random_state=42)
    #train_files, val_files = train_test_split(train_files, test_size=val_size/(train_size + val_size), random_state=42)
    
    # Vytvoření výstupních adresářů, pokud neexistují
    os.makedirs(os.path.join(output_dir, 'train', 'images'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'train', 'masks'), exist_ok=True)
    #os.makedirs(os.path.join(output_dir, 'val', 'images'), exist_ok=True)
    #os.makedirs(os.path.join(output_dir, 'val', 'masks'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'test', 'images'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'test', 'masks'), exist_ok=True)
    
    # Funkce pro kopírování souborů do příslušných adresářů
    def copy_files(file_list, subset):
        for file_name in file_list:
            shutil.copy(os.path.join(image_dir, file_name), os.path.join(output_dir, subset, 'images', file_name))
            shutil.copy(os.path.join(mask_dir, file_name), os.path.join(output_dir, subset, 'masks', file_name))
    
    # Kopírování souborů do příslušných adresářů
    copy_files(train_files, 'train')
    #copy_files(val_files, 'val')
    copy_files(test_files, 'test')

# Příklad použití
# image_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all_patches/images/'
# mask_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all_patches/masks/'
# output_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all_patches_for_training/'

# image_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all/images/'
# mask_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all/masks/'
# output_dir = 'd:/Programovani/_Empanada_Training/250115_Finetuning_MITOLAB_04_with_Codes/_all/_splits/'

# instance segmentation
# ELMI
# image_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/20_ALL_DATA_SEPARATED_GROUPS_ELMI_SCAN/ELMI/images/'
# mask_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/20_ALL_DATA_SEPARATED_GROUPS_ELMI_SCAN/ELMI/masks/'
# output_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/21_ALL_DATA_SEPARATED_Train_Test_Sets/ELMI/'

# SCAN
image_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/20_ALL_DATA_SEPARATED_GROUPS_ELMI_SCAN/SCAN/images/'
mask_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/20_ALL_DATA_SEPARATED_GROUPS_ELMI_SCAN/SCAN/masks/'
output_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/21_ALL_DATA_SEPARATED_Train_Test_Sets/SCAN/'

# panoptic segmentation
# image_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/04_Transform_Masks_to_8bit_Remove_Overlays_and_Fill_Holes/images/'
# mask_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/04_Transform_Masks_to_8bit_Remove_Overlays_and_Fill_Holes/masks/'
# output_dir = 'd:/Programovani/_Empanada_Training/250616 Data_for_training_Mito_Kristy/Mito_All/05_Train_Test_Sets/'

split_dataset(image_dir, mask_dir, output_dir)

# %%
