#include <cstdio>
#include <GLFW/glfw3.h>
#include "item.hpp"
#include "defines.h"

using namespace glm;

Item::Item(vec4 position, const char* name, int id){
	this->position = position;
	this->name = name;
	this->id = id;
	
	this->bbox_min = vec3(0.0, 0.0, 0.0);
	this->bbox_max = vec3(0.0, 0.0, 0.0);
}	

vec3 Item::getBBoxMin() const {
    return bbox_min;
}

vec3 Item::getBBoxMax() const {
    return bbox_max;
}

void Item::setBBoxMin(vec3 n_bbox_min) {
    this->bbox_min = n_bbox_min;
}

void Item::setBBoxMax(vec3 n_bbox_max) {
    this->bbox_max = n_bbox_max;
}

vec4 Item::getPosition() const {
  return position;
}

void Item::setPosition (vec4 newPosition) {
  position = newPosition;
}

float Item::move(vec4 direction) {
    //move foward only
    return direction.x + (float)glfwGetTime() * 0.5f;
}

char const * Item::getName() {
    return name;
}

int Item::getId() {
  return id;
}
