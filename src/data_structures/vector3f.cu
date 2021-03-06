#include "data_structure.h"

using namespace std;

vector3f::vector3f(){
	for(int i = 0; i < 3; ++i){
		set(i, 0.0);
	}
}

vector3f::vector3f(float a, float b, float c){
	set(0, a);
	set(1, b);
	set(2, c);
}

vector3f::vector3f(const vector3f &v){
	for(int i = 0; i < 3; ++i){
		set(i, v.get(i));
	}
}

vector3f::~vector3f(){}

vector3f& vector3f::operator=(const vector3f &v){
	for(int i = 0; i < 3; ++i){
		set(i, v.get(i));
	}
    return *this;
}

void vector3f::zeros(){
	for(int i = 0; i < 3; ++i){
		set(i, 0.0);
	}
}

void vector3f::ones(){
	for(int i = 0; i < 3; ++i){
		set(i, 1.0);
	}
}

void vector3f::set(int pos, float val){
	if(0 == pos) val0 = val;
	elif(1 == pos) val1 = val;
	elif(2 == pos) val2 = val;
	else ;
}

void vector3f::setAll(float val){
	for(int i = 0; i < 3; ++i){
		set(i, val);
	}
}

float vector3f::get(int pos) const{
	if(0 == pos) return val0;
	elif(1 == pos) return val1;
	elif(2 == pos) return val2;
	else return 0.0;
}
void vector3f::copyTo(vector3f &v) const{
	for(int i = 0; i < 3; ++i){
		v.set(i, get(i));
	}
}

vector3f vector3f::operator+(const vector3f &v) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) + v.get(i));
	}
	return tmp;
}

vector3f vector3f::operator+(float a) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) + a);
	}
	return tmp;
}

vector3f& vector3f::operator+=(const vector3f &v){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) + v.get(i));
	}
	return *this;
}

vector3f& vector3f::operator+=(float a){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) + a);
	}
	return *this;
}

vector3f vector3f::operator-(const vector3f &v) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) - v.get(i));
	}
	return tmp;
}

vector3f vector3f::operator-(float a) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) - a);
	}
	return tmp;
}

vector3f& vector3f::operator-=(const vector3f &v){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) - v.get(i));
	}
	return *this;
}

vector3f& vector3f::operator-=(float a){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) - a);
	}
	return *this;
}

vector3f vector3f::operator*(const vector3f &v) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) * v.get(i));
	}
	return tmp;
}

vector3f vector3f::operator*(float a) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) * a);
	}
	return tmp;
}

vector3f& vector3f::operator*=(const vector3f &v){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) * v.get(i));
	}
	return *this;
}

vector3f& vector3f::operator*=(float a){
	for(int i = 0; i < 3; ++i){
		set(i, get(i) * a);
	}
	return *this;
}

vector3f vector3f::operator/(float a) const{
	if(0 == a){
		std::cout<<"denominator is zero..."<<std::endl;
		exit(0);
	}
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) / a);
	}
	return tmp;
}

vector3f& vector3f::operator/=(float a){
	if(0 == a){
		std::cout<<"denominator is zero..."<<std::endl;
		exit(0);
	}
	for(int i = 0; i < 3; ++i){
		set(i, get(i) / a);
	}
	return *this;
}

vector3f vector3f::divNoRem(float a) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, (int)(tmp.get(i) / a));
	}
	return tmp;
}

vector3f vector3f::operator%(float a) const{
	if(0 == a){
		std::cout<<"denominator is zero..."<<std::endl;
		exit(0);
	}
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, (float)((int)(tmp.get(i)) % (int)a));
	}
	return tmp;
}

vector3f& vector3f::operator%=(float a){
	if(0 == a){
		std::cout<<"denominator is zero..."<<std::endl;
		exit(0);
	}
	for(int i = 0; i < 3; ++i){
		set(i, (float)((int)(get(i)) % (int)a));
	}
	return *this;
}

vector3f vector3f::mul(const vector3f &v) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) * v.get(i));
	}
	return tmp;
}

vector3f vector3f::mul(float a) const{
	vector3f tmp;
	copyTo(tmp);
	for(int i = 0; i < 3; ++i){
		tmp.set(i, tmp.get(i) * a);
	}
	return tmp;
}

void vector3f::print(const std::string& str) const{
	std::cout<<str<<std::endl;
	std::cout<<"vector3f: [ ";
	for(int i = 0; i < 3; ++i){
		std::cout<<get(i)<<" ";
	}
	std::cout<<"]"<<std::endl;
}

