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
    // assert both dimensions divisible by 4,
    // needed for I420 memory offset computations
    assert((int)(n_cols * 0.25) == (n_cols * 0.25));
    assert((int)(n_rows * 0.25) == (n_rows * 0.25));

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
        NppStatus ret = nppiYUV420ToBGR_8u_P3C3R(pSrc, rSrcStep, pDst, nDstStep, oSizeROI);
        if (ret != 0)
            printf("I420-to-BGR returned %d\n", ret);
    }
    cudaFree(d_data);

    // allocate memory for CIELAB data on device
    Npp8u *d_data_lab;
    cudaMalloc(&d_data_lab, 3 * n_cols * n_rows * sizeof(Npp8u));

    // convert BGR to CIELAB on device
    {
        Npp8u *pSrc = d_data_bgr, *pDst = d_data_lab;
        int nSrcStep = 3 * n_cols, nDstStep = 3 * n_cols;
        NppiSize oSizeROI;
        oSizeROI.width = n_cols;
        oSizeROI.height = n_rows; // TODO: check row vs. col order!
        NppStatus ret = nppiBGRToLab_8u_C3R(pSrc, nSrcStep, pDst, nDstStep, oSizeROI);
        if (ret != 0)
            printf("BGR-to-CIELAB returned %d\n", ret);
    }
    cudaFree(d_data_bgr);

    // allocate memory for BGR on device
    Npp8u *d_proc_data_bgr;
    cudaMalloc(&d_proc_data_bgr, 3 * n_cols * n_rows * sizeof(Npp8u));

    // convert CIELAB back to BGR
    {
        Npp8u *pSrc = d_data_lab, *pDst = d_proc_data_bgr;
        int nSrcStep = 3 * n_cols, nDstStep = 3 * n_cols;
        NppiSize oSizeROI;
        oSizeROI.width = n_cols;
        oSizeROI.height = n_rows; // TODO: check row vs. col order!
        NppStatus ret = nppiLabToBGR_8u_C3R(pSrc, nSrcStep, pDst, nDstStep, oSizeROI);
        if (ret != 0)
            printf("CIELAB-to-BGR returned %d\n", ret);
    }
    cudaFree(d_data_lab);

    // allocate memory for I420 on device
    Npp8u *d_proc_data;
    cudaMalloc(&d_proc_data, count);

    // convert BGR back to I420
    {
        Npp8u *pSrc = d_proc_data_bgr, *pDst[3];
        pDst[0] = d_proc_data;
        pDst[1] = &d_proc_data[n_cols * n_rows]; // TODO: is address op used correctly
        // TODO: assert offset integer
        pDst[2] = &d_proc_data[(int)(n_cols * n_rows * 1.25)]; // TODO: is address op used correctly
        int nSrcStep = 3 * n_cols, nDstStep = n_cols; // TODO: why nDstStep scalar?
        NppiSize oSizeROI;
        oSizeROI.width = n_cols;
        oSizeROI.height = n_rows; // TODO: check row vs. col order!
        NppStatus ret = nppiBGRToYUV_8u_C3P3R(pSrc, nSrcStep, pDst, nDstStep, oSizeROI);
        if (ret != 0)
            printf("BGR-to-I420 returned %d\n", ret);
    }
    cudaFree(d_proc_data_bgr);

    // copy data back to host
    cv::Mat proc_img_i420 = cv::Mat::zeros(orig_img_i420.size(), orig_img_i420.type());
    h_data = proc_img_i420.data;
    cudaMemcpy(h_data, d_proc_data, count, cudaMemcpyDeviceToHost);

    // free device memory
    cudaFree(d_proc_data);

    cudaDeviceSynchronize();

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

