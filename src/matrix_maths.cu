#include "matrix_maths.h"

Mat exp(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid src..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_exp<<<num_blocks, block_size>>>(src.devData, dst.devData, tmp);
	dst.deviceToHost();
	return dst;
}

Mat log(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid src..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_log<<<num_blocks, block_size>>>(src.devData, dst.devData, tmp);
	dst.deviceToHost();
	return dst;
}

Mat pow(const Mat &src, float power){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid src..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	if(0.0 == power){
		dst.ones();
		return dst;
	}
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_pow<<<num_blocks, block_size>>>(src.devData, dst.devData, power, tmp);
	dst.deviceToHost();
	return dst;
}

Mat divide(const Mat &numerator, float denominator){
	if(NULL == numerator.hostData || NULL == numerator.devData){
		std::cout<<"invalid numerator..."<<std::endl;
		exit(0);
	}
	Mat dst(numerator);
	if(0.0 == denominator){
		std::cout<<"invalid denominator..."<<std::endl;
		dst.zeros();
		return dst;
	}
	int tmp = numerator.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_divide<<<num_blocks, block_size>>>(numerator.devData, dst.devData, denominator, tmp);
	dst.deviceToHost();
	return dst;
}

Mat divide(float numerator, const Mat& denominator){
	if(NULL == denominator.hostData || NULL == denominator.devData){
		std::cout<<"invalid denominator..."<<std::endl;
		exit(0);
	}
	Mat dst(denominator);
	if(0.0 == numerator){
		dst.zeros();
		return dst;
	}
	int tmp = denominator.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_divide<<<num_blocks, block_size>>>(numerator, denominator.devData, dst.devData, tmp);
	dst.deviceToHost();
	return dst;
}

vector3f divide(const vector3f& numerator, float denominator){
	vector3f dst(numerator);
	if(0.0 == denominator){
		dst.zeros();
		return dst;
	}
	for(int i = 0; i < 3; ++i){
		dst.set(i, (dst.get(i) / denominator));
	}
	return dst;
}

vector3f divide(float numerator, const vector3f& denominator){
	vector3f dst(denominator);
	if(0.0 == numerator){
		dst.zeros();
		return dst;
	}
	for(int i = 0; i < 3; ++i){
		if(dst.get(i) == 0.0) continue;
		dst.set(i, (numerator / dst.get(i)));
	}
	return dst;
}

Mat divide(const Mat& numerator, const vector3f& denominator){
	if(NULL == numerator.hostData || NULL == numerator.devData || numerator.channels != 3){
		std::cout<<"invalid numerator..."<<std::endl;
		exit(0);
	}
	Mat dst(numerator);
	int tmp = numerator.rows * numerator.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < 3; ++i){
		cu_divide<<<num_blocks, block_size>>>(numerator.devData + i * tmp, dst.devData + i * tmp, denominator.get(i), tmp);
	}
	dst.deviceToHost();
	return dst;
}

Mat divide(const vector3f& numerator, const Mat& denominator){
	if(NULL == denominator.hostData || NULL == denominator.devData || denominator.channels != 3){
		std::cout<<"invalid denominator..."<<std::endl;
		exit(0);
	}
	Mat dst(denominator);
	int tmp = denominator.rows * denominator.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < 3; ++i){
		cu_divide<<<num_blocks, block_size>>>(numerator.get(i), denominator.devData + i * tmp, dst.devData + i * tmp, tmp);
	}
	dst.deviceToHost();
	return dst;
}

Mat divide(const Mat& numerator, const Mat& denominator){
	if(NULL == denominator.hostData || NULL == denominator.devData ||
	   NULL == numerator.hostData || NULL == numerator.devData || numerator.getLength() != denominator.getLength()){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(numerator);
	int tmp = numerator.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_divide<<<num_blocks, block_size>>>(numerator.devData, denominator.devData, dst.devData, tmp);
	dst.deviceToHost();
	return dst;
}

vector3f divide(const vector3f& numerator, const vector3f& denominator){
	vector3f dst(denominator);
	for(int i = 0; i < 3; ++i){
		if(dst.get(i) == 0.0) continue;
		dst.set(i, (numerator.get(i) / dst.get(i)));
	}
	return dst;
}

float sum(const vector3f& src){
	float res = 0.0;
	for(int i = 0; i < 3; ++i){
		res = (res + src.get(i));
	}
	return res;
}

vector3f sum(const Mat& src){
	if(NULL == src.hostData || NULL == src.devData || src.channels != 3){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	vector3f res;
	int tmp = src.rows * src.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		float *devRes = 0;
		cudaMalloc((void**)&devRes, sizeof(float));
		cu_sum<<<num_blocks, block_size, block_size * sizeof(float)>>>(src.devData + i * tmp, devRes, tmp);
		float hostRes = 0;
		cudaMemcpy(&hostRes, devRes, sizeof(float), cudaMemcpyDeviceToHost);
		cudaFree(devRes);
		res.set(i, hostRes);
	}
	return res;
}

float max(const vector3f &src){
	float res = src.get(0);
	for(int i = 1; i < 3; ++i){
		if(src.get(i) > res) res = src.get(i);
	}
	return res;
}

vector3f max(const Mat& src){
	if(NULL == src.hostData || NULL == src.devData || src.channels != 3){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	vector3f res;
	int tmp = src.rows * src.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		float *dev_maxVal = 0;
		float *dev_minVal = 0;
		int *dev_maxLoc = 0;
		int *dev_minLoc = 0;
		cudaMalloc((void**)&dev_maxVal, sizeof(float));
		cudaMalloc((void**)&dev_minVal, sizeof(float));
		cudaMalloc((void**)&dev_maxLoc, sizeof(int));
		cudaMalloc((void**)&dev_minLoc, sizeof(int));
		cu_minMaxLoc<<<num_blocks, block_size>>>(src.devData + i * tmp, dev_minVal, dev_maxVal, dev_minLoc, dev_maxLoc, tmp);
		float host_maxVal = 0;
		float host_minVal = 0;
		int host_maxLoc = 0;
		int host_minLoc = 0;
		cudaMemcpy(&host_maxVal, dev_maxVal, sizeof(float), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_minVal, dev_minVal, sizeof(float), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_maxLoc, dev_maxLoc, sizeof(int), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_minLoc, dev_minLoc, sizeof(int), cudaMemcpyDeviceToHost);
		cudaFree(dev_maxVal);
		cudaFree(dev_minVal);
		cudaFree(dev_maxLoc);
		cudaFree(dev_maxLoc);
		res.set(i, host_maxVal);
	}
	return res;
}

float min(const vector3f &src){
	float res = src.get(0);
	for(int i = 1; i < 3; ++i){
		if(src.get(i) < res) res = src.get(i);
	}
	return res;
}

vector3f min(const Mat& src){
	if(NULL == src.hostData || NULL == src.devData || src.channels != 3){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	vector3f res;
	int tmp = src.rows * src.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		float *dev_maxVal = 0;
		float *dev_minVal = 0;
		int *dev_maxLoc = 0;
		int *dev_minLoc = 0;
		cudaMalloc((void**)&dev_maxVal, sizeof(float));
		cudaMalloc((void**)&dev_minVal, sizeof(float));
		cudaMalloc((void**)&dev_maxLoc, sizeof(int));
		cudaMalloc((void**)&dev_minLoc, sizeof(int));
		cu_minMaxLoc<<<num_blocks, block_size>>>(src.devData + i * tmp, dev_minVal, dev_maxVal, dev_minLoc, dev_maxLoc, tmp);
		float host_maxVal = 0;
		float host_minVal = 0;
		int host_maxLoc = 0;
		int host_minLoc = 0;
		cudaMemcpy(&host_maxVal, dev_maxVal, sizeof(float), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_minVal, dev_minVal, sizeof(float), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_maxLoc, dev_maxLoc, sizeof(int), cudaMemcpyDeviceToHost);
		cudaMemcpy(&host_minLoc, dev_minLoc, sizeof(int), cudaMemcpyDeviceToHost);
		cudaFree(dev_maxVal);
		cudaFree(dev_minVal);
		cudaFree(dev_maxLoc);
		cudaFree(dev_maxLoc);
		res.set(i, host_minVal);
	}
	return res;
}

Mat greaterThan(const Mat &src, float val){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_greaterThan<<<num_blocks, block_size>>>(src.devData, dst.devData, val, tmp);
	dst.deviceToHost();
	return dst;
}

Mat lessThan(const Mat &src, float val){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_lessThan<<<num_blocks, block_size>>>(src.devData, dst.devData, val, tmp);
	dst.deviceToHost();
	return dst;
}

// non-linearity
Mat sigmoid(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat tmp(src);
	tmp = tmp.mul(-1.0);
	tmp = exp(tmp) + 1.0;
	tmp = divide(1.0, tmp);
	return tmp;
}

Mat
dsigmoid(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat tmp = exp(src);
    Mat tmp2 = tmp + 1.0;
    tmp2 = pow(tmp2, 2.0);
    return divide(tmp, tmp2);
}

Mat
dsigmoid_a(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat res(src);
    res.ones();
    res = res - src;
    res = res.mul(src);
    return res;
}

Mat ReLU(const Mat& M){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat res = greaterThan(M, 0.0);
    res = res.mul(M);
    return res;
}

Mat dReLU(const Mat& M){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat res = greaterThan(M, 0.0);
    return res;
}

Mat LeakyReLU(const Mat& M){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat p = greaterThan(M, 0.0);
    p = p.mul(M);
    Mat n = lessThan(M, 0.0);
    n = n.mul(M);
    n = divide(n, leaky_relu_alpha);
    return p + n;
}

Mat dLeakyReLU(const Mat& M){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat p = greaterThan(M, 0.0);
    Mat n = lessThan(M, 0.0);
    n = divide(n, leaky_relu_alpha);
    return p + n;
}

Mat Tanh(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.getLength();
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	cu_tanh<<<num_blocks, block_size>>>(src.devData, dst.devData, tmp);
	dst.deviceToHost();
	return dst;
}

Mat dTanh(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat res(src);
    res.ones();
    res = res - pow(src, 2.0);
    return res;
}

Mat nonLinearity(const Mat &M, int method){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    if(method == NL_RELU){
        return ReLU(M);
    }elif(method == NL_TANH){
        return Tanh(M);
    }elif(method == NL_LEAKY_RELU){
        return LeakyReLU(M);
    }else{
        return sigmoid(M);
    }
}

Mat dnonLinearity(const Mat &M, int method){
	if(NULL == M.hostData || NULL == M.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    if(method == NL_RELU){
        return dReLU(M);
    }elif(method == NL_TANH){
        return dTanh(M);
    }elif(method == NL_LEAKY_RELU){
        return dLeakyReLU(M);
    }else{
        return dsigmoid(M);
    }
}

// convolution and pooling
Mat fliplr(const Mat &src){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src);
	int tmp = src.rows * src.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp / block_size) + ((tmp % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		cu_fliplr<<<num_blocks, block_size>>>(src.devData + i * tmp, dst.devData + i * tmp, src.rows, src.cols, tmp);
	}
	dst.deviceToHost();
	return dst;
}

Mat rot90(const Mat &src, int k){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
    Mat res(src);
    if(0 == k) return res;
    elif(1 == k) {
    	res = res.t();
    	res = fliplr(res);
    }else{
    	res = rot90(res, k - 1);
    	res = res.t();
    	res = fliplr(res);
    }
    return res;
}

Mat padding(const Mat &src, int pad){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src.rows + pad * 2, src.cols + pad * 2, src.channels);
	int tmp1 = src.rows * src.cols;
	int tmp2 = dst.rows * dst.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp1 / block_size) + ((tmp1 % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		cu_padding<<<num_blocks, block_size>>>(src.devData + i * tmp1, dst.devData + i * tmp2, src.rows, src.cols, dst.rows, tmp1);
	}
	dst.deviceToHost();
	return dst;
}

Mat depadding(const Mat &src, int pad){
	if(NULL == src.hostData || NULL == src.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src.rows - pad * 2, src.cols - pad * 2, src.channels);
	int tmp1 = src.rows * src.cols;
	int tmp2 = dst.rows * dst.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp2 / block_size) + ((tmp2 % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		cu_depadding<<<num_blocks, block_size>>>(src.devData + i * tmp1, dst.devData + i * tmp2, src.rows, src.cols, dst.rows, tmp2);
	}
	dst.deviceToHost();
	return dst;
}

Mat repmat(const Mat &src, int vert, int hori){
	if(NULL == src.hostData || NULL == src.devData || 0 == vert || 0 == hori){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(src.rows * vert, src.cols * hori, src.channels);
	if(1 == vert && 1 == hori) {dst = src; return dst;}
	int tmp1 = src.rows * src.cols;
	int tmp2 = dst.rows * dst.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp2 / block_size) + ((tmp2 % block_size) ? 1 : 0);
	for(int i = 0; i < src.channels; ++i){
		cu_repmat<<<num_blocks, block_size>>>(src.devData + i * tmp1, dst.devData + i * tmp2, src.rows, src.cols, dst.rows, dst.cols, tmp2);
	}
	dst.deviceToHost();
	return dst;
}

Mat kron(const Mat &a, const Mat &b){
	if(NULL == a.hostData || NULL == a.devData || NULL == b.hostData || NULL == b.devData){
		std::cout<<"invalid input..."<<std::endl;
		exit(0);
	}
	Mat dst(a.rows * b.rows, a.cols * b.cols, a.channels);
	int tmp1 = a.rows * a.cols;
	int tmp2 = dst.rows * dst.cols;
	const size_t block_size = threadsPerBlock;
	const size_t num_blocks = (tmp2 / block_size) + ((tmp2 % block_size) ? 1 : 0);
	for(int i = 0; i < a.channels; ++i){
		cu_kron<<<num_blocks, block_size>>>(a.devData + i * tmp1, b.devData, dst.devData + i * tmp2, a.rows, a.cols, dst.rows, dst.cols, tmp2);
	}
	dst.deviceToHost();
	return dst;
}








