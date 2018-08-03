import skimage.io
import skimage.color
import cupy

if __name__ == '__main__':
    filename = '/home/dzhoshkun/data/sample-images/1920x1080.jpg'
    img_orig = skimage.io.imread(filename)
    img_lab = skimage.color.rgb2lab(img_orig)
    print(img_lab.shape)

