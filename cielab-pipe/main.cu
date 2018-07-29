#include <stdio.h>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <nppi.h>

int main(int argc, char *argv[])
{
    // sanity check
    if (argc != 2)
    {
        printf("Usage: %s <path-to-image>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // load image
    cv::Mat orig_img;
    orig_img = cv::imread(argv[1]);
    int n_rows = orig_img.rows, n_cols = orig_img.cols;

    // convert image to I420
    cv::Mat orig_img_i420;
    cv::cvtColor(orig_img, orig_img_i420, cv::COLOR_BGRA2YUV_YV12);

    // prepare data pointers
    Npp8u *h_data = (Npp8u *) orig_img_i420.data, *d_data;

    // allocate device memory
    int count = orig_img_i420.total() * orig_img_i420.elemSize();
    cudaMalloc((void **) &d_data, count);

    // copy data to device
    cudaMemcpy(d_data, h_data, count, cudaMemcpyHostToDevice);

    // allocate memory for BGR data on device
    Npp8u *d_data_bgr;
    cudaMalloc(&d_data_bgr, 3 * n_cols * n_rows * sizeof(Npp8u));

    // convert I420 to BGR on device
    {
        Npp8u *pSrc[3], *pDst = d_data_bgr;
        pSrc[0] = (Npp8u *) d_data;
        pSrc[1] = (Npp8u *) &d_data[n_rows * n_cols]; // TODO: is address op used correctly
        // TODO: assert offset integer
        pSrc[2] = (Npp8u *) &d_data[(int)(n_rows * n_cols * 1.25)]; // TODO: is address op used correctly
        int rSrcStep[3], nDstStep = 3 * n_cols;
        rSrcStep[0] = n_cols;
        // TODO: assert offset integer
        rSrcStep[1] = (int)(n_cols * 0.25);
        // TODO: assert offset integer
        rSrcStep[2] = (int)(n_cols * 0.25);
        NppiSize oSizeROI;
        oSizeROI.width = n_cols;
        oSizeROI.height = n_rows; // TODO: check row vs. col order!
        nppiYUV420ToBGR_8u_P3C3R(pSrc, rSrcStep, pDst, nDstStep, oSizeROI);
    }

    // TODO: delete this, testing only
    cv::Mat proc_img_i420;
    proc_img_i420 = orig_img_i420;

    // copy data back to host
    cudaMemcpy(h_data, d_data, count, cudaMemcpyDeviceToHost);

    // free device memory
    cudaFree(d_data_bgr);
    cudaFree(d_data);

    // save processed image
    cv::Mat proc_img;
    cv::cvtColor(proc_img_i420, proc_img, cv::COLOR_YUV2BGRA_YV12);
    if (not cv::imwrite("./cielab-pipe-processed.jpg", proc_img))
    {
        printf("Could not write processed image\n");
        return EXIT_FAILURE;
    }

    // all good
    return EXIT_SUCCESS;
}

