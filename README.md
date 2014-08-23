The pdf file is the project reporter of Software-for-The-Analysis-of-3D-Biological-Data-Sets.

This project is the creation of a software interface and data processing toolbox tailored to the specific needs of a neurobiology research group. The project scope and requirements were set in collaboration between Cognition and Intelligent Computing Research Institute and Laboratory of Student Training Innovation Programs. The software created is called receptorToolsGUI and is run within MATLAB, utilizing its image processing, user interface, and 3D rendering functionalities.

Professor Sanqing Hu’s lab is investigating the cellular consequences of spinal cord injury (SCI). As part of their research, they have begun to analyze the SCI-­‐induced changes in sensitivity to serotonin (5-­‐HT) by identifying the presence of serotonin receptors. The serotonin receptors can be visualized in transverse image sections of a spinal cord through the use of a confocal microscope. The images are spaced closely together to create a three-­‐dimensional representation of a short segment of the spinal cord. In characterizing the presence of the serotonin receptors, the researchers wanted to identify potential receptors in the noise environment imposed by the confocal microscope. Once potential receptors were identified, their volume and average intensity also needed to be determined. The lab also requested that the 3D data set be rendered in such a way that the visualization might help to characterize the data set.

Analysis of the spinal cord image sequences was previously done in 2D using ImageJ, an open source, Java-­‐based image processing program developed at the National Institutes of Health. While this program is adequate in many aspects, it is not designed for the 12-­‐bit images from the lab’s confocal microscope and does not provide the user the necessary computational flexibility. The researchers needed a piece of software where the all the image processing subtleties would be known and they could define the core functionality.

At all design stages, the project technical requirements were of equal importance to the user interface usability for the neurobiology researchers. The software resulting from this project is a user-­‐friendly packaging of the following tools that can operate on 8, 12, or 16 bit images:

(1)Image I/O with image sequence handling
(2)Serotonin receptor identification in 2D or 3D
  (a)Full data output to MATLAB workspace and/or Microsoft Excel
  (b)Annotated output images for corresponding receptor id data to image
  (c)Auto generates receptor characterizing plots
  (d)Allows auto or interactive user thresholding
(3)3D rendering of data set
  (a) Colored coded volume visualization based on receptor size
(4) Conversion of 3D data set to usable 2D data set via max z projection
(5) Image Histogram
(6) Basic image arithmetic operations
(7) Detailed User’s Manual with instructions for expanding software capability
