#pragma once
#include "general_settings.h"

class Mat;
class vector3f;
class vector2i;

// basic maths
Mat exp(const Mat&);
Mat log(const Mat&);
Mat pow(const Mat&, float);
Mat divide(const Mat&, float);
Mat divide(float, const Mat&);
vector3f divide(const vector3f&, float);
vector3f divide(float, const vector3f&);
Mat divide(const Mat&, const vector3f&);
Mat divide(const vector3f&, const Mat&);
Mat divide(const Mat&, const Mat&);
vector3f divide(const vector3f&, const vector3f&);
float sum(const vector3f&);
vector3f sum(const Mat&);
float max(const vector3f&);
vector3f max(const Mat&);
float min(const vector3f&);
vector3f min(const Mat&);

Mat greaterThan(const Mat&, float);
Mat lessThan(const Mat&, float);

// non-linearity
Mat sigmoid(const Mat&);
Mat dsigmoid(const Mat&);
Mat dsigmoid_a(const Mat&);
Mat ReLU(const Mat&);
Mat dReLU(const Mat&);
Mat LeakyReLU(const Mat&);
Mat dLeakyReLU(const Mat&);
Mat Tanh(const Mat&);
Mat dTanh(const Mat&);
Mat nonLinearity(const Mat&, int);
Mat dnonLinearity(const Mat&, int);

// convolution and pooling
Mat fliplr(const Mat&);
Mat rot90(const Mat&, int);
Mat padding(const Mat&, int);
Mat depadding(const Mat&, int);


Mat repmat(const Mat&, int, int);
Mat kron(const Mat&, const Mat&);


/*
Mat conv2(Mat&, Mat&, int, int, int);
Mat Pooling_with_overlap(Mat&, Size2i, int, int, std::vector<std::vector<Point2i> >&);
Mat Pooling_with_overlap_test(Mat&, Size2i, int, int);
Mat Pooling(Mat&, int, int, std::vector<std::vector<Point2i> >&);
Mat Pooling_test(Mat&, int, int);
Mat UnPooling(Mat&, int, int, std::vector<std::vector<Point2i> >&, Size2i);
Mat UnPooling_with_overlap(Mat&, Size2i, int, int, std::vector<std::vector<Point2i> >&, Size2i);

*/








