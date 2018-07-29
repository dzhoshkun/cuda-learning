#include <stdio.h>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

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

    // convert image to I420
    cv::Mat orig_img_i420;
    cv::cvtColor(orig_img, orig_img_i420, cv::COLOR_BGRA2YUV_I420);

    // TODO: delete this, testing only
    cv::Mat proc_img_i420;
    proc_img_i420 = orig_img_i420;

    // save processed image
    cv::Mat proc_img;
    cv::cvtColor(proc_img_i420, proc_img, cv::COLOR_YUV420p2BGRA);
    if (not cv::imwrite("./cielab-pipe-processed.jpg", proc_img))
    {
        printf("Could not write processed image\n");
        return EXIT_FAILURE;
    }

    // all good
    return EXIT_SUCCESS;
}

