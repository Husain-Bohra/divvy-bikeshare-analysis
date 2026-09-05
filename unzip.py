import os
import zipfile

destination = '/home/husain/Desktop/datascience_conda/Project-DA/bikes/Data'


for file in os.listdir('/home/husain/Desktop/datascience_conda/Project-DA/bikes/Data'):
    # if file.endswith('.zip'):
    #     with zipfile.ZipFile(file,'r') as z:
    #         z.extractall(destination)
    print(file)