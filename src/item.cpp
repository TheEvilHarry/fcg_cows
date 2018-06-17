#include <cstdio>
#include <GLFW/glfw3.h>
#include "item.hpp"
#include "defines.h"

using namespace glm;

Item::Item(vec4 position, const char* name, int id, bool control){
	this->position = position;
	this->name = name;
	this->id = id;
	this->control = control;
	
	this->bbox_min = vec4(0.0, 0.0, 0.0, 0.0);
	this->bbox_max = vec4(0.0, 0.0, 0.0, 0.0);
}	

vec3 Item::getBBoxMin() const {
    return bbox_min;
}

vec3 Item::getBBoxMax() const {
    return bbox_max;
}

void Item::setBBoxMin(vec4 n_bbox_min) {
    this->bbox_min = n_bbox_min;
}

void Item::setBBoxMax(vec4 n_bbox_max) {
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
    //return direction.x + (float)glfwGetTime() * 0.01f;

    bool control_cow = this->control;

    static float old_seconds = (float)glfwGetTime(); //0.1
    float seconds = (float)glfwGetTime();
    float ellapsed_seconds = seconds - old_seconds;
    if (ellapsed_seconds > 0.4f)
    {
        old_seconds = seconds;

        if (control_cow)
            return direction.x + 0.1f;
        else return direction.x - 0.1;
    }
    return direction.x;
}

char const * Item::getName() {
    return name;
}

int Item::getId() {
  return id;
}

bool Item::getControl() {
    return control;
}

void Item::setControl(bool new_control) {
    control = new_control;
}
