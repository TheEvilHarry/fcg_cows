#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

#ifndef _item_h
#define _item_h

using namespace glm;

class Item {
	vec4 position;
	vec4 bbox_min, bbox_max;
	const char* name;
	int id;
	bool control;
	
	public:
	Item(vec4 position, const char* name, int id, bool control);
	vec3 getBBoxMin() const;
	vec3 getBBoxMax() const;
    void setBBoxMin(vec4 n_bbox_min);
    void setBBoxMax(vec4 n_bbox_max);
    vec4 getPosition() const;
	void setPosition(vec4 newPosition);
    float move(vec4 direction);
	char const * getName();
	int getId();
	bool getControl();
	void setControl(bool new_control);
};

#endif