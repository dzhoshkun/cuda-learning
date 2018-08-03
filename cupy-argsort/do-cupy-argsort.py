import skimage.io
import cupy

if __name__ == '__main__':
    filename = '/home/dzhoshkun/data/sample-images/1920x1080.jpg'
    img_orig = skimage.io.imread(filename)
    print(img_orig.shape)

