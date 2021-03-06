import cProfile
import StringIO
import pstats
import skimage.io
import skimage.color
import cupy
import numpy

if __name__ == '__main__':
    pr = cProfile.Profile()
    filename = '/home/dzhoshkun/data/sample-images/1920x1080.jpg'
    img_orig = skimage.io.imread(filename)
    img_lab = skimage.color.rgb2lab(img_orig)
    d_img_a = cupy.array(img_lab[:, :, 1])
    pr.enable()
    img_a_idx = numpy.argsort(img_lab[:, :, 1].flatten())
    d_img_a_idx = cupy.argsort(d_img_a.flatten())
    pr.disable()
    s = StringIO.StringIO()
    sortby = 'tottime'
    ps = pstats.Stats(pr, stream=s).sort_stats(sortby)
    ps.print_stats()
    print(s.getvalue())
    print(cupy.max(d_img_a_idx),
          img_orig.shape[0] * img_orig.shape[1])
    print(d_img_a_idx.shape)

