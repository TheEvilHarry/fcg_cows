#version 330 core

#define CUBE 8

// Atributos de v�rtice recebidos como entrada ("in") pelo Vertex Shader.
// Veja a fun��o BuildTrianglesAndAddToVirtualScene() em "main.cpp".
layout (location = 0) in vec4 model_coefficients;
layout (location = 1) in vec4 normal_coefficients;
layout (location = 2) in vec2 texture_coefficients;

// Matrizes computadas no c�digo C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Atributos de v�rtice que ser�o gerados como sa�da ("out") pelo Vertex Shader.
// ** Estes ser�o interpolados pelo rasterizador! ** gerando, assim, valores
// para cada fragmento, os quais ser�o recebidos como entrada pelo Fragment
// Shader. Veja o arquivo "shader_fragment.glsl".
out vec4 position_world;
out vec4 position_model;
out vec4 normal;
out vec2 texcoords;

out vec3 cor_v;

uniform int object_id;


void main()
{
    // A vari�vel gl_Position define a posi��o final de cada v�rtice
    // OBRIGATORIAMENTE em "normalized device coordinates" (NDC), onde cada
    // coeficiente est� entre -1 e 1.  (Veja slides 144 e 150 do documento
    // "Aula_09_Projecoes.pdf").
    //
    // O c�digo em "main.cpp" define os v�rtices dos modelos em coordenadas
    // locais de cada modelo (array model_coefficients). Abaixo, utilizamos
    // opera��es de modelagem, defini��o da c�mera, e proje��o, para computar
    // as coordenadas finais em NDC (vari�vel gl_Position). Ap�s a execu��o
    // deste Vertex Shader, a placa de v�deo (GPU) far� a divis�o por W. Veja
    // slide 189 do documento "Aula_09_Projecoes.pdf").

    gl_Position = projection * view * model * model_coefficients;

    // Como as vari�veis acima  (tipo vec4) s�o vetores com 4 coeficientes,
    // tamb�m � poss�vel acessar e modificar cada coeficiente de maneira
    // independente. Esses s�o indexados pelos nomes x, y, z, e w (nessa
    // ordem, isto �, 'x' � o primeiro coeficiente, 'y' � o segundo, ...):
    //
    //     gl_Position.x = model_coefficients.x;
    //     gl_Position.y = model_coefficients.y;
    //     gl_Position.z = model_coefficients.z;
    //     gl_Position.w = model_coefficients.w;
    //

    // Posi��o do v�rtice atual no sistema de coordenadas global (World).
    position_world = model * model_coefficients;

    // Posi��o do v�rtice atual no sistema de coordenadas local do modelo.
    position_model = model_coefficients;

    // Normal do v�rtice atual no sistema de coordenadas global (World).
    // Veja slide 94 do documento "Aula_07_Transformacoes_Geometricas_3D.pdf".
    normal = inverse(transpose(model)) * normal_coefficients;
    normal.w = 0.0;
	
	// Toda essa parte do c�digo est� bem explicada no shader_fragment.glsl
	vec3 Kd; // Reflet�ncia difusa
    vec3 Ks; // Reflet�ncia especular
    vec3 Ka; // Reflet�ncia ambiente
    float q; // Expoente especular para o modelo de ilumina��o de Phong

	vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;
	vec4 p = position_world;
	vec4 n = normalize(normal);
	vec4 l = normalize(vec4(1.0,1.0,0.0,0.0));
	vec4 v = normalize(camera_position - p);
	vec4 r = -l + 2 * n * dot(n,l);
	
	//representando o cubo em Gourad Shading.
    if(object_id==CUBE){
		Kd = vec3(0.8,0.4,0.08);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(0.4,0.2,0.04);
        q = 1.0;
		vec3 I = vec3(1.0,1.0,1.0);
        vec3 Ia = vec3(0.4,0.4,0.4);
        vec3 lambert_diffuse_term = Kd * I * max(0, dot(n,l));
        vec3 ambient_term = Ka * Ia;
        vec3 phong_specular_term = Ks * I * max(0,pow(dot(r,v), q));
        cor_v = lambert_diffuse_term + ambient_term + phong_specular_term;
	}

    // Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
    texcoords = texture_coefficients;
}
