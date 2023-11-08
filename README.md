# EVAInformatics
Repo for the EVA Informatics project. Steps to using this code (updated 11/7/2023):

# Prior to using code
1. Ensure MATLAB is downloaded and updated
2. Download the Automated Driving Toolbox add-on (requires computer vision toolbox & image processing toolbox), as well as the Optimization toolbox to run the tsp function.

# Steps to Use
1. Run main_apollo12_2m.m

# Function Definition
SolveTSP.m: Traveling Salesman Solver - identifies optimized ROI order based on distances
pathPlanner.m: Creates cost map and utilizes map to plan path between start and goal pose
createMat.m: Data formatting script used to take DEM files and turn them into matlab usable files


