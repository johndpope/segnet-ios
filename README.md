# Caffe SegNet iOS

The build system of this repo is based on the project [caffe-mobile](https://github.com/solrex/caffe-mobile)
of @solrex.

**This is a modified version of [Caffe](https://github.com/BVLC/caffe) which supports the [SegNet architecture](http://mi.eng.cam.ac.uk/projects/segnet/) on iOS**

As described in **SegNet: A Deep Convolutional Encoder-Decoder Architecture for Image Segmentation** Vijay Badrinarayanan, Alex Kendall and Roberto Cipolla, PAMI 2017 [http://arxiv.org/abs/1511.00561]

## Compile SegNet

To compile SegNet, run the following commands:

```bash
$ git clone https://github.com/gi097/segnet-ios.git
$ ./tools/build_ios.sh
```

## Publications

If you use this software in your research, please cite our publications:

http://arxiv.org/abs/1511.02680
Alex Kendall, Vijay Badrinarayanan and Roberto Cipolla "Bayesian SegNet: Model Uncertainty in Deep Convolutional Encoder-Decoder Architectures for Scene Understanding." arXiv preprint arXiv:1511.02680, 2015.

http://arxiv.org/abs/1511.00561
Vijay Badrinarayanan, Alex Kendall and Roberto Cipolla "SegNet: A Deep Convolutional Encoder-Decoder Architecture for Image Segmentation." PAMI, 2017. 

## License

This modification and extension to the Caffe library is released under a creative commons license which allows for personal and research use only. For a commercial license please contact the authors. You can view a license summary here:
http://creativecommons.org/licenses/by-nc/4.0/
