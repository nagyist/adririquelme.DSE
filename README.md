# 🪨 Discontinuity Set Extractor

**Discontinuity Set Extractor** is a MATLAB tool designed for the structural analysis of rock slopes using **3D point clouds**. It facilitates the identification, classification, and analysis of planar discontinuity sets by examining the **normals** of the points, guiding the user in the structural interpretation of the rock mass.

---

## 📌 System Requirements

- MATLAB version 2024b
- Required Toolboxes:
  - Computer Vision Toolbox
  - Statistics and Machine Learning Toolbox
  - Signal Processing Toolbox
  - Text Analytics Toolbox
  - Global Optimization Toolbox

---

## 📂 Supported Input Formats

- `.txt` (ASCII): Each row represents a point with **X Y Z** coordinates. Additional columns are ignored.
- `.ply`: Includes coordinates, colors, intensity, and normals (if available). If normals are present, the program can use them directly.

---

## ✨ Key Features

- Orientation analysis using point normals.
- Interactive guidance to determine the number of discontinuity sets.
- Classification of the point cloud into structural sets.
- 3D visualization of the classified cloud.
- Clustering of coplanar points and extraction of plane equations.
- Analysis of **normal spacing** between discontinuities.
- Analysis of **persistence** of discontinuity planes.
- Ability to **save and reload analysis states** using `.mat` files.

---

## 🚀 Installation

1. Clone the repository:

   git clone https://github.com/adririquelme/DSE.git

2. Open MATLAB and add the project folder and all its subfolders to the path:

   addpath(genpath('path/to/DSE'))

---

## 🛠️ Usage


1. Open **MATLAB**.

2. Run the main script corresponding to the current version of the program (e.g., `DSE_v3.02.m`):

 ```matlab
 DSE_v3.XX.mlapp
 ```


---

## 🧪 Test Data

Sample 3D point clouds are available at:

https://personal.ua.es/es/ariquelme/nubes-de-puntos-3d.html

---

## 📚 References

- Riquelme, A. J., Abellán, A., Tomás, R., & Jaboyedoff, M. (2014). A new approach for semi-automatic rock mass joints recognition from 3D point clouds. *Computers & Geosciences, 68*, 38–52. https://doi.org/10.1016/j.cageo.2014.03.014

- Riquelme, A., Abellán, A., & Tomás, R. (2015). Discontinuity spacing analysis in rock masses using 3D point clouds. *Engineering Geology, 195*, 185–195. https://doi.org/10.1016/j.enggeo.2015.06.009

- Riquelme, A., Tomás, R., Cano, M., Pastor, J. L., & Abellán, A. (2018). Automatic mapping of discontinuity persistence on rock masses using 3D point clouds. *Rock Mechanics and Rock Engineering, 51*(11), 3005–3028. https://doi.org/10.1007/s00603-018-1519-9

---

## 📬 Contact

Author: Adrián Riquelme  
Repository: https://github.com/adririquelme/DSE