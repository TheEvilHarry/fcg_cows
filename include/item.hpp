#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

#ifndef _item_h
#define _item_h

using namespace glm;

class Item {
	vec4 position;
	vec3 bbox_min, bbox_max;
	const char* name;
	int id;
	
	public:
	Item(vec4 position, const char* name, int id);
	vec3 getBBoxMin() const;
	vec3 getBBoxMax() const;
    void setBBoxMin(vec3 n_bbox_min);
    void setBBoxMax(vec3 n_bbox_max);
    vec4 getPosition() const;
	void setPosition(vec4 newPosition);
	void move(vec4 direction);
	char const * getName();
	int getId();
};

#endif