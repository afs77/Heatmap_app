# App : Build your own heatmap
This app generates heatmap figures, which are commonly used for showing gene expression data, as shown in the example below:<br>
![Heatmap](https://github.com/afs77/Heatmap_app/blob/main/heatmap.png?raw=true)
It uses R shiny to build the app and the pheatmap package to construct the figures. You can choose the parameters you want for your heatmap (Such as: Distance method, clustering method, color palettes, font size).<br><br>

# Input file
The input must be a .txt file containing a numeric matrix with the name of lines and columns, like this:<br><br>
sample1 sample2 sample3 sample4<br>
gene1 0.21 0.42 0.24 0.31<br>
gene2 0.12 0.33 0.16 0.35<br>
gene3 0.24 0.64 0.25 0.83<br>
gene4 0.8 0.33 0.41 0.92<br>
gene5 0.30 0.98 0.22 0.55<br>
gene6 0.42 0.54 0.66 0.23<br>
gene7 0.21 0.38 0.24 0.18<br>
gene8 0.11 0.23 0.61 0.53<br>
gene9 0.49 0.77 0.87 0.38<br><br>
Please check the example input file [here](https://github.com/afs77/Heatmap_app/blob/main/example_input.txt)<br><br>

# How to run
- You will need to have [R](https://www.r-project.org/) and [Rstudio free IDE](https://www.rstudio.com/) installed in your computer.<br>
- The app uses a few R packages: shiny (to build the app), pheatmap (to create the heatmaps), gplots and Rcolorbrewer (for the color palletes). To install these packages, open Rstudio, type the following command in the Console tab and hit enter:<br>
<p align="center">
install.packages(c("shiny", "pheatmap", "gplots", "Rcolorbrewer"))
</p>

- Open the heatmap_app.R file in R studio. Click on the Run app button. You will see the app in a new window.<br>
- Click on the browse button on the left to add your input file, making sure it is a .txt and it is formated as described above. You will see the heatmap figure, built using standard parameters, on the right panel. <br>
- You can now change the parameters on the left panel, and see the resulting figure on the right panel. 
- Once you are satisfied with the result, you can click on the Export.png button on the bottom left to export your figure as a .png file. Save it wherever you want on your computer. The resolution of this image is 300 dpi.
