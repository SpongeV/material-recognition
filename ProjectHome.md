### Texture Synthesis For Material Classification ###

Appearance based statistical machine learning techniques have been around for some time for material recognition. However, none of these approaches combine appearance learning with the physical modeling of the surface. They have to learn the variation in appearance from many examples.

In this research we aim to synthesize new material data by modeling surface characteristics from minimal image resources. Photometric stereo can provide albedo and surface normals, which in turn are needed in the process of image synthesis. Reflection models such as Blinn-Phong (glossy surfaces), Oren-Nayar (rough opaque diffuse surfaces) and Cook-Torrance (microfacets) are used for synthesis.

To develop invariant material features, filter banks with invariant characteristics can be applied to the images. With obtained responses, different types of models can be constructed such as a texton dictionary (Varma & Zisserman) or multivariate Gaussian distributions (Broadhurst).
State-of-the-art classification rates on the Photex database are reported by Targhi using a minimal amount of image data to obtain the models. In this research, we aim to improve on the classification rates using different reflection models for the synthesis.