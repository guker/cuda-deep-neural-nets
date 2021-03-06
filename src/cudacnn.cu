/*
 ============================================================================
 Name        : cudacnn.cu
 Author      : eric_yuan
 Version     :
 Copyright   : 
 Description : CUDA compute reciprocals
 ============================================================================
 */
#include "general_settings.h"

float momentum_w_init = 0.5;
float momentum_d2_init = 0.5;
float momentum_w_adjust = 0.95;
float momentum_d2_adjust = 0.90;
float lrate_w = 0.0;
float lrate_b = 0.0;

bool is_gradient_checking = false;
bool use_log = false;
int training_epochs = 0;
int iter_per_epo = 0;

void run(){

    std::vector<cpuMat*> trainX;
    std::vector<cpuMat*> testX;
    cpuMat* trainY = NULL;
    cpuMat* testY = NULL;
    read_CIFAR10_data(trainX, testX, trainY, testY);

    std::vector<network_layer*> flow;
    buildNetworkFromConfigFile("config.txt", flow);

//    trainX[0] -> print("matrix 0");
//    trainX[1] -> print("matrix 1");

    trainNetwork(trainX, trainY, testX, testY, flow);

    flow.clear();
    std::vector<network_layer*>().swap(flow);

    releaseVector(trainX);
    releaseVector(testX);
    trainY -> release();
    testY -> release();
    trainX.clear();
    std::vector<cpuMat*>().swap(trainX);
    testX.clear();
    std::vector<cpuMat*>().swap(testX);


    //*/
}

int main(void){

	run();



	/*
	Mat *a = new Mat(3, 2, 3);
	a -> randu();
	a -> set(1, 1, 0, 0.7);
	a -> set(2, 1, 0, 0.8);
	a -> set(1, 0, 1, 0.55);
	a -> set(2, 0, 1, 0.45);
	a -> printHost("1st print");

	Mat *b = NULL;
	Mat *c = NULL;
	Mat *d = NULL;
	Mat *e = NULL;
	Mat *f = NULL;
	Mat *g = NULL;
	Mat *h = NULL;
	Mat *i = NULL;
	Mat *j = NULL;
	Mat *k = NULL;
	Mat *l = NULL;
	Mat *m = NULL;
	Mat *n = NULL;
	safeGetPt(b, t(a));
	b -> printHost("2nd print");



	safeGetPt(c, multiply(a, b));
	c -> printHost("3nd print");

	vector3f *v = new vector3f(1.0, 2.0, 3.0);
	safeGetPt(d, multiply(c, v));
	d -> printHost("4th print");

	safeGetPt(e, pow(d, 2.0));
	e -> printHost("5th print");

	safeGetPt(f, dopadding(e, 2));
	f -> printHost("6th print");

	safeGetPt(g, depadding(f, 2));
	g -> printHost("7th print");

	safeGetPt(h, Tanh(g));
	h -> printHost("8th print");

	safeGetPt(i, rot90(h, 2));
	i -> printHost("9th print");

	safeGetPt(j, repmat(i, 2, 2));
	j -> printHost("10th print");

	safeGetPt(k, conv2(j, h, CONV_VALID, 0, 1));
	k -> printHost("11th print");

	vector2i *_size1 = new vector2i(2, 3);
	std::vector<vector3f*> locat;

	safeGetPt(l, pooling_with_overlap(k, _size1, 1, POOL_MAX, locat));
	l -> printHost("12th print");
	for(int counter = 0; counter < locat.size(); counter++){
		string str = "locat_" + to_string(counter);
		locat[counter] -> print(str);
	}
	vector2i *_size2 = new vector2i(6, 6);
	safeGetPt(m, unpooling_with_overlap(l, _size1, 1, POOL_MAX, locat, _size2));
	m -> printHost("13th print");

	vector<vector<Mat*> > vect;
	vector<Mat*> tmpvect;
	tmpvect.push_back(m);
	tmpvect.push_back(m);
	vect.push_back(tmpvect);
	vect.push_back(tmpvect);

	convert(vect, n);
	n -> printHost("14th print");

	vector<vector<Mat*> > vect2;
	convert(n, vect2, 2, 6);
	for(int i = 0; i < vect2.size(); ++i){
		for(int j = 0; j < vect2[i].size(); ++j){
			cout<<"$$$$$$$$$$$$$$$$ "<<i<<" $$$$$$$$$$$$$$$$$$ "<<j<<endl;
			vect2[i][j] -> printHost(" ");
		}
	}
	a -> release();
	b -> release();
	c -> release();
	d -> release();
	e -> release();
	f -> release();
	g -> release();
	h -> release();
	i -> release();
	j -> release();
	k -> release();
	l -> release();
	m -> release();
	n -> release();
	releaseVector(vect);
	releaseVector(vect2);

//*/


/*
	Mat *a = new Mat();
	a -> setSize(3, 2, 1);
	a -> randu();
	a -> printHost("see");
	a -> printDevice("dev");
	a -> release();

	a -> setSize(2, 2, 2);
	a -> randu();
	a -> printHost("see");
	a -> printDevice("dev");

	//*/
/*
	Mat a(3, 3, 3);
	a.randu();
	//a += 2.0;
	a.printHost("1st print");

	Mat b = pow(a, 2.0);
	b.printHost("22222222");

	Mat c = square(a);
	c.printHost("3rd print");
//*/

	/*
	Mat a(3, 2, 3);
	a.randu();
	a.set(1, 1, 0, 0.7);
	a.set(2, 1, 0, 0.8);
	a.set(1, 0, 1, 0.55);
	a.set(2, 0, 1, 0.45);
	a.printHost("1st print");

	Mat b = a.t();
	b.printHost("2nd print");

	Mat c = a * b;
	c.printHost("3nd print");

	vector3f v(1.0, 2.0, 3.0);
	Mat d = c * v;
	d.printHost("4th print");

	Mat *e = pow(&d, 2.0);
	e -> printHost("5th print");

	Mat *f = dopadding(e, 2);
	f -> printHost("6th print");

	Mat *g = depadding(f, 2);
	g -> printHost("7th print");

	Mat *h = Tanh(g);
	h -> printHost("8th print");

	Mat *i = rot90(h, 2);
	i -> printHost("9th print");

	Mat *j = repmat(i, 2, 2);
	j -> printHost("10th print");

	Mat *k = conv2(j, h, CONV_VALID, 0, 1);
	k -> printHost("11th print");

	vector2i _size1(2, 3);
	std::vector<vector3f*> locat;

	Mat *l = pooling_with_overlap(k, _size1, 1, POOL_MAX, locat);
	l -> printHost("12th print");
	for(int counter = 0; counter < locat.size(); counter++){
		string str = "locat_" + to_string(counter);
		locat[counter] -> print(str);
	}
	vector2i _size2(6, 6);
	Mat *m = unpooling_with_overlap(l, _size1, 1, POOL_MAX, locat, _size2);
	m -> printHost("13th print");

	vector<vector<Mat*> > vect;
	vector<Mat*> tmpvect;
	tmpvect.push_back(m);
	tmpvect.push_back(m);
	vect.push_back(tmpvect);
	vect.push_back(tmpvect);

	Mat *n = new Mat();
	convert(vect, n);
	n -> printHost("14th print");

	vector<vector<Mat*> > vect2;
	convert(n, vect2, 2, 6);
	for(int i = 0; i < vect2.size(); ++i){
		for(int j = 0; j < vect2[i].size(); ++j){
			cout<<"$$$$$$$$$$$$$$$$ "<<i<<" $$$$$$$$$$$$$$$$$$ "<<j<<endl;
			vect2[i][j] -> printHost(" ");
		}
	}
	a.release();
	b.release();
	c.release();
	d.release();
	e -> release();
	f -> release();
	g -> release();
	h -> release();
	i -> release();
	j -> release();
	k -> release();
	l -> release();
	m -> release();
	n -> release();
	releaseVector(vect);
	releaseVector(vect2);
//*/

	/*
	Mat a(3, 2, 3);
	a.randu();
	a.set(1, 1, 0, 0.7);
	a.set(2, 1, 0, 0.8);
	a.set(1, 0, 1, 0.55);
	a.set(2, 0, 1, 0.45);
	a.printHost("1st print");

	Mat b = a.t();
	b.printHost("2nd print");

	Mat c = a * b;
	c.printHost("3nd print");

	vector3f v(1.0, 2.0, 3.0);
	Mat d = c * v;
	d.printHost("4th print");

	Mat e = pow(d, 2.0);
	e.printHost("5th print");

	Mat f = dopadding(e, 2);
	f.printHost("6th print");

	Mat g = depadding(f, 2);
	g.printHost("7th print");

	Mat h = Tanh(g);
	h.printHost("8th print");

	Mat i = rot90(h, 2);
	i.printHost("9th print");

	Mat j = repmat(i, 2, 2);
	j.printHost("10th print");

	Mat k = conv2(j, h, CONV_VALID, 0, 1);
	k.printHost("11th print");



	vector2i _size1(2, 3);
	std::vector<vector3f> locat;

	Mat l = pooling_with_overlap(k, _size1, 1, POOL_MAX, locat);
	l.printHost("12th print");
	for(int counter = 0; counter < locat.size(); counter++){
		string str = "locat_" + to_string(counter);
		locat[counter].print(str);
	}
	vector2i _size2(6, 6);
	Mat m = unpooling_with_overlap(l, _size1, 1, POOL_MAX, locat, _size2);
	m.printHost("13th print");
//*/
	return 0;
}
