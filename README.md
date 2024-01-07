# A Large-Scale Study of Cookie Banner Interaction Tools and Their Impact on Users’ Privacy

This repository contains additional material to the paper "A Large-Scale Study of Cookie Banner Interaction Tools and Their Impact on Users’ Privacy," accepted at the *23rd Privacy Enhancing Technologies Symposium 2024 (PETS)*. 

In this repository, we provide __everything__ we have used in our study: tools, code, raw and processed measurement data, data processing pipeline, and the code for generating plots and statistics to reproduce our study's results.



## Repository Structure

- **01_MultiCrawl_(Framework)**  contains the framework necessary to conduct the large-scale measurement presented in the paper. It can be utilized for extensive Web measurements, including crawling multiple websites simultaneously with various browser configurations (e.g., different user agents, extensions, etc.).
  
- **02_Measurement_Data** hosts the collected measurement data, both raw and processed, available as a 600GB ZIP archive.
  
- **03_Data_Processing_SQLs** contains the entire data processing and evaluation pipeline, including all the SQL statements. It relies on the measurement data from _02_Measurement_Data_.
  
- **04_Plots_and_Statistics** provides two notebooks for generating plots and calculating statistics, as presented in our paper.


If you want to use our artifact, you can cite our [paper](https://doi.org/10.56553/popets-2024-0002):

```
@article{demir2024cookie,
  title = {A Large-Scale Study of Cookie Banner Interaction Tools and Their Impact on Users' Privacy},
  author = {Demir, Nurullah and Urban, Tobias and Pohlmann, Norbert and Wressnegger, Christian},
  journal = {Proceedings on Privacy Enhancing Technologies},
  volume = {2024}, 
  year ={2024},
  series = {PoPETS~'24}, 
  doi = {10.56553/popets-2024-0002}
  url= {https://doi.org/10.56553/popets-2024-0002}
}
```


