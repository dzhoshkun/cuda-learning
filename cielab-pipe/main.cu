#include <stdio.h>
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
    cv::Mat orig_img, proc_img;
    orig_img = cv::imread(argv[1]);

    // TODO: delete this, testing only
    proc_img = orig_img;

    // save processed image
    if (not cv::imwrite("./cielab-pipe-processed.jpg", proc_img))
    {
        printf("Could not write processed image\n");
        return EXIT_FAILURE;
    }

    // all good
    return EXIT_SUCCESS;
}

